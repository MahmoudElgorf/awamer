import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awamer/l10n/app_localizations.dart';
import 'package:awamer/widgets/shared/custom_text_field.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  Map<String, dynamic>? userData;
  bool isEditing = false;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          userData = data;
          firstNameController.text = data['firstName'] ?? '';
          lastNameController.text = data['lastName'] ?? '';
          phoneController.text = data['phone'] ?? '';
          addressController.text = data['address'] ?? '';
        });
      }
    }
  }

  Future<void> saveChanges() async {
    final loc = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final updatedData = {
      'firstName': firstNameController.text.trim(),
      'lastName': lastNameController.text.trim(),
      'phone': phoneController.text.trim(),
      'address': addressController.text.trim(),
    };

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(updatedData);
      setState(() {
        userData?.addAll(updatedData);
        isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(loc.profileUpdatedSuccessfully)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(loc.errorUpdatingProfile)));
    }
  }

  void toggleEdit() {
    setState(() => isEditing = !isEditing);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    if (userData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: const CircleAvatar(
              radius: 60,
              backgroundColor: Color(0xFF4C9581),
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
          ),
          const SizedBox(height: 24),
          CustomTextField(
            label: loc.firstName,
            hintText: loc.enterFirstName,
            controller: firstNameController,
            keyboardType: TextInputType.name,
            enabled: isEditing,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return loc.firstNameRequired;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: loc.lastName,
            hintText: loc.enterLastName,
            controller: lastNameController,
            keyboardType: TextInputType.name,
            enabled: isEditing,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return loc.lastNameRequired;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: loc.phoneNumber,
            hintText: loc.enterPhoneNumber,
            controller: phoneController,
            keyboardType: TextInputType.phone,
            enabled: isEditing,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return loc.phoneNumberRequired;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: loc.address,
            hintText: loc.enterAddress,
            controller: addressController,
            maxLines: 2,
            enabled: isEditing,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return loc.addressRequired;
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isEditing ? saveChanges : toggleEdit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4C9581),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
              ),
              child: Text(
                isEditing ? loc.saveChanges : loc.editProfile,
                style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
