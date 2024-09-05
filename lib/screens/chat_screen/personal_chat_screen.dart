import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp5/repos/authentication/authentication_repository.dart';
import 'package:flutter_gp5/repos/chat/chat_room_repository.dart';
import 'package:flutter_gp5/screens/chat_screen/bloc_personal_chat/personal_chat_bloc.dart';
import 'package:flutter_gp5/widgets/chat/bottom_chat_bar.dart';
import 'package:flutter_gp5/widgets/chat/chat_app_bar.dart';

import '../../models/message_model.dart';
import '../../models/user.dart';

class PersonalChatScreen extends StatelessWidget {
  final User chatPartner;

  PersonalChatScreen({super.key, required this.chatPartner});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final TextEditingController messageController = TextEditingController();

    return BlocProvider(
      create: (context) => PersonalChatBloc(
        authRepository: context.read<AuthenticationRepository>(),
        chatRoomRepository: context.read<ChatRepository>(),
      )
        ..add(CreateChatRoomEvent(chatParticipantTwoId: chatPartner.id))
        ..add(GetMessagesEvent(chatParticipantTwoId: chatPartner.id)),
      child: _PersonalChatBody(
        chatPartner: chatPartner,
        scrollController: scrollController,
        messageController: messageController,
      ),
    );
  }
}

class _PersonalChatBody extends StatelessWidget {
  final User chatPartner;
  final ScrollController scrollController;
  final TextEditingController messageController;

  const _PersonalChatBody({
    required this.chatPartner,
    required this.scrollController,
    required this.messageController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: BottomChatBar(
        chatPartnerId: chatPartner.id,
        messageController: messageController,
      ),
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: ChatAppBar(chatPartner: chatPartner),
      ),
      body: BlocBuilder<PersonalChatBloc, PersonalChatState>(
        builder: (context, state) {
          // Handling the initial loading state
          if (state is PersonalChatLoadingState) {
            return _loadingIndicator(context);
          }
          if (state.isLoadingMessages==true) {
            return Column(
              children: [
                _loadingIndicator(context),
                Expanded(
                  child: _chatMessageList(context, state.messagesList,
                      chatPartner.id, scrollController),
                ),
              ],
            );
          }
          if (state.messagesList.isNotEmpty && state.isLoadingMessages==false) {
            return _chatMessageList(
                context, state.messagesList, chatPartner.id, scrollController);
          }
          return Center(child: Text("No messages yet"));
        },
      ),
    );
  }

  Widget _chatMessageList(BuildContext context, List<Message> messages,
      String chatPartnerId, ScrollController scrollController) {
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent &&
          !context.read<PersonalChatBloc>().state.isLoadingMessages) {
        context.read<PersonalChatBloc>().add(
          LoadMoreMessagesEvent(chatParticipantTwoId: chatPartnerId),
        );
      }
    });


    return BlocBuilder<PersonalChatBloc, PersonalChatState>(
      builder: (context, state) {
        // Only the message list updates when state changes
        final messages = state.messagesList;

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 80),
          controller: scrollController,
          itemCount: messages.length,
          reverse: true,
          itemBuilder: (context, index) {
            final message = messages[index];
            final isFromChatPartner = message.senderId == chatPartnerId;

            return Align(
              alignment:
              isFromChatPartner ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: isFromChatPartner ? Colors.grey[300] : Colors.blue[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  message.messageContent,
                  style: TextStyle(
                    color: isFromChatPartner ? Colors.black : Colors.white,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _loadingIndicator(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text('Loading...'),
        ),
        SizedBox(height: 5),
        const CircularProgressIndicator(),
        SizedBox(height: 5),
      ],
    );
  }
}
