import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp5/repos/authentication/authentication_repository.dart';
import 'package:flutter_gp5/repos/chat/chat_room_repository.dart';
import 'package:flutter_gp5/screens/chat_screen/bloc_personal_chat/personal_chat_bloc.dart';
import 'package:flutter_gp5/widgets/chat/bottom_chat_bar.dart';
import 'package:flutter_gp5/widgets/chat/chat_app_bar.dart';
import '../../models/user.dart';
import '../../widgets/chat/chat_messages_list.dart';

class PersonalChatScreen extends StatelessWidget {
  final User chatPartner;

  const PersonalChatScreen({super.key, required this.chatPartner});

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
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !context.read<PersonalChatBloc>().state.isLoadingMessages) {
        context.read<PersonalChatBloc>().add(
              LoadMoreMessagesEvent(chatParticipantTwoId: chatPartner.id),
            );
      }
    });

    return Scaffold(
        bottomSheet: BottomChatBar(
          chatPartnerId: chatPartner.id,
          messageController: messageController,
          scrollController: scrollController,
        ),
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: ChatAppBar(chatPartner: chatPartner),
        ),
        body: BlocBuilder<PersonalChatBloc, PersonalChatState>(
          builder: (context, state) {
            return Column(
              children: [
                // Show loading indicator if messages are being loaded
                if (state.isLoadingMessages)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _loadingIndicator(context),
                      ],
                    ),
                  ),
                // Message list
                Expanded(
                  child: ChatMessageList(messages: state.messagesList,scrollController: scrollController,chatPartner: chatPartner,),
                ),
              ],
            );
          },
        ));
  }


  Widget _loadingIndicator(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text('Loading...'),
        ),
        SizedBox(height: 5),
        CircularProgressIndicator(),
        SizedBox(height: 5),
      ],
    );
  }
}
