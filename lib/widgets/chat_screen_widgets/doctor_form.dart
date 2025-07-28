import 'package:awamer/widgets/shared/custom_text_field.dart';
import 'package:flutter/material.dart';

class DoctorForm extends StatelessWidget {
  final TextEditingController ageController;
  final TextEditingController symptomsController;

  const DoctorForm({
    super.key,
    required this.ageController,
    required this.symptomsController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          label: "العمر",
          hintText: "أدخل عمرك",
          controller: ageController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: "الشكوى أو الأعراض",
          hintText: "اكتب الشكوى بالتفصيل",
          controller: symptomsController,
          maxLines: 3,
        ),
      ],
    );
  }
}
