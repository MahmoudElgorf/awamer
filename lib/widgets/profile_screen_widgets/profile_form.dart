import 'package:flutter/material.dart';
import 'package:awamer/widgets/shared/custom_text_field.dart';
import 'package:awamer/l10n/app_localizations.dart';

class ProfileForm extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final bool isEditing;

  const ProfileForm({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
    required this.addressController,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      children: [
        CustomTextField(
          label: loc.firstName,
          hintText: loc.enterFirstName,
          controller: firstNameController,
          enabled: isEditing,
          keyboardType: TextInputType.name,
          validator: (value) => value == null || value.isEmpty ? loc.firstNameRequired : null,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: loc.lastName,
          hintText: loc.enterLastName,
          controller: lastNameController,
          enabled: isEditing,
          keyboardType: TextInputType.name,
          validator: (value) => value == null || value.isEmpty ? loc.lastNameRequired : null,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: loc.phoneNumber,
          hintText: loc.enterPhoneNumber,
          controller: phoneController,
          enabled: isEditing,
          keyboardType: TextInputType.phone,
          validator: (value) => value == null || value.isEmpty ? loc.phoneNumberRequired : null,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: loc.address,
          hintText: loc.enterAddress,
          controller: addressController,
          enabled: isEditing,
          maxLines: 2,
          validator: (value) => value == null || value.isEmpty ? loc.addressRequired : null,
        ),
      ],
    );
  }
}
