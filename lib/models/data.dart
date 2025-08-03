import 'package:awamer/models/models.dart';

class Data {
  static const List<ServiceCategory> categories = [
    ServiceCategory(
      name: 'Delivery',
      imageAsset: 'assets/images/Delivery.jpg',
    ),
    ServiceCategory(
      name: 'Doctors',
      imageAsset: 'assets/images/Doctors.jpg',
    ),
    ServiceCategory(
      name: 'Pharmacies',
      imageAsset: 'assets/images/Pharmacies.jpg',
    ),
    ServiceCategory(
      name: 'Stores',
      imageAsset: 'assets/images/Stores.jpg',
    ),
    ServiceCategory(
      name: 'Restaurants',
      imageAsset: 'assets/images/Restaurants.jpg',
    ),
  ];

  static const Map<String, List<ServiceCategory>> subCategories = {
    'Delivery': [
      ServiceCategory(
        name: 'Deliver Your Parcel',
        imageAsset: 'assets/images/parcel.jpg',
        providerId: 'Delivery',
      ),
    ],
    'Doctors': [
      ServiceCategory(
        name: 'Internal',
        imageAsset: 'assets/images/Internal.jpg',
        providerId: 'provider_internal_1',
      ),
      ServiceCategory(
        name: 'Dentist',
        imageAsset: 'assets/images/Dentist.jpg',
        providerId: 'kuEgmPuDmMXQy80APwR4vNYDijb2',
      ),
      ServiceCategory(
        name: 'Pediatrics',
        imageAsset: 'assets/images/Pediatrics.jpg',
        providerId: 'provider_pediatrics_1',
      ),
      ServiceCategory(
        name: 'Orthopedic',
        imageAsset: 'assets/images/Orthopedic.jpg',
        providerId: 'provider_orthopedic_1',
      ),
      ServiceCategory(
        name: 'Dermatology',
        imageAsset: 'assets/images/Dermatology.jpg',
        providerId: 'provider_dermatology_1',
      ),
      ServiceCategory(
        name: 'Ophthalmology',
        imageAsset: 'assets/images/Ophthalmology.jpg',
        providerId: 'provider_ophthalmology_1',
      ),
      ServiceCategory(
        name: 'ENT',
        imageAsset: 'assets/images/ENT.jpg',
        providerId: 'provider_ent_1',
      ),
      ServiceCategory(
        name: 'Psychiatry',
        imageAsset: 'assets/images/Psychiatry.jpg',
        providerId: 'provider_psychiatry_1',
      ),
    ],
    'Pharmacies': [
      ServiceCategory(
        name: 'Human Pharmacy',
        imageAsset: 'assets/images/HumanPharmacy.jpg',
        providerId: 'provider_human_pharmacy_1',
      ),
      ServiceCategory(
        name: 'Veterinary Pharmacy',
        imageAsset: 'assets/images/VeterinaryPharmacy.jpg',
        providerId: 'provider_vet_pharmacy_1',
      ),
    ],
    'Stores': [
      ServiceCategory(
        name: 'Grocery Store',
        imageAsset: 'assets/images/Grocery.jpg',
        providerId: 'provider_grocery_1',
      ),
    ],
    'Restaurants': [
      ServiceCategory(
        name: 'Fast Food',
        imageAsset: 'assets/images/FastFood.jpg',
        providerId: 'provider_fastfood_1',
      ),
      ServiceCategory(
        name: 'Traditional Food',
        imageAsset: 'assets/images/TraditionalFood.jpg',
        providerId: 'provider_traditional_1',
      ),
    ],
  };
}
