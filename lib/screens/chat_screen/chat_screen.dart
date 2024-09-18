import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';
import 'package:flutter_gp5/screens/chat_screen/personal_chat_screen.dart';
import 'package:flutter_gp5/utils/image_utils.dart';
import 'package:intl/intl.dart';

import '../../locale/l10n/app_locale.dart';
import '../../models/user.dart';
import '../../repos/authentication/authentication_repository.dart';
import '../../repos/user/user_repository.dart';
import '../../widgets/bottom_nav_bar.dart' as custom;
import '../../widgets/custom_circular_progress_indicator.dart';
import 'bloc/chat_bloc.dart';
import 'bloc/chat_events.dart';
import 'bloc/chat_states.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(
        authRepo: context.read<AuthenticationRepository>(),
        userRepository: RepositoryProvider.of<UserRepository>(context),
      )..add(
          GetAllUsers(),
        ),
      child: const _ChatScreen(),
    );
  }
}

class _ChatScreen extends StatelessWidget {
  const _ChatScreen();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImageUtils.chatBackgroundPhoto),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: const custom.BottomNavigationBar(currentIndex: 3),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            AppLocale.of(context)!.messages,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<ChatBloc, ChatStates>(builder: (context, state) {
          if (state is UsersLoadingState) {
            return buildLoadingWidget(context);
          } else if (state is UsersLoadedState) {
            List<User> users = state.myData;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildRecentsTextWithAvatars(context, users),
                buildLoadedChatWidgets(context, users)
              ],
            );
          } else {
            return Text(AppLocale.of(context)!.no_data);
          }
        }),
      ),
    );
  }
}

Widget buildRecentsRow(BuildContext context) {
  return Row(
    children: [
      SizedBox(width: context.setWidth(3)),
      SizedBox(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            AppLocale.of(context)!.recents,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    ],
  );
}

Widget buildHorizontalUserAvatars(BuildContext context, List<User> users) {
  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: users.length,
    itemBuilder: (context, index) {
      return Row(
        children: [
          SizedBox(
            width: context.setWidth(2.5),
          ),
          SizedBox(
            width: context.setWidth(18),
            child: Column(
              children: [
                CircleAvatar(
                  radius: context.setHeight(5),
                  child: Icon(
                    Icons.person,
                    size: context.setHeight(
                        5), // Adjust the size according to your needs
                  ), // Use dynamic URL
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

Widget buildRecentsTextWithAvatars(BuildContext context, List<User> users) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildRecentsRow(context), // Top widget
      SizedBox(
        height: context.setHeight(10.35), // Set a fixed height for the ListView
        child: buildHorizontalUserAvatars(context, users), // Bottom widget
      ),
    ],
  );
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

Widget buildLoadedChatWidgets(BuildContext context, List<User> users) {
  return Expanded(
    flex: 1,
    child: ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Center(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PersonalChatScreen(chatPartner: user,)),
              );
            },
            child: Column(
              children: [
                SizedBox(
                  height: context.setHeight(0.7),
                ),
                Container(
                  height: context.setHeight(11),
                  width: context.setWidth(95),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white.withOpacity(0.8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 15,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          child: Icon(
                            Icons.person,
                            size: context.setHeight(
                                5), // Adjust the size according to your needs
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: context.setHeight(0.8),
                            ),
                            const Text(
                              "random chat sentence",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: context.setHeight(1.2),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: context.setWidth(17),
                              child: Text(
                                DateFormat('h:mm a').format(
                                  DateTime.now(),
                                ),
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.grey),
                              ),
                            ),
                            Container(
                              width: context.setWidth(4),
                              height: context.setHeight(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFF6750A4),
                                // Background color
                                shape: BoxShape.circle, // Circular
                              ),
                              child: const Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "1",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                ]
            ),
          ),
        );
      },
    ),
  );
}
