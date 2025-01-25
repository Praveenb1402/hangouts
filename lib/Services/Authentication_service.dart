import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hangouts/Services/Database_services.dart';

class Auth_servies {
  void getGoogleAuth(BuildContext context) async {
    GoogleSignInAccount? user_google_account = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? user_google_credentials =
        await user_google_account?.authentication;

    AuthCredential user_credentails = GoogleAuthProvider.credential(
        accessToken: user_google_credentials?.accessToken,
        idToken: user_google_credentials?.idToken);

    setFirebaseAuth(user_credentails, context);
  }

  void setFirebaseAuth(AuthCredential user_credentails, BuildContext context) async {
    UserCredential user_firebase_credentails =
        await FirebaseAuth.instance.signInWithCredential(user_credentails);
    FireStore_services update_user_data = FireStore_services(context);
    update_user_data.setUsersData(user_firebase_credentails);
  }
}
