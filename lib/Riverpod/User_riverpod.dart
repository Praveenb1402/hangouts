import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hangouts/Models/UserLocationModel.dart';
import 'package:hangouts/Models/UsersDataModel.dart';

// Define a StateProvider for storing the username
final userNameProvider = StateProvider<String>((ref) {
  return ""; // Initial value (empty string, indicating no data yet)
});

final itemsProvider = StateProvider<List<Map<String, dynamic>>>((ref) {
  return []; // Default empty list of items
});

final placeDetailsProvider = StateProvider<Map<String, dynamic>>((ref) {
  return {}; // Default empty list of items
});

final locationProvider = StateProvider<String>((ref) {
  return "";
});

final userdatamodelProvider = StateProvider<UserDataModel>((ref) {
  return UserDataModel(
      name: '',
      email: '',
      address: UserLocationModel(
          city: '', state: '', country: '', latitude: 0.0, longitude: 0.0));
});
