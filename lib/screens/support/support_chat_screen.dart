import 'package:awamer/widgets/support_chat_screen_widgets/support_chat_appbar.dart';
import 'package:awamer/widgets/support_chat_screen_widgets/support_chat_body.dart';
import 'package:flutter/material.dart';

class SupportChatScreen extends StatelessWidget {
  final String chatId;
  final bool isSupport;

  const SupportChatScreen({
    Key? key,
    required this.chatId,
    this.isSupport = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: SupportChatAppBar(isSupport: isSupport),
      body: SupportChatBody(
        chatId: chatId,
        isSupport: isSupport,
      ),
    );
  }
}
