import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ProviderRequestCard extends StatelessWidget {
  final Map<String, dynamic> request;
  final String requestId;
  final VoidCallback onTap;
  final Function(bool)? onStatusChanged;
  final bool showActionButtons;

  const ProviderRequestCard({
    super.key,
    required this.request,
    required this.requestId,
    required this.onTap,
    this.onStatusChanged,
    this.showActionButtons = false,
  });

  @override
  Widget build(BuildContext context) {
    final firstName = request['firstName'] ?? '';
    final lastName = request['lastName'] ?? '';
    final fullName = '$firstName $lastName'.trim();
    final formattedDate = (request['timestamp'] != null && request['timestamp'] is Timestamp)
        ? _formatDate(request['timestamp'])
        : 'Date not available';

    final isPending = request['status'] == null || request['status'] == 'pending';
    final isAccepted = request['status'] == 'accepted';
    final isRejected = request['status'] == 'rejected';

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
            topLeft: Radius.circular(16), // Keeping top rounded for dialog
            topRight: Radius.circular(16), // Keeping top rounded for dialog
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFF4C9581).withOpacity(0.1),
              child: const Icon(Icons.person, color: Color(0xFF4C9581)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullName.isEmpty ? 'Unknown User' : fullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
                  if (request['status'] != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(request['status']),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getStatusText(request['status']),
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
            if (onStatusChanged != null && isPending && showActionButtons) ...[
              IconButton(
                icon: const Icon(Icons.check_circle, color: Colors.green),
                onPressed: () async {
                  await onStatusChanged!(true);

                  final userToken = request['userToken'];
                  final serviceType = request['serviceType'] ?? 'Service';

                  if (userToken != null) {
                    await FirebaseFirestore.instance.collection('messages').add({
                      'token': userToken,
                      'notification': {
                        'title': '$serviceType Request Accepted',
                        'body': 'Your request has been accepted',
                      },
                      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                      'timestamp': FieldValue.serverTimestamp(),
                    });
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.cancel, color: Colors.red),
                onPressed: () => onStatusChanged!(false),
              ),
            ] else if (isAccepted)
              const Icon(Icons.check_circle, color: Colors.green, size: 32)
            else if (isRejected)
                const Icon(Icons.cancel, color: Colors.red, size: 32)
              else if (isPending)
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
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'accepted':
        return 'Accepted';
      case 'rejected':
        return 'Rejected';
      case 'pending':
        return 'Pending';
      default:
        return status;
    }
  }
}
