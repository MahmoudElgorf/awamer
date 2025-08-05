import 'package:awamer/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'support_chat_tile.dart';

class SupportChatList extends StatelessWidget {
  const SupportChatList({super.key});

  Future<void> _deleteChat(BuildContext context, String chatId) async {
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
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('support_chats')
          .where('status', isEqualTo: 'open')
          .orderBy('lastMessageTime', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.noOpenChats,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final chat = snapshot.data!.docs[index];
            final chatData = chat.data() as Map<String, dynamic>;

            return SupportChatTile(
              chatId: chat.id,
              chatData: chatData,
              onDelete: () => _deleteChat(context, chat.id),
            );
          },
        );
      },
    );
  }
}
