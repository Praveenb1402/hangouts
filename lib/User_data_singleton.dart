import 'package:hangouts/Models/UsersDataModel.dart';

class UserService {
  static final UserService _instance = UserService._internal();

  String? username;
  String? email_id;
  String? location;
  UserDataModel? userDataModel;

  UserService._internal();

  factory UserService() => _instance;

  void setUsername(String name) {
    username = name;
  }

  String? getUsername() {
    return username;
  }

  void setEmailId(String emailId) {
    email_id = emailId;
  }

  String? getEmailId() {
    return email_id;
  }

  String? getLocation() {
    return location;
  }

  void setLocation(String _location) {
    location = _location;
  }

  UserDataModel? getuserDatamodel() {
    return userDataModel;
  }

  void setuserdatamodel(UserDataModel _userdatamodel) {
    userDataModel = _userdatamodel;
  }
}
