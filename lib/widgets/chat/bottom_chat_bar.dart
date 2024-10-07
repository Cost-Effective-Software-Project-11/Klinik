import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';
import '../../models/message_model.dart';
import '../../screens/chat_screen/bloc_personal_chat/personal_chat_bloc.dart';
import '../../services/storage_service.dart';

class BottomChatBar extends StatelessWidget {
  BottomChatBar({
    super.key,
    required this.chatPartnerId,
    required this.messageController,
    required this.scrollController,
  });

  final String chatPartnerId;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController messageController;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: context.setHeight(10),
        color: Colors.white,
        child: BlocBuilder<PersonalChatBloc, PersonalChatState>(
          builder: (context, state) {
            final hasFile = state.filePath.isNotEmpty;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 28,
                  icon: const Icon(Icons.attach_file, color: Colors.black),
                  onPressed: () {
                    context.read<PersonalChatBloc>().add(GetFilePath());
                  },
                ),
                IconButton(
                  iconSize: 28,
                  icon: const Icon(Icons.camera_alt_rounded, color: Colors.black),
                  onPressed: () {
                    print('Camera icon pressed');
                  },
                ),
                 SizedBox(width: context.setWidth(3)),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0x1D1B2025),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Row(
                        children: [
                          SizedBox(width: context.setWidth(3)),
                          Expanded(
                            child: TextFormField(
                              controller: messageController,
                              textInputAction: TextInputAction.newline,
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: null,
                              textAlign: TextAlign.left,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: hasFile ? 'File selected: ${state.filePath.split('/').last}' : 'Type a message',
                                hintStyle: const TextStyle(color: Colors.grey),
                                prefixIcon: hasFile
                                    ? const Icon(Icons.insert_drive_file, color: Colors.black)
                                    : null,
                              ),
                            ),
                          ),
                          IconButton(
                            iconSize: 28,
                            icon: const Icon(Icons.send_sharp, color: Colors.black),
                            onPressed: () async {
                              final filePath = state.filePath;
                              final hasText = messageController.text.trim().isNotEmpty;
                              final hasFile = filePath.isNotEmpty;

                              if (hasText || hasFile) {
                                String? fileDownloadUrl;
                                String? fileName;
                                if (hasFile) {
                                  fileName = filePath.split('/').last;
                                  fileDownloadUrl = await StorageService().uploadFileAndReturnDownloadURL(filePath, state.chatRoomId);
                                }

                                // Determine the message type based on whether there is text and/or a file
                                final messageType = hasText && fileDownloadUrl != null
                                    ? MessageType.textAndFile
                                    : hasFile
                                    ? MessageType.file
                                    : MessageType.text;

                                // Dispatch the SendMessageEvent with the correct message type
                                context.read<PersonalChatBloc>().add(SendMessageEvent(
                                  receiverId: chatPartnerId,
                                  messageContent: hasText ? messageController.text : '',
                                  messageType: messageType, // Pass the message type
                                  timestamp: Timestamp.fromDate(DateTime.now()),
                                  filePath: fileDownloadUrl ?? '',
                                  fileName: fileName ?? '',
                                ));

                                // Scroll to bottom after sending the message
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  if (scrollController.hasClients) {
                                    scrollController.animateTo(
                                      scrollController.position.minScrollExtent,
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeOut,
                                    );
                                  }
                                });

                                // Clear the text input after sending the message
                                messageController.clear();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please enter a message or select a file.')),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
