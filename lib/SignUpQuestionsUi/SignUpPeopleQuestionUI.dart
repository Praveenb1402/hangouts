import 'package:flutter/material.dart';
import 'package:hangouts/Services/Database_services.dart';

class Signuppeoplequestionui extends StatefulWidget {
  const Signuppeoplequestionui({super.key});

  @override
  State<Signuppeoplequestionui> createState() => _SignuppeoplequestionuiState();
}

class _SignuppeoplequestionuiState extends State<Signuppeoplequestionui> {
  Color color = Colors.red;

  final List<String> _tastechoice = [
    "Just Me",
    "Family",
    "Small Group",
    "Large Group",
    "All of the above",
  ];
  List<String> _selectedChoices = [];
  List<Color> _colorList = List.filled(7, Colors.white);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Group"),
          backgroundColor: Colors.grey[100],
        ),
        body: SafeArea(
            child: Container(
          padding: EdgeInsets.only(left: 20),
          color: Colors.grey[100],
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: SingleChildScrollView(
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("What is the size of your group?"),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(
                    _tastechoice.length,
                    (index) => _choiceTextWidget(_tastechoice[index], index),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: FilledButton(
                      onPressed: () {
                        if (_selectedChoices.length > 0) {
                          updateChoices();
                        } else {
                          show_snackbar("Please select at least one ");
                        }
                      },
                      child: Text("Get Started")),
                )
              ],
            ),
          ),
        )));
  }

  Widget _choiceTextWidget(String foodname, int listIndex) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if(foodname == 'All of the above' && _selectedChoices.length<4)
            {
              _selectedChoices.addAll(_tastechoice);
              _colorList.fillRange(0, 6,Colors.red);
              return;
            }
          else if(foodname == 'All of the above' && _selectedChoices.length>=4)
            {
              _selectedChoices.removeRange(0, _selectedChoices.length-1);
              _colorList.fillRange(0, _colorList.length,Colors.white);
              return;
            }
          if (_colorList[listIndex] != Colors.red) {
            _selectedChoices.add(foodname);
            _colorList[listIndex] = Colors.red;
          } else {
            _selectedChoices.remove(foodname);
            _colorList[listIndex] = Colors.white;
          }
          if (_selectedChoices.length == 5) {
            _colorList[4] = Colors.red;
          } else {
            _colorList[4] = Colors.white;
          }
        });
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: _colorList[listIndex],
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Text(foodname),
      ),
    );
  }

  void updateChoices() {
    FireStore_services fireStore_services = FireStore_services(context);
    fireStore_services.setgrouptypedata(_selectedChoices);
  }

  void show_snackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(20),
        content: Container(
          child: Row(
          spacing: 10,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.grey,
              ),
              Text(message)
            ],
          ),
        ),
        duration: Duration(seconds: 2), // Duration the SnackBar is visible
      ),
    );
  }
}
