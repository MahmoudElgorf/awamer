import 'package:awamer/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../widgets/shared/custom_text_field.dart';

class ProfileAvatarSection extends StatelessWidget {
  final bool isEditing;
  final Map<String, dynamic> userData;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;

  const ProfileAvatarSection({
    super.key,
    required this.isEditing,
    required this.userData,
    required this.firstNameController,
    required this.lastNameController,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey[300],
          child: const Icon(Icons.person, size: 50, color: Colors.white),
        ),
        const SizedBox(height: 24),
        isEditing
            ? Column(
          children: [
            _buildEditableField(loc.firstName, loc.enterFirstName, firstNameController),
            _buildEditableField(loc.lastName, loc.enterLastName, lastNameController),
          ],
        )
            : Text(
          '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildEditableField(String label, String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: CustomTextField(
        label: label,
        hintText: hint,
        controller: controller,
      ),
    );
  }
}
