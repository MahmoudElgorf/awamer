import 'package:awamer/widgets/provider_home_screen_widgets/image_viewer_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ProviderRequestDetailsScreen extends StatelessWidget {
  final String requestId;
  final Map<String, dynamic> requestData;
  final Function(String)? onStatusChanged;

  const ProviderRequestDetailsScreen({
    super.key,
    required this.requestId,
    required this.requestData,
    this.onStatusChanged,
  });

  Future<void> _sendNotification({
    required BuildContext context,
    required String status,
    required String userName,
  }) async {
    try {
      final requestDoc = await FirebaseFirestore.instance
          .collection('requests')
          .doc(requestId)
          .get();

      final userId = requestDoc.data()?['userId'];
      if (userId == null) return;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      final fcmToken = userDoc.data()?['fcmToken'];
      if (fcmToken == null) return;

      final notificationData = {
        'userId': userId,
        'title': 'Request $status',
        'body': 'Your request has been $status.',
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
        'requestId': requestId,
      };

      await FirebaseFirestore.instance
          .collection('notifications')
          .add(notificationData);

      await FirebaseFirestore.instance.collection('messages').add({
        'token': fcmToken,
        'notification': {
          'title': notificationData['title'],
          'body': notificationData['body'],
        },
        'data': {
          'requestId': requestId,
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        },
      });
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstName = requestData['firstName'] ?? '';
    final lastName = requestData['lastName'] ?? '';
    final userName = (firstName + ' ' + lastName).trim().isEmpty
        ? 'Unknown Name'
        : '$firstName $lastName';

    final address = requestData['address'] ?? 'No Address';
    final phone = requestData['phone'] ?? 'No Phone';
    final description = requestData['description'] ?? 'No Description';
    final imageUrl = requestData['imageUrl'];
    final currentStatus = requestData['status'] ?? 'pending';

    final dynamic rawTimestamp = requestData['timestamp'];
    Timestamp? timestamp;
    if (rawTimestamp is Timestamp) {
      timestamp = rawTimestamp;
    }

    final String formattedDate = timestamp != null
        ? DateFormat('yyyy/MM/dd – hh:mm a').format(timestamp.toDate())
        : 'Not Available';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(userName),
        backgroundColor: const Color(0xFF4C9581),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                _buildItem(title: "Name", value: userName),
                const SizedBox(height: 16),
                _buildItem(title: "Address", value: address),
                const SizedBox(height: 16),
                _buildItem(title: "Phone", value: phone),
                const SizedBox(height: 16),
                _buildItem(title: "Description", value: description),
                const SizedBox(height: 16),
                _buildItem(title: "Date", value: formattedDate),
                const SizedBox(height: 24),
                _buildStatusIndicator(currentStatus),
                const SizedBox(height: 24),
                if (onStatusChanged != null)
                  _buildStatusButtons(context, currentStatus),
                const SizedBox(height: 16),
                if (imageUrl != null && imageUrl.isNotEmpty) ...[
                  const Text(
                    "Attached Image",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      showImagePopup(context, imageUrl);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        imageUrl,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem({required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIndicator(String status) {
    Color statusColor;
    switch (status) {
      case 'accepted':
        statusColor = Colors.green;
        break;
      case 'rejected':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor),
      ),
      child: Row(
        children: [
          Icon(
            status == 'accepted'
                ? Icons.check_circle
                : status == 'rejected'
                ? Icons.cancel
                : Icons.access_time,
            color: statusColor,
          ),
          const SizedBox(width: 10),
          Text(
            'Status: ${status.toUpperCase()}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButtons(BuildContext context, String currentStatus) {
    final firstName = requestData['firstName'] ?? '';
    final lastName = requestData['lastName'] ?? '';
    final userName = '$firstName $lastName'.trim();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.check, color: Colors.white),
          label: const Text('Accept', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: currentStatus == 'accepted'
              ? null
              : () async {
            if (onStatusChanged != null) {
              await onStatusChanged!('accepted');
              await _sendNotification(
                context: context,
                status: 'accepted',
                userName: userName,
              );
              Navigator.pop(context);
            }
          },
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.close, color: Colors.white),
          label: const Text('Reject', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: currentStatus == 'rejected'
              ? null
              : () async {
            if (onStatusChanged != null) {
              await onStatusChanged!('rejected');
              await _sendNotification(
                context: context,
                status: 'rejected',
                userName: userName,
              );
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
