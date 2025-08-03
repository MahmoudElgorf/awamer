import 'package:awamer/services/notification_messages.dart';
import 'package:awamer/widgets/profile_screen_widgets/provider_header_section.dart';
import 'package:awamer/widgets/provider_home_screen_widgets/provider_requests_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/provider_home_screen_widgets/provider_tabs_section.dart';

class ProviderHomeScreen extends StatefulWidget {
  const ProviderHomeScreen({super.key});

  @override
  State<ProviderHomeScreen> createState() => _ProviderHomeScreenState();
}

class _ProviderHomeScreenState extends State<ProviderHomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _updateRequestStatus(String requestId, String newStatus) async {
    try {
      final requestRef = FirebaseFirestore.instance.collection('requests').doc(requestId);

      // تحديث الحالة في Firestore
      await requestRef.update({
        'status': newStatus,
        'respondedAt': FieldValue.serverTimestamp(),
      });

      if (newStatus == 'accepted') {
        final requestSnapshot = await requestRef.get();
        final requestData = requestSnapshot.data();

        if (requestData != null) {
          final fcmToken = requestData['fcmToken'];
          final userId = requestData['userId'];
          final serviceName = requestData['service'];

          final notification = serviceNotificationMessages[serviceName] ??
              {
                'title': 'Request Accepted',
                'body': 'Your service request has been accepted.',
              };

          if (fcmToken != null && fcmToken is String) {
            await FirebaseFirestore.instance.collection('messages').add({
              'token': fcmToken,
              'notification': {
                'title': notification['title'],
                'body': notification['body'],
              },
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'requestId': requestId,
              'userId': userId ?? '',
              'createdAt': FieldValue.serverTimestamp(),
            });
          }
        }
      }
    } catch (e) {
      print('Error updating status or sending notification: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text("Not logged in")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Column(
        children: [
          const ProviderHeaderSection(),
          ProviderTabsSection(tabController: _tabController),
          Expanded(
            child: ProviderRequestsTabView(
              tabController: _tabController,
              currentUserId: currentUser!.uid,
              onStatusChanged: _updateRequestStatus,
            ),
          ),
        ],
      ),
    );
  }
}
