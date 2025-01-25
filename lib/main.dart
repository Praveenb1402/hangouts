import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hangouts/HomePage/Main_Page_UI.dart';
import 'package:hangouts/Login_Page_UI/Login_UI.dart';
import 'package:hangouts/SignUpQuestionsUi/SignUpPeopleQuestionUI.dart';
import 'package:hangouts/SignUpQuestionsUi/SignUpTasteQuestionUI.dart';
import 'SignUpQuestionsUi/SignUpstateQuestionUI.dart';
import 'firebase_options.dart';
import 'package:splashify/splashify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

late final FirebaseApp app;
late final FirebaseAuth auth;
bool _skipped_pressed = false;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  _skipped_pressed = prefs.getBool("skiped")!=null?true:false;
  app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  auth = FirebaseAuth.instanceFor(app: app);
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MaterialApp(
      title: 'Flutter Demo',
      home: Splashify(
        // title: "HangOuts",
        heightBetween: 5,
        titleBold: true,
        titleColor: Color(0xFF38FF53),
        // blurIntroAnimation: true,
        subTitle:
            Text("HangOuts\nFind the Perfect Spot\nfor You and Your Crew!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'DancingScript',
                  fontSize: 25,
                )),
        imagePath: 'Images/hangoutLogo.png',
        imageFadeIn: true,
        imageSize: 150,
        navigateDuration: 3,
        // Navigate to the child widget after 3 seconds
        child: const MyHomePage(
            title: 'Flutter Demo Home Page'), // Your main app screen widget
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      // Signuppeoplequestionui()
      FirebaseAuth.instance.currentUser != null
          ? MainPageUi()
          : _skipped_pressed
              ? MainPageUi()
              : LoginUi(),
    );
  }
}
