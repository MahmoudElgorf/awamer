import 'package:flutter/material.dart';
import 'package:awamer/widgets/profile_screen_widgets/profile_header.dart';
import 'package:awamer/widgets/profile_screen_widgets/profile_body.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      appBar: ProfileHeader(),
      body: ProfileBody(),
    );
  }
}
