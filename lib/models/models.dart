class ServiceCategory {
  final String name;
  final String imageAsset;
  final String? providerId;

  const ServiceCategory({
    required this.name,
    required this.imageAsset,
    this.providerId,
  });
}