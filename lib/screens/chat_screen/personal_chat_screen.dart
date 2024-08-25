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
  const PersonalChatScreen({super.key, required this.chatPartner});

  final User chatPartner;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PersonalChatBloc(
        authRepository: context.read<AuthenticationRepository>(),
        chatRoomRepository: context.read<ChatRepository>(),
      )..add(CreateChatRoomEvent(chatParticipantTwoId: chatPartner.id)),
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
      bottomSheet: BottomChatBar(chatPartnerId: chatPartner.id),
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        //TODO: fix that size.
        preferredSize: const Size.fromHeight(56),
        child: ChatAppBar(chatPartner: chatPartner),
      ),
      body: BlocBuilder<PersonalChatBloc, PersonalChatState>(
        builder: (context, state) {
          if (state is PersonalChatMessagesLoadedState) {
            return _chatMessageList(context, state.messagesList,null);
          } else if (state is PersonalChatLoadingState || state is PersonalChatRoomCreatedState) {
            return _loadingIndicator(context);
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

Widget _chatMessageList(BuildContext context, List<Message> messages, String? currentUserId) {
  return Expanded(
    child: ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return Text(message.messageContent);
      },
    ),
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
