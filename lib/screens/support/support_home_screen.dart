import 'package:awamer/widgets/support_home_screen_widgets/support_chat_list.dart';
import 'package:flutter/material.dart';
import 'package:awamer/l10n/app_localizations.dart';
import 'package:awamer/widgets/shared/provider_header_section.dart';

class SupportHomeScreen extends StatelessWidget {
  const SupportHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Column(
        children: [
          const ProviderHeaderSection(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.supportDashboard,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4C9581),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Expanded(child: SupportChatList()),
        ],
      ),
    );
  }
}
