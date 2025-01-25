import 'package:hangouts/Models/UserLocationModel.dart';

class UserDataModel {
  final String name;
  final String email;
  UserLocationModel address;

  UserDataModel({
    required this.name,
    required this.email,
    required this.address,
});

  UserDataModel.data({
    required this.name,
    required this.email,
    required this.address,
  });

  // Convert a Firestore document to a User object
  factory UserDataModel.fromFirestore(Map<String, dynamic> data) {
    return UserDataModel.data(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      address: UserLocationModel.fromFirestore(data['address'] ?? {}),
    );
  }

  // Convert User object to a Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'address': address.toMap(),
    };
  }
}
