import 'package:flutter/material.dart';
import 'package:awamer/widgets/home_screen_widgets/offer_carousel.dart';
import '../widgets/home_screen_widgets/header_section.dart';
import '../widgets/home_screen_widgets/category_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFd4d4d4),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderSection(),
            const SizedBox(height: 16),
            const OfferCarousel(),
            const SizedBox(height: 16),
            const CategorySection(),
          ],
        ),
      ),
    );
  }
}