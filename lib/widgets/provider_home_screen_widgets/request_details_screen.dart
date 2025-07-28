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
    final userName = requestData['name'] ?? 'اسم غير معروف';
    final address = requestData['address'] ?? 'بدون عنوان';
    final phone = requestData['phone'] ?? 'بدون رقم';
    final description = requestData['description'] ?? 'لا يوجد وصف';
    final status = requestData['status'] ?? 'pending';

    final dynamic rawTimestamp = requestData['timestamp'];
    Timestamp? timestamp;
    if (rawTimestamp is Timestamp) {
      timestamp = rawTimestamp;
    }

    final String formattedDate = timestamp != null
        ? DateFormat('yyyy/MM/dd – HH:mm').format(timestamp.toDate())
        : 'غير متوفر';

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الطلب'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("الاسم: $userName", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("العنوان: $address", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("الهاتف: $phone", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("الوصف: $description", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text(
              "التاريخ: $formattedDate",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Chip(
              backgroundColor: _getStatusColor(status),
              label: Text(
                _getStatusText(status),
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'قيد الانتظار';
      case 'accepted':
        return 'مقبول';
      case 'rejected':
        return 'مرفوض';
      default:
        return 'غير معروف';
    }
  }
}
