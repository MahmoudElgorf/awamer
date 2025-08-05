import 'package:flutter/material.dart';
import 'package:awamer/l10n/app_localizations.dart';

class ServiceRequestFAB extends StatelessWidget {
  final VoidCallback onPressed;
  const ServiceRequestFAB({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      icon: const Icon(Icons.send, color: Colors.white),
      label: Text(
        AppLocalizations.of(context)!.submitRequest,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: const Color(0xFF4C9581),
    );
  }
}
