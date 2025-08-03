import 'package:awamer/l10n/app_localizations.dart';
import 'package:awamer/services/notification_messages.dart';
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

      final request = requestDoc.data();
      if (request == null) return;

      final userId = request['userId'];
      if (userId == null) return;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      final fcmToken = userDoc.data()?['fcmToken'];
      if (fcmToken == null) return;

      final serviceType = request['serviceType'] ?? 'General';

      final title = '${AppLocalizations.of(context)!.request} $status';
      final body = serviceNotificationMessages[serviceType]?[status] ??
          '${AppLocalizations.of(context)!.yourRequestHasBeen} $status.';

      final notificationData = {
        'userId': userId,
        'title': title,
        'body': body,
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
          'title': title,
          'body': body,
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
    final loc = AppLocalizations.of(context)!;
    final firstName = requestData['firstName'] ?? '';
    final lastName = requestData['lastName'] ?? '';
    final userName = (firstName + ' ' + lastName).trim().isEmpty
        ? loc.unknownName
        : '$firstName $lastName';

    final address = requestData['address'] ?? loc.noAddress;
    final phone = requestData['phone'] ?? loc.noPhone;
    final description = requestData['description'] ?? loc.noDescription;
    final imageUrl = requestData['imageUrl'];
    final currentStatus = requestData['status'] ?? 'pending';

    final dynamic rawTimestamp = requestData['timestamp'];
    Timestamp? timestamp;
    if (rawTimestamp is Timestamp) {
      timestamp = rawTimestamp;
    }

    final String formattedDate = timestamp != null
        ? DateFormat('yyyy/MM/dd – hh:mm a').format(timestamp.toDate())
        : loc.notAvailable;

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
                _buildItem(title: loc.name, value: userName),
                const SizedBox(height: 16),
                _buildItem(title: loc.address, value: address),
                const SizedBox(height: 16),
                _buildItem(title: loc.phone, value: phone),
                const SizedBox(height: 16),
                _buildItem(title: loc.description, value: description),
                const SizedBox(height: 16),
                _buildItem(title: loc.date, value: formattedDate),
                const SizedBox(height: 24),
                _buildStatusIndicator(currentStatus, loc),
                const SizedBox(height: 24),
                if (onStatusChanged != null)
                  _buildStatusButtons(context, currentStatus, loc),
                const SizedBox(height: 16),
                if (imageUrl != null && imageUrl.isNotEmpty) ...[
                  Text(
                    loc.attachedImage,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
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

  Widget _buildStatusIndicator(String status, AppLocalizations loc) {
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
            '${loc.status}: ${status.toUpperCase()}',
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

  Widget _buildStatusButtons(
      BuildContext context, String currentStatus, AppLocalizations loc) {
    final firstName = requestData['firstName'] ?? '';
    final lastName = requestData['lastName'] ?? '';
    final userName = '$firstName $lastName'.trim();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.check, color: Colors.white),
          label: Text(loc.accept, style: const TextStyle(color: Colors.white)),
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
          label: Text(loc.reject, style: const TextStyle(color: Colors.white)),
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
