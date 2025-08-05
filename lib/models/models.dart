import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceCategory {
  final String name;
  final String imageAsset;
  final String? providerId;

  const ServiceCategory({
    required this.name,
    required this.imageAsset,
    this.providerId,
  });
}
class RequestDecisionForm {
  final String? price;
  final String? deliveryTime;
  final String? notes;
  final String status; // 'accepted' or 'rejected'

  RequestDecisionForm({
    this.price,
    this.deliveryTime,
    this.notes,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'price': price,
      'deliveryTime': deliveryTime,
      'notes': notes,
      'status': status,
    };
  }
}