import 'package:flutter/cupertino.dart';

class ServiceCategory {
  final String name;
  final IconData icon;

  const ServiceCategory({required this.name, required this.icon});
}

class ServiceItem {
  final String name;
  final String imageUrl;
  final double rating;
  final int price;

  const ServiceItem({
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.price,
  });
}