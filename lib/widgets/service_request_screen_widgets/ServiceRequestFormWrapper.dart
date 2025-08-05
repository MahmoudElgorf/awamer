import 'package:flutter/material.dart';
import 'chat_form.dart'; // اللي هو الفورم الكامل
import 'package:image_picker/image_picker.dart';

class ServiceRequestFormWrapper extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String serviceType;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController descriptionController;
  final void Function(XFile?) onImagePicked;
  final XFile? selectedImage;

  const ServiceRequestFormWrapper({
    super.key,
    required this.formKey,
    required this.serviceType,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    required this.descriptionController,
    required this.onImagePicked,
    required this.selectedImage,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: ChatForm(
          serviceType: serviceType,
          nameController: nameController,
          phoneController: phoneController,
          addressController: addressController,
          descriptionController: descriptionController,
          onImagePicked: onImagePicked,
          selectedImage: selectedImage,
        ),
      ),
    );
  }
}
