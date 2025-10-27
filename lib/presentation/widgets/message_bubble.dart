import 'package:flutter/material.dart';
import 'package:gpt_clone/models/sender.dart';
import '../styles/app_theme.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message, required this.isUser});

  final Message message;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    final bubbleGradient = isUser
        ? AppGradients.userBubble
        : AppGradients.botBubble;
    final textColor = isUser ? Colors.white : Colors.white.withOpacity(0.95);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: bubbleGradient,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: isUser
                  ? const Radius.circular(18)
                  : const Radius.circular(4),
              bottomRight: isUser
                  ? const Radius.circular(4)
                  : const Radius.circular(18),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Text(
              message.content,
              style: TextStyle(color: textColor, height: 1.28, fontSize: 15.5),
            ),
          ),
        ),
      ),
    );
  }
}
