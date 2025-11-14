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

  @override
  void onInit() {
    super.onInit();
    chatRepository = IconChatRepositoryImpl();
    subscriptionService = Get.find<SubscriptionService>();
    token = UserStore.to.token;
    // Get IDs from navigation arguments or user context
    final args = Get.arguments ?? {};
    traineeProfileId =
        args['traineeProfileId'] ?? 1; // Replace with actual logic
    trainerProfileId =
        args['trainerProfileId'] ?? 1; // Replace with actual logic
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
    String wsBaseUrl = DioProvider.baseUrl;
    if (wsBaseUrl.startsWith('https://')) {
      wsBaseUrl = wsBaseUrl.replaceFirst('https://', 'wss://');
    } else if (wsBaseUrl.startsWith('http://')) {
      wsBaseUrl = wsBaseUrl.replaceFirst('http://', 'ws://');
    }
    final wsUrl = '$wsBaseUrl/ws/ai_chat/$roomName/';
    channel = IOWebSocketChannel.connect(
      wsUrl,
      headers: {'Authorization': 'Bearer $token'},
    );
    await channel?.ready;
    channel?.stream.listen((data) {
      try {
        final decoded = jsonDecode(data);
        messages.insert(0, {
          'content': decoded['message'],
          'user_id': decoded['user_id'],
          'sender_type': decoded['sender_type'],
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
    });
  }

  void optimisticSendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty || roomId == null || token == null) return;
    
    // Check subscription status before sending message
    if (!subscriptionService.canSendMessage()) {
      _showPaywall();
      return;
    }
    
    // Optimistically add message to UI
    messages.insert(0, {
      'content': text,
      'user_id': 'me',
      'timestamp': DateTime.now().toIso8601String(),
    });
    textController.clear();
    
    // Send to WebSocket
    try {
      channel?.sink.add(jsonEncode({'message': text}));
    } catch (_) {}
    
    // Also send to REST API for persistence
    try {
      await chatRepository.sendMessage(roomId!, token!, text);
      // After successful message send, decrement free message count
      await subscriptionService.onMessageSent();
    } catch (_) {}
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
    print('[icon_chat] IconChatController disposed, closing WebSocket');
    textController.dispose();
    channel?.sink.close();
    super.onClose();
  }
}
