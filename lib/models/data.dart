import 'package:awamer/models/models.dart';

class Data {
  static const List<ServiceCategory> categories = [
    ServiceCategory(name: 'Delivery', imageAsset: 'assets/images/Delivery.jpg'),
    ServiceCategory(name: 'Doctors', imageAsset: 'assets/images/Doctors.jpg'),
    ServiceCategory(
      name: 'Pharmacies',
      imageAsset: 'assets/images/Pharmacies.jpg',
    ),
    ServiceCategory(name: 'Stores', imageAsset: 'assets/images/Stores.jpg'),
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
      ),
    ],
    'Doctors': [
      ServiceCategory(
        name: 'Internal',
        imageAsset: 'assets/images/Internal.jpg',
      ),
      ServiceCategory(name: 'Dentist', imageAsset: 'assets/images/Dentist.jpg'),
      ServiceCategory(
        name: 'Pediatrics',
        imageAsset: 'assets/images/Pediatrics.jpg',
      ),
      ServiceCategory(
        name: 'Orthopedic',
        imageAsset: 'assets/images/Orthopedic.jpg',
      ),
      ServiceCategory(
        name: 'Dermatology',
        imageAsset: 'assets/images/Dermatology.jpg',
      ),
      ServiceCategory(
        name: 'Ophthalmology',
        imageAsset: 'assets/images/Ophthalmology.jpg',
      ),
      ServiceCategory(name: 'ENT', imageAsset: 'assets/images/ENT.jpg'),
      ServiceCategory(
        name: 'Psychiatry',
        imageAsset: 'assets/images/Psychiatry.jpg',
      ),
    ],
    'Pharmacies': [
      ServiceCategory(
        name: 'Human Pharmacy',
        imageAsset: 'assets/images/HumanPharmacy.jpg',
      ),
      ServiceCategory(
        name: 'Veterinary Pharmacy',
        imageAsset: 'assets/images/VeterinaryPharmacy.jpg',
      ),
    ],
    'Stores': [
      ServiceCategory(
        name: 'Grocery Store',
        imageAsset: 'assets/images/Grocery.jpg',
      ),
    ],
    'Restaurants': [
      ServiceCategory(
        name: 'Fast Food',
        imageAsset: 'assets/images/FastFood.jpg',
      ),
      ServiceCategory(
        name: 'Traditional Food',
        imageAsset: 'assets/images/TraditionalFood.jpg',
      ),
    ],
  };
}
