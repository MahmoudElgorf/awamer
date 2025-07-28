import 'package:awamer/widgets/shared/custom_text_field.dart';
import 'package:flutter/material.dart';

class PharmacyForm extends StatelessWidget {
  final TextEditingController medicineController;

  const PharmacyForm({
    super.key,
    required this.medicineController,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: "اسم الدواء أو الوصفة",
      hintText: "أدخل اسم الدواء أو صورة الوصفة",
      controller: medicineController,
    );
  }
}
