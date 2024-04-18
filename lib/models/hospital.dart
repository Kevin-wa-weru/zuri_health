class Hospital {
  final String name;
  final double distance;
  final double latitude;
  final double longitude;
  final String placeId;
  final String? address;
  final String? phone;
  final String? website;

  Hospital({
    required this.name,
    required this.distance,
    required this.latitude,
    required this.longitude,
    required this.placeId,
    this.address,
    this.phone,
    this.website,
  });
}
