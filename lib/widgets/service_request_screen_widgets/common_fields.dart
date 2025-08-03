import 'package:awamer/l10n/app_localizations.dart';
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
    final loc = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            label: loc.fullNameLabel,
            hintText: loc.fullNameHint,
            controller: nameController,
            validator: (value) => (value == null || value.isEmpty) ? loc.fullNameRequired : null,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomTextField(
            label: loc.phoneLabel,
            hintText: loc.phoneHint,
            controller: phoneController,
            keyboardType: TextInputType.phone,
            validator: (value) => (value == null || value.isEmpty) ? loc.phoneRequired : null,
          ),
        ),
      ],
    );
  }
}
