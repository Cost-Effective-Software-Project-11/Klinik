import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';
import 'package:flutter_gp5/repos/authentication/authentication_repository.dart';
import 'package:flutter_gp5/repos/chat/chat_room_repository.dart';
import 'package:flutter_gp5/screens/chat_screen/bloc_personal_chat/personal_chat_bloc.dart';

import '../../models/message_model.dart';
import '../../models/user.dart';

class PersonalChatScreen extends StatelessWidget {
  final User chatPartner;

  const PersonalChatScreen({super.key, required this.chatPartner});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PersonalChatBloc(
        authRepository: context.read<AuthenticationRepository>(),
        chatRoomRepository: context.read<ChatRoomRepository>(),
      )..add(
        CreateChatRoomEvent(chatParticipantTwoId: chatPartner.id),
      ),
      child: _PersonalChat(chatPartner: chatPartner),
    );
  }

}


class _PersonalChat extends StatelessWidget {
  final User chatPartner;
  const _PersonalChat({required this.chatPartner});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomSheet: buildBottomChatBar(context),
        resizeToAvoidBottomInset: true,
        appBar: buildAppBar(context, chatPartner),
        body: BlocBuilder<PersonalChatBloc, PersonalChatState>(
          builder: (context, state) {
            if (state is PersonalChatMessagesLoadedState) {
              return Center(
                  child: buildChatMessageListTile(
                      context, state.messagesList, state.currentUserId));
            } else {
              return SizedBox();
            }
          },
        ));
  }
}

Widget buildBottomChatBar(BuildContext context) {
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
                const Expanded(
                  child: TextField(
                    maxLines: null,
                    // Allows the TextField to expand in height
                    minLines: 1,
                    textAlign: TextAlign.left,
                    // Aligns the user input text to the left
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Type a message',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                IconButton(
                  iconSize: context.setWidth(8),
                  icon: const Icon(Icons.keyboard_voice, color: Colors.black),
                  onPressed: () {
                    print('Send icon pressed');
                  },
                ),
              ],
            ),
          ),
          // Icon for sending message
          IconButton(
            iconSize: 28,
            icon: const Icon(Icons.send_sharp, color: Colors.black),
            onPressed: () {
              print('Send icon pressed');
            },
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
            return Container();
          }));
}
