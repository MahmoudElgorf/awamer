import 'package:awamer/widgets/shared/custom_text_field.dart';
import 'package:flutter/material.dart';

class DeliveryForm extends StatelessWidget {
  final TextEditingController pickupController;
  final TextEditingController dropoffController;

  const DeliveryForm({
    super.key,
    required this.pickupController,
    required this.dropoffController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          label: "عنوان الالتقاط",
          hintText: "أدخل عنوان الالتقاط",
          controller: pickupController,
          validator: (value) {
            if (value == null || value.isEmpty) return 'من فضلك أدخل عنوان الالتقاط';
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: "عنوان التوصيل",
          hintText: "أدخل عنوان التوصيل",
          controller: dropoffController,
          validator: (value) {
            if (value == null || value.isEmpty) return 'من فضلك أدخل عنوان التوصيل';
            return null;
          },
        ),
      ],
    );
  }
}
