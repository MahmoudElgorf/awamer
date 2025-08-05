import 'package:awamer/widgets/user_support_screen_widgets/chat_list.dart';
import 'package:awamer/widgets/user_support_screen_widgets/previous_chats_title.dart';
import 'package:awamer/widgets/user_support_screen_widgets/support_header.dart';
import 'package:awamer/widgets/user_support_screen_widgets/support_welcome_card.dart';
import 'package:flutter/material.dart';


class UserSupportScreen extends StatelessWidget {
  const UserSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SupportHeader(),
      backgroundColor: const Color(0xFFF4F4F4),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            SupportWelcomeCard(),
            SizedBox(height: 20),
            PreviousChatsTitle(),
            SizedBox(height: 10),
            Expanded(child: ChatList()),
          ],
        ),
      ),
    );
  }
}
