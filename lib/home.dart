import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/ChatSystem/Chating_Screen.dart';
import 'package:flutter_application_1/filter_screen.dart';
import 'package:flutter_application_1/search_screen.dart';
import 'package:flutter_application_1/star_Rating.dart';
import 'package:flutter_application_1/survey_screen.dart';
import 'package:http/http.dart' as https;
import 'dart:convert';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'Bottom.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'dart:async';
import 'ChatSystem/ChatScreen.dart';
import 'DetailsPost.dart';
import 'No_Internet.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import 'guider/notification_sender.dart';
import 'inbox.dart';
import 'main.dart';

class HOme extends StatefulWidget {
  var btoken;
  var bid;
  HOme({
    required this.bid,
    required this.btoken,
  });

  @override
  State<HOme> createState() => _HOmeState(bid: bid, btoken: btoken);
}

class _HOmeState extends State<HOme> {
  int bid;
  String btoken;

  _HOmeState({
    required this.btoken,
    required this.bid,
  });
  ScrollController _scrollController = ScrollController();
  List<dynamic> data = [];
  bool isLoading = false;
  int currentPage = 1; // Track the current page/offset.
  int pageSize = 20; // Number of items to load per page.

  int? userid;
  var result;
  var counts;
  bool dataLoaded = false;
  bool _scrollListenerfirst = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    loadData(currentPage);
    _initializeData();
    //Debugs(bid);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  void _initializeData() async {
    try {
      usertoken = await getToken();
      getid();

      // Debugs("usertoken:$usertoken");
      setState(() {});
    } catch (e) {
      // Handle exceptions here, such as if token or id is not found
      // Debugs("Error: $e");
    }
  }

  Future<void> RateNow(String name) async {
    final res = await https.post(
      Uri.parse("https://lookranks.com/and_api/profile/$name"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Token $usertoken',
      },
      body: jsonEncode(
        {
          // 'country': _selectedCountry,
        },
      ),
    );

    if (res.statusCode == 200) {
      Debugs("delete");
      // Debugs(res.body);
    } else {
      // Debugs('Failed to load data. Status code: ${res.statusCode}');
    }
  }

  Future<void> loadData(int page) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
        _initializeData();
      });

      try {
        final res = await https.get(
          Uri.parse("https://lookranks.com/and_api/?page=$page"),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Token $usertoken', // Add the token to the headers
          },
        );
        if (res.statusCode == 200) {
          var apiData = jsonDecode(res.body);
          print("home data :$apiData");
          counts = apiData["count"];

          setState(() {
            _scrollListenerfirst = true;
            dataLoaded = true;
            data.addAll(apiData["results"] as List<dynamic>);
            result = List<Map<String, dynamic>>.from(data);
            // Debugs(result);
            isLoading = false;
          });
          //Debugs(result);
        } else if (res.statusCode == 404) {
          // Handle a 404 error (Not Found) here, e.g., show a not found message to the user.
          Debugs("API Error 404: Resource not found");
        } else if (res.statusCode == 401) {
          // Handle a 401 error (Unauthorized) here, e.g., show a login screen or access denied message.
          Debugs("API Error 401: Unauthorized");
        } else if (res.statusCode == 500) {
          // Handle a 500 error (Internal Server Error) here, e.g., show a generic error message to the user.
          Debugs("API Error 500: Internal Server Error");
        } else {
          // Handle other API errors here, e.g., show a generic error message to the user.
          //Debugs("API Error: ${res.statusCode}");
        }
      } catch (e) {
        // Handle exceptions here, such as network errors.
        //Debugs("Error in server request: $e");
      }
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (_scrollListenerfirst) {
        setState(() {
          _scrollListenerfirst = false;
          currentPage++;
        });
        loadData(currentPage);
      }
      // User has scrolled to the bottom, load more data here.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      // backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _scrollController, // Use the ScrollController.
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            centerTitle: false,
            elevation: 0.0,
            title: Row(
              children: [
                // Add your logo here
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: CircleAvatar(
                    radius: 17,
                    backgroundImage: AssetImage('assets/images/logo.png'),
                  ),
                ),
                SizedBox(width: 6),
                GradientText(
                  "LookRanks",
                  style: TextStyle(
                    fontFamily: "Lemon",
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                  colors: [
                    Colors.blueAccent,
                    Colors.pinkAccent,
                    //  Colors.blueGrey,
                    //  Colors.green
                  ],
                ),
              ],
            ),
            floating: true,
            snap: true,
            actions: [
              IconButton(
                icon: Icon(Icons.message_outlined, size: 30),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Inbox_Screen(),
                      ));
                },
              ),
              Hero(
                tag: "filter",
                child: IconButton(
                  icon: Icon(Icons.filter_tilt_shift_sharp, size: 30),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Filter_screen(btoken: usertoken),
                        ));
                  },
                ),
              ),
              Hero(
                tag: "search",
                child: IconButton(
                  icon: Icon(Icons.search, size: 30),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => search_screen(btoken: btoken),
                        ));
                  },
                ),
              ),
            ],
          ),
          dataLoaded
              ? SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      if (index < result.length) {
                        return Homecard(
                          images: result[index]['pic_urls'],
                          name: result[index]['name'],
                          flag: result[index]['country'],
                          grade: result[index]['Grade'],
                          grade_per: result[index]['Grade_per'],
                          five_star: result[index]['star_rating'],
                          rating: result[index]['total_rating'],
                          rating_per: result[index]['rating_per'],
                          views: result[index]['view_counts'],
                          views_per: result[index]['view_per'],
                          profile_pic: result[index]['userpic'],
                          pid: result[index]['pk'],
                          has_surveyed: result[index]['has_surveyed'],
                        );
                      } else if (isLoading) {
                        if (counts != result.length) {
                          return ShimmerHomecard();
                        }
                      } else {
                        return NoInternetScreen(); // Return an empty container when data is null or index is out of bounds.
                      }
                    },
                    childCount: result.length + (isLoading ? 1 : 0),
                  ),
                )
              : SliverFillRemaining(
                  hasScrollBody: false,
                  fillOverscroll: true,
                  child: Container(
                    color: Colors.white,
                    child: ten_shimear(),
                  ),
                ),
          SliverFillRemaining(
            hasScrollBody: false,
            fillOverscroll: true,
            child: Container(
              height: 70,
              color: Colors.white,
              child: Center(child: Text("Bottom content")),
            ),
          ),
        ],
      ),
    );
  }
}

class Homecard extends StatefulWidget {
  List<dynamic> images;
  var has_surveyed;
  var pid;
  String? flag;
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
      this.has_surveyed,
      required this.pid,
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
      has_surveyed: has_surveyed,
      pid: pid,
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
  var has_surveyed;
  var pid;
  var grade_per;
  String name;
  var flag;
  var rating;
  var rating_per;
  var five_star;
  var views;
  var views_per;
  var profile_pic;

  double _userRatingfromRateNow = 0.0;

  TextEditingController Rating_AnserfromRateNow = TextEditingController();
  bool ShowTextfiledOntop = false;

  _HomecardState({
    this.has_surveyed,
    required this.pid,
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
  bool onebutton = false;
  final ScrollController _scrollController = ScrollController();

  void checkRatingbutton() async {
    var perfs = await SharedPreferences.getInstance();
    onebutton = perfs.getBool('Checksurveyed$pid') ?? false;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    checkRatingbutton();
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Dialog cannot be dismissed by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black12,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 140,
                width: 140,
                child: Image(image: AssetImage('assets/images/logo4.gif')),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> RateNow(int id) async {
    _showLoadingDialog(context);
    String coment = '........';
    if (Rating_AnserfromRateNow.text.isNotEmpty) {
      Debugs('coment empty');
      setState(() {
        coment = Rating_AnserfromRateNow.text;
      });
    }
    final res = await https.post(
      Uri.parse("https://lookranks.com/and_api/onrate/"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Token $usertoken',
      },
      body: jsonEncode(
        {
          'rating': _userRatingfromRateNow.toDouble(),
          'comment': Rating_AnserfromRateNow.text.isNotEmpty
              ? Rating_AnserfromRateNow.text
              : coment,
          'user': id,
        },
      ),
    );

    if (res.statusCode == 201) {
      var data = res.body;
      Map<String, dynamic> decodedResponse = jsonDecode(data);
      setState(() {
        onebutton = true;
      });

      Debugs("RateNow is done...");
      var token = decodedResponse['fb_token'];

      Debugs(res.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              'Posted!',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ),
      );
      // Debugs(res.body);
      Navigator.pop(context);

      Navigator.pop(context);
      var perfs = await SharedPreferences.getInstance();
      perfs.setBool('Checksurveyed$id', true);
      await NotificationService.sendNotificationToSelectedDevice(
          ' $UserName Rated Your Post',
          coment == '........'
              ? '       Check Out Your Post!'
              : Rating_AnserfromRateNow.text,
          token);
    } else {
      Navigator.pop(context);
      Navigator.pop(context);
      SnackBar(
        content: Center(
          child: Text(
            'Something Went Wrong.',
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
      );
      // Debugs('Failed to load data. Status code: ${res.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.13),
            blurRadius: 20.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Card(
        color: Colors.white,
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
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
              onDoubleTap: () async {
                if (!has_surveyed && !onebutton)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Rating(
                          Updateonebutton: () {
                            setState(() {
                              onebutton = true;
                            });
                          },
                          pid: pid,
                          grade: grade,
                          five_star: five_star,
                          flag: flag,
                          grade_per: grade_per,
                          images: images,
                          rating_per: rating_per,
                          username: name,
                          view_per: views_per,
                          profile_pic: images[0]),
                    ),
                  );
              },
              onTap: () async {
                bool Firsttimescroll = true;
                bool _isLoading = false;
                void _handleButtonPress() {
                  setState(() {
                    _isLoading = true;
                    // Simulate a loading process, you can replace this with your actual data fetching logic.
                    Future.delayed(Duration(seconds: 2), () {
                      setState(() {
                        _isLoading = false;
                      });
                    });
                  });
                }

                if (!has_surveyed && !onebutton)
                  await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true, // Set this to true
                    builder: (BuildContext context) {
                      return Container(
                        height: 645,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              Stack(children: [
                                Stack(
                                  children: [
                                    if (images.length >= 1)
                                      CarouselSlider(
                                        options: CarouselOptions(
                                          autoPlay: true,
                                          enlargeCenterPage: true,
                                          aspectRatio: 12 / 14,
                                        ),
                                        items: images.map((imageUrl) {
                                          return Stack(children: [
                                            Container(
                                                width: double.infinity,
                                                child: Image.network(imageUrl,
                                                    fit: BoxFit.cover)),
                                            Positioned(
                                                bottom: 70,
                                                left: 10,
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                            width: 16,
                                                            height: 16,
                                                            child: Image(
                                                              image: AssetImage(
                                                                  "assets/images/logo.png"),
                                                            )),
                                                        Stack(children: [
                                                          Container(
                                                            width: 70,
                                                            height: 15,
                                                            color:
                                                                Colors.white54,
                                                          ),
                                                          Text("LookRanks",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      "Sofia",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800)),
                                                        ]),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            '@',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .redAccent,
                                                                fontSize: 10),
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                Colors.white54,
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            name,
                                                            style: TextStyle(
                                                                fontSize: 10),
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                Colors.white54,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                )),
                                            Positioned(
                                              bottom: 18,
                                              left: 50,
                                              child:
                                                  CircularProgressWithPercentage(
                                                color: Colors.redAccent,
                                                progressicon: Icons
                                                    .local_activity_rounded,

                                                percentage:
                                                    grade_per, // Change this to the desired percentage
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 18,
                                              left: 120,
                                              child:
                                                  CircularProgressWithPercentage(
                                                color: Colors.blueAccent,
                                                progressicon:
                                                    Icons.bar_chart_rounded,

                                                percentage:
                                                    rating_per, // Change this to the desired percentage
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 18,
                                              left: 190,
                                              child:
                                                  CircularProgressWithPercentage(
                                                color: Colors.green,
                                                progressicon: Icons.radar_sharp,

                                                percentage:
                                                    views_per, // Change this to the desired percentage
                                              ),
                                            ),
                                          ]);
                                        }).toList(),
                                      ),
                                    if (images.length == 0)
                                      Stack(
                                        children: [
                                          Container(
                                            height: 400,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(40),
                                                    topRight:
                                                        Radius.circular(40))),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(40),
                                                  topRight:
                                                      Radius.circular(40)),
                                              child: Image.network(
                                                images.first,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                              bottom: 60,
                                              left: 10,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                          width: 16,
                                                          height: 16,
                                                          child: Image(
                                                            image: AssetImage(
                                                                "assets/images/logo.png"),
                                                          )),
                                                      Stack(
                                                        children: [
                                                          Container(
                                                            width: 70,
                                                            height: 15,
                                                            color:
                                                                Colors.white38,
                                                          ),
                                                          Text("LookRanks",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      "Sofia",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800)),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Colors
                                                                      .white38),
                                                          child: Text(
                                                            "@",
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .redAccent),
                                                          )),
                                                      Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Colors
                                                                      .white38),
                                                          child: Text(
                                                            "$name",
                                                            style: TextStyle(
                                                                fontSize: 10),
                                                          )),
                                                    ],
                                                  )
                                                ],
                                              )),
                                          Positioned(
                                            bottom: 10,
                                            left: 50,
                                            child:
                                                CircularProgressWithPercentage(
                                              color: Colors.red,
                                              progressicon:
                                                  Icons.local_activity_rounded,

                                              percentage:
                                                  grade_per, // Change this to the desired percentage
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 10,
                                            left: 120,
                                            child:
                                                CircularProgressWithPercentage(
                                              color: Colors.blue,
                                              progressicon:
                                                  Icons.bar_chart_rounded,

                                              percentage:
                                                  rating_per, // Change this to the desired percentage
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 10,
                                            left: 190,
                                            child:
                                                CircularProgressWithPercentage(
                                              color: Colors.green,
                                              progressicon: Icons.radar_sharp,

                                              percentage:
                                                  views_per, // Change this to the desired percentage
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ]),
                              Text(
                                "How many stars would you rate this person",
                                style: TextStyle(
                                    fontFamily: "Lemon", fontSize: 10),
                              ),
                              Container(
                                // height: 60,
                                // width: 330,
                                decoration: BoxDecoration(
                                    color: Colors.white54,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                              ),
                              RatingBar.builder(
                                itemSize: 60,
                                initialRating: 0.0,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 3.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star_rounded,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  setState(() {
                                    Debugs(rating);
                                    _userRatingfromRateNow = rating;
                                  });
                                },
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 1.15,
                                height: 50,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 10.0,
                                          color:
                                              Colors.black12.withOpacity(0.1)),
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(40.0))),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: Theme(
                                      data: ThemeData(
                                        highlightColor: Colors.white,
                                        hintColor: Colors.white,
                                      ),
                                      child: TextFormField(
                                        validator: (input) {},
                                        onSaved: (input) {
                                          if (input == null || input.isEmpty) {
                                            Rating_AnserfromRateNow.text =
                                                'none';
                                          } else {
                                            Rating_AnserfromRateNow.text =
                                                input;
                                          }
                                        },
                                        controller: Rating_AnserfromRateNow,
                                        onChanged: (focusNode) {
                                          if (Firsttimescroll) {
                                            setState(() {
                                              Firsttimescroll = false;
                                            });
                                            _scrollController.animateTo(
                                              _scrollController.offset +
                                                  300.0, // Scroll down by 500 pixels (adjust the value as needed)
                                              duration: Duration(
                                                  milliseconds:
                                                      2000), // Adjust the duration as needed
                                              curve: Curves.ease,
                                            );
                                          }
                                          // Debugs the user's input data
                                          Debugs('inputing');
                                        },
                                        decoration: InputDecoration(
                                          hintText: "Write Comment (Optional)",
                                          hintStyle: TextStyle(
                                            fontFamily: "Sofia",
                                            color: Colors.black,
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 1.0,
                                              style: BorderStyle.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all<
                                          EdgeInsetsGeometry>(
                                        EdgeInsets.all(0),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.transparent),
                                    ),
                                    child: Container(
                                      width: 100,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                                0.2), // Shadow color
                                            spreadRadius: 3, // Spread radius
                                            blurRadius: 6, // Blur radius
                                            offset: Offset(
                                                0, 3), // Offset in x and y
                                          ),
                                        ],
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.yellow[800]!,
                                            Colors.yellow[700]!,
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      padding: EdgeInsets.all(10.0),
                                      child: Center(
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontFamily: "Poppins"),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Debugs(
                                      //     'tapedd for rate Now : pid is $pid');
                                      RateNow(pid);
                                    },
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all<
                                          EdgeInsetsGeometry>(
                                        EdgeInsets.all(0),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.transparent),
                                    ),
                                    child: Container(
                                      width: 100,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                                0.2), // Shadow color
                                            spreadRadius: 3, // Spread radius
                                            blurRadius: 6, // Blur radius
                                            offset: Offset(
                                                0, 3), // Offset in x and y
                                          ),
                                        ],
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.blue,
                                            Colors.lightBlue
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      padding: EdgeInsets.all(10.0),
                                      child: Center(
                                        child: Text(
                                          "Post",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontFamily: "Poppins"),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 320,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
              },
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
                        backgroundImage: CachedNetworkImageProvider(images[0]),
                      ),
                      SizedBox(width: 10),
                      Text(
                        name.length >= 13
                            ? '${name.substring(0, 10)}...'
                            : name,
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
                            size: 57,
                            color: Colors.yellow[600],
                          ),
                          Text(
                            "$five_star",
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // SizedBox(height: 0.5),
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
                    height: 8,
                  ),

                  if (!has_surveyed && !onebutton)
                    Row(
                      children: [
                        SizedBox(
                          width: 30,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Rating(
                                    Updateonebutton: () {
                                      setState(() {
                                        onebutton = true;
                                      });
                                    },
                                    pid: pid,
                                    grade: grade,
                                    five_star: five_star,
                                    flag: flag,
                                    grade_per: grade_per,
                                    images: images,
                                    rating_per: rating_per,
                                    username: name,
                                    view_per: views_per,
                                    profile_pic: images[0]),
                              ),
                            );
                          },
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.all(0),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.transparent),
                          ),
                          child: Container(
                            width: 100,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.2), // Shadow color
                                  spreadRadius: 3, // Spread radius
                                  blurRadius: 6, // Blur radius
                                  offset: Offset(0, 3), // Offset in x and y
                                ),
                              ],
                              gradient: LinearGradient(
                                colors: [Colors.orange, Colors.yellow],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: EdgeInsets.all(10.0),
                            child: Center(
                              child: Text(
                                "Survey",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: "Poppins"),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        ElevatedButton(
                          onPressed: () async {
                            bool Firsttimescroll = true;
                            bool _isLoading = false;
                            void _handleButtonPress() {
                              setState(() {
                                _isLoading = true;
                                // Simulate a loading process, you can replace this with your actual data fetching logic.
                                Future.delayed(Duration(seconds: 2), () {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                });
                              });
                            }

                            await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true, // Set this to true
                              builder: (BuildContext context) {
                                return Container(
                                  height: 645,
                                  child: SingleChildScrollView(
                                    controller: _scrollController,
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      children: [
                                        Stack(children: [
                                          Stack(
                                            children: [
                                              if (images.length >= 1)
                                                CarouselSlider(
                                                  options: CarouselOptions(
                                                    autoPlay: true,
                                                    enlargeCenterPage: true,
                                                    aspectRatio: 12 / 14,
                                                  ),
                                                  items: images.map((imageUrl) {
                                                    return Stack(children: [
                                                      Container(
                                                          width:
                                                              double.infinity,
                                                          child: Image.network(
                                                              imageUrl,
                                                              fit: BoxFit
                                                                  .cover)),
                                                      Positioned(
                                                          bottom: 70,
                                                          left: 10,
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                      width: 16,
                                                                      height:
                                                                          16,
                                                                      child:
                                                                          Image(
                                                                        image: AssetImage(
                                                                            "assets/images/logo.png"),
                                                                      )),
                                                                  Stack(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              70,
                                                                          height:
                                                                              15,
                                                                          color:
                                                                              Colors.white54,
                                                                        ),
                                                                        Text(
                                                                            "LookRanks",
                                                                            style: TextStyle(
                                                                                fontSize: 12,
                                                                                fontFamily: "Sofia",
                                                                                fontWeight: FontWeight.w800)),
                                                                      ]),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    child: Text(
                                                                      '@',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .redAccent,
                                                                          fontSize:
                                                                              10),
                                                                    ),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .white54,
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    child: Text(
                                                                      name,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              10),
                                                                    ),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .white54,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          )),
                                                      Positioned(
                                                        bottom: 18,
                                                        left: 50,
                                                        child:
                                                            CircularProgressWithPercentage(
                                                          color:
                                                              Colors.redAccent,
                                                          progressicon: Icons
                                                              .local_activity_rounded,

                                                          percentage:
                                                              grade_per, // Change this to the desired percentage
                                                        ),
                                                      ),
                                                      Positioned(
                                                        bottom: 18,
                                                        left: 120,
                                                        child:
                                                            CircularProgressWithPercentage(
                                                          color:
                                                              Colors.blueAccent,
                                                          progressicon: Icons
                                                              .bar_chart_rounded,

                                                          percentage:
                                                              rating_per, // Change this to the desired percentage
                                                        ),
                                                      ),
                                                      Positioned(
                                                        bottom: 18,
                                                        left: 190,
                                                        child:
                                                            CircularProgressWithPercentage(
                                                          color: Colors.green,
                                                          progressicon:
                                                              Icons.radar_sharp,

                                                          percentage:
                                                              views_per, // Change this to the desired percentage
                                                        ),
                                                      ),
                                                    ]);
                                                  }).toList(),
                                                ),
                                              if (images.length == 0)
                                                Stack(
                                                  children: [
                                                    Container(
                                                      height: 400,
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          40),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          40))),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        40),
                                                                topRight: Radius
                                                                    .circular(
                                                                        40)),
                                                        child: Image.network(
                                                          images.first,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                        bottom: 60,
                                                        left: 10,
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Container(
                                                                    width: 16,
                                                                    height: 16,
                                                                    child:
                                                                        Image(
                                                                      image: AssetImage(
                                                                          "assets/images/logo.png"),
                                                                    )),
                                                                Stack(
                                                                  children: [
                                                                    Container(
                                                                      width: 70,
                                                                      height:
                                                                          15,
                                                                      color: Colors
                                                                          .white38,
                                                                    ),
                                                                    Text(
                                                                        "LookRanks",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            fontFamily:
                                                                                "Sofia",
                                                                            fontWeight:
                                                                                FontWeight.w800)),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  child: Text(
                                                                    '@',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .redAccent,
                                                                        fontSize:
                                                                            10),
                                                                  ),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white54,
                                                                  ),
                                                                ),
                                                                Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            color:
                                                                                Colors.white38),
                                                                    child: Text(
                                                                      "$name",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              10),
                                                                    )),
                                                              ],
                                                            )
                                                          ],
                                                        )),
                                                    Positioned(
                                                      bottom: 10,
                                                      left: 50,
                                                      child:
                                                          CircularProgressWithPercentage(
                                                        color: Colors.red,
                                                        progressicon: Icons
                                                            .local_activity_rounded,

                                                        percentage:
                                                            grade_per, // Change this to the desired percentage
                                                      ),
                                                    ),
                                                    Positioned(
                                                      bottom: 10,
                                                      left: 120,
                                                      child:
                                                          CircularProgressWithPercentage(
                                                        color: Colors.blue,
                                                        progressicon: Icons
                                                            .bar_chart_rounded,

                                                        percentage:
                                                            rating_per, // Change this to the desired percentage
                                                      ),
                                                    ),
                                                    Positioned(
                                                      bottom: 10,
                                                      left: 190,
                                                      child:
                                                          CircularProgressWithPercentage(
                                                        color: Colors.green,
                                                        progressicon:
                                                            Icons.radar_sharp,

                                                        percentage:
                                                            views_per, // Change this to the desired percentage
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ]),
                                        Text(
                                          "How many stars would you rate this person",
                                          style: TextStyle(
                                              fontFamily: "Lemon",
                                              fontSize: 10),
                                        ),
                                        Container(
                                          // height: 60,
                                          // width: 330,
                                          decoration: BoxDecoration(
                                              color: Colors.white54,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30))),
                                        ),
                                        RatingBar.builder(
                                          itemSize: 60,
                                          initialRating: 0.0,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 3.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star_rounded,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {
                                            setState(() {
                                              Debugs(rating);
                                              _userRatingfromRateNow = rating;
                                            });
                                          },
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.15,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    blurRadius: 10.0,
                                                    color: Colors.black12
                                                        .withOpacity(0.1)),
                                              ],
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(40.0))),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0, right: 15.0),
                                              child: Theme(
                                                data: ThemeData(
                                                  highlightColor: Colors.white,
                                                  hintColor: Colors.white,
                                                ),
                                                child: TextFormField(
                                                  validator: (input) {},
                                                  onSaved: (input) {
                                                    if (input == null ||
                                                        input.isEmpty) {
                                                      Rating_AnserfromRateNow
                                                          .text = 'none';
                                                    } else {
                                                      Rating_AnserfromRateNow
                                                          .text = input;
                                                    }
                                                  },
                                                  controller:
                                                      Rating_AnserfromRateNow,
                                                  onChanged: (focusNode) {
                                                    if (Firsttimescroll) {
                                                      setState(() {
                                                        Firsttimescroll = false;
                                                      });
                                                      _scrollController
                                                          .animateTo(
                                                        _scrollController
                                                                .offset +
                                                            300.0, // Scroll down by 500 pixels (adjust the value as needed)
                                                        duration: Duration(
                                                            milliseconds:
                                                                2000), // Adjust the duration as needed
                                                        curve: Curves.ease,
                                                      );
                                                    }
                                                    // Debugs the user's input data
                                                    Debugs('inputing');
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Write Comment (Optional)",
                                                    hintStyle: TextStyle(
                                                      fontFamily: "Sofia",
                                                      color: Colors.black,
                                                    ),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.white,
                                                        width: 1.0,
                                                        style: BorderStyle.none,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              style: ButtonStyle(
                                                padding: MaterialStateProperty
                                                    .all<EdgeInsetsGeometry>(
                                                  EdgeInsets.all(0),
                                                ),
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                            Color>(
                                                        Colors.transparent),
                                              ),
                                              child: Container(
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(
                                                              0.2), // Shadow color
                                                      spreadRadius:
                                                          3, // Spread radius
                                                      blurRadius:
                                                          6, // Blur radius
                                                      offset: Offset(0,
                                                          3), // Offset in x and y
                                                    ),
                                                  ],
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Colors.yellow[800]!,
                                                      Colors.yellow[700]!,
                                                    ],
                                                    begin: Alignment.centerLeft,
                                                    end: Alignment.centerRight,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                padding: EdgeInsets.all(10.0),
                                                child: Center(
                                                  child: Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontFamily: "Poppins"),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                // Debugs(
                                                //     'tapedd for rate Now : pid is $pid');
                                                RateNow(pid);
                                              },
                                              style: ButtonStyle(
                                                padding: MaterialStateProperty
                                                    .all<EdgeInsetsGeometry>(
                                                  EdgeInsets.all(0),
                                                ),
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                            Color>(
                                                        Colors.transparent),
                                              ),
                                              child: Container(
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(
                                                              0.2), // Shadow color
                                                      spreadRadius:
                                                          3, // Spread radius
                                                      blurRadius:
                                                          6, // Blur radius
                                                      offset: Offset(0,
                                                          3), // Offset in x and y
                                                    ),
                                                  ],
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Colors.blue,
                                                      Colors.lightBlue
                                                    ],
                                                    begin: Alignment.centerLeft,
                                                    end: Alignment.centerRight,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                padding: EdgeInsets.all(10.0),
                                                child: Center(
                                                  child: Text(
                                                    "Post",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontFamily: "Poppins"),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 320,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.all(0),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.transparent),
                          ),
                          child: Container(
                            width: 110,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.2), // Shadow color
                                  spreadRadius: 3, // Spread radius
                                  blurRadius: 6, // Blur radius
                                  offset: Offset(0, 3), // Offset in x and y
                                ),
                              ],
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
                                "Rate Now",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: "Poppins"),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        )
                      ],
                    )
                  else
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
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.all(0),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),
                        ),
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.2), // Shadow color
                                spreadRadius: 3, // Spread radius
                                blurRadius: 6, // Blur radius
                                offset: Offset(0, 3), // Offset in x and y
                              ),
                            ],
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
                      SizedBox(width: 40),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Inbox_Screen(
                                  Receiver_Pkid: pid,
                                  Receiver_User: name,
                                ),
                              ));
                        },
                        style: ButtonStyle(
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.all(0),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),
                        ),
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.2), // Shadow color
                                spreadRadius: 3, // Spread radius
                                blurRadius: 6, // Blur radius
                                offset: Offset(0, 3), // Offset in x and y
                              ),
                            ],
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
                              "Send m",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: "Poppins"),
                            ),
                          ),
                        ),
                      ),
                    ])
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
                        GifCircularProgressBar(progress: 0.0),
                      ],
                    ),
                  );
                },
                errorWidget: (context, url, error) =>
                    GifCircularProgressBar(progress: 0),
              );
            }),
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
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10),
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 110,
                          height: 20,
                          color: Colors.grey[300],
                        ),
                      ),
                      SizedBox(width: 8),
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 20,
                          width: 40,
                          color: Colors.grey[300],
                        ),
                      ),
                      Spacer(),
                      Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Icon(
                            Icons.star_rounded,
                            color: Colors.grey[300],
                            size: 60,
                          )),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 70,
                              height: 10,
                              color: Colors.grey[300],
                            ),
                          ),
                          SizedBox(
                            height: 17,
                          ),
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Icon(
                              Icons.circle_outlined,
                              size: 60,
                              color: Colors.grey[300],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 70,
                              height: 10,
                              color: Colors.grey[300],
                            ),
                          ),
                          SizedBox(
                            height: 17,
                          ),
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Icon(
                              Icons.circle_outlined,
                              size: 60,
                              color: Colors.grey[300],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 70,
                              height: 10,
                              color: Colors.grey[300],
                            ),
                          ),
                          SizedBox(
                            height: 17,
                          ),
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Icon(
                              Icons.circle_outlined,
                              size: 60,
                              color: Colors.grey[300],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 30,
                      ),
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                        ),
                      ),
                      Spacer(),
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyButton extends StatefulWidget {
  final Function onPressed;
  final String buttonText;
  final bool isLoading;

  MyButton({
    required this.onPressed,
    required this.buttonText,
    this.isLoading = false,
  });

  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading
          ? null
          : () async {
              setState(() {
                // Set _isLoading to true when the button is pressed.
                _isLoading = true;
              });

              await widget.onPressed();

              setState(() {
                // Set _isLoading back to false when the async operation is completed.
                _isLoading = false;
              });
            },
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.all(0),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          Colors.transparent,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedOpacity(
            opacity: _isLoading ? 0.0 : 1.0,
            duration: Duration(milliseconds: 200),
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
                  widget.buttonText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: "Poppins",
                  ),
                ),
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: _isLoading ? 1.0 : 0.0,
            duration: Duration(milliseconds: 200),
            child: Container(
              width: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.lightBlueAccent],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: EdgeInsets.all(10.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            ),
          ),
        ],
      ),
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
        children: <Widget>[
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

class MyHomePage extends StatefulWidget {
  String TextforButton;
  MyHomePage({required this.TextforButton});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = false;

  void _handleButtonPress() {
    setState(() {
      _isLoading = true;
      // Simulate a loading process, you can replace this with your actual data fetching logic.
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // style: ButtonStyle(
      //   padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
      //     EdgeInsets.all(0),
      //   ),
      //   backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
      // ),

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
          child: _isLoading
              ? Container(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(
                    color: Colors.red,
                    strokeWidth: 1.8,
                  ),
                )
              : Text(
                  widget.TextforButton,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: "Poppins",
                  ),
                ),
        ),
      ),
    );
  }
}
