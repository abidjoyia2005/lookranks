import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shimmer/shimmer.dart';

import 'Bottom.dart';
import 'DetailsPost.dart';
import 'No_Internet.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Search_result extends StatefulWidget {
  String? btoken;
  String? search;

  Search_result({this.btoken, this.search});

  @override
  State<Search_result> createState() => _Search_resultState();
}

class _Search_resultState extends State<Search_result> {
  late String btoken;
  late String search;
  List data = [];
  var input;
  FocusNode searchFocusNode = FocusNode();
  TextEditingController Searchs = TextEditingController();

  @override
  void initState() {
    super.initState();
    btoken = widget.btoken!;
    search = widget.search!;
    Searchs.text = widget.search!;
    loadData(search);
  }

  Future<List<dynamic>> loadData(String searchText) async {
    try {
      final res = await http.get(
        Uri.parse("https://lookranks.com/and_api/search/?query=$searchText"),
        headers: <String, String>{
          'Authorization': 'Token $usertoken',
        },
      );

      if (res.statusCode == 200) {
        Debugs('search result.......\n ${res.body}');
        return jsonDecode(res.body) as List<dynamic>;
      } else {
        // Handle different HTTP status codes here
        Debugs("API Error: ${res.statusCode}");
        throw Exception("API Error: ${res.statusCode}");
      }
    } catch (e) {
      // Handle exceptions here, such as network errors.
      Debugs("Error in server request: $e");
      throw Exception("Error in server request: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.yellow[700]),
          toolbarHeight: 70,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10.0,
                      color: Colors.black12.withOpacity(0.1),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                ),
                width: 200,
                child: TextFormField(
                  validator: (input) {},
                  onSaved: (input) => input = input,
                  controller: Searchs,
                  decoration: InputDecoration(
                    hintText: "    Search",
                    hintStyle: TextStyle(
                      fontFamily: "Sofia",
                      color: Colors.black,
                    ),
                    enabledBorder: new UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 0.1,
                        style: BorderStyle.none,
                      ),
                    ),
                  ),
                  textInputAction: TextInputAction.search, // Set search action
                  onFieldSubmitted: (value) {
                    // Handle search action here
                    var sr = Searchs.text;
                    setState(() {
                      search = sr;
                    });
                  },
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  var sr = Searchs.text;
                  setState(() {
                    search = sr;
                  });
                },
                child: Text("Search"))
          ],
        ),
        body: FutureBuilder<List<dynamic>>(
          future: loadData(search),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ten_shimear(); // Loading indicator
            } else if (snapshot.hasError) {
              return Column(
                children: [
                  NoInternetScreen(),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        height: 52.0,
                        width: 260,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80.0),
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 214, 84, 84),
                              Color.fromARGB(255, 201, 59, 59),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Go Back",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Sofia",
                              letterSpacing: 0.9,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Column(
                children: [
                  Image.asset('assets/images/notfound.png'),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '   Sorry ,',
                          style: TextStyle(
                              fontFamily: 'Sofia',
                              fontWeight: FontWeight.w800,
                              fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      'No person named "$search" was found.',
                      style: TextStyle(
                          fontFamily: 'Sofia',
                          fontWeight: FontWeight.w600,
                          fontSize: 17),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        height: 52.0,
                        width: 260,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80.0),
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 214, 84, 84),
                              Color.fromARGB(255, 201, 59, 59),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Go Back",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Sofia",
                              letterSpacing: 0.9,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              List<dynamic> data = snapshot.data!;
              // Handle displaying the data here
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, i) {
                  return Homecard(
                    images: data[i]["pic_urls"],
                    name: data[i]['name'],
                    flag: data[i]['country_name'],
                    grade: data[i]['Grade'],
                    grade_per: data[i]['Grade_per'],
                    five_star: data[i]['star_rating'],
                    rating: data[i]['total_rating'],
                    rating_per: data[i]['rating_per'],
                    views: data[i]['viewcounts'],
                    views_per: data[i]['view_per'],
                    profile_pic: data[i]['userpic'],
                  );
                },
              );
            }
          },
        ));
  }
}

class Homecard extends StatefulWidget {
  List<dynamic> images;
  var flag;
  var grade;
  var grade_per;
  var rating;
  var rating_per;
  var five_star;
  var views;
  var views_per;
  var profile_pic;

  String name;
  @override
  Homecard(
      {required this.name,
      required this.rating,
      required this.rating_per,
      required this.views,
      required this.views_per,
      required this.five_star,
      required this.images,
      required this.grade,
      required this.grade_per,
      this.profile_pic,
      this.flag});

  @override
  State<Homecard> createState() => _HomecardState(
      profile_pic: profile_pic,
      five_star: five_star,
      rating: rating,
      rating_per: rating_per,
      views: views,
      views_per: views_per,
      name: name,
      images: images,
      flag: flag,
      grade: grade,
      grade_per: grade_per);
}

class _HomecardState extends State<Homecard> {
  @override
  List<dynamic> images;
  var grade;
  var grade_per;
  String name;
  var flag;
  var rating;
  var rating_per;
  var five_star;
  var views;
  var views_per;
  var profile_pic;
  double _userRating = 0.0;
  TextEditingController Rating_Anser = TextEditingController();

  _HomecardState({
    this.profile_pic,
    required this.name,
    required this.grade,
    required this.grade_per,
    required this.images,
    this.flag,
    required this.rating,
    required this.rating_per,
    required this.views,
    required this.views_per,
    required this.five_star,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.13),
            blurRadius: 7.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Card(
        color: Colors.white,
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          children: [
            InkWell(
              onLongPress: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Detail_Screen(Longpressusername: name),
                    ));
              },
              onDoubleTap: () {
                // showModalBottomSheet(
                //   context: context,
                //   isScrollControlled: true, // Set this to true
                //   builder: (BuildContext context) {
                //     return SingleChildScrollView(
                //       // Wrap the content with SingleChildScrollView
                //       child: Column(
                //         children: [
                //           Container(
                //               width: double.infinity,
                //               height: MediaQuery.of(context).size.height /
                //                   1.15, // Use the screen height
                //               child: Stack(
                //                 children: [
                //                   if (images.length > 1)
                //                     CarouselSlider(
                //                       options: CarouselOptions(
                //                         autoPlay: true,
                //                         enlargeCenterPage: true,
                //                         aspectRatio: 13 / 14,
                //                       ),
                //                       items: images.map((imageUrl) {
                //                         return Stack(children: [
                //                           Container(
                //                               width: double.infinity,
                //                               child: Image.network(imageUrl,
                //                                   fit: BoxFit.cover)),
                //                           Positioned(
                //                               bottom: 70,
                //                               left: 10,
                //                               child: Column(
                //                                 children: [
                //                                   Row(
                //                                     children: [
                //                                       Container(
                //                                           width: 16,
                //                                           height: 16,
                //                                           child: Image(
                //                                             image: AssetImage(
                //                                                 "assets/images/logo.png"),
                //                                           )),
                //                                       Stack(children: [
                //                                         Container(
                //                                           width: 70,
                //                                           height: 15,
                //                                           color: Colors.white54,
                //                                         ),
                //                                         Text("LookRanks",
                //                                             style: TextStyle(
                //                                                 fontSize: 12,
                //                                                 fontFamily:
                //                                                     "Sofia",
                //                                                 fontWeight:
                //                                                     FontWeight
                //                                                         .w800)),
                //                                       ]),
                //                                     ],
                //                                   ),
                //                                   Stack(
                //                                     children: [
                //                                       Container(
                //                                         child: Text(
                //                                           name,
                //                                           style: TextStyle(
                //                                               fontSize: 10),
                //                                         ),
                //                                         decoration:
                //                                             BoxDecoration(
                //                                           color: Colors.white54,
                //                                         ),
                //                                       ),
                //                                     ],
                //                                   )
                //                                 ],
                //                               )),
                //                           Positioned(
                //                             bottom: 18,
                //                             left: 50,
                //                             child:
                //                                 CircularProgressWithPercentage(
                //                               color: Colors.red,
                //                               progressicon:
                //                                   Icons.local_activity_rounded,

                //                               percentage:
                //                                   grade_per, // Change this to the desired percentage
                //                             ),
                //                           ),
                //                           Positioned(
                //                             bottom: 18,
                //                             left: 120,
                //                             child:
                //                                 CircularProgressWithPercentage(
                //                               color: Colors.blue,
                //                               progressicon:
                //                                   Icons.bar_chart_rounded,

                //                               percentage:
                //                                   rating_per, // Change this to the desired percentage
                //                             ),
                //                           ),
                //                           Positioned(
                //                             bottom: 18,
                //                             left: 190,
                //                             child:
                //                                 CircularProgressWithPercentage(
                //                               color: Colors.green,
                //                               progressicon: Icons.radar_sharp,

                //                               percentage:
                //                                   views_per, // Change this to the desired percentage
                //                             ),
                //                           ),
                //                         ]);
                //                       }).toList(),
                //                     ),
                //                   if (images.length == 1)
                //                     Stack(
                //                       children: [
                //                         Container(
                //                           height: MediaQuery.of(context)
                //                                   .size
                //                                   .height /
                //                               1.7,
                //                           width: double.infinity,
                //                           child: Image.network(
                //                             images.first,
                //                             fit: BoxFit.fitHeight,
                //                           ),
                //                         ),
                //                         Positioned(
                //                             bottom: 60,
                //                             left: 10,
                //                             child: Column(
                //                               children: [
                //                                 Row(
                //                                   children: [
                //                                     Container(
                //                                         width: 16,
                //                                         height: 16,
                //                                         child: Image(
                //                                           image: AssetImage(
                //                                               "assets/images/logo.png"),
                //                                         )),
                //                                     Stack(
                //                                       children: [
                //                                         Container(
                //                                           width: 70,
                //                                           height: 15,
                //                                           color: Colors.white54,
                //                                         ),
                //                                         Text("LookRanks",
                //                                             style: TextStyle(
                //                                                 fontSize: 12,
                //                                                 fontFamily:
                //                                                     "Sofia",
                //                                                 fontWeight:
                //                                                     FontWeight
                //                                                         .w800)),
                //                                       ],
                //                                     ),
                //                                   ],
                //                                 ),
                //                                 Stack(
                //                                   children: [
                //                                     Container(
                //                                         width: 50,
                //                                         height: 14,
                //                                         color: Colors.white54),
                //                                     Text(
                //                                       name,
                //                                       style: TextStyle(
                //                                           fontSize: 10),
                //                                     ),
                //                                   ],
                //                                 )
                //                               ],
                //                             )),
                //                         Positioned(
                //                           bottom: 10,
                //                           left: 50,
                //                           child: CircularProgressWithPercentage(
                //                             color: Colors.red,
                //                             progressicon:
                //                                 Icons.local_activity_rounded,

                //                             percentage:
                //                                 grade_per, // Change this to the desired percentage
                //                           ),
                //                         ),
                //                         Positioned(
                //                           bottom: 10,
                //                           left: 120,
                //                           child: CircularProgressWithPercentage(
                //                             color: Colors.blue,
                //                             progressicon:
                //                                 Icons.bar_chart_rounded,

                //                             percentage:
                //                                 rating_per, // Change this to the desired percentage
                //                           ),
                //                         ),
                //                         Positioned(
                //                           bottom: 10,
                //                           left: 190,
                //                           child: CircularProgressWithPercentage(
                //                             color: Colors.green,
                //                             progressicon: Icons.radar_sharp,

                //                             percentage:
                //                                 views_per, // Change this to the desired percentage
                //                           ),
                //                         ),
                //                       ],
                //                     ),
                //                   Positioned(
                //                     bottom:
                //                         MediaQuery.of(context).size.height / 20,
                //                     left:
                //                         MediaQuery.of(context).size.width / 17,
                //                     child: Container(
                //                       child: Column(children: [
                //                         Stack(children: [
                //                           Container(
                //                             height: 60,
                //                             width: 330,
                //                             decoration: BoxDecoration(
                //                                 color: Colors.white54,
                //                                 borderRadius: BorderRadius.all(
                //                                     Radius.circular(30))),
                //                           ),
                //                           RatingBar.builder(
                //                             itemSize: 60,
                //                             initialRating: 0.0,
                //                             minRating: 1,
                //                             direction: Axis.horizontal,
                //                             allowHalfRating: true,
                //                             itemCount: 5,
                //                             itemPadding: EdgeInsets.symmetric(
                //                                 horizontal: 3.0),
                //                             itemBuilder: (context, _) => Icon(
                //                               Icons.star_rounded,
                //                               color: Colors.amber,
                //                             ),
                //                             onRatingUpdate: (rating) {
                //                               setState(() {
                //                                 _userRating = rating;
                //                               });
                //                             },
                //                           ),
                //                         ]),
                //                         Text(
                //                           "Give Rating to this person?",
                //                           style: TextStyle(fontFamily: "Lemon"),
                //                         ),
                //                         Container(
                //                           width: MediaQuery.of(context)
                //                                   .size
                //                                   .width /
                //                               1.15,
                //                           height: 50,
                //                           decoration: BoxDecoration(
                //                               boxShadow: [
                //                                 BoxShadow(
                //                                     blurRadius: 10.0,
                //                                     color: Colors.black12
                //                                         .withOpacity(0.1)),
                //                               ],
                //                               color: Colors.white,
                //                               borderRadius: BorderRadius.all(
                //                                   Radius.circular(40.0))),
                //                           child: Center(
                //                             child: Padding(
                //                               padding: const EdgeInsets.only(
                //                                   left: 15.0, right: 15.0),
                //                               child: Theme(
                //                                 data: ThemeData(
                //                                   highlightColor: Colors.white,
                //                                   hintColor: Colors.white,
                //                                 ),
                //                                 child: TextFormField(
                //                                     validator: (input) {},
                //                                     onSaved: (input) =>
                //                                         input = input,
                //                                     controller: Rating_Anser,
                //                                     decoration: InputDecoration(
                //                                       hintText:
                //                                           "Anser the Question Or give  suggesstion",
                //                                       hintStyle: TextStyle(
                //                                           fontFamily: "Sofia",
                //                                           color: Colors.black),
                //                                       enabledBorder:
                //                                           new UnderlineInputBorder(
                //                                         borderSide: BorderSide(
                //                                             color: Colors.white,
                //                                             width: 1.0,
                //                                             style: BorderStyle
                //                                                 .none),
                //                                       ),
                //                                     )),
                //                               ),
                //                             ),
                //                           ),
                //                         ),
                //                         SizedBox(
                //                           height: 10,
                //                         ),
                //                         Row(
                //                           children: [
                //                             ElevatedButton(
                //                               onPressed: () {},
                //                               style: ButtonStyle(
                //                                 padding: MaterialStateProperty
                //                                     .all<EdgeInsetsGeometry>(
                //                                   EdgeInsets.all(0),
                //                                 ),
                //                                 backgroundColor:
                //                                     MaterialStateProperty.all<
                //                                             Color>(
                //                                         Colors.transparent),
                //                               ),
                //                               child: Container(
                //                                 width: 100,
                //                                 decoration: BoxDecoration(
                //                                   gradient: LinearGradient(
                //                                     colors: [
                //                                       Colors.orange,
                //                                       Colors.yellow
                //                                     ],
                //                                     begin: Alignment.centerLeft,
                //                                     end: Alignment.centerRight,
                //                                   ),
                //                                   borderRadius:
                //                                       BorderRadius.circular(
                //                                           20.0),
                //                                 ),
                //                                 padding: EdgeInsets.all(10.0),
                //                                 child: Center(
                //                                   child: Text(
                //                                     "Cancel",
                //                                     style: TextStyle(
                //                                         color: Colors.white,
                //                                         fontSize: 14,
                //                                         fontFamily: "Poppins"),
                //                                   ),
                //                                 ),
                //                               ),
                //                             ),
                //                             SizedBox(
                //                               width: MediaQuery.of(context)
                //                                       .size
                //                                       .width /
                //                                   4,
                //                             ),
                //                             ElevatedButton(
                //                               onPressed: () {},
                //                               style: ButtonStyle(
                //                                 padding: MaterialStateProperty
                //                                     .all<EdgeInsetsGeometry>(
                //                                   EdgeInsets.all(0),
                //                                 ),
                //                                 backgroundColor:
                //                                     MaterialStateProperty.all<
                //                                             Color>(
                //                                         Colors.transparent),
                //                               ),
                //                               child: Container(
                //                                 width: 100,
                //                                 decoration: BoxDecoration(
                //                                   gradient: LinearGradient(
                //                                     colors: [
                //                                       Colors.blue,
                //                                       Colors.lightBlueAccent
                //                                     ],
                //                                     begin: Alignment.centerLeft,
                //                                     end: Alignment.centerRight,
                //                                   ),
                //                                   borderRadius:
                //                                       BorderRadius.circular(
                //                                           20.0),
                //                                 ),
                //                                 padding: EdgeInsets.all(10.0),
                //                                 child: Center(
                //                                   child: Text(
                //                                     "  Post  ",
                //                                     style: TextStyle(
                //                                         color: Colors.white,
                //                                         fontSize: 14,
                //                                         fontFamily: "Poppins"),
                //                                   ),
                //                                 ),
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                       ]),
                //                     ),
                //                   ),
                //                 ],
                //               )),
                //         ],
                //       ),
                //     );
                //   },
                // );
              },
              onTap: () async {},
              child: Hero(
                tag: grade,
                child: Container(
                  width: double.infinity,
                  height: 325,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SlidingImageWidget(
                        imageUrls: images,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 0, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: CachedNetworkImageProvider(profile_pic),
                      ),
                      SizedBox(width: 10),
                      Text(
                        name.length >= 13 ? name.substring(0, 12) : name,
                        style: TextStyle(
                          fontFamily: "Sofia",
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(width: 8),
                      if (flag != null)
                        Container(
                          height: 20,
                          width: 40,
                          child: Image.asset(
                              "assets/images/flags/${flag.toLowerCase()}.png"),
                        ),
                      Spacer(),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 65,
                            color: Colors.yellow[600],
                          ),
                          Text(
                            "$five_star",
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: [
                          Text(
                            "Rank :$grade",
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: "Poppins",
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w800),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: CircularProgressWithPercentage(
                              progressicon: Icons.local_activity_rounded,
                              color: Colors.redAccent,
                              percentage:
                                  grade_per, // Change this to the desired percentage
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Rating:${rating.toInt().toString()}",
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: "Poppins",
                                color: Colors.blue[400],
                                fontWeight: FontWeight.w800),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: CircularProgressWithPercentage(
                              progressicon: Icons.bar_chart_rounded,
                              color: Colors.blue[400],
                              percentage:
                                  rating_per, // Change this to the desired percentage
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Views:$views",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: "Poppins",
                              color: Colors.green[400],
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: CircularProgressWithPercentage(
                              progressicon: Icons.radar_sharp,
                              color: Colors.green[400],
                              percentage:
                                  views_per, // Change this to the desired percentage
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Detail_Screen(Longpressusername: name),
                            ));
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.all(0),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                      ),
                      child: Container(
                        width: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue, Colors.lightBlueAccent],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: EdgeInsets.all(10.0),
                        child: Center(
                          child: Text(
                            "See Post",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: "Poppins"),
                          ),
                        ),
                      ),
                    ),
                  ])
                  // Row(
                  //   children: [
                  //     SizedBox(
                  //       width: 30,
                  //     ),
                  //     ElevatedButton(
                  //       onPressed: () {},
                  //       style: ButtonStyle(
                  //         padding:
                  //             MaterialStateProperty.all<EdgeInsetsGeometry>(
                  //           EdgeInsets.all(0),
                  //         ),
                  //         backgroundColor: MaterialStateProperty.all<Color>(
                  //             Colors.transparent),
                  //       ),
                  //       child: Container(
                  //         width: 100,
                  //         decoration: BoxDecoration(
                  //           gradient: LinearGradient(
                  //             colors: [Colors.orange, Colors.yellow],
                  //             begin: Alignment.centerLeft,
                  //             end: Alignment.centerRight,
                  //           ),
                  //           borderRadius: BorderRadius.circular(20.0),
                  //         ),
                  //         padding: EdgeInsets.all(10.0),
                  //         child: Center(
                  //           child: Text(
                  //             "Survey",
                  //             style: TextStyle(
                  //                 color: Colors.white,
                  //                 fontSize: 14,
                  //                 fontFamily: "Poppins"),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     Spacer(),
                  //     ElevatedButton(
                  //       onPressed: () {},
                  //       style: ButtonStyle(
                  //         padding:
                  //             MaterialStateProperty.all<EdgeInsetsGeometry>(
                  //           EdgeInsets.all(0),
                  //         ),
                  //         backgroundColor: MaterialStateProperty.all<Color>(
                  //             Colors.transparent),
                  //       ),
                  //       child: Container(
                  //         width: 100,
                  //         decoration: BoxDecoration(
                  //           gradient: LinearGradient(
                  //             colors: [Colors.blue, Colors.lightBlueAccent],
                  //             begin: Alignment.centerLeft,
                  //             end: Alignment.centerRight,
                  //           ),
                  //           borderRadius: BorderRadius.circular(20.0),
                  //         ),
                  //         padding: EdgeInsets.all(10.0),
                  //         child: Center(
                  //           child: Text(
                  //             "Rate Now",
                  //             style: TextStyle(
                  //                 color: Colors.white,
                  //                 fontSize: 14,
                  //                 fontFamily: "Poppins"),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       width: 30,
                  //     )
                  //   ],
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircularProgressWithPercentage extends StatelessWidget {
  final int percentage;
  var color;
  var progressicon;

  CircularProgressWithPercentage(
      {required this.percentage,
      required this.color,
      required this.progressicon});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white60,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
            Container(
              width: 45,
              height: 45,
              child: CircularProgressIndicator(
                value: percentage / 100,
                strokeWidth: 4.8,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            Icon(
              progressicon,
              size: 37,
              color: Colors.grey[300],
            ),
            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SlidingImageWidget extends StatefulWidget {
  final List<dynamic> imageUrls;

  SlidingImageWidget({required this.imageUrls});

  @override
  _SlidingImageWidgetState createState() => _SlidingImageWidgetState();
}

class _SlidingImageWidgetState extends State<SlidingImageWidget> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        PageView.builder(
      controller: _pageController,
      itemCount: widget.imageUrls.length,
      itemBuilder: (context, index) {
        return CachedNetworkImage(
          imageUrl: widget.imageUrls[index],
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, url, downloadProgress) {
            return Container(
              color: Colors.white,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 100.0,
                    width: 100.0,
                    child: CircularProgressIndicator(
                      color: Colors.pink,
                      strokeWidth: 10,
                      value: downloadProgress.progress,
                    ),
                  ),
                  GifCircularProgressBar( progress: 0.0),
                ],
              ),
            );
          },
          errorWidget: (context, url, error) => GifCircularProgressBar( progress: 0),
        );}),
        if (widget.imageUrls.length > 1)
          Positioned(
            bottom: 20.0,
            child: Row(
              children: widget.imageUrls.map((url) {
                int currentIndex = widget.imageUrls.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == currentIndex
                        ? Colors.blue
                        : Colors.grey,
                  ),
                );
              }).toList(),
            ),
          ),
        Positioned(
          top: 20.0,
          right: 17.0,
          child: Container(
            height: 25,
            width: 33,
            decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.all(Radius.circular(18))),
          ),
        ),
        Positioned(
          top: 20.0,
          right: 20.0,
          child: Text(
            "${_currentPage + 1}/${widget.imageUrls.length}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class GifCircularProgressBar extends StatelessWidget {
  final double progress;

  GifCircularProgressBar({
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(color: Colors.white70),
            child: Image(
                image:
                    AssetImage('assets/images/logo4.gif')), // Load the GIF logo
          ),
        ],
      ),
    );
  }
}

class ten_shimear extends StatefulWidget {
  const ten_shimear({super.key});

  @override
  State<ten_shimear> createState() => _ten_shimearState();
}

class _ten_shimearState extends State<ten_shimear> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ShimmerHomecard(),
          SizedBox(
            height: 7,
          ),
          ShimmerHomecard(),
          SizedBox(
            height: 7,
          ),
          ShimmerHomecard(),
          SizedBox(
            height: 7,
          ),
          ShimmerHomecard(),
          SizedBox(
            height: 7,
          ),
          ShimmerHomecard(),
          SizedBox(
            height: 7,
          ),
          ShimmerHomecard(),
          SizedBox(
            height: 7,
          ),
          ShimmerHomecard(),
          SizedBox(
            height: 7,
          ),
          ShimmerHomecard(),
          SizedBox(
            height: 7,
          ),
          ShimmerHomecard(),
          SizedBox(
            height: 7,
          ),
          ShimmerHomecard(),
          SizedBox(
            height: 7,
          ),
          ShimmerHomecard(),
          SizedBox(
            height: 7,
          ),
          ShimmerHomecard(),
          SizedBox(
            height: 7,
          ),
          ShimmerHomecard(),
          SizedBox(
            height: 7,
          ),
          ShimmerHomecard(),
          SizedBox(
            height: 7,
          ),
          ShimmerHomecard(),
          SizedBox(
            height: 7,
          ),
        ],
      ),
    );
  }
}

class ShimmerHomecard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.13),
            blurRadius: 7.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Card(
        color: Colors.white,
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 300,
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 0, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey[300],
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 110,
                        height: 20,
                        color: Colors.grey[300],
                      ),
                      SizedBox(width: 8),
                      Container(
                        height: 20,
                        width: 40,
                        color: Colors.grey[300],
                      ),
                      Spacer(),
                      Icon(
                        Icons.star_rounded,
                        color: Colors.grey[300],
                        size: 60,
                      )
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: [
                          Container(
                            width: 70,
                            height: 10,
                            color: Colors.grey[300],
                          ),
                          SizedBox(
                            height: 17,
                          ),
                          Icon(
                            Icons.circle_outlined,
                            size: 60,
                            color: Colors.grey[300],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            width: 70,
                            height: 10,
                            color: Colors.grey[300],
                          ),
                          SizedBox(
                            height: 17,
                          ),
                          Icon(
                            Icons.circle_outlined,
                            size: 60,
                            color: Colors.grey[300],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            width: 70,
                            height: 10,
                            color: Colors.grey[300],
                          ),
                          SizedBox(
                            height: 17,
                          ),
                          Icon(
                            Icons.circle_outlined,
                            size: 60,
                            color: Colors.grey[300],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  // Row(
                  //   children: [
                  //     SizedBox(
                  //       width: 30,
                  //     ),
                  //     Container(
                  //       width: 100,
                  //       height: 40,
                  //       decoration: BoxDecoration(
                  //           color: Colors.grey[300],
                  //           borderRadius:
                  //               BorderRadius.all(Radius.circular(30))),
                  //     ),
                  //     Spacer(),
                  //     Container(
                  //       width: 100,
                  //       height: 40,
                  //       decoration: BoxDecoration(
                  //           color: Colors.grey[300],
                  //           borderRadius:
                  //               BorderRadius.all(Radius.circular(30))),
                  //     ),
                  //     SizedBox(
                  //       width: 30,
                  //     )
                  //   ],
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
