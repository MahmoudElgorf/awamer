import 'package:awamer/l10n/app_localizations.dart';
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
    final loc = AppLocalizations.of(context)!;

    return Column(
      children: [
        CustomTextField(
          label: loc.ageLabel,
          hintText: loc.ageHint,
          controller: ageController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: loc.symptomsLabel,
          hintText: loc.symptomsHint,
          controller: symptomsController,
          maxLines: 3,
        ),
      ],
    );
  }
}
