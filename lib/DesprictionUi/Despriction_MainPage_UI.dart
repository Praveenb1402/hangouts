import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hangouts/Riverpod/User_riverpod.dart';
import 'package:hangouts/Services/GoogleMapRedirector.dart';
import '../Services/Database_services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DesprictionMainpageUi extends StatefulWidget {
  final String payload_name;

  DesprictionMainpageUi({super.key, required this.payload_name});

  @override
  State<DesprictionMainpageUi> createState() => _DesprictionMainpageUiState();
}

class _DesprictionMainpageUiState extends State<DesprictionMainpageUi> {
  @override
  Widget build(BuildContext context) {
    return DescriptionStateless(widget.payload_name);
  }
}

class DescriptionStateless extends ConsumerWidget {
  final String payloadName;
  final PageController _reviewpagecontroller =
      PageController(initialPage: 0); // set the initial page you want to show
  DescriptionStateless(this.payloadName);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placeDetailsMap = ref.watch(placeDetailsProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Function to be called after build
      getPlaceDetails(context, ref, payloadName);
      // rating_details = placeDetailsMap['rating_reviews'].toString().split("&&");
    });
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
          child: SingleChildScrollView(
        child: placeDetailsMap.isNotEmpty &&
                placeDetailsMap['payload'] == '$payloadName'
            ? Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios_sharp),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Text(placeDetailsMap['place_name'] ?? ""),
                          Icon(Icons.share),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 20, top: 20),
                          width: MediaQuery.sizeOf(context).width,
                          height: 250,
                          child: Shimmer.fromColors(
                            baseColor: Color(0xFFE0E0E0),
                            highlightColor: Colors.white,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.lightGreen,
                                  borderRadius: BorderRadius.circular(20)),
                              height: 100,
                              // Placeholder color
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20, top: 20),
                          width: MediaQuery.sizeOf(context).width,
                          height: 250,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    placeDetailsMap['image_url'] ?? ""),
                                fit: BoxFit
                                    .cover, // This ensures the image fills the container while preserving the aspect ratio
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.red,
                          ),
                          Text(placeDetailsMap['rating_reviews'] ??
                              "No Reviews"),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            margin: EdgeInsets.only(right: 10, top: 10),
                            child: Text(
                              "Veg",
                              style: TextStyle(fontSize: 10),
                            )),
                        placeDetailsMap['non_veg'] == true
                            ? Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                margin: EdgeInsets.only(right: 10, top: 10),
                                child: Text(
                                  "Non Veg",
                                  style: TextStyle(fontSize: 10),
                                ))
                            : SizedBox(),
                        Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            margin: EdgeInsets.only(right: 10, top: 10),
                            child: Icon(
                              Icons.directions_car_filled,
                              size: 15,
                            ))
                      ],
                    ),
                    setSpace(10),
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: text_richData("Opening Hours: ",
                          placeDetailsMap['opening_hours'] ?? ""),
                    ),
                    setSpace(10),
                    // text_richData("Location:  ",
                    //     "4, Kengal Hanumanthaiah Rd, Bheemanna Garden, Shanti Nagar, Bengaluru, Karnataka"),
                    // setSpace(10),
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: text_richData("About this place: \n\n",
                          placeDetailsMap['description'] ?? ""),
                    ),
                    setSpace(10),
                    text_richData("Location: ", ""),
                    setSpace(30),
                    GestureDetector(
                      onTap: () {
                        if (placeDetailsMap['location'] != null) {
                          GoogleMapRedirector().openGoogleMaps(
                              0, 0, placeDetailsMap['location']);
                        } else {
                          show_snackbar("Sorry location not Found", context);
                        }
                      },
                      child: Card(
                        color: Colors.white,
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            children: [
                              Image.asset("Images/map_backbround_image.png"),
                              Center(
                                child: Text(
                                  placeDetailsMap['location'] ??
                                      "Not Mentioned",
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    setSpace(30),
                    Text(
                      "Signature Delights",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),

                    // signature data list scroll
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width - 20,
                      height: 280,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: placeDetailsMap['dishes_images_details']
                                      ['dishes_names']
                                  .length ??
                              3,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.white,
                              shadowColor: Colors.white,
                              elevation: 0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 130,
                                    height: 150,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(placeDetailsMap[
                                                      'dishes_images_details']
                                                  ['images_url'][(index +
                                                      1)
                                                  .toString()] ??
                                              ""),
                                          fit: BoxFit
                                              .cover, // This ensures the image fills the container while preserving the aspect ratio
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(13))),
                                  ),
                                  Container(
                                    width: 100,
                                    margin: EdgeInsets.only(top: 3),
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            placeDetailsMap['dishes_images_details']
                                                            ['dishes_names']
                                                        [(index + 1).toString()]
                                                    .split("&&")[0] ??
                                                "",
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            // Limits text to 2 lines
                                            overflow: TextOverflow.ellipsis),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.star_rounded,
                                              color: Colors.red,
                                            ),
                                            Text("Ratings",
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                                // Limits text to 2 lines
                                                overflow: TextOverflow.ellipsis)
                                          ],
                                        ),
                                        Text(
                                            placeDetailsMap['dishes_images_details']
                                                            ['dishes_names']
                                                        [(index + 1).toString()]
                                                    .split("&&")[1] ??
                                                "",
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            // Limits text to 2 lines
                                            overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),
                    ),

                    // Reviews section
                    setSpace(30),
                    Text(
                      "Reviews",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Container(
                        width: MediaQuery.sizeOf(context).width,
                        height: 250,
                        child: placeDetailsMap['reviews'] != null
                            ? PageView.builder(
                                controller: _reviewpagecontroller,
                                scrollDirection: Axis.horizontal,
                                itemCount: placeDetailsMap['reviews'].length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: 250,
                                    width:
                                        MediaQuery.sizeOf(context).width - 100,
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      spacing: 10,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                Text(placeDetailsMap['reviews']
                                                        [index]['name']
                                                    .toString()),
                                              ],
                                            ),
                                            Icon(Icons.supervised_user_circle)
                                          ],
                                        ),
                                        RatingBar(
                                            itemSize: 25,
                                            initialRating:
                                                (placeDetailsMap['reviews']
                                                        [index]['rating_star']
                                                    .toDouble()),
                                            minRating: 1,
                                            onRatingUpdate: (double value) {},
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            // Allows half ratings
                                            itemCount: 5,
                                            // Number of stars
                                            ignoreGestures: true,
                                            ratingWidget: RatingWidget(
                                              full: Icon(Icons.star,
                                                  color: Colors.amber),
                                              half: Icon(Icons.star_half,
                                                  color: Colors.yellow),
                                              empty: Icon(Icons.star_border,
                                                  color: Colors.yellow),
                                            )),
                                        Text(
                                          placeDetailsMap['reviews'][index]
                                                  ['review_string']
                                              .toString(),
                                        ),
                                      ],
                                    ),
                                  );
                                })
                            : Text("No Reviews",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))),
                    placeDetailsMap['reviews'] != null
                        ? Center(
                            child: SmoothPageIndicator(
                              controller: _reviewpagecontroller,
                              count: placeDetailsMap['reviews'].length,
                              onDotClicked: (index) {
                                _reviewpagecontroller.animateToPage(
                                  index,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeInOut,
                                );
                              },
                              effect: const ExpandingDotsEffect(
                                  dotHeight: 10, dotWidth: 10, spacing: 10),
                            ),
                          )
                        : Container(),

                    // Booking button..
                    Container(
                        margin: EdgeInsets.only(top: 20),
                        width: MediaQuery.sizeOf(context).width - 50,
                        child: FilledButton(
                            onPressed: () {}, child: Text("Book Reservations")))
                  ],
                ),
              )
            : Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 30, right: 30, top: 30),
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    child: Shimmer.fromColors(
                      baseColor: Color(0xFFE0E0E0),
                      highlightColor: Colors.white,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.lightGreen,
                            borderRadius: BorderRadius.circular(20)),
                        height: 100,
                        // Placeholder color
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 30, right: 30, top: 30),
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: Shimmer.fromColors(
                      baseColor: Color(0xFFE0E0E0),
                      highlightColor: Colors.white,
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.lightGreen,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  Row(
                    spacing: 5,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 30, top: 10),
                        width: 30,
                        height: 30,
                        child: Shimmer.fromColors(
                          baseColor: Color(0xFFE0E0E0),
                          highlightColor: Colors.white,
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                                color: Colors.lightGreen,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width: 30,
                        height: 30,
                        child: Shimmer.fromColors(
                          baseColor: Color(0xFFE0E0E0),
                          highlightColor: Colors.white,
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                                color: Colors.lightGreen,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 30, right: 30, top: 30),
                    width: MediaQuery.of(context).size.width,
                    // height: 170,
                    child: Shimmer.fromColors(
                      baseColor: Color(0xFFE0E0E0),
                      highlightColor: Colors.white,
                      child: Container(
                        height: 300,
                        decoration: BoxDecoration(
                            color: Colors.lightGreen,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  // Column(
                  //   children: List.generate(
                  //     3,
                  //     (index) =>
                  //   ),
                  // ),
                ],
              ),
      )),
    );
  }
}

Widget text_richData(String details1, String details2) {
  return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: details1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: details2,
            style: TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.justify);
}

Widget setSpace(double height_required) {
  return SizedBox(
    height: height_required,
  );
}

void show_snackbar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2), // Duration the SnackBar is visible
    ),
  );
}

void getPlaceDetails(
    BuildContext context, WidgetRef ref, String payloadName) async {
  FireStore_services databaseProcess = FireStore_services(context);
  databaseProcess.getPlaceDetails(ref, payloadName);
}
