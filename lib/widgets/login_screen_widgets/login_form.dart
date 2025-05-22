import 'package:flutter/material.dart';
import '../../screens/forgot_password_screen.dart';
import '../shared/custom_text_field.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const CustomTextField(
            label: 'Email ',
            hintText: 'Enter Your Email ',
          ),
          const SizedBox(height: 20),
          const CustomTextField(
            label: 'Password',
            hintText: 'Enter Your Password',
            isPassword: true,
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                );
              },
              child: const Text('Forget Password?',style: TextStyle(color: Color(0xFF4C9581),fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4C9581),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () {},
              child: const Text('Sign In',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
