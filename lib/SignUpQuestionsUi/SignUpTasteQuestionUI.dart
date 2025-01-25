import 'package:flutter/material.dart';
import 'package:hangouts/Services/Database_services.dart';

class Signuptastequestionui extends StatefulWidget {
  const Signuptastequestionui({super.key});

  @override
  State<Signuptastequestionui> createState() => _SignuptastequestionuiState();
}

class _SignuptastequestionuiState extends State<Signuptastequestionui> {
  Color color = Colors.red;

  final List<String> _tastechoice = [
    "North Indian",
    "South Indian",
    "Punjabi",
    "Gujarati",
    "Rajasthani",
    "Bengali",
    "Maharashtrian"
  ];
  List<String> _selectedChoices = [];
  List<Color> _colorList = List.filled(7, Colors.white);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:false,
        backgroundColor: Colors.grey[100],
        title: Row(
          children: [
            // Icon(Icons.arrow_back_ios),
            Text(
              "Select your taste",
              style: TextStyle(fontSize: 15),
            ),
            Divider(
              color: Colors.black,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.only(left: 20),
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: SingleChildScrollView(
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("What style of food you prefer?\nSelect some on them."),
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
                      if(_selectedChoices.length>0)
                        updateChoices();
                      else
                        show_snackbar("Please select atleast one");
                    },
                    child: Text("Continue")),
              )
            ],
          ),
        ),
      )),
    );
  }

  Widget _choiceTextWidget(String _foodname, int _listIndex) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_colorList[_listIndex] != Colors.red) {
            _selectedChoices.add(_foodname);
            _colorList[_listIndex] = Colors.red;
          } else {
            _selectedChoices.remove(_foodname);
            _colorList[_listIndex] = Colors.white;
          }
        });
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: _colorList[_listIndex],
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Text(_foodname),
      ),
    );
  }

  void updateChoices() {
    FireStore_services fireStore_services = FireStore_services(context);
    fireStore_services.updateChoices(_selectedChoices);
  }

  void show_snackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2), // Duration the SnackBar is visible
      ),
    );
  }
}
