import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:intl/intl.dart';
import '../controllers/icon_chat_controller.dart';
import '../../../data/local/preference/store/user_store.dart';

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
    // final IconChatController controller = Get.find<IconChatController>();
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
                Image.asset(
                  'assets/images/icon-logo-pink.png',
                  width: 80,
                  height: 80,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Welcome to Icon Chat!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Start a conversation with your AI trainer.',
                  style: TextStyle(
                    fontSize: 16,
                    color: secondaryHeaderColor,
                    fontFamily: 'Inter',
                  ),
                  textAlign: TextAlign.center,
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
              String formattedTime;
              try {
                final rawTimestamp = message['timestamp'];
                if (rawTimestamp != null && rawTimestamp.isNotEmpty) {
                  // Assuming the timestamp is an ISO 8601 string.
                  final dateTime = DateTime.parse(rawTimestamp);
                  // Formats the time to a pattern like "5:30 PM".
                  formattedTime = DateFormat('h:mm a').format(dateTime);
                } else {
                  formattedTime = '';
                }
              } catch (e) {
                // Fallback to an empty string if parsing fails.
                formattedTime = '';
              }
              final text = message['content'] ?? '';
              if (senderType == 'trainee') {
                return SenderMessageBubble(text: text, timestamp: formattedTime);
              } else {
                return ReceiverMessageBubble(text: text, timestamp: formattedTime);
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
  const CustomAppBar({Key? key}) : super(key: key);

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
                backgroundImage: AssetImage('assets/images/icon-logo-pink.png'),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: onlineIndicator,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
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
          ),
          // Subscription Status Indicator
          Obx(() {
            final userStore = Get.find<UserStore>();
            if (userStore.isPremium) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF00C853).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF00C853).withOpacity(0.3),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, size: 12, color: Color(0xFF00C853)),
                    SizedBox(width: 4),
                    Text(
                      'Premium',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF00C853),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              );
            } else {
              final remainingMessages = userStore.remainingFreeMessages;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: senderBubbleColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: senderBubbleColor.withOpacity(0.3)),
                ),
                child: Text(
                  '$remainingMessages left',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: senderBubbleColor,
                    fontFamily: 'Inter',
                  ),
                ),
              );
            }
          }),
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
    final userStore = Get.find<UserStore>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: scaffoldBackgroundColor,
      child: Obx(() {
        final bool canSendMessage =
            userStore.isPremium || userStore.remainingFreeMessages > 0;
        final String hintText = canSendMessage
            ? 'Type Here...'
            : 'Subscribe to continue...';

        return Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.textController,
                enabled: canSendMessage,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: canSendMessage
                      ? componentBackgroundColor
                      : componentBackgroundColor.withOpacity(0.5),
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: canSendMessage
                        ? secondaryHeaderColor
                        : secondaryHeaderColor.withOpacity(0.5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(
                    canSendMessage
                        ? Icons.graphic_eq_rounded
                        : Icons.lock_outlined,
                    color: canSendMessage
                        ? secondaryHeaderColor
                        : secondaryHeaderColor.withOpacity(0.5),
                  ),
                ),
                style: TextStyle(
                  color: canSendMessage
                      ? primaryColor
                      : primaryColor.withOpacity(0.5),
                  fontSize: 16,
                  fontFamily: 'Inter',
                ),
                onSubmitted: canSendMessage
                    ? (_) {
                        controller.optimisticSendMessage();
                      }
                    : null,
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: canSendMessage
                  ? senderBubbleColor
                  : senderBubbleColor.withOpacity(0.5),
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: canSendMessage
                    ? () {
                        controller.optimisticSendMessage();
                        "Calling method".log();
                      }
                    : null,
              ),
            ),
          ],
        );
      }),
    );
  }
}
/*
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
}*/

class SenderMessageBubble extends StatelessWidget {
  final String text;
  final String timestamp;
  const SenderMessageBubble({
    super.key,
    required this.text,
    required this.timestamp,
  });

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
  const ReceiverMessageBubble({
    super.key,
    required this.text,
    required this.timestamp,
  });

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
