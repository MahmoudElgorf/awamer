import 'package:awamer/screens/provider/provider_home_screen.dart';
import 'package:awamer/screens/support/support_home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../screens/user/home_screen.dart';
import '../../screens/registration_screens/forgot_password_screen.dart';
import '../../screens/registration_screens/signup_screen.dart';
import '../shared/custom_text_field.dart';
import '../shared/auth_footer.dart';

class SigninForm extends StatefulWidget {
  const SigninForm({super.key});

  @override
  State<SigninForm> createState() => _SigninFormState();
}

class _SigninFormState extends State<SigninForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final uid = userCredential.user!.uid;
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        throw FirebaseAuthException(code: 'user-not-found');
      }

      final data = userDoc.data();
      final role = data?['role'] ?? 'user';

      if (!mounted) return;

      if (role == 'provider') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProviderHomeScreen()),
        );
      } else if (role == 'support') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SupportHomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String msg = 'حدث خطأ أثناء تسجيل الدخول';
      if (e.code == 'user-not-found') msg = 'هذا البريد غير مسجل';
      if (e.code == 'wrong-password') msg = 'كلمة المرور غير صحيحة';

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CustomTextField(
              label: 'Email',
              hintText: 'Enter Your Email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) =>
              value == null || !value.contains('@') ? 'بريد غير صحيح' : null,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: 'Password',
              hintText: 'Enter Your Password',
              controller: _passwordController,
              isPassword: true,
              obscureText: _obscurePassword,
              validator: (value) =>
              value != null && value.length < 6 ? 'كلمة المرور قصيرة' : null,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                  );
                },
                child: const Text(
                  'Forget Password?',
                  style: TextStyle(color: Color(0xFF4C9581), fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4C9581),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Sign In', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
            AuthFooter(
              text: "Don't Have An Account?",
              buttonText: "Sign Up",
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const SignUpScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
