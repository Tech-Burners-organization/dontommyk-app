import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:tommy/core/result/result.dart';
import 'package:tommy/core/usecase/usecase.dart';
import 'package:tommy/view/features/ai_coach/data/models/ai_conversation_model.dart';
import 'package:tommy/view/features/ai_coach/data/models/ai_message_model.dart';
import 'package:tommy/view/features/ai_coach/domain/usecases/create_ai_conversation_usecase.dart';
import 'package:tommy/view/features/ai_coach/domain/usecases/get_ai_conversations_usecase.dart';
import 'package:tommy/view/features/ai_coach/domain/usecases/get_ai_messages_usecase.dart';

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

  const AiConversationsLoaded(
    this.conversations, {
    this.activeConversationId,
    this.isCreating = false,
    this.messages = const [],
    this.isLoadingMessages = false,
    this.messagesError,
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
  }) {
    return AiConversationsLoaded(
      conversations ?? this.conversations,
      activeConversationId:
          activeConversationId ?? this.activeConversationId,
      isCreating: isCreating ?? this.isCreating,
      messages: messages ?? this.messages,
      isLoadingMessages: isLoadingMessages ?? this.isLoadingMessages,
      messagesError: messagesError,
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

  AiConversationsCubit({
    required this.getAiConversationsUseCase,
    required this.createAiConversationUseCase,
    required this.getAiMessagesUseCase,
  }) : super(const AiConversationsInitial());

  Future<void> fetchConversations({String? selectId}) async {
    if (state is! AiConversationsLoaded) {
      emit(const AiConversationsLoading());
    }

    final result = await getAiConversationsUseCase(const NoParams());

    switch (result) {
      case ResultSuccess(data: final conversations):
        final currentActive = selectId ??
            (state is AiConversationsLoaded
                ? (state as AiConversationsLoaded).activeConversationId
                : null);

        final activeId = currentActive ??
            (conversations.isNotEmpty ? conversations.first.id : null);

        emit(AiConversationsLoaded(
          conversations,
          activeConversationId: activeId,
          messages: const [],
          isLoadingMessages: activeId != null,
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
        emit(latest.copyWith(
          messages: messages,
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
      ));
    }
  }
}
