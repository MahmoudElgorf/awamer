import 'package:awamer/l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AcceptedOrderCard extends StatelessWidget {
  final Map<String, dynamic> order;

  const AcceptedOrderCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final firstName = order['firstName'] ?? '';
    final lastName = order['lastName'] ?? '';
    final fullName = '$firstName $lastName'.trim();
    final timestamp = order['acceptedAt'] ?? order['timestamp'];
    final formattedDate = (timestamp != null && timestamp is Timestamp)
        ? _formatDate(timestamp)
        : loc.dateNotAvailable;

    final serviceType = order['service'] ?? 'طلب';
    final deliveryTime = order['deliveryTime'] ?? 'لم يتم التحديد';
    final servicePrice = order['servicePrice'] ?? '0';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFFE8F5E9), Color(0xFFE1F5FE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFF4C9581).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                serviceType,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF2E7D32),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF4C9581).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${loc.price}: $servicePrice',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4C9581),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.person_outline, size: 20, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                fullName.isEmpty ? loc.unknownUser : fullName,
                style: const TextStyle(fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time, size: 20, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                'موعد التسليم: $deliveryTime',
                style: const TextStyle(fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                'تاريخ القبول: $formattedDate',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (order['providerNote'] != null && order['providerNote'].isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.note, size: 20, color: Color(0xFF4C9581)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      order['providerNote'],
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return DateFormat('yyyy/MM/dd – hh:mm a').format(date);
  }
}