import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp5/models/user.dart';
import '../../models/message_model.dart';
import '../../screens/chat_screen/bloc_personal_chat/personal_chat_bloc.dart';

class ChatMessageList extends StatelessWidget {
  final List<Message> messages;
  final ScrollController scrollController;
  final User chatPartner;
  final String chatRoomId;

  const ChatMessageList({
    super.key,
    required this.messages,
    required this.scrollController,
    required this.chatPartner,
    required this.chatRoomId,
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
        final isPreviousMessageFromCurrentUser =
            index < messages.length - 1 &&
                messages[index + 1].senderId != chatPartner.id;
        final isCurrentMessageFromChatPartner = isFromChatPartner;

        return Column(
          crossAxisAlignment: isCurrentMessageFromChatPartner
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            // Display avatar for chat partner if needed
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
                  horizontal: MediaQuery.of(context).size.height * 0.02,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height *
                      0.015, // Dynamic vertical padding
                  horizontal: MediaQuery.of(context).size.width *
                      0.03, // Dynamic horizontal padding
                ),
                decoration: BoxDecoration(
                  color: isCurrentMessageFromChatPartner
                      ? const Color(0xFFDBD6E0)
                      : const Color(0xFFC5B3E5),
                  borderRadius: BorderRadius.only(
                    topLeft: isCurrentMessageFromChatPartner
                        ? Radius.zero
                        : const Radius.circular(18.0),
                    topRight: const Radius.circular(18.0),
                    bottomLeft: const Radius.circular(18.0),
                    bottomRight: isCurrentMessageFromChatPartner
                        ? const Radius.circular(18.0)
                        : Radius.zero,
                  ),
                ),
                child: BlocBuilder<PersonalChatBloc, PersonalChatState>(
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (message.messageType != MessageType.text &&
                            message.fileName != null) ...[
                          GestureDetector(
                            onTap: () {
                              context.read<PersonalChatBloc>().add(
                                  DownloadFile(
                                      fileName: message.fileName!,
                                      chatRoomId: chatRoomId));
                              print("File tapped: ${message.fileName}");
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.description,
                                  color: Colors.black,
                                  size: 25,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  message.fileName != null
                                      ? '#${message.fileName!}'
                                      : 'File',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        if (message.messageContent.isNotEmpty) ...[
                          Text(
                            message.messageContent,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
