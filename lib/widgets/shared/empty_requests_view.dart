import 'package:awamer/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class EmptyRequestsView extends StatelessWidget {
  const EmptyRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Center(
      child: Text(
        loc.noCurrentlyRequests,
        style: const TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }
}
