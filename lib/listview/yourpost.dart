import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Bottom.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/listview/Createpost.dart';
import 'package:flutter_application_1/profile.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:country_picker/country_picker.dart';
import 'dart:convert';
import 'dart:async';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as https;


class DetailPost extends StatefulWidget {
  const DetailPost({Key? key}) : super(key: key);

  @override
  State<DetailPost> createState() => _DetailPostState();
}

class _DetailPostState extends State<DetailPost> {
  late Future<void> apiDataFuture;
  List<dynamic> images = ["skjbdkbekfdb", "ndkaefdewn"];
  List<dynamic>? comentlist;

  @override
  void initState() {
    super.initState();
    apiDataFuture = DetailAccount();
  }

  var apiData;
  var questions;


  Future<void> Questions() async {
    final res = await https.get(
      Uri.parse("https://lookranks.com/and_api/get_answer/$UserName"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        // 'Authorization': 'Token $usertoken'
      },
    );

    if (res.statusCode == 200) {
      final jsonData = jsonDecode(res.body);
      print("questions data.......");
      print(jsonData['answers']);
      setState(() {
       questions=jsonData['answers'];
       qesloading=false;
      });
    } else {
      print('Failed to load data. Status code: ${res.statusCode}');
    }
  }
    Future<void> DetailAccount() async {
    final res = await https.get(
      Uri.parse("https://lookranks.com/and_api/detail/$UserName"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Token $usertoken'
      },
    );

    if (res.statusCode == 200) {
      final jsonData = jsonDecode(res.body);
      print(jsonData);
      setState(() {
        apiData = jsonData;
        images = jsonData["pic_urls"];
        comentlist = jsonData["comment_list"];
      });
    } else {
       
      print('Failed to load data. Status code: ${res.statusCode}');
    }
  }

  Future<void> DeleteAccount() async {
    final progressDialog = ProgressDialog(context);
    progressDialog.style(
      message: 'Deleting Post...',
      progressWidget: CircularProgressIndicator(),
    );
    progressDialog.show;
    final res = await https.post(
      Uri.parse("https://lookranks.com/and_api/deactivate_account/"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Token $usertoken',
      },
    );

    if (res.statusCode == 200) {
      setState(() {
        userHasProfileImage = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              'Your post has been deleted.',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ),
      );
     Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Bottom(),
        ),
      );

      print("delete");
      print(res.body);
    } else {
      print('Failed to load data. Status code: ${res.statusCode}');
    }
  }
   bool QA =false;
   bool qesloading=true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: Colors.yellow[700]),
          title: Text("Your Post"),
          centerTitle: true,
        ),
      body: userHasProfileImage ? FutureBuilder<void>(
        future: apiDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SHimer();
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (apiData == null) {
            return Column(
              children: [
                Image.asset('assets/images/NoPost.png'),
              ],
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  images.length >= 0
                      ? CarouselSlider(
                          options: CarouselOptions(
                            autoPlay: true,
                            enlargeCenterPage: true,
                            aspectRatio: 13 / 14,
                          ),
                          items: images.map((imageUrls) {
                            return Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  child: Stack(
                                    children: [
                                      Image.network(imageUrls,
                                          fit: BoxFit.cover),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                                color: Colors.white54,
                                              ),
                                              Text("LookRanks",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: "Sofia",
                                                      fontWeight:
                                                          FontWeight.w800)),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "@",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors
                                                  .redAccent, // Set the text color to black (you can use any color you prefer)
                                              backgroundColor: Colors.white54,
                                            ),
                                          ),
                                          Text(
                                            "$UserName",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors
                                                  .black, // Set the text color to black (you can use any color you prefer)
                                              backgroundColor: Colors.white54,
                                            ),
                                          ),
                                        ],
                                      ),
                                      RatingBarIndicator(
                                        rating:
                                            apiData['star_rating'].toDouble(),
                                        itemBuilder: (context, index) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        itemCount: 5,
                                        itemSize: 20.0,
                                        unratedColor: Colors.grey[400],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            CircularProgressWithPercentage(
                                              percentage: apiData["Grade_per"],
                                              color: Colors.red,
                                              progressicon:
                                                  Icons.local_activity_rounded,
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            CircularProgressWithPercentage(
                                              color: Colors.blue,
                                              progressicon:
                                                  Icons.bar_chart_rounded,
                                              percentage: apiData["rating_per"],
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            CircularProgressWithPercentage(
                                              color: Colors.green,
                                              progressicon: Icons.radar_sharp,
                                              percentage: apiData["view_per"],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]
                            );
                          }).toList(),
                        )
                      :
                      // if ({apiData["pic_urls"]}.length == 1)
                      Stack(
                          children: [
                            Container(
                              height: 300,
                              width: double.infinity,
                              child: Image.network(
                                images.first,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ],
                        ),
                  // Padding(
                  //   padding: const EdgeInsets.all(12.0),
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //         color: Colors.deepPurple[200],
                  //         borderRadius: BorderRadius.all(Radius.circular(20))),
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Column(
                  //         children: [
                  //           Text(
                  //             "Ratings and Suggestions",
                  //             style: TextStyle(
                  //                 fontFamily: "Sofia",
                  //                 fontSize: 18,
                  //                 color: Colors.white,
                  //                 fontWeight: FontWeight.w600),
                  //           ),
                  //           Padding(
                  //             padding:
                  //                 const EdgeInsets.only(left: 15, right: 15),
                  //             child: Text(
                  //               "${comentlist!.length} peoples Rate your picture. If you'd like to have more people rate your picture, you need to rate other people's pictures as well. if you rate more people's posts, more people rate your post",
                  //               style: TextStyle(
                  //                 color: Colors.white,
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 10, right: 10),
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.all(Radius.circular(20)),
                  //       color: Colors.purple[50],
                  //       border: Border.all(
                  //           width: 1.5, color: Colors.deepPurple[400]!),
                  //     ),
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(12.0),
                  //       child: Column(
                  //         children: [
                  //           Center(
                  //             child: Text(
                  //               "Ratings and Suggestions",
                  //               style: TextStyle(
                  //                 fontWeight: FontWeight.w700,
                  //                 // letterSpacing: 1.2,
                  //                 fontFamily: "Sans",
                  //               ),
                  //             ),
                  //           ),
                  //           if (comentlist!.length > 1)
                  //             Text(
                  //               "${comentlist?.length ?? 0} people Rate your picture.If you want more ratings, rate other people posts. This way, your post will reach a larger audience and receive more ratings.",
                  //               style: TextStyle(
                  //                 fontWeight: FontWeight.w400,
                  //                 letterSpacing: 0.7,
                  //                 fontFamily: "Sans",
                  //               ),
                  //             ),
                  //           if (comentlist!.length < 2)
                  //             Text(
                  //               "${comentlist?.length ?? 0} person Rate your picture.If you want more ratings, rate other people posts. This way, your post will reach a larger audience and receive more ratings.",
                  //               style: TextStyle(
                  //                 fontWeight: FontWeight.w400,
                  //                 letterSpacing: 0.7,
                  //                 fontFamily: "Sans",
                  //               ),
                  //             ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Container(height: 8,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    
                    InkWell(
                      onTap: ()async{
                         final prefs = await SharedPreferences
                                              .getInstance();

                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Delete Post",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'Poppins'),
                                                    ),
                                                  ],
                                                ),
                                                content: Container(
                                                  height: 180,
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                20, 0, 10, 0),
                                                        child: Text(
                                                          "Note: Removing your post will result in the loss of your rank and post details.",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Sofia',
                                                              color: Colors
                                                                  .red[300],
                                                              fontSize: 17),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                20, 20, 20, 0),
                                                        child: Text(
                                                          "Are you sure you want to Delete your post?",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Sofia'),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      TextButton(
                                                        child: Text("Cancel"),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(); // Close the alert dialog
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text(
                                                          "Delete",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .redAccent),
                                                        ),
                                                        onPressed: () {
                                                          prefs.setString(
                                                              "profilepicture",
                                                              "null");
                                                          DeleteAccount();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                      },
                      child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2), // Shadow color
                            spreadRadius: 2, // Spread radius
                            blurRadius: 5, // Blur radius
                            offset: Offset(0, 3), // Offset in x and y
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete, color: Colors.redAccent),
                          Text(" Delete", style: TextStyle(color: Colors.redAccent)),
                        ],
                      ),
                    ),
                    ),
                    SizedBox(width: 10,),
                  InkWell(
                    onTap: (){
                      showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Add Post",
                                                      style: TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'Poppins'),
                                                    ),
                                                  ],
                                                ),
                                                content: Container(
                                                  height: 175,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(10, 0, 10, 0),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          "Note: You can have only one post.",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Sofia',
                                                              color: Colors
                                                                  .blue,
                                                              fontSize: 17),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          "You already have a post. To create a new one, you must remove the previous one.",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              letterSpacing: 1,
                                                              fontFamily:
                                                                  'Sofia'),
                                                        ),
                                                        // SizedBox(
                                                        //   height: 5,
                                                        // ),
                                                        // Text(
                                                        //   "You can have only one post.",
                                                        //   style: TextStyle(
                                                        //       color: Colors.red,
                                                        //       fontSize: 15,
                                                        //       fontWeight:
                                                        //           FontWeight
                                                        //               .w600,
                                                        //       letterSpacing: 1,
                                                        //       fontFamily:
                                                        //           'Sofia'),
                                                        // ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      TextButton(
                                                        child: Text(
                                                          "Close",
                                                          style: TextStyle(),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                    },
                    child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          spreadRadius: 2, // Spread radius
                          blurRadius: 5, // Blur radius
                          offset: Offset(0, 3), // Offset in x and y
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_circle_outlined, color: Colors.blue),
                        Text(" Add", style: TextStyle(color: Colors.blue)),
                      ],
                    ),
                  ),
                  ),
                    SizedBox(width: 10,),
                   InkWell(
                    onTap: (){
                      showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Help",
                                                      style: TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'Poppins'),
                                                    ),
                                                  ],
                                                ),
                                                content: Container(
                                                  height: 258,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(8, 8,0, 0),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          "${comentlist!.length} peoples Rate your picture.",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Sofia',
                                                              color: Colors
                                                                  .amber[900],
                                                              fontSize: 17),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          "  If you'd like to have more people rate your picture, you need to rate other people's pictures as well. if you rate more people's posts, Your post shows more audience.",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              letterSpacing: 1,
                                                              fontFamily:
                                                                  'Sofia'),
                                                        ),
                                                        // SizedBox(
                                                        //   height: 5,
                                                        // ),
                                                        // Text(
                                                        //   "You can have only one post.",
                                                        //   style: TextStyle(
                                                        //       color: Colors.red,
                                                        //       fontSize: 15,
                                                        //       fontWeight:
                                                        //           FontWeight
                                                        //               .w600,
                                                        //       letterSpacing: 1,
                                                        //       fontFamily:
                                                        //           'Sofia'),
                                                        // ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      TextButton(
                                                        child: Text(
                                                          "Close",
                                                          style: TextStyle(),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                    },
                     child: Container(
                     height: 40,
                     width: 100,
                     decoration: BoxDecoration(
                       color: Colors.grey[300],
                       borderRadius: BorderRadius.all(Radius.circular(50)),
                       boxShadow: [
                         BoxShadow(
                           color: Colors.black.withOpacity(0.2), // Shadow color
                           spreadRadius: 2, // Spread radius
                           blurRadius: 5, // Blur radius
                           offset: Offset(0, 3), // Offset in x and y
                         ),
                       ],
                     ),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Icon(Icons.help, color: Colors.amber[900]),
                         Text(" Help", style: TextStyle(color: Colors.amber[900])),
                       ],
                     ),
                   ),
                   )

                  ],),
                  Container(height: 15,),
                apiData["ask_question1"]!='null'?
                    Row(
                  children: [
                    
                    SizedBox(width: 10,),
                    InkWell(
                      onTap: (){
                        setState(() {
                           QA=false;
                        });
                       
                       
                      },
                      child: AnimatedContainer(
                          duration:Duration(seconds: 2) ,
                        decoration: BoxDecoration( 
                          color: Colors.white70,
                            boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          spreadRadius: 3, // Spread radius
                          blurRadius: 6, // Blur radius
                          offset: Offset(0, 3), // Offset in x and y
                        ),
                      ],
                          border: Border.all(
                            width:QA? 0:2,
    color:QA ?Colors.grey[400]!:Colors.deepPurple[300]! , // Set the border color to black
  ),borderRadius: BorderRadius.all(Radius.circular(30))),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8,8,8,0),
                          child: Column(
                            children: [
                              
                              Text("Rating & Comment", style: TextStyle(fontSize: 14, color: QA?Colors.grey[600]:Colors.deepPurple[300])),
                              SizedBox(height: 3,),
                              AnimatedContainer(
                                duration: Duration(seconds: 1),
                                height: 5, 
                                width: QA?30:120,
                                decoration: BoxDecoration(color:QA?Colors.grey[400]:Colors.deepPurple[300], borderRadius: BorderRadius.all(Radius.circular(50))),
                              ), 
                              
                                            
                            ],
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                   
                    InkWell(
                      onTap: ()async{
                        Questions();
                        setState(() {
                          QA=true; 
                        });
                      },
                      child: AnimatedContainer(
                        duration:Duration(seconds: 2) ,
                        decoration: BoxDecoration( 
                          color: Colors.white70,
                            boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          spreadRadius: 3, // Spread radius
                          blurRadius: 6, // Blur radius
                          offset: Offset(0, 3), // Offset in x and y
                        ),
                      ],
                          border: Border.all(
                            width:QA? 2:0,
    color:QA ?Colors.deepPurple[300]!: Colors.grey[400]!, // Set the border color to black
  ),borderRadius: BorderRadius.all(Radius.circular(30))),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8,8,8,0),
                          child: Column(
                            children: [
                              Text("Question & Answer",style: TextStyle(fontSize: 14, color: QA?Colors.deepPurple[300]:Colors.grey[600])),
                              SizedBox(height: 3,),
                               AnimatedContainer(
                                duration: Duration(seconds: 1),
                                height: 5, 
                                width: QA?130:30,
                                decoration: BoxDecoration(color:QA?Colors.deepPurple[300]:Colors.grey[400], borderRadius: BorderRadius.all(Radius.circular(50))),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                  ],
                  
                 ):
                
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 20,),
                    InkWell(
                      onTap: (){
                        setState(() {
                           QA=false;
                        });
                       
                       
                      },
                      child: Column(

                        children: [
                         
                          Text("Rating & Coment", style: TextStyle(fontSize: 18, color: QA?Colors.grey[600]:Colors.deepPurple[300],fontWeight: FontWeight.w500)),
                          AnimatedContainer(
                            duration: Duration(seconds: 1),
                            height: 5, 
                            width: QA?30:130,
                            decoration: BoxDecoration(color:QA?Colors.grey[400]:Colors.deepPurple[300], borderRadius: BorderRadius.all(Radius.circular(50))),
                          ), 
                          
                    
                        ],
                      ),
                    ),
                   
                 
                  ],
                 ),

                if(!QA)
                   if (comentlist!.length != 0)
                    for (int i = 0; i < comentlist!.length; i++)
                      UserReviewWidget(
                        Userpic: comentlist?[i]['userpic'],
                        comment: comentlist![i]['comment'],
                        date: comentlist![i]['timestamp'],
                        rating: comentlist![i]['rating'],
                        userName: comentlist![i]['commented_by'],
                      )
                  else
                      Stack(
                          alignment: Alignment.center,
                           children: [
                              Image.asset(
                            'assets/images/Messaging (1).gif'),
                                                   Positioned(
                                                    top: 80,
                                                     child: Text(
                                                                               "No Rating Found",
                                                                               style: TextStyle(
                                                                                   fontSize: 15,
                                                                                   fontWeight: FontWeight.w800,
                                                                                   color: Colors.blueGrey,
                                                                                   fontFamily: 'Poppins'),
                                                     ),
                                                   ),
                                           ],
                         ),
                    if(QA)
                    !qesloading?Column(
                      children: [

                        if(questions.length<-1 ||questions.length==0|| apiData["ask_question1"]==null)
                        apiData["ask_question1"]==null?
                        Column(
                      children: [
                        
                         Column(
                          //alignment: Alignment.center,
                           children: [
                            SizedBox(height: 40,),
                             
                                                   Text(
                                                                             "Creator does not ask any Questions",
                                                                             style: TextStyle(
                                                                                 fontSize: 15,
                                                                                 fontWeight: FontWeight.w800,
                                                                                 color: Colors.blueGrey,
                                                                                 fontFamily: 'Poppins'),
                                                   ),
                                                    Image.asset(
                            'assets/images/3.png'),
                                           ],
                         ),
                       
                      ],
                    ):Column(
                      children: [
                        
                         Stack(
                          alignment: Alignment.center,
                           children: [
                              Image.asset(
                            'assets/images/Messaging (1).gif'),
                                                   Positioned(
                                                    top: 80,
                                                     child: Text(
                                                                               "No Question & Answer founded",
                                                                               style: TextStyle(
                                                                                   fontSize: 15,
                                                                                   fontWeight: FontWeight.w800,
                                                                                   color: Colors.blueGrey,
                                                                                   fontFamily: 'Poppins'),
                                                     ),
                                                   ),
                                           ],
                         ),
                       
                      ],
                    ),
                        for(int i=0;i<questions.length;i++)
                        if(images!= null && questions[i]['answer1']!=null && questions[i]['submitted_by']['name']!=null &&questions[i]['submitted_by']['pic']!=null )
                        CommentReplyCard(name: questions[i]['submitted_by']['name'],
                        pic:questions[i]['submitted_by']['pic'],
                        ans: questions[i]['answer1'],
                        img:images,
                        ques:apiData["ask_question1"],
                        //longpressname:widget.Longpressusername,
                        
                        )
                        
                      ],
                    ):tenreplaycard(),
                
                  SizedBox(
                    height: 65,
                  )
                ],
              ),
            );
          }
        },
      ):NoPost()
    );
  }
}

class CommentReplyCard extends StatelessWidget {
  var name;
  var pic;
  var ans;
  var img;
  var ques;
  CommentReplyCard({this.name,this.pic,this.ans,this.img, this.ques});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Original Comment
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                          CircleAvatar(
  radius: 20,
  backgroundImage: CachedNetworkImageProvider(img.first),
),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                               UserName!.length >= 22
                                ? '${name.substring(0, 19)}...'
                                : UserName!,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                               "  Creator",
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w500,color:Colors.green),
                            ),
                          ],
                        ),
                        Text(
                          ques,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Reply Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 30,),
                      CircleAvatar(
  radius: 20,
  backgroundImage: CachedNetworkImageProvider(pic),
),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                               name.length >= 22
                            ? '${name.substring(0, 19)}...'
                            : name,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              ans,
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Reply Metadata (e.g., time)
                  SizedBox(height: 8),
                  // Text(
                  //   "2 hours ago",
                  //   style: TextStyle(fontSize: 12, color: Colors.grey),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class UserReviewWidget extends StatelessWidget {
  //var data;
  final String userName;
  final double rating;
  final String comment;
  final String date;
  String Userpic;

  UserReviewWidget(
      {required this.userName,
      required this.rating,
      required this.comment,
      required this.date,
      required this.Userpic});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Userpic == "null"
                    ? CircleAvatar(
                        radius: 18,
                        backgroundImage:
                            AssetImage("assets/images/No_profile_pic.png"),
                      )
                    : CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage(Userpic),
                      ),
                SizedBox(width: 8.0),
                Text(
                  userName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                RatingBarIndicator(
                  rating: rating,
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 24.0,
                  unratedColor: Colors.grey[400],
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(80,0,0,0),
              child: Text(
                comment,
                style: TextStyle(fontSize: 14.0),
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
              ],
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
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  color: Colors.white60,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
            Container(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                value: percentage / 100,
                strokeWidth: 3.5,
                backgroundColor: Colors.grey[100],
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            Icon(
              progressicon,
              size: 26,
              color: Colors.grey[400],
            ),
            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 12,
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

class tenreplaycard extends StatefulWidget {
  const tenreplaycard({super.key});

  @override
  State<tenreplaycard> createState() => _tenreplaycardState();
}

class _tenreplaycardState extends State<tenreplaycard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ReplayCardShimmer(),
        ReplayCardShimmer(),
        ReplayCardShimmer(),
        ReplayCardShimmer(),
        ReplayCardShimmer(),
        ReplayCardShimmer(),
        ReplayCardShimmer(),
        ReplayCardShimmer(),
        ReplayCardShimmer(),
        ReplayCardShimmer(),
      ],
    );
  }
}
class ReplayCardShimmer extends StatelessWidget {

 

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Original Comment
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
                    child:CircleAvatar(
                    radius: 20,
                    
                  ),
                  ),
                  
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                        child: Container( width: 100, height: 10 ,color: Colors.grey,) ,
                      ),
                    SizedBox(height: 8,),
                    Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
                        child: Container( width: 180, height: 10,color: Colors.grey) ,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Reply Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 30,),
                       Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
                    child:CircleAvatar(
                    radius: 20,
                    
                  ),
                  ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                        child: Container( width: 100, height: 10 ,color: Colors.grey,) ,
                      ),
                    SizedBox(height: 8,),
                    Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
                        child: Container( width: 180, height: 10,color: Colors.grey) ,
                      ),
                        ],
                      ),
                    ],
                  ),
                  // Reply Metadata (e.g., time)
                  SizedBox(height: 8),
                  // Text(
                  //   "2 hours ago",
                  //   style: TextStyle(fontSize: 12, color: Colors.grey),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SHimer extends StatelessWidget {
  const SHimer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Shimmer.fromColors(
                  child: Container(
                    color: Colors.grey[300],
                    height: 315,
                    width: 36,
                  ),
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!),
              SizedBox(
                width: 4,
              ),
              Container(
                height: 395,
                width: 280,
                color: Colors.grey[300],
                child: Stack(
                  children: [
                    Container(
                      child: Positioned(
                          bottom: 90,
                          left: 20,
                          child: Shimmer.fromColors(
                              child: Container(
                                color: Colors.red,
                                height: 11,
                                width: 80,
                              ),
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!)),
                    ),
                    Positioned(
                        bottom: 72,
                        left: 20,
                        child: Shimmer.fromColors(
                            child: Container(
                              color: Colors.grey[300],
                              height: 11,
                              width: 90,
                            ),
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!)),
                    Positioned(
                      bottom: 47,
                      left: 10,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: RatingBarIndicator(
                          rating: 0.0, // Use a dummy rating value
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 24.0,
                          unratedColor: Colors.grey[400],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Row(
                        children: [
                          Shimmer.fromColors(
                              child: Icon(Icons.circle_outlined, size: 48),
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!),
                          Shimmer.fromColors(
                              child: Icon(Icons.circle_outlined, size: 48),
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!),
                          Shimmer.fromColors(
                              child: Icon(Icons.circle_outlined, size: 48),
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!),
                          SizedBox(
                            width: 60,
                          ),
                          Shimmer.fromColors(
                              child: Icon(Icons.add_circle_outline_outlined,
                                  size: 30),
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!),
                          SizedBox(
                            width: 10,
                          ),
                          Shimmer.fromColors(
                              child: Icon(
                                Icons.delete,
                                size: 30,
                              ),
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4),
              Shimmer.fromColors(
                  child: Container(
                    color: Colors.grey[300],
                    height: 315,
                    width: 36,
                  ),
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Shimmer.fromColors(
                 baseColor:  Colors.grey[300]! ,
                         highlightColor: Colors.grey[100] !,
                         child: Container(height: 40, 
                         width: 100,
                         decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50)),color: Colors.grey),
                         ),
              ),
              SizedBox(width: 10,),
               Shimmer.fromColors(
                 baseColor:  Colors.grey[300]! ,
                         highlightColor: Colors.grey[100] !,
                         child: Container(height: 40, 
                         width: 100,
                         decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50)),color: Colors.grey),
                         ),
              ),
              SizedBox(width: 10,), Shimmer.fromColors(
                 baseColor:  Colors.grey[300]! ,
                         highlightColor: Colors.grey[100] !,
                         child: Container(height: 40, 
                         width: 100,
                         decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50)),color: Colors.grey),
                         ),
              ),
              

          ]),
          SizedBox(height: 10,),
          
         Row(
             children: [
                 SizedBox(width: 10,),
                   Shimmer.fromColors(
                     baseColor:  Colors.grey[300]! ,
                             highlightColor: Colors.grey[100] !,
                     child: Container(
                       
                          decoration: BoxDecoration( 
                         
                           
                            border: Border.all(
                              width: 2,
                       //color:QA ?Colors.deepPurple[300]!: Colors.grey[400]!, // Set the border color to black
                     ),borderRadius: BorderRadius.all(Radius.circular(30))),
                       child: Padding(
                        padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                         child: Column(
                           children: [
                             Shimmer.fromColors(
                               baseColor:  Colors.grey[300]! ,
                               highlightColor: Colors.grey[100] !,
                               child: Text(
                                 
                                 "Rating & Comment",
                                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                               ),
                             ),
                             SizedBox(height: 3),
                             Shimmer.fromColors(
                                baseColor:  Colors.grey[300]! ,
                               highlightColor: Colors.grey[100] !,
                               child: AnimatedContainer(
                                 duration: Duration(seconds: 1),
                                 height: 5,
                                 width: 130,
                                 decoration: BoxDecoration(
                                   color: Colors.grey[400] ,
                                   borderRadius: BorderRadius.all(Radius.circular(50)),
                                 ),
                               ),
                             ),
                           ],
                         ),
                       ),
                     ),
                   ),
                   Spacer(),
                  Shimmer.fromColors(
                     baseColor:  Colors.grey[300]! ,
                             highlightColor: Colors.grey[100] !,
                     child: Container(
                       
                          decoration: BoxDecoration( 
                         
                           
                            border: Border.all(
                              width: 2,
                       //color:QA ?Colors.deepPurple[300]!: Colors.grey[400]!, // Set the border color to black
                     ),borderRadius: BorderRadius.all(Radius.circular(30))),
                       child: Padding(
                        padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                         child: Column(
                           children: [
                             Shimmer.fromColors(
                               baseColor:  Colors.grey[300]! ,
                               highlightColor: Colors.grey[100] !,
                               child: Text(
                                 
                                 "Question & Answer",
                                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                               ),
                             ),
                             SizedBox(height: 3),
                             Shimmer.fromColors(
                                baseColor:  Colors.grey[300]! ,
                               highlightColor: Colors.grey[100] !,
                               child: AnimatedContainer(
                                 duration: Duration(seconds: 1),
                                 height: 5,
                                 width: 30,
                                 decoration: BoxDecoration(
                                   color: Colors.grey[400] ,
                                   borderRadius: BorderRadius.all(Radius.circular(50)),
                                 ),
                               ),
                             ),
                           ],
                         ),
                       ),
                     ),
                   ),
                      SizedBox(width: 10,),
                 ],
           ),
      SizedBox(height: 10), // Adjust the spacing as needed
      
          // Container(
          //     decoration: BoxDecoration(
          //         color: Colors.grey[300],
          //         borderRadius: BorderRadius.all(Radius.circular(20))),
          //     height: 113,
          //     width: 330,
          //     child: Column(
          //       children: [
          //         SizedBox(
          //           height: 10,
          //         ),
          //         Shimmer.fromColors(
          //             child: Container(
          //                 color: Colors.black, height: 20, width: 120),
          //             baseColor: Colors.grey[300]!,
          //             highlightColor: Colors.grey[100]!),
          //         SizedBox(
          //           height: 8,
          //         ),
          //         Shimmer.fromColors(
          //             child: Container(
          //                 color: Colors.black, height: 15, width: 220),
          //             baseColor: Colors.grey[300]!,
          //             highlightColor: Colors.grey[100]!),
          //         SizedBox(
          //           height: 5,
          //         ),
          //         Shimmer.fromColors(
          //             child: Container(
          //                 color: Colors.black, height: 15, width: 250),
          //             baseColor: Colors.grey[300]!,
          //             highlightColor: Colors.grey[100]!),
          //         SizedBox(
          //           height: 5,
          //         ),
          //         Shimmer.fromColors(
          //             child: Container(
          //                 color: Colors.black, height: 15, width: 100),
          //             baseColor: Colors.grey[300]!,
          //             highlightColor: Colors.grey[100]!)
          //       ],
          //     )),
          ShimmerColumn(),
          SizedBox(
            height: 3,
          ),
          ShimmerColumn(),
          SizedBox(
            height: 3,
          ),
          ShimmerColumn(),
          SizedBox(
            height: 3,
          ),
          ShimmerColumn(),
          SizedBox(
            height: 3,
          ),
          ShimmerColumn(),
          SizedBox(
            height: 3,
          ),
          ShimmerColumn(),
        ],
      ),
    );
  }
}

class ShimmerColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      width: 450,
      child: Card(
        elevation: 3.0,
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  // Wrap the CircleAvatar with Shimmer
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: CircleAvatar(
                      radius: 20,
                      // Use a transparent placeholder image
                      backgroundImage: AssetImage("assets/images/logo.png"),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Shimmer.fromColors(
                        child: Container(
                          height: 5,
                          width: 20,
                        ),
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!),
                  )
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  SizedBox(
                    width: 30,
                  ),
                  // Wrap the RatingBarIndicator with Shimmer
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: RatingBarIndicator(
                      rating: 0.0, // Use a dummy rating value
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 24.0,
                      unratedColor: Colors.grey[400],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              // Wrap the comment text with Shimmer
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: double.infinity,
                  height: 16.0,
                  color: Colors
                      .white, // Use a background color that matches your UI
                ),
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Wrap the date text with Shimmer
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 80.0,
                      height: 12.0,
                      color: Colors
                          .white, // Use a background color that matches your UI
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NoPost extends StatefulWidget {
  const NoPost({super.key});

  @override
  State<NoPost> createState() => _NoPostState();
}

class _NoPostState extends State<NoPost> {
 
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/images/NoPost.png'),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'Create a post to boost your beauty ranking since you currently have none, To become a part of the worldwide beautiful persons ranklist.',
            style: TextStyle(fontFamily: 'Sofia', fontWeight: FontWeight.w400),
          ),
        ),
        InkWell(
          splashColor: Colors.white,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Postscreen(bid: 56890, btoken: 567890),
                ));
          },
          child: AnimatedContainer(
            height: 52,
            duration: Duration(milliseconds: 300),
            width: 260,
            decoration: BoxDecoration(
                    boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          spreadRadius: 3, // Spread radius
                          blurRadius: 6, // Blur radius
                          offset: Offset(0, 3), // Offset in x and y
                        ),
                      ],
              border: Border.all(
                color: Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(80.0),
              gradient: LinearGradient(
                
                colors: [
                  Colors.blue,
                  Colors.blueAccent,
                ],
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              "Create Post",
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
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          spreadRadius: 3, // Spread radius
                          blurRadius: 6, // Blur radius
                          offset: Offset(0, 3), // Offset in x and y
                        ),
                      ],
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
    
  }
}
