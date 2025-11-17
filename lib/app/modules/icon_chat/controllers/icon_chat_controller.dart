import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../repository/icon_chat_repository_impl.dart';
import '../../../base/network/dio_provider.dart';
import '../../../data/local/preference/store/user_store.dart';
import '../../../core/services/subscription_service.dart';
import '../../../core/widgets/paywall_dialog.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:web_socket_channel/io.dart';

class IconChatController extends GetxController {
  final messages = <Map<String, dynamic>>[].obs;
  final textController = TextEditingController();
  late IconChatRepositoryImpl chatRepository;
  late SubscriptionService subscriptionService;
  WebSocketChannel? channel;
  int? roomId;
  String? roomName;
  String? token;
  int? traineeProfileId;
  int? trainerProfileId;
  String? mySenderType;

  bool _isConnectingToWebSocket = false;
  bool _isConnectedToWebSocket = false;

  StreamSubscription? _webSocketSubscription;

  @override
  void onInit() {
    super.onInit();
    chatRepository = IconChatRepositoryImpl();
    subscriptionService = Get.find<SubscriptionService>();
    token = UserStore.to.token;
    final args = Get.arguments ?? {};
    traineeProfileId = args['traineeProfileId'] ?? 1;
    trainerProfileId = args['trainerProfileId'] ?? 1;
    mySenderType = 'trainee';
    _initChat();
  }

  Future<void> _initChat() async {
    if (traineeProfileId == null || trainerProfileId == null || token == null) {
      return;
    }
    roomId = await chatRepository.getOrCreateRoom(
      traineeProfileId: traineeProfileId!,
      trainerProfileId: trainerProfileId!,
      token: token!,
    );
    if (roomId != null) {
      await _fetchMessages();
      roomName =
          'chat_${traineeProfileId}_$trainerProfileId'; // You may need to fetch actual room name
      _connectWebSocket();
    }
  }

  Future<void> _fetchMessages() async {
    if (roomId == null || token == null) return;
    final msgs = await chatRepository.fetchMessages(roomId!, token!);
    messages.assignAll(msgs);
  }

  Future<void> _connectWebSocket() async {
    if (roomName == null || token == null) return;
    if (_isConnectingToWebSocket || _isConnectedToWebSocket) return;
    _isConnectingToWebSocket = true;
    _isConnectedToWebSocket = false;

    while (true) {
      try {
        String wsBaseUrl = DioProvider.baseUrl;
        if (wsBaseUrl.startsWith('https://')) {
          wsBaseUrl = wsBaseUrl.replaceFirst('https://', 'wss://');
        } else if (wsBaseUrl.startsWith('http://')) {
          wsBaseUrl = wsBaseUrl.replaceFirst('http://', 'ws://');
        }
        final wsUrl = '$wsBaseUrl/ws/icon_chat/';
        channel = IOWebSocketChannel.connect(
          wsUrl,
          headers: {'Authorization': 'Bearer $token'},
        );
        await channel?.ready;
        _webSocketSubscription?.cancel(); // Cancel any previous subscription
        _webSocketSubscription = channel?.stream.listen(
          (data) {
            try {
              final decoded = jsonDecode(data);
              messages.insert(0, {
                'content': decoded['message'],
                'sender_type': decoded['sender_type'] ?? 'trainer_icon',
                'timestamp': DateTime.now().toIso8601String(),
              });
            } catch (e, s) {
              log(
                "Error decoding chats websocket message.",
                error: e,
                stackTrace: s,
                name: 'icon_chat_controller',
              );
            }
          },
          onDone: () async {
            log(
              "WebSocket connection closed. Attempting to reconnect...",
              name: 'icon_chat_controller',
            );
            _isConnectedToWebSocket = false;
            await _webSocketSubscription?.cancel();
            await Future.delayed(const Duration(seconds: 2));
            _connectWebSocket();
          },
          onError: (error) async {
            log("WebSocket error: $error", name: 'icon_chat_controller');
            _isConnectedToWebSocket = false;
            await _webSocketSubscription?.cancel();
            await Future.delayed(const Duration(seconds: 2));
            _connectWebSocket();
          },
          cancelOnError: true,
        );
        _isConnectedToWebSocket = true;
        _isConnectingToWebSocket = false;
        log("WebSocket connected successfully.", name: 'icon_chat_controller');
        break;
      } catch (e) {
        log(
          "WebSocket connection error: $e. Retrying in 5 seconds...",
          name: 'icon_chat_controller',
        );
        await Future.delayed(const Duration(seconds: 5));
        continue;
      }
    }
  }

  void optimisticSendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty || roomId == null || token == null) return;

    if (!subscriptionService.canSendMessage()) {
      _showPaywall();
      return;
    }

    messages.insert(0, {
      'content': text,
      'sender_type': mySenderType ?? 'trainee',
      'timestamp': DateTime.now().toIso8601String(),
    });
    textController.clear();
    try {
      channel?.sink.add(jsonEncode({'message': text}));
    } catch (e) {
      log(
        "Error sending message via WebSocket.",
        error: e,
        name: 'icon_chat_controller',
      );
    }
  }

  /// Show paywall dialog when user runs out of free messages
  void _showPaywall() {
    Get.dialog(
      const PaywallDialog(),
      barrierDismissible: false, // Prevent dismissing by tapping outside
    );
  }

  @override
  void onClose() {
    log(
      'IconChatController disposed, closing WebSocket',
      name: 'icon_chat_controller',
    );
    textController.dispose();
    _webSocketSubscription?.cancel();
    channel?.sink.close();
    super.onClose();
  }
}
