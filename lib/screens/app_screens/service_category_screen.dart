import 'package:flutter/material.dart';

class ServiceCategoryScreen extends StatelessWidget {
  final String name;
  final String imageAsset;

  const ServiceCategoryScreen({
    super.key,
    required this.name,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(name),
        backgroundColor: const Color(0xFF4C9581),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ServiceHeader(name: name, imageAsset: imageAsset),
            const SizedBox(height: 30),
            ProviderContactButton(onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('فتح تواصل مع مقدم الخدمة')),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class ServiceHeader extends StatelessWidget {
  final String name;
  final String imageAsset;

  const ServiceHeader({
    super.key,
    required this.name,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(imageAsset, width: 200, height: 200, fit: BoxFit.cover);
  }
}

class ProviderContactButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ProviderContactButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.chat),
      label: const Text('Chat Now'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 48),
        backgroundColor: const Color(0xFF333333),
        textStyle: const TextStyle(fontSize: 18),
      ),
    );

  }
}