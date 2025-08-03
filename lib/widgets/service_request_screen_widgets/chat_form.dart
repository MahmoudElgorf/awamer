import 'package:awamer/l10n/app_localizations.dart';
import 'package:awamer/widgets/service_request_screen_widgets/attachment_section.dart';
import 'package:awamer/widgets/service_request_screen_widgets/common_fields.dart';
import 'package:awamer/widgets/service_request_screen_widgets/delivery_form.dart';
import 'package:awamer/widgets/service_request_screen_widgets/doctor_form.dart';
import 'package:awamer/widgets/service_request_screen_widgets/pharmacy_form.dart';
import 'package:awamer/widgets/service_request_screen_widgets/restaurant_form.dart';
import 'package:awamer/widgets/service_request_screen_widgets/store_form.dart';
import 'package:awamer/widgets/shared/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatForm extends StatelessWidget {
  final String serviceType;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController descriptionController;
  final void Function(XFile?) onImagePicked;
  final XFile? selectedImage;

  ChatForm({
    super.key,
    required this.serviceType,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    required this.descriptionController,
    required this.onImagePicked,
    this.selectedImage,
  });

  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropoffController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      children: [
        CommonFields(
          nameController: nameController,
          phoneController: phoneController,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: loc.addressLabel,
          hintText: loc.addressHint,
          controller: addressController,
          validator: (value) =>
          (value == null || value.isEmpty) ? loc.addressRequired : null,
        ),
        const SizedBox(height: 16),
        _buildServiceSpecificForm(serviceType),
        const SizedBox(height: 16),
        CustomTextField(
          label: loc.descriptionLabel,
          hintText: loc.descriptionHint,
          controller: descriptionController,
          maxLines: 4,
        ),
        const SizedBox(height: 16),
        AttachmentSection(
          selectedImage: selectedImage,
          onImagePicked: onImagePicked,
        ),
      ],
    );
  }

  Widget _buildServiceSpecificForm(String type) {
    switch (type) {
      case 'Doctors':
        return DoctorForm(
          ageController: TextEditingController(),
          symptomsController: TextEditingController(),
        );
      case 'Delivery':
        return DeliveryForm(
          pickupController: TextEditingController(),
          dropoffController: TextEditingController(),
        );
      case 'Pharmacies':
        return PharmacyForm(medicineController: TextEditingController());
      case 'Stores':
        return StoreForm(itemsController: TextEditingController());
      case 'Restaurants':
        return RestaurantForm(itemsController: TextEditingController());
      default:
        return const SizedBox.shrink();
    }
  }
}
