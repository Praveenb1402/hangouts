import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../Services/Database_services.dart';

class Signupstatequestionui extends StatefulWidget {
  const Signupstatequestionui({super.key});

  @override
  State<Signupstatequestionui> createState() => _SignupstatequestionuiState();
}

class _SignupstatequestionuiState extends State<Signupstatequestionui> {
  final List<String> _citiesInIndia = [
    "Surat",
    "Jaipur",
    "Lucknow",
    "Kanpur",
    "Nagpur",
    "Indore",
    "Vadodara",
    "Faridabad",
    "Meerut",
    "Noida",
    "Chandrapur",
    "Thane"
  ];
  String _location = "Getting location...";
  String _state = "Getting state...";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            // Icon(Icons.arrow_back_ios),
            Text(
              "Pick a region",
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
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //   width: MediaQuery.sizeOf(context).width,
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     border: Border.all(
              //       color: Colors.black, // Border color
              //       width: 0.5, // Border width
              //     ),
              //   ),
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     spacing: 5,
              //     children: [
              //       SizedBox(
              //         width: 10,
              //       ),
              //       Icon(Icons.search),
              //       Container(
              //         width: MediaQuery.sizeOf(context).width - 50,
              //         child: TextFormField(
              //           decoration: InputDecoration(
              //               hintText: "Search your City",
              //               border: InputBorder.none),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              //location auto detection container
              GestureDetector(
                onTap: () {
                  _showloadingscreen();
                  _getLocation();
                },
                child: Container(
                  color: Colors.white,
                  padding:
                      EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
                  child: Row(
                    spacing: 5,
                    children: [
                      Icon(
                        Icons.my_location_sharp,
                        color: Colors.red,
                      ),
                      Text(
                        "Auto Detect my location",
                        style: TextStyle(color: Colors.red),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Text(
                "  popular cities".toUpperCase(),
                style: TextStyle(),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                color: Colors.white,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    _statecontainerbuilder(
                        "Bengaluru", Icons.location_on_sharp),
                    _statecontainerbuilder(
                        "Delhi-NCR", Icons.location_on_sharp),
                    _statecontainerbuilder("Chennai", Icons.location_on_sharp),
                    _statecontainerbuilder("Pune", Icons.location_on_sharp),
                    _statecontainerbuilder(
                        "Hyderabad", Icons.location_on_sharp),
                    _statecontainerbuilder("Kolkata", Icons.location_on_sharp),
                    _statecontainerbuilder(
                        "Ahmedabad", Icons.location_on_sharp),
                    _statecontainerbuilder("Kochi", Icons.location_on_sharp),
                  ],
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Text(
                "  other cities".toUpperCase(),
                style: TextStyle(),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                color: Colors.white,
                width: MediaQuery.sizeOf(context).width,
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: _citiesInIndia.length,
                    itemBuilder: (context, index) {
                      return _othercitieslist(_citiesInIndia[index]);
                    }),
              )
            ],
          ),
        ),
      )),
    );
  }

  Widget _othercitieslist(String _citiesname) {
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.sizeOf(context).width / 4,
      decoration:
          BoxDecoration(border: Border.all(color: Colors.grey, width: 0.1)),
      child: Text(_citiesname),
    );
  }

  Widget _statecontainerbuilder(String _stateName, IconData _stateicon) {
    return GestureDetector(
      onTap: () {
        show_snackbar("Location set to $_stateName");
        FireStore_services databaseProcess = FireStore_services(context);
        databaseProcess.setuserplace(null, null, _stateName);
      },
      child: Container(
        width: MediaQuery.sizeOf(context).width / 4,
        height: 90,
        decoration:
            BoxDecoration(border: Border.all(color: Colors.grey, width: 0.1)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(_stateicon), Text(_stateName)],
        ),
      ),
    );
  }

  void _getLocation() async {
    // Request permission
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      setState(() {
        // show the user that there is issue to get the location
        _location = "Location services are disabled.";
      });
      return;
    }
    // Request permission for location
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() {
        // how the user that without permission we cannot get the location
        _location = "Location permission denied.";
      });
      return;
    }

    // Get the user's current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Get the user's address from latitude and longitude
    List<Placemark>? placemarks = await GeocodingPlatform.instance
        ?.placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark? place = placemarks?[0];
    Navigator.of(context).pop();
    show_snackbar("Location set to " + place!.locality.toString());
    FireStore_services databaseProcess = FireStore_services(context);
    databaseProcess.setuserplace(position, place!, '');
  }

  void _showloadingscreen() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Fetching Location'),
          content: Text('Please wait while we fetch your location'),
          actions: [
            // TextButton(
            //   onPressed: () {
            //     Navigator.of(context).pop(); // Close the dialog
            //   },
            //   child: Text('Close'),
            // ),
          ],
        );
      },
    );
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
