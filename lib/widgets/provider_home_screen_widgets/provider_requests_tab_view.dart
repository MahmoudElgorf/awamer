import 'package:awamer/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../shared/empty_requests_view.dart';
import 'provider_request_card.dart';
import 'provider_request_details_screen.dart';

class ProviderRequestsTabView extends StatelessWidget {
  final TabController tabController;
  final String currentUserId;
  final Future<void> Function(String, String) onStatusChanged;

  const ProviderRequestsTabView({
    super.key,
    required this.tabController,
    required this.currentUserId,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        _buildRequestsList(context, 'pending'),
        _buildRequestsList(context, 'accepted'),
        _buildRequestsList(context, 'rejected'),
      ],
    );
  }

  Widget _buildRequestsList(BuildContext context, String status) {
    final loc = AppLocalizations.of(context)!;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('requests')
          .where('providerId', isEqualTo: currentUserId)
          .where('status', isEqualTo: status)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const EmptyRequestsView(),
                const SizedBox(height: 10),
                Text(
                  _getEmptyListMessage(loc, status),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final requestData = doc.data() as Map<String, dynamic>;

              return ProviderRequestCard(
                request: requestData,
                requestId: doc.id,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProviderRequestDetailsScreen(
                      requestId: doc.id,
                      requestData: requestData,
                      onStatusChanged: (newStatus) =>
                          onStatusChanged(doc.id, newStatus),
                    ),
                  ),
                ),
                showActionButtons: status == 'pending',
                onStatusChanged: (isAccepted) => onStatusChanged(
                  doc.id,
                  isAccepted ? 'accepted' : 'rejected',
                ),
              );
            },
          ),
        );
      },
    );
  }

  String _getEmptyListMessage(AppLocalizations loc, String status) {
    switch (status) {
      case 'pending':
        return loc.noNewRequests;
      case 'accepted':
        return loc.noAcceptedRequests;
      case 'rejected':
        return loc.noRejectedRequests;
      default:
        return loc.noRequests;
    }
  }
}
