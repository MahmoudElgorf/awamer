import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awamer/l10n/app_localizations.dart';
import 'order_status_badge.dart';

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onStatusChange;

  const OrderCard({
    super.key,
    required this.data,
    this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final service = data['serviceType'] ?? data['service'] ?? loc.service;
    final status = data['status'] ?? 'pending';
    final timestamp = (data['timestamp'] as Timestamp?)?.toDate();
    final description = data['description'] ?? '';
    final imageUrl = data['imageUrl'];

    // بيانات الرد على الطلب
    final deliveryTime = data['deliveryTime'] ?? '';
    final servicePrice = data['servicePrice'] ?? '';
    final providerNote = data['providerNote'] ?? '';
    final rejectionReason = data['rejectionReason'] ?? '';

    final statusColor = {
      'pending': Colors.orange,
      'accepted': const Color(0xFF4C9581),
      'rejected': Colors.red,
    }[status] ?? Colors.grey;

    final statusText = _getStatusText(context, status);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    service,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4C9581),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                OrderStatusBadge(
                  status: status,
                  color: statusColor,
                  label: statusText,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // تاريخ الطلب
            if (timestamp != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${timestamp.toLocal().toString().split('.')[0]}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),

            // وصف الطلب
            if (description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),

            // رسالة القبول (للطلبات المقبولة)
            if (status == 'accepted')
              _buildAcceptedResponse(context, deliveryTime, servicePrice, providerNote),

            // سبب الرفض (للطلبات المرفوضة)
            if (status == 'rejected' && rejectionReason.isNotEmpty)
              _buildRejectedResponse(context, rejectionReason),

            // الصورة المرفقة
            if (imageUrl != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (_, child, progress) {
                      return progress == null
                          ? child
                          : Container(
                        height: 150,
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => Container(
                      height: 150,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, size: 50),
                    ),
                  ),
                ),
              ),

            // أزرار الإجراءات (للطلبات المعلقة)
            if (status == 'pending' && onStatusChange != null)
              _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAcceptedResponse(
      BuildContext context,
      String deliveryTime,
      String servicePrice,
      String providerNote
      ) {
    final loc = AppLocalizations.of(context)!;
    final serviceType = data['serviceType'] ?? data['service'] ?? 'General';

    String timeLabel = _getTimeLabel(serviceType);
    String priceLabel = _getPriceLabel(serviceType);
    String notesLabel = _getNotesLabel(serviceType);

    return Column(
      children: [
        // موعد التسليم/الحجز
        if (deliveryTime.isNotEmpty)
          _buildResponseItem(
            context,
            icon: Icons.access_time,
            label: timeLabel,
            value: deliveryTime,
            color: const Color(0xFF4C9581),
          ),

        // السعر
        if (servicePrice.isNotEmpty)
          _buildResponseItem(
            context,
            icon: Icons.attach_money,
            label: priceLabel,
            value: '$servicePrice ${loc.price}',
            color: const Color(0xFF4C9581),
          ),

        // الملاحظات
        if (providerNote.isNotEmpty)
          _buildResponseItem(
            context,
            icon: Icons.note,
            label: notesLabel,
            value: providerNote,
            color: const Color(0xFF4C9581),
          ),
      ],
    );
  }

  Widget _buildRejectedResponse(BuildContext context, String reason) {
    return _buildResponseSection(
      context,
      icon: Icons.cancel,
      color: Colors.red,
      message: reason,
    );
  }

  Widget _buildResponseItem(
      BuildContext context, {
        required IconData icon,
        required String label,
        required String value,
        required Color color,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponseSection(BuildContext context, {
    required IconData icon,
    required Color color,
    required String message,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.green[50],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () => onStatusChange?.call(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check, size: 18, color: Colors.green),
              const SizedBox(width: 4),
              Text(loc.accept, style: const TextStyle(color: Colors.green)),
            ],
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.red[50],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () => onStatusChange?.call(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.close, size: 18, color: Colors.red),
              const SizedBox(width: 4),
              Text(loc.reject, style: const TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }

  String _getStatusText(BuildContext context, String status) {
    switch (status) {
      case 'accepted':
        return AppLocalizations.of(context)!.statusAccepted;
      case 'rejected':
        return AppLocalizations.of(context)!.statusRejected;
      case 'pending':
        return AppLocalizations.of(context)!.statusPending;
      default:
        return status;
    }
  }

  String _getTimeLabel(String serviceType) {
    switch (serviceType) {
      case 'Dentist':
      case 'Doctor':
        return 'موعد الحجز';
      case 'Delivery':
      case 'Pharmacy':
      case 'Restaurant':
      case 'Store':
        return 'موعد التوصيل';
      default:
        return 'الوقت المتوقع';
    }
  }

  String _getPriceLabel(String serviceType) {
    switch (serviceType) {
      case 'Dentist':
      case 'Doctor':
        return 'سعر الكشف';
      case 'Delivery':
        return 'سعر التوصيل';
      case 'Pharmacy':
      case 'Restaurant':
      case 'Store':
        return 'السعر الإجمالي';
      default:
        return 'السعر';
    }
  }

  String _getNotesLabel(String serviceType) {
    switch (serviceType) {
      case 'Dentist':
      case 'Doctor':
        return 'تعليمات للمريض';
      case 'Delivery':
        return 'ملاحظات للمندوب';
      case 'Pharmacy':
        return 'ملاحظات الأدوية';
      case 'Restaurant':
        return 'ملاحظات الطلب';
      case 'Store':
        return 'ملاحظات الطلب';
      default:
        return 'ملاحظات إضافية';
    }
  }
}