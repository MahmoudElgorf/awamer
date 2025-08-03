import 'package:awamer/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../screens/user/home_screen.dart';

class SigninHeader extends StatelessWidget {
  const SigninHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 80, bottom: 40, left: 20, right: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF4C9581),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(80),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text(
                AppLocalizations.of(context)!.welcomeBack,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
           Text(
            AppLocalizations.of(context)!.signIn,
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
