import 'package:awamer/widgets/provider_home_screen_widgets/image_viewer_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class RequestDetailsScreen extends StatelessWidget {
  final String requestId;
  final Map<String, dynamic> requestData;

  const RequestDetailsScreen({
    super.key,
    required this.requestId,
    required this.requestData,
  });

  @override
  Widget build(BuildContext context) {
    final firstName = requestData['firstName'] ?? '';
    final lastName = requestData['lastName'] ?? '';
    final userName =
    (firstName + ' ' + lastName).trim().isEmpty
        ? 'Unknown Name'
        : '$firstName $lastName';

    final address = requestData['address'] ?? 'No Address';
    final phone = requestData['phone'] ?? 'No Phone';
    final description = requestData['description'] ?? 'No Description';
    final imageUrl = requestData['imageUrl'];

    final dynamic rawTimestamp = requestData['timestamp'];
    Timestamp? timestamp;
    if (rawTimestamp is Timestamp) {
      timestamp = rawTimestamp;
    }

    final String formattedDate =
    timestamp != null
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
}
