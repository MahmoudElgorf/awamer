import 'package:flutter/material.dart';
import 'package:awamer/screens/signup_screen.dart';
import '../shared/auth_footer.dart';

class LogInFooter extends StatelessWidget {
  const LogInFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Column(
        children: [
          AuthFooter(
            text: "Don't Have An Account?",
            buttonText: "Sign Up",
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()),
              );
            },
          )
        ],
      ),
    );
  }
}
