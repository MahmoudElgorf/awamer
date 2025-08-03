import 'package:awamer/screens/profile_screen.dart';
import 'package:awamer/screens/user/user_orders_screen.dart';
import 'package:awamer/screens/user/user_support_screen.dart';
import 'package:awamer/screens/registration_screens/signin_screen.dart';
import 'package:awamer/widgets/user_screen_widgets/notification_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui';
import 'dart:math';

class UserHeaderSection extends StatelessWidget {
  const UserHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

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
              uid == null
                  ? const Icon(Icons.notifications_none, color: Colors.white)
                  : StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('notifications')
                    .where('userId', isEqualTo: uid)
                    .where('read', isEqualTo: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  int unreadCount = snapshot.data?.docs.length ?? 0;
                  return Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_none, color: Colors.white),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => const NotificationDialog(),
                          );
                        },
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          // User Info
          if (uid != null)
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Text(
                    'Welcome',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }

                final userData = snapshot.data!.data() as Map<String, dynamic>;
                final fullName = '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}';
                final address = userData['address'] ?? 'No Address Provided';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white70, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            address,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
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
  final Color iconColor = const Color(0xffffffff);

  int? _pressedIndex;

  List<Map<String, dynamic>> icons = [
    {'icon': Icons.support_agent, 'label': 'Support'},
    {'icon': Icons.logout, 'label': 'Logout'},
    {'icon': Icons.shopping_bag, 'label': 'Orders'},
    {'icon': Icons.person, 'label': 'Profile'},
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
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
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const ProfileScreen()),
                      );
                    } else if (label == 'Logout') {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => SigninScreen()),
                            (route) => false,
                      );
                    } else if (label == 'Orders') {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const UserOrdersScreen()),
                      );
                    } else if (label == 'Support') {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const UserSupportScreen()),
                      );
                    }
                  },
                  child: AnimatedScale(
                    scale: isPressed ? 1.2 : 1.0,
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeInOut,
                    child: Column(
                      children: [
                        Icon(icons[index]['icon'], color: iconColor, size: 30),
                        const SizedBox(height: 4),
                        Text(
                          icons[index]['label'],
                          style: TextStyle(color: iconColor, fontSize: 12),
                        ),
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
