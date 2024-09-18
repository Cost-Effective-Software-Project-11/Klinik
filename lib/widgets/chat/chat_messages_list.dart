import 'package:flutter/material.dart';
import 'package:flutter_gp5/models/user.dart';

import '../../models/message_model.dart';

class ChatMessageList extends StatelessWidget {
  final List<Message> messages;
  final ScrollController scrollController;
  final User chatPartner;

  const ChatMessageList({
    super.key,
    required this.messages,
    required this.scrollController,
    required this.chatPartner,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height * 0.12,
        top: MediaQuery.of(context).size.height * 0.05,
      ),
      controller: scrollController,
      itemCount: messages.length,
      reverse: true,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isFromChatPartner = message.senderId == chatPartner.id;
        final isPreviousMessageFromCurrentUser = index < messages.length - 1 &&
            messages[index + 1].senderId != chatPartner.id;
        final isCurrentMessageFromChatPartner = isFromChatPartner;

        return Column(
          crossAxisAlignment: isCurrentMessageFromChatPartner
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            if (index < messages.length - 1 &&
                isPreviousMessageFromCurrentUser &&
                isCurrentMessageFromChatPartner)
              const Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      NetworkImage('https://via.placeholder.com/150'),
                ),
              ),
            Align(
              alignment: isCurrentMessageFromChatPartner
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Container(
                margin: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.003,
                  horizontal: MediaQuery.of(context).size.height * 0.01,
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: isCurrentMessageFromChatPartner
                      ? const Color(0xFFDBD6E0)
                      : const Color(0xFFC5B3E5),
                  borderRadius: BorderRadius.only(
                    topLeft: isCurrentMessageFromChatPartner
                        ? Radius.zero
                        : const Radius.circular(12.0),
                    topRight: const Radius.circular(12.0),
                    bottomLeft: const Radius.circular(12.0),
                    bottomRight: isCurrentMessageFromChatPartner
                        ? const Radius.circular(12.0)
                        : Radius.zero,
                  ),
                ),
                child: Text(
                  message.messageContent,
                  style: TextStyle(
                    color: isCurrentMessageFromChatPartner
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
