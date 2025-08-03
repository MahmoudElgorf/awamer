import 'package:awamer/l10n/app_localizations.dart';
import 'package:awamer/widgets/shared/custom_text_field.dart';
import 'package:flutter/material.dart';

class RestaurantForm extends StatelessWidget {
  final TextEditingController itemsController;

  const RestaurantForm({
    super.key,
    required this.itemsController,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return CustomTextField(
      label: loc.foodItemsLabel,
      hintText: loc.foodItemsHint,
      controller: itemsController,
      maxLines: 2,
    );
  }
}
