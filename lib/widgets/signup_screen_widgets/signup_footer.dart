import 'package:flutter/material.dart';
import '../../screens/login_screen.dart';
import '../shared/auth_footer.dart';

class SignUpFooter extends StatelessWidget {
  const SignUpFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4C9581),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () {},
              child: const Text('Sign Up',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 30),
          AuthFooter(
            text: 'Already Have An Account?',
            buttonText: 'Sign In',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          )
        ],
      ),
    );
  }
}
