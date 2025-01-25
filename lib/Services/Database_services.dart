import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:geocoding_platform_interface/src/models/placemark.dart';
import 'package:hangouts/HomePage/Main_Page_UI.dart';
import 'package:hangouts/Models/UserLocationModel.dart';
import 'package:hangouts/Models/UsersDataModel.dart';
import 'package:hangouts/Riverpod/User_riverpod.dart';
import 'package:hangouts/SignUpQuestionsUi/SignUpPeopleQuestionUI.dart';
import 'package:hangouts/SignUpQuestionsUi/SignUpTasteQuestionUI.dart';
import 'package:hangouts/SignUpQuestionsUi/SignUpstateQuestionUI.dart';
import 'package:hangouts/User_data_singleton.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FireStore_services {
  late BuildContext context;

  FireStore_services(BuildContext context) {
    this.context = context;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void updateChoices(List<String> choicesList) async {
    if (FirebaseAuth.instance.currentUser != null) {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      DocumentReference userRef = _firestore.collection('users').doc(uid);
      userRef.update({'choicesList': choicesList});
    } else {
      SharedPreferences choicepref = await SharedPreferences.getInstance();
      choicepref.setStringList("choicesList", choicesList);
    }
    show_snackbar("Choice updated");
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
            return Signuppeoplequestionui();
          }));
    });

  }


  void setgrouptypedata(List<String> choiceList)async
  {
    if (FirebaseAuth.instance.currentUser != null) {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      DocumentReference userRef = _firestore.collection('users').doc(uid);
      userRef.update({'grouptype': choiceList});
    }else {
      SharedPreferences choicepref = await SharedPreferences.getInstance();
      choicepref.setStringList("grouptype", choiceList);
    }
    show_snackbar("Group choice updated");
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
            return MainPageUi();
          }));
    });

  }

  void getUsersData(String? userId, WidgetRef ref) async {
    final userRef = FirebaseFirestore.instance.collection('users');

    DocumentSnapshot docSnapshot = await userRef.doc(userId).get();
    UserService userService = UserService();
    if (docSnapshot.exists) {
      userService.setuserdatamodel(UserDataModel.fromFirestore(
          docSnapshot.data() as Map<String, dynamic>));
      userService.setUsername(docSnapshot.get("name").toString());
      if (ref.watch(userNameProvider) != userService.getUsername()!) {
        ref.read(userdatamodelProvider.notifier).state =
            userService.getuserDatamodel()!;
        ref.read(userNameProvider.notifier).state = userService.getUsername()!;
      }
    } else {
      SharedPreferences location_pref = await SharedPreferences.getInstance();
      UserDataModel userDataModel = new UserDataModel(
          name: 'Guest',
          email: '',
          address: UserLocationModel(
              city: location_pref.getString('location')!=null ?location_pref.getString('location')!:"",
              state: '',
              country: '',
              latitude: 0.0,
              longitude: 0.0));
      userService.setuserdatamodel(userDataModel);
      userService.setUsername('Guest');
      if (ref.watch(userNameProvider) != userService.getUsername()!) {
        ref.read(userdatamodelProvider.notifier).state =
            userService.getuserDatamodel()!;
        ref.read(userNameProvider.notifier).state = userService.getUsername()!;
      }
    }
  }

  void setUsersData(UserCredential user_firebase_credentails) async {
    String? userId = user_firebase_credentails.user?.uid;
    try {
      // Get reference to the user document
      DocumentReference userRef = _firestore.collection('users').doc(userId);

      // Use update() to update specific fields in the document

      // Fetch the document
      DocumentSnapshot docSnapshot = await userRef.get();

      if (!docSnapshot.exists) {
        show_snackbar("Creating your account");
        upload_users_data(user_firebase_credentails, userRef);
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) {
                return Signupstatequestionui();
              }));
        });
      } else {
        show_snackbar("Logging you in");
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) {
                return MainPageUi();
              }));
        });
      }


    } catch (e) {
      show_snackbar("Error in logging in");
      // Handle errors
    }
  }

  void show_snackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2), // Duration the SnackBar is visible
      ),
    );
  }

  void getTrendingPlaceData(WidgetRef ref) async {
    if (ref.watch(itemsProvider).isEmpty) {
      List<Map<String, dynamic>> _items = [];
      CollectionReference trending_places_collections =
          _firestore.collection('trending_places');
      QuerySnapshot querySnapshot = await trending_places_collections.get();
      _items = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      ref.read(itemsProvider.notifier).state = _items;
    }
    // return _items;
  }

  void upload_users_data(UserCredential user_firebase_credentails,
      DocumentReference<Object?> userRef) async {
    String? username = user_firebase_credentails.user?.displayName;
    String? useremail = user_firebase_credentails.user?.email;
    await userRef.set({
      'name': username, // Update name field
      'email': useremail, // Update email field
    });
    UserService userService = UserService();
    userService.setUsername(username!);
    userService.setEmailId(useremail!);
  }

  void getPlaceDetails(WidgetRef ref, payload_name) async {
    // final data = ref.watch(placeDetailsProvider);
    // data.
    if (ref.watch(placeDetailsProvider)['payload'] != payload_name) {
      DocumentReference trending_places_collections =
          _firestore.collection('restaurants_details').doc(payload_name);
      DocumentSnapshot snapshot = await trending_places_collections.get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      data['payload']=payload_name;
      ref.read(placeDetailsProvider.notifier).state = data;
    }
  }

  void setuserplace(
      Position? position, Placemark? placemark, String location_string) async {
    Map<String, dynamic> locationData = {
      'latitude': position?.latitude,
      'longitude': position?.longitude,
      'state': placemark?.administrativeArea,
      'city':
          placemark?.locality != null ? placemark?.locality : location_string,
      'country': placemark?.country,
      // Add other fields as necessary
    };
    if (FirebaseAuth.instance.currentUser != null) {
      DocumentReference userRef = _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid);
      await userRef.update({'address': locationData});
    } else {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('location', location_string);
    }
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return Signuptastequestionui();
      }));
    });
  }
}
