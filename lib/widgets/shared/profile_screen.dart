import 'package:awamer/widgets/shared/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  bool isEditing = false;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم تحديث الملف الشخصي بنجاح")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("حدث خطأ أثناء التحديث")),
      );
    }
  }

  void toggleEdit() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            color: Color(0xFF4C9581),
          ),
          child: AppBar(
            title: const Text(
              'الملف الشخصي',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
        ),
      ),
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            // صورة الملف الشخصي
            Container(
              padding: const EdgeInsets.all(16),
              child: const CircleAvatar(
                radius: 60,
                backgroundColor: Color(0xFF4C9581),
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // حقول المعلومات
            CustomTextField(
              label: "الاسم الأول",
              hintText: "أدخل اسمك الأول",
              controller: firstNameController,
              keyboardType: TextInputType.name,
              enabled: isEditing, // تفعيل/تعطيل حسب وضع التعديل
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يجب إدخال الاسم الأول';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            CustomTextField(
              label: "الاسم الأخير",
              hintText: "أدخل اسمك الأخير",
              controller: lastNameController,
              keyboardType: TextInputType.name,
              enabled: isEditing,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يجب إدخال الاسم الأخير';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            CustomTextField(
              label: "رقم الهاتف",
              hintText: "أدخل رقم هاتفك",
              controller: phoneController,
              keyboardType: TextInputType.phone,
              enabled: isEditing,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يجب إدخال رقم الهاتف';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            CustomTextField(
              label: "العنوان",
              hintText: "أدخل عنوانك",
              controller: addressController,
              maxLines: 2,
              enabled: isEditing,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يجب إدخال العنوان';
                }
                return null;
              },
            ),

            const SizedBox(height: 32),

            // زر التعديل/الحفظ
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4C9581),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                onPressed: isEditing ? saveChanges : toggleEdit,
                child: Text(
                  isEditing ? 'حفظ التغييرات' : 'تعديل الملف',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}