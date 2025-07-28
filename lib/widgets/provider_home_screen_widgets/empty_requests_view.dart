import 'package:flutter/material.dart';

class EmptyRequestsView extends StatelessWidget {
  const EmptyRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "لا توجد طلبات حالياً",
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }
}
