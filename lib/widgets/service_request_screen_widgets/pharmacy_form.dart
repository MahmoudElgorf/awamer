import 'package:awamer/l10n/app_localizations.dart';
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
    final loc = AppLocalizations.of(context)!;

    return CustomTextField(
      label: loc.medicineLabel,
      hintText: loc.medicineHint,
      controller: medicineController,
    );
  }
}
