import 'package:awamer/widgets/user_orders_screen_widgets/orders_app_bar.dart';
import 'package:awamer/widgets/user_orders_screen_widgets/orders_list.dart';
import 'package:flutter/material.dart';


class UserOrdersScreen extends StatelessWidget {
  const UserOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: OrdersAppBar(),
      backgroundColor: Color(0xFFF5F5F5),
      body: OrdersList(),
    );
  }
}
