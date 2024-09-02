import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';

import '../../screens/chat_screen/bloc_personal_chat/personal_chat_bloc.dart';

class BottomChatBar extends StatelessWidget {
  BottomChatBar({super.key, required this.chatPartnerId, required this.messageController});

  final String chatPartnerId;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController messageController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: context.setHeight(10),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              iconSize: context.setRadius(context, 8),
              icon: const Icon(Icons.attach_file, color: Colors.black),
              onPressed: () {
                print('Attach file icon pressed');
              },
            ),
            IconButton(
              iconSize: context.setWidth(8),
              icon: const Icon(Icons.camera_alt_rounded, color: Colors.black),
              onPressed: () {
                print('Camera icon pressed');
              },
            ),
            SizedBox(width: context.setWidth(3)),
            Expanded(
              child: Container(
                width: context.setWidth(60),  // No need to set the width here as it's wrapped in Expanded
                decoration: BoxDecoration(
                  color: const Color(0x1D1B2025),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Form(
                  key: _formKey,
                  child: Row(
                    children: [
                      SizedBox(
                        width: context.setWidth(6),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: messageController,
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: null,
                          textAlign: TextAlign.left,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Type a message',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Message cannot be empty';
                            }
                            return null;
                          },
                        ),
                      ),
                      IconButton(
                        iconSize: 28,
                        icon: const Icon(Icons.send_sharp, color: Colors.black),
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            context.read<PersonalChatBloc>().add(SendMessageEvent(
                              receiverId: chatPartnerId,
                              messageContent: messageController.text,
                              timestamp: Timestamp.fromDate(DateTime.now()),
                            ));
                            messageController.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
