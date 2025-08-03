import 'package:awamer/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../widgets/shared/custom_text_field.dart';

class ProfileInfoSection extends StatelessWidget {
  final bool isEditing;
  final Map<String, dynamic> userData;
  final TextEditingController phoneController;
  final TextEditingController addressController;

  const ProfileInfoSection({
    super.key,
    required this.isEditing,
    required this.userData,
    required this.phoneController,
    required this.addressController,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      children: [
        _buildInfoRow(Icons.email, userData['email'] ?? ''),
        const SizedBox(height: 8),
        isEditing
            ? _buildEditableField(loc.phone, loc.enterYourPhone, phoneController)
            : _buildInfoRow(Icons.phone, phoneController.text),
        const SizedBox(height: 8),
        isEditing
            ? _buildEditableField(loc.address, loc.enterYourAddress, addressController)
            : _buildInfoRow(Icons.location_on, addressController.text),
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

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
