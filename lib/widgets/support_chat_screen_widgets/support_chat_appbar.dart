import 'package:awamer/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class SupportChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSupport;

  const SupportChatAppBar({super.key, required this.isSupport});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        isSupport
            ? AppLocalizations.of(context)!.supportChat
            : AppLocalizations.of(context)!.technicalSupport,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: const Color(0xFF4C9581),
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 0,
    );
  }
}
