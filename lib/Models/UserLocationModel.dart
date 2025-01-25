class UserLocationModel {
  String city;
  final String country;
  final String state;
  final double latitude;
  final double longitude;

  UserLocationModel({
    required this.city,
    required this.state,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  // Convert a Firestore document to an Address object
  factory UserLocationModel.fromFirestore(Map<String, dynamic> data) {
    return UserLocationModel(
      city: data['city'] ?? '',
      state: data['state'] ?? '',
      country: data['country'] ?? '',
      latitude: data['latitude'] ?? 0.0,
      longitude: data['longitude'] ?? 0.0,
    );
  }

  // Convert Address object to a Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'state': state,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

