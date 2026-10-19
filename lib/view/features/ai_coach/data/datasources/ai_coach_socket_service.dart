import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:tommy/core/config/app_config.dart';
import 'package:tommy/core/utils/prefs_helper.dart';

class AiCoachTypingData {
  final String requestId;
  final String? conversationId;

  const AiCoachTypingData({required this.requestId, this.conversationId});
}

class AiCoachChunkData {
  final String requestId;
  final String? conversationId;
  final String delta;

  const AiCoachChunkData({
    required this.requestId,
    this.conversationId,
    required this.delta,
  });
}

class AiCoachDoneData {
  final String requestId;
  final String conversationId;
  final String? messageId;
  final String reply;

  const AiCoachDoneData({
    required this.requestId,
    required this.conversationId,
    this.messageId,
    required this.reply,
  });
}

class AiCoachErrorData {
  final String? requestId;
  final String message;

  const AiCoachErrorData({this.requestId, required this.message});
}

class AiCoachNotificationData {
  final String title;
  final Map<String, dynamic> raw;

  const AiCoachNotificationData({required this.title, this.raw = const {}});
}

class AiCoachSocketService {
  static final AiCoachSocketService _instance =
      AiCoachSocketService._internal();
  factory AiCoachSocketService() => _instance;
  AiCoachSocketService._internal();

  io.Socket? _socket;
  String? _token;
  bool _isConnecting = false;
  String? _lastDoneRequestId;
  String? _lastDoneMessageId;

  final _typingController =
      StreamController<AiCoachTypingData>.broadcast();
  final _chunkController =
      StreamController<AiCoachChunkData>.broadcast();
  final _doneController = StreamController<AiCoachDoneData>.broadcast();
  final _errorController =
      StreamController<AiCoachErrorData>.broadcast();
  final _notificationController =
      StreamController<AiCoachNotificationData>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();

  Stream<AiCoachTypingData> get onTyping => _typingController.stream;
  Stream<AiCoachChunkData> get onChunk => _chunkController.stream;
  Stream<AiCoachDoneData> get onDone => _doneController.stream;
  Stream<AiCoachErrorData> get onErrorEvent => _errorController.stream;
  Stream<AiCoachNotificationData> get onNotification =>
      _notificationController.stream;
  Stream<bool> get onConnectionChanged => _connectionController.stream;

  bool get isConnected => _socket?.connected == true;
  String? get currentToken => _token;

  static Map<String, dynamic> _asMap(dynamic data) {
    if (data == null) return <String, dynamic>{};
    if (data is Map<String, dynamic>) return data;
    if (data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), value));
    }
    if (data is String && data.trim().startsWith('{')) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map) {
          return decoded.map((key, value) => MapEntry(key.toString(), value));
        }
      } catch (_) {}
    }
    return <String, dynamic>{};
  }

  void connect({String? token}) {
    final effectiveToken = (token ?? PrefsHelper.token).trim();
    if (effectiveToken.isEmpty) {
      debugPrint('[AiCoachSocketService] Cannot connect without access token');
      return;
    }

    if (_socket != null && _token == effectiveToken) {
      if (_socket!.connected) {
        debugPrint(
          '[AiCoachSocketService] Socket already connected with current token',
        );
        return;
      }
      if (_isConnecting) {
        debugPrint(
          '[AiCoachSocketService] Socket is already in connecting state',
        );
        return;
      }
      _isConnecting = true;
      _socket!.connect();
      return;
    }

    disconnect();
    _token = effectiveToken;
    _isConnecting = true;

    try {
      debugPrint(
        '[AiCoachSocketService] Connecting to ${AppConfig.socketUrl} (auth & query token set)',
      );

      final options = io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': effectiveToken})
          .setQuery({'token': effectiveToken})
          .enableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(10)
          .setReconnectionDelay(2000)
          .build();
      options['forceNew'] = true;

      _socket = io.io(AppConfig.socketUrl, options);

      _socket!.clearListeners();

      _socket!.onConnect((_) {
        _isConnecting = false;
        debugPrint('[AiCoachSocketService] Connected! socketId=${_socket?.id}');
        _connectionController.add(true);
      });

      _socket!.onDisconnect((reason) {
        _isConnecting = false;
        debugPrint('[AiCoachSocketService] Disconnected. reason: $reason');
        _connectionController.add(false);
      });

      _socket!.onConnectError((err) {
        _isConnecting = false;
        debugPrint('[AiCoachSocketService] Connect error: $err');
        _connectionController.add(false);
      });

      _socket!.onError((err) {
        debugPrint('[AiCoachSocketService] Error: $err');
        _errorController.add(
          AiCoachErrorData(
            message: err?.toString() ?? 'Socket connection error',
          ),
        );
      });

      _socket!.on('ai-coach:typing', (data) {
        debugPrint('[AiCoachSocketService] event: ai-coach:typing -> $data');
        final map = _asMap(data);
        _typingController.add(
          AiCoachTypingData(
            requestId: map['requestId']?.toString() ?? '',
            conversationId: map['conversationId']?.toString(),
          ),
        );
      });

      _socket!.on('ai-coach:chunk', (data) {
        final map = _asMap(data);
        _chunkController.add(
          AiCoachChunkData(
            requestId: map['requestId']?.toString() ?? '',
            conversationId: map['conversationId']?.toString(),
            delta: map['delta']?.toString() ?? '',
          ),
        );
      });

      _socket!.on('ai-coach:done', (data) {
        debugPrint('[AiCoachSocketService] event: ai-coach:done -> $data');
        final map = _asMap(data);
        final requestId = map['requestId']?.toString() ?? '';
        final messageId = map['messageId']?.toString();
        final conversationId = map['conversationId']?.toString() ?? '';
        final reply = map['reply']?.toString() ?? '';

        // Deduplicate multiple identical done events from socket
        if (requestId.isNotEmpty && requestId == _lastDoneRequestId) {
          debugPrint(
            '[AiCoachSocketService] Ignoring duplicate done event for requestId: $requestId',
          );
          return;
        }
        if (messageId != null &&
            messageId.isNotEmpty &&
            messageId == _lastDoneMessageId) {
          debugPrint(
            '[AiCoachSocketService] Ignoring duplicate done event for messageId: $messageId',
          );
          return;
        }

        _lastDoneRequestId = requestId;
        _lastDoneMessageId = messageId;

        _doneController.add(
          AiCoachDoneData(
            requestId: requestId,
            conversationId: conversationId,
            messageId: messageId,
            reply: reply,
          ),
        );
      });

      _socket!.on('ai-coach:error', (data) {
        debugPrint('[AiCoachSocketService] event: ai-coach:error -> $data');
        final map = _asMap(data);
        _errorController.add(
          AiCoachErrorData(
            requestId: map['requestId']?.toString(),
            message: map['message']?.toString() ?? 'Something went wrong',
          ),
        );
      });

      _socket!.on('notification', (data) {
        debugPrint('[AiCoachSocketService] event: notification -> $data');
        final map = _asMap(data);
        _notificationController.add(
          AiCoachNotificationData(
            title: map['title']?.toString() ?? '',
            raw: map,
          ),
        );
      });

      _socket!.connect();
    } catch (e) {
      debugPrint('[AiCoachSocketService] Exception while connecting: $e');
    }
  }

  void emitSend({
    required String content,
    String? conversationId,
    required String requestId,
    void Function(Map<String, dynamic> ack)? onAck,
  }) {
    if (_socket == null || !_socket!.connected) {
      throw StateError('Socket is not connected');
    }

    final payload = <String, dynamic>{
      'content': content,
      if (conversationId != null && conversationId.trim().isNotEmpty)
        'conversationId': conversationId.trim(),
      'requestId': requestId,
    };

    debugPrint('[AiCoachSocketService] emit ai-coach:send -> $payload');

    if (onAck != null) {
      _socket!.emitWithAck('ai-coach:send', payload, ack: (ackData) {
        debugPrint('[AiCoachSocketService] ack callback -> $ackData');
        onAck(_asMap(ackData));
      });
    } else {
      _socket!.emit('ai-coach:send', payload);
    }
  }

  void disconnect() {
    try {
      _isConnecting = false;
      _socket?.clearListeners();
      _socket?.disconnect();
      _socket?.destroy();
      _socket = null;
    } catch (e) {
      debugPrint('[AiCoachSocketService] Error during disconnect: $e');
    }
  }

  void dispose() {
    disconnect();
    _typingController.close();
    _chunkController.close();
    _doneController.close();
    _errorController.close();
    _notificationController.close();
    _connectionController.close();
  }
}
