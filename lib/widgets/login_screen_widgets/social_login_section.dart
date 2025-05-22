import 'package:flutter/material.dart';
import 'social_login_button.dart';

class SocialLoginSection extends StatelessWidget {
  const SocialLoginSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
      child: Column(
        children: [
          const Divider(thickness: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SocialLoginButton(
                imagePath: 'assets/images/google.png',
                text: 'Google',
              ),
              SizedBox(width: 20),
              SocialLoginButton(
                imagePath: 'assets/images/facebook.png',
                text: 'Facebook',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
