import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';
import 'package:flutter_gp5/repos/authentication/authentication_repository.dart';
import 'package:flutter_gp5/repos/chat/chat_room_repository.dart';
import 'package:flutter_gp5/screens/chat_screen/bloc_personal_chat/personal_chat_bloc.dart';
import 'package:flutter_gp5/widgets/chat/bottom_chat_bar.dart';
import 'package:flutter_gp5/widgets/chat/chat_app_bar.dart';

import '../../locale/l10n/app_locale.dart';
import '../../models/message_model.dart';
import '../../models/user.dart';
import '../../widgets/custom_circular_progress_indicator.dart';

class PersonalChatScreen extends StatelessWidget {
   PersonalChatScreen({super.key, required this.chatPartner});

  final User chatPartner;
  final ScrollController _scrollController = ScrollController();
   final TextEditingController _messageController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PersonalChatBloc(
        authRepository: context.read<AuthenticationRepository>(),
        chatRoomRepository: context.read<ChatRepository>(),
      )
        ..add(CreateChatRoomEvent(chatParticipantTwoId: chatPartner.id))
        ..add(GetMessagesEvent(chatParticipantTwoId: chatPartner.id)),
      child: _PersonalChat(chatPartner: chatPartner,scrollController: _scrollController,messageController: _messageController,),
    );
  }
}

class _PersonalChat extends StatelessWidget {
  final User chatPartner;
  final ScrollController scrollController;
  final TextEditingController messageController;
  const _PersonalChat({required this.chatPartner, required this.scrollController,required this.messageController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: BottomChatBar(chatPartnerId: chatPartner.id, messageController: messageController,),
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(

        //TODO: fix that size.
        preferredSize:  Size.fromHeight(100),
        child: ChatAppBar(chatPartner: chatPartner),
      ),
      body: BlocBuilder<PersonalChatBloc, PersonalChatState>(
        builder: (context, state) {
          if (state is PersonalChatLoadingState) {
            return _loadingIndicator(context);
          } else if (state is PersonalChatState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              scrollController.animateTo(
                scrollController.position.maxScrollExtent,  // Scroll to the bottom
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            });
            return _chatMessageList(context, state.messagesList, chatPartner.id, scrollController);
          } else {
            return const SizedBox(
              child: Text("The state is wrong"),
            );
          }
        },
      ),
    );
  }
}

Widget _chatMessageList(BuildContext context, List<Message> messages,
    String chatPartnerId, ScrollController scrollController) {
  return ListView.builder(
    controller: scrollController,
    padding: EdgeInsets.only(bottom: context.setHeight(10)),
    itemCount: messages.length,
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
}

Widget _loadingIndicator(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Center(
        child: Text(AppLocale.of(context)!.loading),
      ),
      SizedBox(height: context.setHeight(3)),
      const CustomCircularProgressIndicator(),
      SizedBox(height: context.setHeight(3)),
    ],
  );
}
