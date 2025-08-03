import 'package:awamer/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awamer/widgets/shared/custom_text_field.dart';
import 'package:awamer/widgets/shared/auth_footer.dart';
import 'package:awamer/screens/registration_screens/signin_screen.dart';
import 'package:awamer/screens/user/home_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;
  String? _phoneError;

  Future<bool> _isEmailAlreadyRegistered(String email) async {
    try {
      final methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _emailError = null;
      _passwordError = null;
      _phoneError = null;
    });

    try {
      final emailExists = await _isEmailAlreadyRegistered(_emailController.text.trim());
      if (emailExists) {
        setState(() {
          _emailError = AppLocalizations.of(context)!.emailAlreadyExists;
        });
        return;
      }

      final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await FirebaseFirestore.instance.collection('users').doc(result.user!.uid).set({
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'role': 'user',
        'service': '',
        'createdAt': Timestamp.now(),
      });

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String? errorField;

      if (e.code == 'email-already-in-use') {
        _emailError = AppLocalizations.of(context)!.emailAlreadyExists;
        errorField = 'email';
      } else if (e.code == 'weak-password') {
        _passwordError = AppLocalizations.of(context)!.weakPassword;
        errorField = 'password';
      } else if (e.code == 'invalid-email') {
        _emailError = AppLocalizations.of(context)!.invalidEmail;
        errorField = 'email';
      } else {
        _emailError = AppLocalizations.of(context)!.registrationFailed;
      }

      setState(() {});
    } catch (e) {
      setState(() {
        _emailError = AppLocalizations.of(context)!.unexpectedError;
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(child: _buildFirstNameField(tr)),
                const SizedBox(width: 16),
                Expanded(child: _buildLastNameField(tr)),
              ],
            ),
            const SizedBox(height: 20),
            _buildEmailField(tr),
            const SizedBox(height: 20),
            _buildPhoneField(tr),
            const SizedBox(height: 20),
            _buildPasswordField(tr),
            const SizedBox(height: 32),
            _buildSignUpButton(tr),
            const SizedBox(height: 24),
            AuthFooter(
              text: tr.alreadyHaveAccount,
              buttonText: tr.signIn,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const SigninScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstNameField(AppLocalizations tr) {
    return CustomTextField(
      label: tr.firstName,
      hintText: tr.enterFirstName,
      controller: _firstNameController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return tr.firstNameRequired;
        }
        return null;
      },
    );
  }

  Widget _buildLastNameField(AppLocalizations tr) {
    return CustomTextField(
      label: tr.lastName,
      hintText: tr.enterLastName,
      controller: _lastNameController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return tr.lastNameRequired;
        }
        return null;
      },
    );
  }

  Widget _buildEmailField(AppLocalizations tr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: tr.email,
          hintText: tr.enterEmail,
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return tr.emailRequired;
            }
            if (!value.contains('@')) {
              return tr.invalidEmail;
            }
            return null;
          },
        ),
        if (_emailError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 12),
            child: Text(
              _emailError!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildPhoneField(AppLocalizations tr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: tr.phone,
          hintText: tr.enterPhone,
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return tr.phoneRequired;
            }
            if (value.length < 10) {
              return tr.shortPhone;
            }
            return null;
          },
        ),
        if (_phoneError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 12),
            child: Text(
              _phoneError!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildPasswordField(AppLocalizations tr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: tr.password,
          hintText: tr.enterPassword,
          controller: _passwordController,
          isPassword: true,
          obscureText: _obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return tr.passwordRequired;
            }
            if (value.length < 6) {
              return tr.shortPassword;
            }
            return null;
          },
        ),
        if (_passwordError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 12),
            child: Text(
              _passwordError!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildSignUpButton(AppLocalizations tr) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4C9581),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _isLoading ? null : _signUp,
        child: _isLoading
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 3,
          ),
        )
            : Text(
          tr.signUp.toUpperCase(),
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
