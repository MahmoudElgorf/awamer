import 'package:awamer/models/data.dart';
import 'package:awamer/screens/app_screens/service_category_screen.dart';
import 'package:flutter/material.dart';
import 'category_item.dart';

class CategorySection extends StatefulWidget {
  const CategorySection({super.key});

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  int? selectedCategoryIndex;
  final ScrollController _scrollController = ScrollController();

  final categories = Data.categories;
  final subCategories = Data.subCategories;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategoryName = selectedCategoryIndex != null
        ? categories[selectedCategoryIndex!].name
        : null;

    final subCats = selectedCategoryName != null
        ? subCategories[selectedCategoryName] ?? []
        : [];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // التصنيفات الرئيسية
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Categories',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 130,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      imageAsset: categories[index].imageAsset,
                      label: categories[index].name,
                      isLarge: true,
                      isSelected: selectedCategoryIndex == index,
                    ),
                  ),
                );
              },
            ),
          ),

          // التصنيفات الفرعية
          if (selectedCategoryIndex != null && subCats.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: subCats.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.9,
                    ),
                    itemBuilder: (context, index) {
                      final subCategory = subCats[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ServiceCategoryScreen(
                                name: subCategory.name,
                                imageAsset: subCategory.imageAsset,
                              ),
                            ),
                          );
                        },
                        child: CategoryItem(
                          imageAsset: subCategory.imageAsset,
                          label: subCategory.name,
                          isLarge: false,
                          isSelected: false,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}