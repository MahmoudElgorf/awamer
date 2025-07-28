import 'package:awamer/widgets/home_screen_widgets/address_prompt.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/shared/header_section.dart';
import '../../widgets/home_screen_widgets/offer_carousel.dart';
import '../../widgets/home_screen_widgets/category_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserAddress();
  }

  Future<void> _checkUserAddress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final data = doc.data();
      if (data != null) {
        final address = data['address'];
        if (address == null || address.toString().isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AddressPrompt.show(context);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFd4d4d4),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            HeaderSection(),
            SizedBox(height: 16),
            OfferCarousel(),
            SizedBox(height: 16),
            CategorySection(),
          ],
        ),
      ),
    );
  }
}
