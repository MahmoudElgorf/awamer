import 'package:flutter/material.dart';
import 'package:awamer/l10n/app_localizations.dart';

class PreviousChatsTitle extends StatelessWidget {
  const PreviousChatsTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.previousConversations,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF4C9581),
      ),
    );
  }
}
