import 'package:flutter/material.dart';

class EmptyRequestsView extends StatelessWidget {
  const EmptyRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "No Currently Requests",
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }
}
