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
    return CustomTextField(
      label: "الأصناف المطلوبة",
      hintText: "اكتب الطلبات التي تريدها",
      controller: itemsController,
      maxLines: 2,
    );
  }
}
