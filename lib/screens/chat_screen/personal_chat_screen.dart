import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';
import 'package:flutter_gp5/repos/authentication/authentication_repository.dart';
import 'package:flutter_gp5/repos/chat/chat_room_repository.dart';
import 'package:flutter_gp5/screens/chat_screen/bloc_personal_chat/personal_chat_bloc.dart';

import '../../locale/l10n/app_locale.dart';
import '../../models/message_model.dart';
import '../../models/user.dart';
import '../../widgets/custom_circular_progress_indicator.dart';

class PersonalChatScreen extends StatefulWidget {
  final User chatPartner;

  const PersonalChatScreen({super.key, required this.chatPartner});

  @override
  _PersonalChatScreenState createState() => _PersonalChatScreenState();
}

class _PersonalChatScreenState extends State<PersonalChatScreen> {
  late TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PersonalChatBloc(
        authRepository: context.read<AuthenticationRepository>(),
        chatRoomRepository: context.read<ChatRoomRepository>(),
      )..add(
          CreateChatRoomEvent(chatParticipantTwoId: widget.chatPartner.id),
        ),
      child: BlocListener<PersonalChatBloc, PersonalChatState>(
        listener: (context, state) {
          if (state is PersonalChatRoomCreatedState) {
            context.read<PersonalChatBloc>().add(
                GetMessagesEvent(chatParticipantTwoId: widget.chatPartner.id));
          }
        },
        child: _PersonalChat(
          chatPartner: widget.chatPartner,
          messageController: _messageController,
        ),
      ),
    );
  }
}

class _PersonalChat extends StatelessWidget {
  final User chatPartner;
  final TextEditingController messageController;

  const _PersonalChat(
      {required this.chatPartner, required this.messageController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet:
          buildBottomChatBar(context, messageController, chatPartner.id),
      resizeToAvoidBottomInset: true,
      appBar: buildAppBar(context, chatPartner),
      body: BlocBuilder<PersonalChatBloc, PersonalChatState>(
        builder: (context, state) {
          if (state is PersonalChatMessagesLoadedState) {
            return buildChatMessageListTile(context, state.messagesList,null);
          } else if (state is PersonalChatLoadingState || state is PersonalChatRoomCreatedState) {
            return buildLoadingWidget(context);
          } else {
            return const SizedBox(
              child: Text("Doesnt Work"),
            );
          }
        },
      ),
    );
  }
}

Widget buildBottomChatBar(BuildContext context,
    TextEditingController messageController, String chatPartnerId) {
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
          Container(
            width: context.setWidth(60),
            decoration: BoxDecoration(
              color: const Color(0x1D1B2025),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: context.setWidth(6),
                ),
                Expanded(
                  child: TextField(
                    controller: messageController,
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    minLines: null,
                    maxLines: null,
                    textAlign: TextAlign.left,
                    // Aligns the user input text to the left
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Type a message',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),

                // Icon for sending message
                IconButton(
                  iconSize: 28,
                  icon: const Icon(Icons.send_sharp, color: Colors.black),
                  onPressed: () {
                    // Get the text from the TextField
                    final messageText = messageController.text.trim();
                    if (messageText.isNotEmpty) {
                      // Dispatch an event to send the message
                      context.read<PersonalChatBloc>().add(
                            SendMessageEvent(
                              receiverId: chatPartnerId,
                              messageContent: messageText,
                              timestamp: Timestamp.fromDate(DateTime.now()),
                              messageType: "String",
                            ),
                          );

                      // Clear the TextField
                      messageController.clear();
                    } else {
                      print('Message is empty');
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

PreferredSizeWidget buildAppBar(BuildContext context, User chatPartner) {
  return AppBar(
    toolbarHeight: context.setHeight(10),
    leadingWidth: context.setWidth(8), // Set toolbar height
    leading: Align(
      alignment: Alignment.center,
      child: Transform.scale(
        scale: 2.7,
        child: IconButton(
          icon: const Icon(Icons.navigate_before, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
    ),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Circular Avatar
        const CircleAvatar(
          radius: 30,
          // Adjust the radius as needed
          backgroundImage: NetworkImage(
              'https://via.placeholder.com/150'), // Replace with your image URL
        ),
        SizedBox(width: context.setWidth(2)),
        // Space between the avatar and text
        // Text
        Expanded(
          child: Text(
            chatPartner.name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Icons
        IconButton(
          icon: const Icon(
            Icons.call,
          ),
          iconSize: context.setWidth(9),
          onPressed: () {
            print('Call icon pressed');
          },
        ),
        IconButton(
          icon: const Icon(Icons.videocam_rounded),
          iconSize: context.setWidth(10),
          onPressed: () {
            print('Camera icon pressed');
          },
        ),
      ],
    ),
  );
}

Widget buildChatMessageListTile(
    BuildContext context, List<Message> messages, String? currentUserId) {
  return Expanded(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            return SizedBox(child:Text(message.messageContent));
          }));
}

Widget buildLoadingWidget(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Center(
        child: Text(
          AppLocale.of(context)!.loading,
        ),
      ),
      SizedBox(
        height: context.setHeight(3),
      ),
      const CustomCircularProgressIndicator(),
      SizedBox(
        height: context.setHeight(3),
      ),
    ],
  );
}
