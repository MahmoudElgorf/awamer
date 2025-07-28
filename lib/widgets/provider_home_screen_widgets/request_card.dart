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
    final status = request['status'];
    final statusColor = _getStatusColor(status);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: statusColor.withOpacity(0.2),
          child: Icon(Icons.person, color: statusColor),
        ),
        title: Text(
          fullName.isEmpty ? 'مستخدم غير معروف' : fullName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          request['timestamp'] != null && request['timestamp'] is Timestamp
              ? _formatDate(request['timestamp'])
              : 'تاريخ غير متاح',
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: Chip(
          backgroundColor: statusColor,
          label: Text(
            _getStatusText(status),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  String _formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return DateFormat('yyyy/MM/dd – HH:mm').format(date);
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
