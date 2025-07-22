import 'dart:math';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awamer/screens/app_screens/profile_screen.dart';
import 'package:awamer/screens/registration_screens/signin_screen.dart';

class ProviderHomeScreen extends StatelessWidget {
  const ProviderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Column(
        children: [
          const HeaderSection(),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 48, left: 16, right: 16, bottom: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF4C9581),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const Center(
                        child: Material(
                          color: Colors.transparent,
                          child: BlurBackgroundMenu(),
                        ),
                      );
                    },
                  );
                },
              ),
              const Icon(Icons.notifications_none, color: Colors.white),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class BlurBackgroundMenu extends StatefulWidget {
  const BlurBackgroundMenu({super.key});

  @override
  State<BlurBackgroundMenu> createState() => _BlurBackgroundMenuState();
}

class _BlurBackgroundMenuState extends State<BlurBackgroundMenu> {
  final double radius = 80;
  final double center = 110;
  final Color iconColor = Colors.white;
  int? _pressedIndex;

  final List<Map<String, dynamic>> icons = [
    {'icon': Icons.settings, 'label': 'Settings'},
    {'icon': Icons.logout, 'label': 'Logout'},
    {'icon': Icons.shopping_bag, 'label': 'Orders'},
    {'icon': Icons.person, 'label': 'Profile'},
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Blur + dark overlay
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              width: 250,
              height: 250,
              color: Colors.black.withOpacity(0.4),
            ),
          ),
        ),
        SizedBox(
          width: 220,
          height: 220,
          child: Stack(
            children: List.generate(icons.length, (index) {
              final angle = (2 * pi / icons.length) * index;
              final dx = center + radius * cos(angle) - 24;
              final dy = center + radius * sin(angle) - 24;
              final isPressed = _pressedIndex == index;

              return Positioned(
                left: dx,
                top: dy,
                child: GestureDetector(
                  onTapDown: (_) {
                    setState(() => _pressedIndex = index);
                  },
                  onTapUp: (_) async {
                    setState(() => _pressedIndex = null);
                    final label = icons[index]['label'];
                    Navigator.of(context).pop();

                    if (label == 'Profile') {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
                    } else if (label == 'Logout') {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const SigninScreen()),
                            (route) => false,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$label tapped')),
                      );
                    }
                  },
                  onTapCancel: () {
                    setState(() => _pressedIndex = null);
                  },
                  child: AnimatedScale(
                    scale: isPressed ? 1.2 : 1.0,
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeInOut,
                    child: Column(
                      children: [
                        Icon(icons[index]['icon'], color: iconColor, size: 30),
                        const SizedBox(height: 4),
                        Text(icons[index]['label'], style: TextStyle(color: iconColor, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
