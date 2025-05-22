import 'package:flutter/material.dart';
import 'package:awamer/models/models.dart';
import 'category_item.dart';
import 'services_list.dart';

class CategorySection extends StatefulWidget {
  const CategorySection({super.key});

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  int? selectedCategoryIndex;
  final ScrollController _scrollController = ScrollController();

  final List<ServiceCategory> categories = const [
    ServiceCategory(name: 'Delivery', icon: Icons.delivery_dining),
    ServiceCategory(name: 'Doctors', icon: Icons.local_hospital),
    ServiceCategory(name: 'Technicians', icon: Icons.build),
    ServiceCategory(name: 'Stores', icon: Icons.store),
    ServiceCategory(name: 'Restaurants', icon: Icons.restaurant),
    ServiceCategory(name: 'Pharmacies', icon: Icons.local_pharmacy),
    ServiceCategory(name: 'Cleaning', icon: Icons.cleaning_services),
    ServiceCategory(name: 'Education', icon: Icons.school),
  ];

  final Map<String, List<ServiceItem>> categoryServices = {
    'Delivery': [
      ServiceItem(name: 'Food Delivery', imageUrl: '', rating: 4.5, price: 10),
      ServiceItem(name: 'Parcel Delivery', imageUrl: '', rating: 4.2, price: 15),
    ],
    'Doctors': [
      ServiceItem(name: 'Dr. Ahmed', imageUrl: '', rating: 4.8, price: 100),
      ServiceItem(name: 'Dr. Mohamed', imageUrl: '', rating: 4.6, price: 120),
    ],
    // أضف باقي الفئات...
  };

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // قسم الفئات مع إمكانية التمرير الأفقي
          SizedBox(
            height: 150, // ارتفاع ثابت لقسم الفئات
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategoryIndex = index;
                      });
                    },
                    child: CategoryItem(
                      icon: categories[index].icon,
                      label: categories[index].name,
                      isLarge: true,
                      isSelected: selectedCategoryIndex == index,
                    ),
                  ),
                );
              },
            ),
          ),

          if (selectedCategoryIndex != null)
            ServicesList(
              services: categoryServices[categories[selectedCategoryIndex!].name] ?? [],
            ),
        ],
      ),
    );
  }
}