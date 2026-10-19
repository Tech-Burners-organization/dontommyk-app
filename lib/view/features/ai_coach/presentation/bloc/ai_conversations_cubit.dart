import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:tommy/core/result/result.dart';
import 'package:tommy/core/usecase/usecase.dart';
import 'package:tommy/view/features/ai_coach/data/datasources/ai_coach_socket_service.dart';
import 'package:tommy/view/features/ai_coach/data/models/ai_conversation_model.dart';
import 'package:tommy/view/features/ai_coach/data/models/ai_message_model.dart';
import 'package:tommy/view/features/ai_coach/domain/usecases/create_ai_conversation_usecase.dart';
import 'package:tommy/view/features/ai_coach/domain/usecases/delete_ai_conversation_usecase.dart';
import 'package:tommy/view/features/ai_coach/domain/usecases/get_ai_conversations_usecase.dart';
import 'package:tommy/view/features/ai_coach/domain/usecases/get_ai_messages_usecase.dart';
import 'package:tommy/view/features/ai_coach/domain/usecases/send_ai_message_usecase.dart';

sealed class AiConversationsState extends Equatable {
  const AiConversationsState();

  @override
  List<Object?> get props => [];
}

class AiConversationsInitial extends AiConversationsState {
  const AiConversationsInitial();
}

class AiConversationsLoading extends AiConversationsState {
  const AiConversationsLoading();
}

class AiConversationsLoaded extends AiConversationsState {
  final List<AiConversationModel> conversations;
  final String? activeConversationId;
  final bool isCreating;
  final List<AiMessageModel> messages;
  final bool isLoadingMessages;
  final String? messagesError;
  final bool isSending;
  final bool isAiTyping;
  final String streamingReply;
  final String? currentRequestId;
  final bool isSocketConnected;

  const AiConversationsLoaded(
    this.conversations, {
    this.activeConversationId,
    this.isCreating = false,
    this.messages = const [],
    this.isLoadingMessages = false,
    this.messagesError,
    this.isSending = false,
    this.isAiTyping = false,
    this.streamingReply = '',
    this.currentRequestId,
    this.isSocketConnected = false,
  });

  AiConversationModel? get activeConversation {
    if (activeConversationId == null || activeConversationId!.isEmpty) {
      return null;
    }
    try {
      return conversations.firstWhere(
        (c) => c.id == activeConversationId,
      );
    } catch (_) {
      return null;
    }
  }

  AiConversationsLoaded copyWith({
    List<AiConversationModel>? conversations,
    String? activeConversationId,
    bool? isCreating,
    List<AiMessageModel>? messages,
    bool? isLoadingMessages,
    String? messagesError,
    bool? isSending,
    bool? isAiTyping,
    String? streamingReply,
    String? currentRequestId,
    bool? isSocketConnected,
  }) {
    return AiConversationsLoaded(
      conversations ?? this.conversations,
      activeConversationId:
          activeConversationId ?? this.activeConversationId,
      isCreating: isCreating ?? this.isCreating,
      messages: messages ?? this.messages,
      isLoadingMessages: isLoadingMessages ?? this.isLoadingMessages,
      messagesError: messagesError,
      isSending: isSending ?? this.isSending,
      isAiTyping: isAiTyping ?? this.isAiTyping,
      streamingReply: streamingReply ?? this.streamingReply,
      currentRequestId: currentRequestId ?? this.currentRequestId,
      isSocketConnected: isSocketConnected ?? this.isSocketConnected,
    );
  }

  @override
  List<Object?> get props => [
        conversations,
        activeConversationId,
        isCreating,
        messages,
        isLoadingMessages,
        messagesError,
        isSending,
        isAiTyping,
        streamingReply,
        currentRequestId,
        isSocketConnected,
      ];
}

class AiConversationsError extends AiConversationsState {
  final String message;

  const AiConversationsError(this.message);

  @override
  List<Object?> get props => [message];
}

class AiConversationsCubit extends Cubit<AiConversationsState> {
  final GetAiConversationsUseCase getAiConversationsUseCase;
  final CreateAiConversationUseCase createAiConversationUseCase;
  final GetAiMessagesUseCase getAiMessagesUseCase;
  final SendAiMessageUseCase sendAiMessageUseCase;
  final DeleteAiConversationUseCase deleteAiConversationUseCase;
  final AiCoachSocketService socketService;

  StreamSubscription<bool>? _connSub;
  StreamSubscription<AiCoachTypingData>? _typingSub;
  StreamSubscription<AiCoachChunkData>? _chunkSub;
  StreamSubscription<AiCoachDoneData>? _doneSub;
  StreamSubscription<AiCoachErrorData>? _errorSub;

  String? _activeRequestId;
  String? _lastDoneRequestId;

  AiConversationsCubit({
    required this.getAiConversationsUseCase,
    required this.createAiConversationUseCase,
    required this.getAiMessagesUseCase,
    required this.sendAiMessageUseCase,
    required this.deleteAiConversationUseCase,
    AiCoachSocketService? socketService,
  })  : socketService = socketService ?? AiCoachSocketService(),
        super(const AiConversationsInitial()) {
    _initSocket();
  }

  void _initSocket() {
    socketService.connect();

    _connSub = socketService.onConnectionChanged.listen((connected) {
      if (state is AiConversationsLoaded) {
        final current = state as AiConversationsLoaded;
        emit(current.copyWith(isSocketConnected: connected));
      }
    });

    _typingSub = socketService.onTyping.listen((data) {
      if (state is! AiConversationsLoaded) return;
      final current = state as AiConversationsLoaded;
      if (current.currentRequestId == data.requestId || current.isSending) {
        emit(current.copyWith(isAiTyping: true));
      }
    });

    _chunkSub = socketService.onChunk.listen((data) {
      if (state is! AiConversationsLoaded) return;
      final current = state as AiConversationsLoaded;
      if (current.currentRequestId == data.requestId || current.isSending) {
        final updatedReply = current.streamingReply + data.delta;
        emit(current.copyWith(
          isAiTyping: false,
          streamingReply: updatedReply,
        ));
      }
    });

    _doneSub = socketService.onDone.listen((data) {
      if (state is! AiConversationsLoaded) return;
      final current = state as AiConversationsLoaded;

      // Validate matching request
      final isMatching = (data.requestId.isNotEmpty &&
              (_activeRequestId == data.requestId ||
                  current.currentRequestId == data.requestId)) ||
          (current.isSending && _activeRequestId != null);

      if (!isMatching) {
        debugPrint(
          '[AiConversationsCubit] Ignored done event: not matching active request (${data.requestId} vs $_activeRequestId)',
        );
        return;
      }

      if (data.requestId.isNotEmpty && data.requestId == _lastDoneRequestId) {
        debugPrint(
          '[AiConversationsCubit] Ignored duplicate done event: ${data.requestId}',
        );
        return;
      }

      _lastDoneRequestId = data.requestId;
      _activeRequestId = null;

      final fullReply = data.reply.trim().isNotEmpty
          ? data.reply.trim()
          : current.streamingReply.trim();

      if (fullReply.isEmpty) {
        emit(current.copyWith(
          isSending: false,
          isAiTyping: false,
          streamingReply: '',
          currentRequestId: null,
        ));
        return;
      }

      // Check if message is already in current.messages
      final alreadyExists = current.messages.any((m) {
        if (data.messageId != null &&
            data.messageId!.isNotEmpty &&
            m.id == data.messageId) {
          return true;
        }
        if (!m.isUser && m.content.trim() == fullReply) {
          return true;
        }
        return false;
      });

      if (alreadyExists) {
        debugPrint(
          '[AiConversationsCubit] Message already exists in current.messages. Skipping duplicate.',
        );
        emit(current.copyWith(
          isSending: false,
          isAiTyping: false,
          streamingReply: '',
          currentRequestId: null,
          messagesError: null,
        ));
        return;
      }

      final newAiMessage = AiMessageModel(
        id: (data.messageId != null && data.messageId!.isNotEmpty)
            ? data.messageId!
            : 'ai_${DateTime.now().millisecondsSinceEpoch}',
        conversationId: data.conversationId,
        role: 'assistant',
        content: fullReply,
        createdAt: DateTime.now().toIso8601String(),
      );

      final convExists =
          current.conversations.any((c) => c.id == data.conversationId);
      List<AiConversationModel> updatedConversations = current.conversations;
      if (!convExists && data.conversationId.isNotEmpty) {
        final newConv = AiConversationModel(
          id: data.conversationId,
          employeeId: '',
          organizationId: '',
          title: current.messages.isNotEmpty
              ? current.messages.last.content
              : 'New Conversation',
          messageCount: current.messages.length + 1,
          lastMessageAt: DateTime.now().toIso8601String(),
        );
        updatedConversations = [newConv, ...current.conversations];
      }

      emit(current.copyWith(
        conversations: updatedConversations,
        activeConversationId: data.conversationId,
        messages: [...current.messages, newAiMessage],
        isSending: false,
        isAiTyping: false,
        streamingReply: '',
        currentRequestId: null,
        messagesError: null,
      ));
    });

    _errorSub = socketService.onErrorEvent.listen((data) {
      if (state is! AiConversationsLoaded) return;
      final current = state as AiConversationsLoaded;
      if (current.currentRequestId == data.requestId || current.isSending) {
        debugPrint(
          'AiCoach socket error received for request ${data.requestId}: ${data.message}',
        );

        // If error occurred during streaming/sending, reset sending lock and show message
        emit(current.copyWith(
          isSending: false,
          isAiTyping: false,
          streamingReply: '',
          currentRequestId: null,
          messagesError: data.message,
        ));
      }
    });
  }

  Future<void> fetchConversations({String? selectId}) async {
    if (state is! AiConversationsLoaded) {
      emit(const AiConversationsLoading());
    }

    final result = await getAiConversationsUseCase(const NoParams());

    switch (result) {
      case ResultSuccess(data: final conversations):
        final uniqueConversations = <AiConversationModel>[];
        final seenConvIds = <String>{};
        for (final c in conversations) {
          if (seenConvIds.add(c.id)) {
            uniqueConversations.add(c);
          }
        }

        final currentActive = selectId ??
            (state is AiConversationsLoaded
                ? (state as AiConversationsLoaded).activeConversationId
                : null);

        final activeId = currentActive ??
            (uniqueConversations.isNotEmpty
                ? uniqueConversations.first.id
                : null);

        emit(AiConversationsLoaded(
          uniqueConversations,
          activeConversationId: activeId,
          messages: const [],
          isLoadingMessages: activeId != null,
          isSocketConnected: socketService.isConnected,
        ));

        if (activeId != null) {
          await fetchMessages(activeId);
        }
      case ResultFailure(failure: final failure):
        debugPrint(
          'AiConversationsCubit.fetchConversations failure: ${failure.message}',
        );
        if (state is! AiConversationsLoaded) {
          emit(AiConversationsError(failure.message));
        }
    }
  }

  Future<void> fetchMessages(String conversationId) async {
    if (state is! AiConversationsLoaded) return;
    final current = state as AiConversationsLoaded;

    emit(current.copyWith(
      activeConversationId: conversationId,
      isLoadingMessages: true,
      messagesError: null,
    ));

    final result = await getAiMessagesUseCase(conversationId);

    if (state is! AiConversationsLoaded) return;
    final latest = state as AiConversationsLoaded;
    if (latest.activeConversationId != conversationId) return;

    switch (result) {
      case ResultSuccess(data: final messages):
        final uniqueMessages = <AiMessageModel>[];
        final seenKeys = <String>{};
        for (final m in messages) {
          final key = m.id.isNotEmpty ? m.id : '${m.role}_${m.content}';
          if (seenKeys.add(key)) {
            uniqueMessages.add(m);
          }
        }

        emit(latest.copyWith(
          messages: uniqueMessages,
          isLoadingMessages: false,
          messagesError: null,
        ));
      case ResultFailure(failure: final failure):
        debugPrint(
          'AiConversationsCubit.fetchMessages failure: ${failure.message}',
        );
        emit(latest.copyWith(
          isLoadingMessages: false,
          messagesError: failure.message,
        ));
    }
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    if (trimmed.length > 4000) {
      if (state is AiConversationsLoaded) {
        final current = state as AiConversationsLoaded;
        emit(current.copyWith(
          messagesError: 'Message cannot exceed 4000 characters',
        ));
      }
      return;
    }

    if (state is! AiConversationsLoaded) return;
    final current = state as AiConversationsLoaded;

    if (current.isSending || current.isAiTyping || current.streamingReply.isNotEmpty) {
      emit(current.copyWith(
        messagesError: 'Please wait for the current reply to finish',
      ));
      return;
    }

    final activeId = current.activeConversationId;
    final requestId = 'msg-${DateTime.now().millisecondsSinceEpoch}';
    _activeRequestId = requestId;

    final tempUserMessage = AiMessageModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: activeId ?? '',
      role: 'user',
      content: trimmed,
      createdAt: DateTime.now().toIso8601String(),
    );

    emit(current.copyWith(
      messages: [...current.messages, tempUserMessage],
      isSending: true,
      isAiTyping: true,
      streamingReply: '',
      currentRequestId: requestId,
      messagesError: null,
    ));

    // If socket is not connected, try connecting
    if (!socketService.isConnected) {
      socketService.connect();
    }

    // Try socket emit first
    if (socketService.isConnected) {
      try {
        socketService.emitSend(
          content: trimmed,
          conversationId: activeId,
          requestId: requestId,
          onAck: (ack) {
            if (ack['success'] == false && ack['message'] != null) {
              if (state is AiConversationsLoaded) {
                final cur = state as AiConversationsLoaded;
                if (cur.currentRequestId == requestId) {
                  emit(cur.copyWith(
                    isSending: false,
                    isAiTyping: false,
                    messagesError: ack['message'].toString(),
                  ));
                }
              }
            }
          },
        );
        return;
      } catch (e) {
        debugPrint('Socket emit error: $e. Falling back to REST API.');
      }
    }

    // Fallback: REST API
    await _executeRestFallback(trimmed, activeId);
  }

  Future<void> _executeRestFallback(String content, String? conversationId) async {
    String? effectiveConvId = conversationId;

    if (effectiveConvId == null || effectiveConvId.isEmpty) {
      final createResult = await createAiConversationUseCase(content);
      switch (createResult) {
        case ResultSuccess(data: final newConv):
          effectiveConvId = newConv.id;
          if (state is AiConversationsLoaded) {
            final cur = state as AiConversationsLoaded;
            final updatedList = [
              newConv,
              ...cur.conversations.where((c) => c.id != newConv.id),
            ];
            emit(cur.copyWith(
              conversations: updatedList,
              activeConversationId: newConv.id,
            ));
          }
        case ResultFailure(failure: final failure):
          if (state is AiConversationsLoaded) {
            final cur = state as AiConversationsLoaded;
            emit(cur.copyWith(
              isSending: false,
              isAiTyping: false,
              messagesError: failure.message,
            ));
          }
          return;
      }
    }

    final result = await sendAiMessageUseCase(
      SendAiMessageParams(
        conversationId: effectiveConvId,
        content: content,
      ),
    );

    if (state is! AiConversationsLoaded) return;
    final current = state as AiConversationsLoaded;

    switch (result) {
      case ResultSuccess(data: final aiMessage):
        final alreadyExists = current.messages.any((m) =>
            (aiMessage.id.isNotEmpty && m.id == aiMessage.id) ||
            (!m.isUser && m.content.trim() == aiMessage.content.trim()));

        final updatedList = alreadyExists
            ? current.messages
            : [...current.messages, aiMessage];

        emit(current.copyWith(
          messages: updatedList,
          isSending: false,
          isAiTyping: false,
          streamingReply: '',
          currentRequestId: null,
          messagesError: null,
        ));
      case ResultFailure(failure: final failure):
        emit(current.copyWith(
          isSending: false,
          isAiTyping: false,
          streamingReply: '',
          currentRequestId: null,
          messagesError: failure.message,
        ));
    }
  }

  Future<AiConversationModel?> createConversation(String title) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return null;

    final currentConversations = switch (state) {
      AiConversationsLoaded(:final conversations) => conversations,
      _ => <AiConversationModel>[],
    };
    final currentActiveId = switch (state) {
      AiConversationsLoaded(:final activeConversationId) => activeConversationId,
      _ => null,
    };
    final currentMessages = switch (state) {
      AiConversationsLoaded(:final messages) => messages,
      _ => <AiMessageModel>[],
    };

    emit(AiConversationsLoaded(
      currentConversations,
      activeConversationId: currentActiveId,
      messages: currentMessages,
      isCreating: true,
      isSocketConnected: socketService.isConnected,
    ));

    final result = await createAiConversationUseCase(trimmed);

    switch (result) {
      case ResultSuccess(data: final newConversation):
        final updatedList = [
          newConversation,
          ...currentConversations.where((c) => c.id != newConversation.id),
        ];
        emit(AiConversationsLoaded(
          updatedList,
          activeConversationId: newConversation.id,
          isCreating: false,
          messages: const [],
          isLoadingMessages: false,
          isSocketConnected: socketService.isConnected,
        ));
        return newConversation;
      case ResultFailure(failure: final failure):
        debugPrint(
          'AiConversationsCubit.createConversation failure: ${failure.message}',
        );
        emit(AiConversationsLoaded(
          currentConversations,
          activeConversationId: currentActiveId,
          messages: currentMessages,
          isCreating: false,
          isSocketConnected: socketService.isConnected,
        ));
        return null;
    }
  }

  void selectConversation(String id) {
    if (state is AiConversationsLoaded) {
      final current = state as AiConversationsLoaded;
      if (current.activeConversationId == id && current.messages.isNotEmpty) {
        return;
      }
      emit(current.copyWith(
        activeConversationId: id,
        messages: const [],
        isLoadingMessages: true,
        isSending: false,
        isAiTyping: false,
        streamingReply: '',
        currentRequestId: null,
      ));
      fetchMessages(id);
    }
  }

  void startNewChat() {
    if (state is AiConversationsLoaded) {
      final current = state as AiConversationsLoaded;
      emit(AiConversationsLoaded(
        current.conversations,
        activeConversationId: null,
        messages: const [],
        isLoadingMessages: false,
        isSending: false,
        isAiTyping: false,
        streamingReply: '',
        currentRequestId: null,
        isSocketConnected: current.isSocketConnected,
      ));
    }
  }

  Future<bool> deleteConversation(String conversationId) async {
    if (state is! AiConversationsLoaded) return false;
    final current = state as AiConversationsLoaded;

    final result = await deleteAiConversationUseCase(conversationId);

    switch (result) {
      case ResultSuccess():
        final updatedList = current.conversations
            .where((c) => c.id != conversationId)
            .toList();

        if (current.activeConversationId == conversationId) {
          final nextActiveId =
              updatedList.isNotEmpty ? updatedList.first.id : null;
          emit(AiConversationsLoaded(
            updatedList,
            activeConversationId: nextActiveId,
            messages: const [],
            isLoadingMessages: nextActiveId != null,
            isSocketConnected: current.isSocketConnected,
          ));
          if (nextActiveId != null) {
            await fetchMessages(nextActiveId);
          }
        } else {
          emit(current.copyWith(conversations: updatedList));
        }
        return true;

      case ResultFailure(failure: final failure):
        debugPrint(
          'AiConversationsCubit.deleteConversation failure: ${failure.message}',
        );
        emit(current.copyWith(messagesError: failure.message));
        return false;
    }
  }

  void clearError() {
    if (state is AiConversationsLoaded) {
      final current = state as AiConversationsLoaded;
      emit(current.copyWith(messagesError: null));
    }
  }

  @override
  Future<void> close() {
    _connSub?.cancel();
    _typingSub?.cancel();
    _chunkSub?.cancel();
    _doneSub?.cancel();
    _errorSub?.cancel();
    return super.close();
  }
}
