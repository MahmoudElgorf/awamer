import 'package:awamer/l10n/app_localizations.dart';
import 'package:awamer/widgets/provider_home_screen_widgets/image_viewer_widget.dart';
import 'package:awamer/widgets/shared/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ProviderRequestDetailsScreen extends StatefulWidget {
  final String requestId;
  final Map<String, dynamic> requestData;
  final Function(String)? onStatusChanged;

  const ProviderRequestDetailsScreen({
    super.key,
    required this.requestId,
    required this.requestData,
    this.onStatusChanged,
  });

  @override
  State<ProviderRequestDetailsScreen> createState() =>
      _ProviderRequestDetailsScreenState();
}

class _ProviderRequestDetailsScreenState
    extends State<ProviderRequestDetailsScreen> {
  final TextEditingController _rejectionReasonController = TextEditingController();
  final TextEditingController _deliveryTimeController = TextEditingController();
  final TextEditingController _servicePriceController = TextEditingController();
  final TextEditingController _providerNoteController = TextEditingController();

  final Map<String, Map<String, String>> _serviceMessages = {
    'Dentist': {
      'accepted': 'تم قبول حجزك الطبي. موعد الحجز: {time} - سعر الكشف: {price} جنيه',
      'rejected': 'نعتذر لعدم تمكننا من قبول حجزك. السبب: {reason}',
    },
    'Doctor': {
      'accepted': 'تم قبول حجزك الطبي. موعد الحجز: {time} - سعر الكشف: {price} جنيه',
      'rejected': 'نعتذر لعدم تمكننا من قبول حجزك. السبب: {reason}',
    },
    'Delivery': {
      'accepted': 'تم قبول طلب التوصيل. موعد التسليم: {time} - سعر التوصيل: {price} جنيه',
      'rejected': 'لا يمكننا تنفيذ طلب التوصيل حالياً. السبب: {reason}',
    },
    'Pharmacy': {
      'accepted': 'تم قبول طلب الأدوية. سيتم التوصيل: {time} - السعر الإجمالي: {price} جنيه',
      'rejected': 'بعض الأدوية غير متوفرة حالياً. السبب: {reason}',
    },
    'Restaurant': {
      'accepted': 'تم قبول طلب الطعام. موعد التوصيل: {time} - السعر الإجمالي: {price} جنيه',
      'rejected': 'المطعم مغلق حالياً. السبب: {reason}',
    },
    'Store': {
      'accepted': 'تم قبول طلبك من المتجر. موعد التوصيل: {time} - السعر الإجمالي: {price} جنيه',
      'rejected': 'بعض المنتجات غير متوفرة. السبب: {reason}',
    },
  };

  String _getServiceType() {
    return widget.requestData['service'] ?? 'General';
  }

  Future<void> _assignToDeliveryProvider() async {
    try {
      final serviceType = _getServiceType();

      // لا نرسل طلب توصيل لخدمات الأطباء وطب الأسنان
      if (serviceType == 'Doctor' || serviceType == 'Dentist') return;

      // البحث عن مندوب توصيل متاح
      final deliveryProviders = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'provider')
          .where('service', isEqualTo: 'Delivery')
          .where('serviceType', isEqualTo: 'Delivery')
          .limit(1)
          .get();

      if (deliveryProviders.docs.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('لا يوجد مندوب توصيل متاح حالياً')));
        }
        return;
      }

      final deliveryProvider = deliveryProviders.docs.first;
      final deliveryProviderId = deliveryProvider.id;
      final deliveryProviderFcmToken = deliveryProvider.data()['fcmToken'];

      // تحديث الطلب الأصلي بإضافة معلومات المندوب
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(widget.requestId)
          .update({
        'assignedDeliveryProviderId': deliveryProviderId,
        'deliveryStatus': 'pending',
        'deliveryAssignedAt': FieldValue.serverTimestamp(),
      });

      // إرسال إشعار للمندوب
      await _sendDeliveryNotification(
        deliveryProviderId: deliveryProviderId,
        fcmToken: deliveryProviderFcmToken,
      );

    } catch (e) {
      print('Error assigning to delivery provider: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('حدث خطأ أثناء تعيين مندوب التوصيل')));
      }
    }
  }

  Future<void> _sendDeliveryNotification({
    required String deliveryProviderId,
    required String fcmToken,
  }) async {
    try {
      // إرسال إشعار FCM
      await FirebaseFirestore.instance.collection('messages').add({
        'token': fcmToken,
        'notification': {
          'title': 'طلب توصيل جديد',
          'body': 'طلب توصيل جديد من نوع ${widget.requestData['service']}',
        },
        'data': {
          'requestId': widget.requestId,
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'type': 'new_delivery',
        },
      });

      // إضافة إشعار في collection الإشعارات
      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': deliveryProviderId,
        'title': 'طلب توصيل جديد',
        'body': 'طلب توصيل جديد من نوع ${widget.requestData['service']}',
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
        'requestId': widget.requestId,
        'type': 'delivery_assignment',
      });
    } catch (e) {
      print('Error sending delivery notification: $e');
    }
  }

  Future<void> _sendNotification({
    required String status,
    required String userName,
    required String message,
  }) async {
    try {
      final userId = widget.requestData['userId'];
      if (userId == null) return;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      final fcmToken = userDoc.data()?['fcmToken'];
      if (fcmToken == null) return;

      // إضافة إشعار للمستخدم
      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': userId,
        'title': 'تحديث حالة الطلب',
        'body': message,
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
        'requestId': widget.requestId,
      });

      // إرسال إشعار FCM
      await FirebaseFirestore.instance.collection('messages').add({
        'token': fcmToken,
        'notification': {
          'title': 'تحديث حالة الطلب',
          'body': message,
        },
        'data': {
          'requestId': widget.requestId,
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        },
      });
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  Future<void> _handleStatusChange(String status) async {
    if (status == 'rejected') {
      final reason = await _showRejectionDialog();
      if (reason == null || reason.isEmpty) return;
      _rejectionReasonController.text = reason;
    } else if (status == 'accepted') {
      final details = await _showAcceptanceDialog();
      if (details == null) return;
    }

    if (widget.onStatusChanged != null) {
      await widget.onStatusChanged!(status);

      final serviceType = _getServiceType();
      final message = _getStatusMessage(serviceType, status);

      await _sendNotification(
        status: status,
        userName: _getUserName(),
        message: message,
      );

      await _updateRequestData(status);

      // إرسال الطلب لمندوب التوصيل إذا كان مقبولاً وليس طلب طبيب
      if (status == 'accepted') {
        await _assignToDeliveryProvider();
      }

      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _updateRequestData(String status) async {
    final updateData = {
      'status': status,
      'responseTime': FieldValue.serverTimestamp(),
    };

    if (status == 'rejected') {
      updateData['rejectionReason'] = _rejectionReasonController.text;
    } else if (status == 'accepted') {
      updateData['providerNote'] = _providerNoteController.text;
      updateData['deliveryTime'] = _deliveryTimeController.text;
      updateData['servicePrice'] = _servicePriceController.text;
    }

    await FirebaseFirestore.instance
        .collection('requests')
        .doc(widget.requestId)
        .update(updateData);
  }

  String _getStatusMessage(String serviceType, String status) {
    if (status == 'accepted') {
      return (_serviceMessages[serviceType]?[status] ?? 'تم قبول طلبك.')
          .replaceAll('{time}', _deliveryTimeController.text)
          .replaceAll('{price}', _servicePriceController.text);
    } else {
      return (_serviceMessages[serviceType]?[status] ?? 'تم رفض طلبك.')
          .replaceAll('{reason}', _rejectionReasonController.text);
    }
  }

  Future<String?> _showRejectionDialog() async {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          AppLocalizations.of(context)!.rejectionReason,
          style: const TextStyle(color: Colors.red),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                label: 'سبب الرفض',
                hintText: 'أدخل سبب الرفض...',
                controller: _rejectionReasonController,
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_rejectionReasonController.text.isNotEmpty) {
                Navigator.pop(context, _rejectionReasonController.text);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(AppLocalizations.of(context)!.confirm),
          ),
        ],
      ),
    );
  }

  Future<Map<String, String>?> _showAcceptanceDialog() async {
    final serviceType = _getServiceType();

    return showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          _getDialogTitle(serviceType),
          style: const TextStyle(color: Color(0xFF4C9581)),
        ),
        content: _buildServiceSpecificForm(serviceType),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_validateForm(serviceType)) {
                Navigator.pop(context, {
                  'deliveryTime': _deliveryTimeController.text,
                  'servicePrice': _servicePriceController.text,
                  'providerNote': _providerNoteController.text,
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4C9581),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(_getConfirmButtonText(serviceType)),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceSpecificForm(String serviceType) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            label: _getTimeLabel(serviceType),
            hintText: _getTimeHint(serviceType),
            controller: _deliveryTimeController,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: _getPriceLabel(serviceType),
            hintText: _getPriceHint(serviceType),
            controller: _servicePriceController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: _getNotesLabel(serviceType),
            hintText: _getNotesHint(serviceType),
            controller: _providerNoteController,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  bool _validateForm(String serviceType) {
    if (_deliveryTimeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('الرجاء إدخال ${_getTimeLabel(serviceType)}')),
      );
      return false;
    }

    if (_servicePriceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('الرجاء إدخال ${_getPriceLabel(serviceType)}')),
      );
      return false;
    }

    return true;
  }

  String _getDialogTitle(String serviceType) {
    switch (serviceType) {
      case 'Dentist':
      case 'Doctor':
        return 'تأكيد حجز الطبيب';
      case 'Delivery':
        return 'تأكيد طلب التوصيل';
      case 'Pharmacy':
        return 'تأكيد طلب الصيدلية';
      case 'Restaurant':
        return 'تأكيد طلب المطعم';
      case 'Store':
        return 'تأكيد طلب المتجر';
      default:
        return 'تأكيد الطلب';
    }
  }

  String _getTimeLabel(String serviceType) {
    switch (serviceType) {
      case 'Dentist':
      case 'Doctor':
        return 'موعد الحجز';
      case 'Delivery':
        return 'موعد التوصيل';
      case 'Pharmacy':
        return 'موعد التوصيل';
      case 'Restaurant':
        return 'موعد التوصيل';
      case 'Store':
        return 'موعد التوصيل';
      default:
        return 'الوقت المتوقع';
    }
  }

  String _getTimeHint(String serviceType) {
    switch (serviceType) {
      case 'Dentist':
      case 'Doctor':
        return 'مثال: غداً الساعة 2 مساءً';
      case 'Delivery':
        return 'مثال: خلال ساعة';
      case 'Pharmacy':
        return 'مثال: خلال ساعتين';
      case 'Restaurant':
        return 'مثال: خلال 45 دقيقة';
      case 'Store':
        return 'مثال: خلال 3 ساعات';
      default:
        return 'مثال: خلال 24 ساعة';
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

  String _getPriceHint(String serviceType) {
    switch (serviceType) {
      case 'Dentist':
      case 'Doctor':
        return 'مثال: 200 جنيه';
      case 'Delivery':
        return 'مثال: 50 جنيه';
      case 'Pharmacy':
        return 'مثال: 350 جنيه';
      case 'Restaurant':
        return 'مثال: 250 جنيه';
      case 'Store':
        return 'مثال: 500 جنيه';
      default:
        return 'مثال: 100 جنيه';
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

  String _getNotesHint(String serviceType) {
    switch (serviceType) {
      case 'Dentist':
      case 'Doctor':
        return 'أي تعليمات أو ملاحظات';
      case 'Delivery':
        return 'أي تعليمات خاصة للتوصيل';
      case 'Pharmacy':
        return 'أي تعليمات خاصة بالأدوية';
      case 'Restaurant':
        return 'أي تعليمات خاصة بالطعام';
      case 'Store':
        return 'أي معلومات إضافية عن المنتجات';
      default:
        return 'أي معلومات إضافية';
    }
  }

  String _getConfirmButtonText(String serviceType) {
    switch (serviceType) {
      case 'Dentist':
      case 'Doctor':
        return 'تأكيد الحجز';
      case 'Delivery':
        return 'تأكيد التوصيل';
      case 'Pharmacy':
      case 'Restaurant':
      case 'Store':
        return 'تأكيد الطلب';
      default:
        return 'تأكيد';
    }
  }

  String _getUserName() {
    final firstName = widget.requestData['firstName'] ?? '';
    final lastName = widget.requestData['lastName'] ?? '';
    return '$firstName $lastName'.trim();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final userName = _getUserName().isEmpty ? loc.unknownName : _getUserName();
    final address = widget.requestData['address'] ?? loc.noAddress;
    final phone = widget.requestData['phone'] ?? loc.noPhone;
    final description = widget.requestData['description'] ?? loc.noDescription;
    final imageUrl = widget.requestData['imageUrl'];
    final currentStatus = widget.requestData['status'] ?? 'pending';
    final serviceType = _getServiceType();

    final dynamic rawTimestamp = widget.requestData['timestamp'];
    Timestamp? timestamp;
    if (rawTimestamp is Timestamp) timestamp = rawTimestamp;

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
                _buildItem(title: loc.serviceType, value: serviceType),
                const SizedBox(height: 16),
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
                if (widget.onStatusChanged != null)
                  _buildStatusButtons(currentStatus, loc),
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

  Widget _buildStatusButtons(String currentStatus, AppLocalizations loc) {
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
              : () => _handleStatusChange('accepted'),
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
              : () => _handleStatusChange('rejected'),
        ),
      ],
    );
  }
}