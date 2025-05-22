import 'package:flutter/material.dart';
import '../shared/custom_text_field.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25),
      child: Column(
        children: [
          Row(
            children: const [
              Expanded(
                child: CustomTextField(
                  label: 'First Name',
                  hintText: 'First Name',
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  label: 'Last Name',
                  hintText: 'Last Name',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const CustomTextField(
            label: 'Email ',
            hintText: 'Enter Your Email ',
          ),
          const SizedBox(height: 20),
          const CustomTextField(
            label: 'Phone ',
            hintText: 'Enter Your Phone Number',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),
          const CustomTextField(
            label: 'Password',
            hintText: 'Enter Your Password',
            isPassword: true,
          ),
        ],
      ),
    );
  }
}
