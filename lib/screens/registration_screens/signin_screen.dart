import 'package:awamer/widgets/signin_screen_widgets/signin_form.dart';
import 'package:awamer/widgets/signin_screen_widgets/signin_header.dart';
import 'package:flutter/material.dart';


class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFd4d4d4),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            SigninHeader(),
            SigninForm(),
          ],
        ),
      ),
    );
  }
}
