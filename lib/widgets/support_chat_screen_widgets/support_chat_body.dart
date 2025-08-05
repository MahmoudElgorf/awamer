import 'package:awamer/l10n/app_localizations.dart';
import 'package:awamer/services/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SupportChatBody extends StatefulWidget {
  final String chatId;
  final bool isSupport;

  const SupportChatBody({
    Key? key,
    required this.chatId,
    required this.isSupport,
  }) : super(key: key);

  @override
  State<SupportChatBody> createState() => _SupportChatBodyState();
}

class _SupportChatBodyState extends State<SupportChatBody> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final Stream<QuerySnapshot> _messagesStream;

  @override
  void initState() {
    super.initState();
    _messagesStream = _firestore
        .collection('support_chats')
        .doc(widget.chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();

    if (widget.isSupport) _markMessagesAsRead();
  }

  Future<void> _markMessagesAsRead() async {
    await _firestore.collection('support_chats').doc(widget.chatId).update({
      'unreadCount': 0,
    });

    final messages = await _firestore
        .collection('support_chats')
        .doc(widget.chatId)
        .collection('messages')
        .where('isRead', isEqualTo: false)
        .where('senderId', isNotEqualTo: _auth.currentUser?.uid)
        .get();

    for (var doc in messages.docs) {
      await doc.reference.update({'isRead': true});
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('support_chats')
        .doc(widget.chatId)
        .collection('messages')
        .add({
      'senderId': user.uid,
      'senderName': user.displayName ??
          (widget.isSupport
              ? AppLocalizations.of(context)!.support
              : AppLocalizations.of(context)!.defaultUser),
      'text': _messageController.text,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
    });

    await _firestore.collection('support_chats').doc(widget.chatId).update({
      'lastMessage': _messageController.text,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'unreadCount': widget.isSupport ? 0 : FieldValue.increment(1),
    });

    await _sendNotification();
    _messageController.clear();
  }

  Future<void> _sendNotification() async {
    try {
      final chatDoc = await _firestore
          .collection('support_chats')
          .doc(widget.chatId)
          .get();

      if (!chatDoc.exists) return;

      final chatData = chatDoc.data();
      if (chatData == null) return;

      final String receiverId = widget.isSupport
          ? chatData['userId'] as String? ?? ''
          : 'dfzrN9qQmXZCpJcdmU4AlWu7Hd83';

      if (receiverId.isEmpty) return;

      final userDoc =
      await _firestore.collection('users').doc(receiverId).get();

      final fcmToken = userDoc.data()?['fcmToken'] as String?;
      if (fcmToken == null || fcmToken.isEmpty) return;

      await NotificationService.sendSupportMessageNotification(
        toToken: fcmToken,
        title: widget.isSupport
            ? AppLocalizations.of(context)!.supportReply
            : AppLocalizations.of(context)!.newMessage,
        body: _messageController.text,
        chatId: widget.chatId,
        senderId: _auth.currentUser?.uid ?? '',
      );
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  Future<void> _deleteMessage(String messageId) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteMessage),
        content: Text(AppLocalizations.of(context)!.confirmDeleteMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              AppLocalizations.of(context)!.delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _firestore
          .collection('support_chats')
          .doc(widget.chatId)
          .collection('messages')
          .doc(messageId)
          .delete();
    }
  }

  String _formatTime(DateTime? date) {
    if (date == null) return '';
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _messagesStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline,
                          size: 60, color: Colors.grey[400]),
                      const SizedBox(height: 10),
                      Text(AppLocalizations.of(context)!.startChatWithSupport),
                    ],
                  ),
                );
              }

              return ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final message = snapshot.data!.docs[index];
                  final data = message.data() as Map<String, dynamic>;
                  final isMe = data['senderId'] == _auth.currentUser?.uid;

                  return GestureDetector(
                    onLongPress: () => _deleteMessage(message.id),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: isMe
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth:
                              MediaQuery.of(context).size.width * 0.75,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              margin:
                              const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? const Color(0xFF4C9581)
                                    : Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(16),
                                  topRight: const Radius.circular(16),
                                  bottomLeft: isMe
                                      ? const Radius.circular(16)
                                      : const Radius.circular(4),
                                  bottomRight: isMe
                                      ? const Radius.circular(4)
                                      : const Radius.circular(16),
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 2,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: isMe
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  if (!isMe) ...[
                                    Text(
                                      data['senderName'] ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF4C9581),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                  ],
                                  Text(
                                    data['text'] ?? '',
                                    style: TextStyle(
                                      color: isMe ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatTime(data['timestamp']?.toDate()),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isMe
                                          ? Colors.white70
                                          : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        _buildInputField(context),
      ],
    );
  }

  Widget _buildInputField(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.typeYourMessage,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                maxLines: 4,
                minLines: 1,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF4C9581),
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
