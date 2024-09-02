import 'package:flutter/material.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';
import 'package:flutter_gp5/models/user.dart';

class ChatAppBar extends StatelessWidget {
  const ChatAppBar({super.key, required this.chatPartner});

  final User chatPartner;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      toolbarHeight: context.setHeight(10),
      leadingWidth: context.setWidth(8),
      leading: Align(
        alignment: Alignment.center,
        child: Transform.scale(
          scale: 2.7,
          child: IconButton(
            icon: const Icon(Icons.navigate_before, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          ),
          SizedBox(width: context.setWidth(2)),
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
}