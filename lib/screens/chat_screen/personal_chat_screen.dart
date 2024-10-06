import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp5/repos/authentication/authentication_repository.dart';
import 'package:flutter_gp5/repos/chat/chat_room_repository.dart';
import 'package:flutter_gp5/screens/chat_screen/bloc_personal_chat/personal_chat_bloc.dart';
import 'package:flutter_gp5/widgets/chat/bottom_chat_bar.dart';
import 'package:flutter_gp5/widgets/chat/chat_app_bar.dart';
import 'package:flutter_gp5/utils/image_utils.dart';
import '../../locale/l10n/app_locale.dart';
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
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent &&
          !context.read<PersonalChatBloc>().state.isLoadingMessages) {
        context.read<PersonalChatBloc>().add(
          LoadMoreMessagesEvent(chatParticipantTwoId: chatPartner.id),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white, // Keep scaffold background solid white
      bottomSheet: BottomChatBar(
        chatPartnerId: chatPartner.id,
        messageController: messageController,
        scrollController: scrollController,
      ),
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          color: Colors.white,
          child: ChatAppBar(chatPartner: chatPartner), // Custom ChatAppBar content
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageUtils.chatBackgroundPhoto),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.white.withOpacity(0.7),
          child: BlocBuilder<PersonalChatBloc, PersonalChatState>(
            builder: (context, state) {
              return Column(
                children: [
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
                  Expanded(
                    child: ChatMessageList(
                      messages: state.messagesList,
                      scrollController: scrollController,
                      chatPartner: chatPartner,
                      chatRoomId: state.chatRoomId,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }



  Widget _loadingIndicator(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(AppLocale.of(context)!.loading),
        ),
        const SizedBox(height: 5),
        const CircularProgressIndicator(),
        const SizedBox(height: 5),
      ],
    );
  }
}
