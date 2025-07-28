import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AttachmentSection extends StatelessWidget {
  final XFile? selectedImage;
  final void Function(XFile?) onImagePicked;

  const AttachmentSection({
    super.key,
    required this.selectedImage,
    required this.onImagePicked,
  });

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    onImagePicked(image);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.attach_file, color: Colors.white),
          label: const Text(
            'إرفاق صورة',
            style: TextStyle(color: Colors.white,),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4C9581),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          ),
        ),
        if (selectedImage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Image.file(File(selectedImage!.path), height: 100),
          ),
      ],
    );
  }
}
