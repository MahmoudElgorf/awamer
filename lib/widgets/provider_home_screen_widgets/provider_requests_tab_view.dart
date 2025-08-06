import 'package:awamer/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../shared/empty_requests_view.dart';
import 'provider_request_card.dart';
import 'provider_request_details_screen.dart';
import 'accepted_order_card.dart';

class ProviderRequestsTabView extends StatelessWidget {
  final TabController tabController;
  final String currentUserId;
  final Future<void> Function(String, String) onStatusChanged;
  final String? userServiceType;
  final String? userRole;

  const ProviderRequestsTabView({
    super.key,
    required this.tabController,
    required this.currentUserId,
    required this.onStatusChanged,
    this.userServiceType,
    this.userRole,
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
    final bool showBothCards = userRole == 'provider' && userServiceType == 'Delivery';

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

              if (showBothCards && status == 'accepted') {
                return Column(
                  children: [
                    AcceptedOrderCard(
                      order: requestData,
                    ),
                    const SizedBox(height: 8),
                    ProviderRequestCard(
                      request: requestData,
                      requestId: doc.id,
                      onTap: () => _navigateToDetails(context, doc.id, requestData),
                    ),
                  ],
                );
              } else {
                return ProviderRequestCard(
                  request: requestData,
                  requestId: doc.id,
                  onTap: () => _navigateToDetails(context, doc.id, requestData),
                );
              }
            },
          ),
        );
      },
    );
  }

  void _navigateToDetails(BuildContext context, String requestId, Map<String, dynamic> requestData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProviderRequestDetailsScreen(
          requestId: requestId,
          requestData: requestData,
          onStatusChanged: (newStatus) => onStatusChanged(requestId, newStatus),
        ),
      ),
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