import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class RequestCard extends StatelessWidget {
  final Map<String, dynamic> request;
  final String requestId;
  final VoidCallback onTap;

  const RequestCard({
    super.key,
    required this.request,
    required this.requestId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final firstName = request['firstName'] ?? '';
    final lastName = request['lastName'] ?? '';
    final fullName = '$firstName $lastName'.trim();
    final formattedDate = (request['timestamp'] != null && request['timestamp'] is Timestamp)
        ? _formatDate(request['timestamp'])
        : 'Date not available';

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return DateFormat('yyyy/MM/dd – hh:mm a').format(date);
  }
}
