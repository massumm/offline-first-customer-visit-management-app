import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import '../controllers/icon_chat_controller.dart';

const scaffoldBackgroundColor = Color(0xFF121212);
const primaryColor = Color(0xFFFFFFFF);
const secondaryHeaderColor = Color(0xFFB0B0B0);
const componentBackgroundColor = Color(0xFF2C2C2E);
const senderBubbleColor = Color(0xFFE55C37);
const onlineIndicator = Color(0xFF00C853);

class IconChatView extends GetView<IconChatController> {
  const IconChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: CustomAppBar(),
      ),
      body: Obx(() {
        if (controller.messages.isEmpty) {
          // Welcome/Empty State
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                    'assets/images/icon-logo-pink.png',
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Say Hi, to Icon Mish',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Welcome to your chat! Start a conversation or choose a suggestion below.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: secondaryHeaderColor,
                    fontFamily: 'Inter',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    _SuggestionChip(label: 'I want to build muscle'),
                    _SuggestionChip(label: 'Meal plan help'),
                    _SuggestionChip(label: 'Motivation tips'),
                    _SuggestionChip(label: 'Suggest my first workout'),
                  ],
                ),
              ],
            ),
          );
        } else {
          // Active Chat
          return ListView.builder(
            reverse: true,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            itemCount: controller.messages.length,
            itemBuilder: (context, index) {
              final message = controller.messages[index];
              final senderType = message['sender_type'];
              final time = message['timestamp'] ?? '12:00';
              if (senderType == 'trainee') {
                return SenderMessageBubble(
                  text: message['content'] ?? '',
                  timestamp: time,
                );
              } else {
                return ReceiverMessageBubble(
                  text: message['content'] ?? '',
                  timestamp: time,
                );
              }
            },
          );
        }
      }),
      bottomNavigationBar: const ChatInputBar(),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: componentBackgroundColor,
          ),
          child: IconButton(
            icon: const Icon(
              CupertinoIcons.back,
              color: primaryColor,
              size: 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      title: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/icon-logo-pink.png'),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: onlineIndicator,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: scaffoldBackgroundColor,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Mish Icon',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                'Online',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: secondaryHeaderColor,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(
            CupertinoIcons.chat_bubble,
            color: primaryColor,
            size: 22,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(
            CupertinoIcons.settings,
            color: primaryColor,
            size: 22,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}

class ChatInputBar extends StatefulWidget {
  const ChatInputBar({super.key});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<IconChatController>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: scaffoldBackgroundColor,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.textController,
              decoration: InputDecoration(
                filled: true,
                fillColor: componentBackgroundColor,
                hintText: 'Type Here...',
                hintStyle: const TextStyle(color: secondaryHeaderColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(
                  Icons.graphic_eq_rounded,
                  color: secondaryHeaderColor,
                ),
              ),
              style: const TextStyle(
                color: primaryColor,
                fontSize: 16,
                fontFamily: 'Inter',
              ),
              onSubmitted: (_) {
                controller.optimisticSendMessage();
              },
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: senderBubbleColor,
            shape: const CircleBorder(),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () {
                controller.optimisticSendMessage();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final String label;
  const _SuggestionChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return RawChip(
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: primaryColor,
          fontFamily: 'Inter',
        ),
      ),
      backgroundColor: componentBackgroundColor,
      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
    );
  }
}

class SenderMessageBubble extends StatelessWidget {
  final String text;
  final String timestamp;
  const SenderMessageBubble({super.key, required this.text, required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: senderBubbleColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(4),
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: primaryColor,
                fontFamily: 'Inter',
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            timestamp,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: secondaryHeaderColor,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}

class ReceiverMessageBubble extends StatelessWidget {
  final String text;
  final String timestamp;
  const ReceiverMessageBubble({super.key, required this.text, required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: componentBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: primaryColor,
                fontFamily: 'Inter',
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            timestamp,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: secondaryHeaderColor,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
