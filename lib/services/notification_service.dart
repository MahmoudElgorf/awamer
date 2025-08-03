import 'package:awamer/widgets/shared/support_chat_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize(BuildContext context) async {
    // طلب الإذن (خاص بـ iOS)
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // حفظ Token عند التغيير
    _firebaseMessaging.onTokenRefresh.listen(_saveTokenToFirestore);

    // الحصول على Token الحالي
    await _saveTokenToFirestore(await _firebaseMessaging.getToken());

    // التعامل مع الإشعارات
    FirebaseMessaging.onMessage.listen((message) {
      _handleNotification(message, context);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNotification(message, context);
    });

    // الإشعارات عند فتح التطبيق
    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotification(initialMessage, context);
    }
  }

  Future<void> _saveTokenToFirestore(String? token) async {
    if (token == null) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({'fcmToken': token});
  }

  void _handleNotification(RemoteMessage message, BuildContext context) {
    final data = message.data;
    if (data['type'] == 'support_chat' && data['chatId'] != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SupportChatScreen(
            chatId: data['chatId'],
            isSupport: data['senderId'] == 'BWn8QAHBDKb4Eky29xYgd48iLGH3',
          ),
        ),
      );
    }
  }

  static Future<void> sendNotification({
    required String toToken,
    required String title,
    required String body,
    required String chatId,
    required String senderId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=YOUR_SERVER_KEY',
        },
        body: jsonEncode({
          'notification': {
            'title': title,
            'body': body,
            'sound': 'default',
          },
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'chatId': chatId,
            'type': 'support_chat',
            'senderId': senderId,
          },
          'to': toToken,
        }),
      );

      print('Notification sent: ${response.body}');
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}