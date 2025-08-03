import 'package:awamer/l10n/app_localizations.dart';
import 'package:awamer/models/data.dart';
import 'package:awamer/screens/user/service_request_screen.dart';
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String getLocalizedCategoryName(BuildContext context, String name) {
    final loc = AppLocalizations.of(context)!;
    switch (name) {
      case 'Delivery':
        return loc.delivery;
      case 'Doctors':
        return loc.doctors;
      case 'Pharmacies':
        return loc.pharmacies;
      case 'Stores':
        return loc.stores;
      case 'Restaurants':
        return loc.restaurants;
      default:
        return name;
    }
  }

  String getLocalizedSubCategoryName(BuildContext context, String name) {
    final loc = AppLocalizations.of(context)!;
    switch (name) {
      case 'Deliver Your Parcel':
        return loc.deliverYourParcel;
      case 'Internal':
        return loc.internal;
      case 'Dentist':
        return loc.dentist;
      case 'Pediatrics':
        return loc.pediatrics;
      case 'Orthopedic':
        return loc.orthopedic;
      case 'Dermatology':
        return loc.dermatology;
      case 'Ophthalmology':
        return loc.ophthalmology;
      case 'ENT':
        return loc.ent;
      case 'Psychiatry':
        return loc.psychiatry;
      case 'Human Pharmacy':
        return loc.humanPharmacy;
      case 'Veterinary Pharmacy':
        return loc.veterinaryPharmacy;
      case 'Grocery Store':
        return loc.groceryStore;
      case 'Fast Food':
        return loc.fastFood;
      case 'Traditional Food':
        return loc.traditionalFood;
      default:
        return name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategoryName = selectedCategoryIndex != null
        ? Data.categories[selectedCategoryIndex!].name
        : null;

    final subCats = selectedCategoryName != null
        ? Data.subCategories[selectedCategoryName] ?? []
        : [];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              AppLocalizations.of(context)!.categories,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 130,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: Data.categories.length,
              itemBuilder: (context, index) {
                final category = Data.categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategoryIndex = index;
                      });
                    },
                    child: CategoryItem(
                      imageAsset: category.imageAsset,
                      label: getLocalizedCategoryName(context, category.name),
                      isLarge: true,
                      isSelected: selectedCategoryIndex == index,
                    ),
                  ),
                );
              },
            ),
          ),
          if (selectedCategoryIndex != null && subCats.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                              builder: (context) => ServiceRequestScreen(
                                serviceName: getLocalizedSubCategoryName(context, subCategory.name),
                                imageAsset: subCategory.imageAsset,
                                providerId: subCategory.providerId,
                              ),
                            ),
                          );
                        },
                        child: CategoryItem(
                          imageAsset: subCategory.imageAsset,
                          label: getLocalizedSubCategoryName(context, subCategory.name),
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
