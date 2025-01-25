import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hangouts/Services/Authentication_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../SignUpQuestionsUi/SignUpstateQuestionUI.dart';

class LoginUi extends StatefulWidget {
  const LoginUi({super.key});

  @override
  State<LoginUi> createState() => _LoginUiState();
}

class _LoginUiState extends State<LoginUi> {
  bool _islogin = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
          child: Container(
        color: Colors.white,
        margin: EdgeInsets.all(10),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setBool("skiped", false);
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return const Signupstatequestionui();
                  }), (Route<dynamic> route) => false);
                },
                child: Text(
                  "SKIP",
                  textAlign: TextAlign.end,
                ),
              ),
              // Icon(Icons.icecream_outlined),
              // Text(
              //   textAlign: TextAlign.center,
              //   "HangOuts",
              //   style: TextStyle(
              //       fontSize: 40,
              //       fontFamily: 'DancingScript',
              //       color: Color(0xFF38FF53)),
              // ),
              SizedBox(
                height: 30,
              ),
              Image.asset(
                'Images/hangoutLogo.png',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
              SizedBox(
                height: 30,
              ),

              /**
                   * Continue with user google account type
                   * */
              GestureDetector(
                onTap: () {
                  setState(() {
                    _islogin = true;
                  });
                  Auth_servies services = Auth_servies();
                  services.getGoogleAuth(context);
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // Background color of the container
                    border: Border.all(
                      color: Colors.black, // Border color
                      width: 1, // Border width
                    ),
                    borderRadius: BorderRadius.circular(5), // Rounded corners
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: [
                      SvgPicture.asset(
                        "Images/google_icon.svg",
                        width: 20,
                        height: 20,
                      ),
                      Text("Continue with google account")
                    ],
                  ),
                ),
              ),

              /**
                   * Contiue with user email type
                   * */
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white, // Background color of the container
                  border: Border.all(
                    color: Colors.black, // Border color
                    width: 1, // Border width
                  ),
                  borderRadius: BorderRadius.circular(5), // Rounded corners
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10,
                  children: [
                    Icon(Icons.email_outlined),
                    Text("Continue with email")
                  ],
                ),
              ),
              Center(child: Text("OR")),
              Container(
                width: MediaQuery.sizeOf(context).width - 300,
                margin: EdgeInsets.all(10),
                child: TextField(
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Continue with mobile number',
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2)),
                  ),
                ),
              ),
              Visibility(
                  visible: _islogin,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ))
            ],
          ),
        ),
      )),
    );
  }
}
