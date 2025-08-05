import 'package:flutter/material.dart';

class ServiceRequestAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const ServiceRequestAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: const Color(0xFF4C9581),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
