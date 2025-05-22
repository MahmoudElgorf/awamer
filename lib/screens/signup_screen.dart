import 'package:flutter/material.dart';
import 'package:awamer/widgets/signup_screen_widgets/signup_footer.dart';
import '../widgets/signup_screen_widgets/signup_header.dart';
import '../widgets/signup_screen_widgets/signup_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFd4d4d4),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            SignUpHeader(),
            SignUpForm(),
            SignUpFooter()
          ],
        ),
      ),
    );
  }
}
