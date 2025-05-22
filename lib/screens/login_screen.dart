import 'package:flutter/material.dart';
import 'package:awamer/widgets/login_screen_widgets/login_footer.dart';
import '../widgets/login_screen_widgets/login_header.dart';
import '../widgets/login_screen_widgets/login_form.dart';
import '../widgets/login_screen_widgets/social_login_section.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFd4d4d4),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            LoginHeader(),
            LoginForm(),
            SocialLoginSection(),
            LogInFooter()
          ],
        ),
      ),
    );
  }
}
