import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isLarge;
  final bool isSelected;

  const CategoryItem({
    super.key,
    required this.icon,
    required this.label,
    this.isLarge = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: isLarge ? 36 : 28,
          backgroundColor: isSelected ? Colors.grey[300] : Colors.white,
          child: Icon(
            icon,
            color: const Color(0xFF4C9581),
            size: isLarge ? 32 : 24,
          ),
        ),
        SizedBox(height: isLarge ? 8 : 6),
        Text(
          label,
          style: TextStyle(
            fontSize: isLarge ? 16 : 14,
            fontWeight: isLarge ? FontWeight.w500 : FontWeight.normal,
            color: isSelected ? Colors.blue : Colors.black,
          ),
        ),
      ],
    );
  }
}