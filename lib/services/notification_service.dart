import 'package:awamer/services/notification_messages.dart';
import 'package:awamer/screens/support_chat_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static const String _serverKey = 'YOUR_SERVER_KEY'; // ضع مفتاح FCM الحقيقي هنا

  Future<void> initialize(BuildContext context) async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true,
    );

    _firebaseMessaging.onTokenRefresh.listen(_saveTokenToFirestore);

    String? token = await _firebaseMessaging.getToken();
    if (token != null) await _saveTokenToFirestore(token);

    FirebaseMessaging.onMessage.listen((message) {
      _handleNotification(message, context);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNotification(message, context);
    });

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
    final notification = message.notification;

    if (data['type'] == 'support_chat' && data['chatId'] != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SupportChatScreen(
            chatId: data['chatId'],
            isSupport: data['senderId'] == 'BWn8QAHBDKb4Eky29xYgd48iLGH3',
          ),
        ),
      );
    } else if (data['type'] == 'service_request' && data['requestId'] != null) {
      _handleRequestNotification(data, context);
    }

    if (notification != null) {
      _showLocalNotification(notification.title, notification.body);
    }
  }

  void _handleRequestNotification(Map<String, dynamic> data, BuildContext context) {
    print('Request notification: ${data['requestId']}');
  }

  void _showLocalNotification(String? title, String? body) {
    if (title != null && body != null) {
      print('Showing local notification: $title - $body');
      // يمكن استخدام flutter_local_notifications هنا لعرض الإشعار فعليًا
    }
  }

  static Future<void> sendServiceNotification({
    required String toToken,
    required String serviceType,
    required String requestId,
    required String status,
  }) async {
    final messages = serviceNotificationMessages[serviceType] ?? {
      'pending': 'تم استلام طلبك وجاري مراجعته',
      'accepted': 'تم قبول طلبك بنجاح',
      'rejected': 'تم رفض طلبك',
    };

    final titles = {
      'pending': 'طلبك قيد المراجعة',
      'accepted': 'تم قبول الطلب',
      'rejected': 'تم رفض الطلب',
    };

    final body = messages[status] ?? 'تم تحديث حالة طلبك إلى $status';
    final title = titles[status] ?? 'طلب جديد';

    await _sendFcmNotification(
      toToken: toToken,
      title: title,
      body: body,
      data: {
        'type': 'service_request',
        'requestId': requestId,
        'status': status,
        'serviceType': serviceType,
      },
    );
  }

  static Future<void> sendSupportMessageNotification({
    required String toToken,
    required String title,
    required String body,
    required String chatId,
    required String senderId,
  }) async {
    await _sendFcmNotification(
      toToken: toToken,
      title: title,
      body: body,
      data: {
        'type': 'support_chat',
        'chatId': chatId,
        'senderId': senderId,
      },
    );
  }

  static Future<void> _sendFcmNotification({
    required String toToken,
    required String title,
    required String body,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$_serverKey',
        },
        body: jsonEncode({
          'notification': {
            'title': title,
            'body': body,
            'sound': 'default',
          },
          'priority': 'high',
          'data': {
            ...data,
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          },
          'to': toToken,
        }),
      );

      print('FCM Response: ${response.statusCode} - ${response.body}');
    } catch (e) {
      print('Error sending FCM: $e');
    }
  }
}
