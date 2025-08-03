import 'package:awamer/l10n/app_localizations.dart';
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
    final loc = AppLocalizations.of(context)!;

    return Column(
      children: [
        CustomTextField(
          label: loc.pickupAddressLabel,
          hintText: loc.pickupAddressHint,
          controller: pickupController,
          validator: (value) {
            if (value == null || value.isEmpty) return loc.pickupAddressRequired;
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: loc.dropoffAddressLabel,
          hintText: loc.dropoffAddressHint,
          controller: dropoffController,
          validator: (value) {
            if (value == null || value.isEmpty) return loc.dropoffAddressRequired;
            return null;
          },
        ),
      ],
    );
  }
}
