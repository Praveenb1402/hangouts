import 'package:flutter/material.dart';
import 'package:hangouts/DesprictionUi/Despriction_MainPage_UI.dart';
import 'package:hangouts/User_data_singleton.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hangouts/Riverpod/User_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Services/Database_services.dart';

class MainPageUi extends StatefulWidget {
  const MainPageUi({super.key});

  @override
  State<MainPageUi> createState() => _MainPageUiState();
}

class _MainPageUiState extends State<MainPageUi> {
  @override
  Widget build(BuildContext context) {
    return _MainPageStatlessUi();
  }
}

class _MainPageStatlessUi extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the _userNameProvider to get the username state
    final username = ref.watch(userNameProvider);
    final trending_places = ref.watch(itemsProvider);
    final location = ref.watch(userdatamodelProvider).address.city;
    final UserService userService = UserService();
    final group_size_pics = [
      'Images/group_bg_mainpage.png',
      'Images/couple_bg_mainpage.png',
      'Images/family_bg_mainpage.png',
      'Images/solo_bg_mainpage.png'
    ];
    final _browseGroupText = ["Group", "Couple", "Family", 'solo'];

    final _boxgrendientColors = [
      [
        Colors.blue.withOpacity(0.6),
        Colors.green.withOpacity(0.6),
      ],
      [
        Colors.red.withOpacity(0.7),
        Colors.yellow.withOpacity(0.7),
      ],
      [
        Colors.purple.withOpacity(0.8),
        Colors.pink.withOpacity(0.8),
      ],
      [
        Colors.orange.withOpacity(0.6),
        Colors.cyan.withOpacity(0.6),
      ],
      [
        Colors.teal.withOpacity(0.5),
        Colors.brown.withOpacity(0.5),
      ],
      [
        Colors.indigo.withOpacity(0.7),
        Colors.lime.withOpacity(0.7),
      ]
    ];

    final _showiconslist = [
      Icons.emoji_emotions_outlined,
      Icons.add_a_photo_outlined,
      Icons.celebration_outlined,
      Icons.emoji_events_outlined,
      Icons.add_circle_outline
    ];
    final _shownames = [
      "Comedy Show",
      "Photo Contest",
      "Night Show",
      "Participants Contest",
      "More Events"
    ];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Function to be called after build
      if (username.isEmpty && userService.getUsername() != username) {
        getCurrentUserData(context, ref);
      }
      getTrendingPlacesData(context, ref);
    });
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Here you can add more widgets, like an app bar, etc.
                username.isNotEmpty
                    ? Container(
                        padding: EdgeInsets.only(
                            bottom: 10, left: 10.0, right: 10.0),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Hello $username,",
                                  style: TextStyle(
                                    fontFamily: 'DancingScript',
                                    fontSize: 25,
                                  ),
                                ),
                                Icon(Icons.supervised_user_circle,
                                    size: 40, color: Colors.grey)
                              ],
                            ),
                            Text(
                              "Discover your next favorite meal",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            location.isEmpty
                                ? Container(
                                    child: Text("select location"),
                                  )
                                : Container()
                          ],
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 5,
                              children: [
                                // Shimmer effect for the username loading
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 3,
                                  height: 20,
                                  child: Shimmer.fromColors(
                                    baseColor: Color(0xFFE0E0E0),
                                    highlightColor: Colors.white,
                                    child: Container(
                                      height: 100,
                                      color: Colors
                                          .lightGreen, // Placeholder color
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  height: 20,
                                  child: Shimmer.fromColors(
                                    baseColor: Color(0xFFE0E0E0),
                                    highlightColor: Colors.white,
                                    child: Container(
                                      height: 100,
                                      color: Colors
                                          .lightGreen, // Placeholder color
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.white,
                                direction: ShimmerDirection.ltr,
                                period: Duration(milliseconds: 1500),
                                child: Icon(Icons.supervised_user_circle,
                                    size: 40, color: Color(0xFF38FF53))),
                          ],
                        ),
                      ),
                SizedBox(
                  height: 30,
                ),

                // 2nd layout
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    location.isNotEmpty
                        ? "Trending Restaurants in $location"
                        : "Trending Restaurants",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                trending_places.isNotEmpty
                    ? Container(
                        margin: EdgeInsets.only(top: 5),
                        width: MediaQuery.sizeOf(context).width - 10,
                        height: 240,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              trending_places.length, // The number of items
                          itemBuilder: (context, index) {
                            // Builds each list item lazily
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return DesprictionMainpageUi(
                                      payload_name: trending_places[index]
                                          ['payload_name']);
                                }));
                              },
                              child: Card(
                                color: Colors.transparent,
                                elevation: 0,
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // image container
                                      Stack(
                                        children: [
                                          Container(
                                            width: 200,
                                            height: 150,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              // Light grey placeholder color
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                            ),
                                            child: Shimmer.fromColors(
                                              baseColor: Colors.grey[300]!,
                                              // Base shimmer color
                                              highlightColor: Colors.white,
                                              // Highlight shimmer color
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  // Light grey placeholder color
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20)),
                                                ),
                                                width: double.infinity,
                                                height: double.infinity,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(bottom: 10),
                                            width: 200,
                                            height: 150,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      trending_places[index]
                                                          ['image_url']),
                                                  fit: BoxFit.cover,
                                                  // This ensures the image fills the container while preserving the aspect ratio
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                          )
                                        ],
                                      ),

                                      // place name and rating container
                                      Container(
                                        width: 200,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              trending_places[index]
                                                  ['place_name'],
                                              textAlign: TextAlign.center,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(Icons.star_rounded,
                                                        color: Colors.red),
                                                    Text(trending_places[index]
                                                                ['rating']
                                                            ?.toString() ??
                                                        "No rating")
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 50,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(trending_places[index]
                                                                    ['reviews']
                                                                .toString() ==
                                                            'null'
                                                        ? '0'
                                                        : trending_places[index]
                                                                ['reviews']
                                                            .toString()),
                                                    Text(" reviews"),
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Container(
                        color: Colors.transparent,
                        margin: EdgeInsets.only(top: 5),
                        width: MediaQuery.sizeOf(context).width - 10,
                        height: 240,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3, // The number of items
                          itemBuilder: (context, index) {
                            // Builds each list item lazily
                            return Card(
                              color: Colors.transparent,
                              elevation: 0,
                              child: Container(
                                margin: EdgeInsets.all(5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // image container
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      width: 200,
                                      height: 150,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                    ),

                                    // place name and rating container
                                    Container(
                                      width: 200,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "",
                                            textAlign: TextAlign.center,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Icon(Icons.star,
                                                      color: Colors.yellow),
                                                  Text("9.4")
                                                ],
                                              ),
                                              SizedBox(
                                                width: 50,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(""),
                                                  Text(""),
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Upcoming Events near you",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  // color: Colors.white,
                  margin: EdgeInsets.only(top: 5, left: 8, right: 10),
                  width: MediaQuery.sizeOf(context).width - 10,
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5, // The number of items
                    itemBuilder: (context, index) {
                      // Builds each list item lazily
                      return Card(
                        color: Colors.grey,
                        shadowColor: Colors.white,
                        elevation: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              height: 150,
                              // decoration: BoxDecoration(
                              //     image: DecorationImage(
                              //       image: NetworkImage(
                              //         "https://media.cntraveler.com/photos/56689b81c3c9e01555a4ddbf/master/pass/positano-amalfi-coast-italy-cr-alamy.jpg",
                              //       ),
                              //       fit: BoxFit
                              //           .cover, // This ensures the image fills the container while preserving the aspect ratio
                              //     ),
                              //     borderRadius: BorderRadius.all(
                              //         Radius.circular(20))),
                              child: Icon(
                                _showiconslist[index],
                                size: 50,
                              ),
                            ),
                            Container(
                              width: 100,
                              height: 50,
                              margin: EdgeInsets.only(top: 3),
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))),
                              child: Center(
                                child: Text(_shownames[index],
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    // Limits text to 2 lines
                                    overflow: TextOverflow.ellipsis),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("Browse by Group Size",style: TextStyle(fontSize: 18,
                      fontWeight: FontWeight.bold),),
                ),
                Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(bottom: 20, left: 10),
                    width: MediaQuery.sizeOf(context).width,

                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(
                          4,
                          (index) => Container(
                                padding: EdgeInsets.all(5),
                                width: MediaQuery.sizeOf(context).width-215,
                                height: 100,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: _boxgrendientColors[index],
                                      // Purple with opacity 0.6],  // Gradient colors
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    image: DecorationImage(
                                      alignment: Alignment.centerRight,
                                      fit: BoxFit.fitHeight,
                                      image: AssetImage(group_size_pics[index]),
                                    ),
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(_browseGroupText[index],style: TextStyle(fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                                ),
                              )
                          // Container(
                          //   margin: EdgeInsets.only(left: 10),
                          //   child: Column(
                          //       spacing: 10,
                          //       children: List.generate(
                          //           2,
                          //               (index) =>
                          //               )),
                          // )
                          ),
                    )

                    // ListView.builder(
                    // scrollDirection: Axis.horizontal,
                    // itemCount: 3,
                    // itemBuilder: (index, context) {
                    //
                    // }),
                    ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("Browse by taste",style: TextStyle(fontSize: 18,
                      fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(bottom: 20),
                  width: MediaQuery.sizeOf(context).width,
                  height: 220,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (index, context) {
                        return Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Column(
                              spacing: 10,
                              children: List.generate(
                                  2,
                                  (index) => Container(
                                        width: 150,
                                        height: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                      ))),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void getCurrentUserData(BuildContext context, WidgetRef ref) async {
  FireStore_services databaseProcess = FireStore_services(context);
  databaseProcess.getUsersData(
      FirebaseAuth.instance.currentUser?.uid.toString(), ref);
}

void getTrendingPlacesData(BuildContext context, WidgetRef ref) async {
  FireStore_services databaseProcess = FireStore_services(context);
  databaseProcess.getTrendingPlaceData(ref);
}
