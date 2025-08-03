import 'package:awamer/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class EditSaveButton extends StatelessWidget {
  final bool isEditing;
  final VoidCallback onEdit;
  final VoidCallback onSave;

  const EditSaveButton({
    super.key,
    required this.isEditing,
    required this.onEdit,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return ElevatedButton(
      onPressed: isEditing ? onSave : onEdit,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4C9581),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      ),
      child: Text(
        isEditing ? loc.saveChanges : loc.editProfile,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
