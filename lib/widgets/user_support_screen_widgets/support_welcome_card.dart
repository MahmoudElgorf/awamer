import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awamer/l10n/app_localizations.dart';
import 'package:awamer/screens/support/support_chat_screen.dart';

class SupportWelcomeCard extends StatelessWidget {
  const SupportWelcomeCard({super.key});

  void _startNewChat(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final chatDoc =
    await FirebaseFirestore.instance.collection('support_chats').add({
      'userId': user.uid,
      'supportId': 'BWn8QAHBDKb4Eky29xYgd48iLGH3',
      'userName': user.displayName ?? 'مستخدم',
      'createdAt': FieldValue.serverTimestamp(),
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
      'status': 'open',
      'unreadCount': 0,
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SupportChatScreen(chatId: chatDoc.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.welcomeMessage,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4C9581),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.supportDescription,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _startNewChat(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4C9581),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: Text(
              AppLocalizations.of(context)!.startNewChat,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
