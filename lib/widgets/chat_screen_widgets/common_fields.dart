import 'package:awamer/widgets/shared/custom_text_field.dart';
import 'package:flutter/material.dart';

class CommonFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;

  const CommonFields({
    super.key,
    required this.nameController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            label: "الاسم بالكامل",
            hintText: "أدخل اسمك",
            controller: nameController,
            validator: (value) => (value == null || value.isEmpty) ? 'الاسم مطلوب' : null,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomTextField(
            label: "رقم الهاتف",
            hintText: "أدخل رقم هاتفك",
            controller: phoneController,
            keyboardType: TextInputType.phone,
            validator: (value) => (value == null || value.isEmpty) ? 'رقم الهاتف مطلوب' : null,
          ),
        ),
      ],
    );
  }
}
