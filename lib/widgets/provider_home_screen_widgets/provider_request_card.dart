import 'package:awamer/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ProviderRequestCard extends StatelessWidget {
  final Map<String, dynamic> request;
  final String requestId;
  final VoidCallback onTap;
  final bool isDeliveryRequest;

  const ProviderRequestCard({
    super.key,
    required this.request,
    required this.requestId,
    required this.onTap,
    this.isDeliveryRequest = false,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final firstName = request['firstName'] ?? '';
    final lastName = request['lastName'] ?? '';
    final fullName = '$firstName $lastName'.trim();
    final dynamic timestamp = isDeliveryRequest
        ? request['deliveryAssignedAt'] ?? request['timestamp']
        : request['timestamp'];
    final formattedDate = (timestamp != null && timestamp is Timestamp)
        ? _formatDate(timestamp)
        : loc.dateNotAvailable;

    final status = isDeliveryRequest
        ? request['deliveryStatus'] ?? 'pending'
        : request['status'] ?? 'pending';
    final isAccepted = status == 'accepted';
    final isRejected = status == 'rejected';
    final isCompleted = status == 'completed';

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isDeliveryRequest
              ? Border.all(color: const Color(0xFF4C9581), width: 1.5)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFF4C9581).withOpacity(0.1),
              child: Icon(
                isDeliveryRequest ? Icons.delivery_dining : Icons.person,
                color: const Color(0xFF4C9581),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isDeliveryRequest ? 'طلب توصيل' : request['service'] ?? 'طلب',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (isDeliveryRequest && request['servicePrice'] != null)
                        Text(
                          '${request['servicePrice']} ${loc.price}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4C9581),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    fullName.isEmpty ? loc.unknownUser : fullName,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusText(loc, status),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isCompleted)
              const Icon(Icons.done_all, color: Colors.blue, size: 32)
            else if (isAccepted)
              const Icon(Icons.check_circle, color: Colors.green, size: 32)
            else if (isRejected)
                const Icon(Icons.cancel, color: Colors.red, size: 32)
              else
                const Icon(Icons.access_time, color: Colors.orange, size: 32)
          ],
        ),
      ),
    );
  }

  String _formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return DateFormat('yyyy/MM/dd – hh:mm a').format(date);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'accepted':
        return Colors.green.withOpacity(0.2);
      case 'rejected':
        return Colors.red.withOpacity(0.2);
      case 'completed':
        return Colors.blue.withOpacity(0.2);
      case 'pending':
        return Colors.orange.withOpacity(0.2);
      default:
        return Colors.grey.withOpacity(0.2);
    }
  }

  String _getStatusText(AppLocalizations loc, String status) {
    switch (status) {
      case 'accepted':
        return loc.accepted;
      case 'rejected':
        return loc.rejected;
      case 'completed':
        return 'مكتمل';
      case 'pending':
        return loc.pending;
      default:
        return status;
    }
  }
}