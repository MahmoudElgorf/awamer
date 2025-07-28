import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/shared/header_section.dart';
import '../../widgets/provider_home_screen_widgets/request_card.dart';
import '../../widgets/provider_home_screen_widgets/request_details_screen.dart';
import '../../widgets/provider_home_screen_widgets/empty_requests_view.dart';

class ProviderHomeScreen extends StatelessWidget {
  const ProviderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Column(
        children: [
          const HeaderSection(),
          Expanded(
            child: currentUser == null
                ? const Center(child: Text("لم يتم تسجيل الدخول"))
                : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('requests')
                  .where('providerId', isEqualTo: currentUser.uid)
                  .where('status', whereIn: ['pending', 'accepted'])
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const EmptyRequestsView();
                }

                return RefreshIndicator(
                  onRefresh: () async =>
                  await Future.delayed(const Duration(seconds: 1)),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final doc = snapshot.data!.docs[index];
                      print('PROVIDER UID: ${currentUser?.uid}');
                      return RequestCard(
                        request: doc.data() as Map<String, dynamic>,
                        requestId: doc.id,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RequestDetailsScreen(
                              requestId: doc.id,
                              requestData: doc.data()
                              as Map<String, dynamic>,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
