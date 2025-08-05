import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awamer/l10n/app_localizations.dart';
import 'package:awamer/screens/support/support_chat_screen.dart';
import 'delete_chat_dialog.dart';

class ChatItem extends StatelessWidget {
  final String chatId;
  final Map<String, dynamic> chatData;

  const ChatItem({super.key, required this.chatId, required this.chatData});

  Future<void> _deleteChat(String chatId) async {
    try {
      final messages = await FirebaseFirestore.instance
          .collection('support_chats')
          .doc(chatId)
          .collection('messages')
          .get();

      final batch = FirebaseFirestore.instance.batch();
      for (var doc in messages.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      await FirebaseFirestore.instance
          .collection('support_chats')
          .doc(chatId)
          .delete();
    } catch (e) {
      print('Error deleting chat: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(chatId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) => showDialog(
        context: context,
        builder: (context) => DeleteChatDialog(),
      ),
      onDismissed: (_) => _deleteChat(chatId),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SupportChatScreen(chatId: chatId),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Color(0xFF4C9581),
                child: Icon(Icons.support_agent, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.supportTeam,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      chatData['lastMessage'] ?? '',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_left, color: Color(0xFF4C9581)),
            ],
          ),
        ),
      ),
    );
  }
}
