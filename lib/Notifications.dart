import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'Add_post.dart';
import 'Bottom.dart';
import 'No_Internet.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  late Future<List<dynamic>> apiData;
  int? total_notifications;
  int? current_total_notifications;

  Future<List<Map<String, dynamic>>> getdata() async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $usertoken',
    };
    var res = await http.get(
      Uri.parse('https://lookranks.com/and_api/notify/'),
      headers: headers,
    );

    var apiData = jsonDecode(res.body);
    Debugs('Nofication data from api');
    Debugs(apiData);

    return List<Map<String, dynamic>>.from(apiData);
  }

  @override
  void initState() {
    super.initState();

    apiData = getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Notifications",
          style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w700),
        ),
      ),
      body: FutureBuilder(
        future: apiData,
        builder: (context, snapshot) {
          // Replace GifCircularProgressBar with Shimmer
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!, // You can customize these colors
                highlightColor: Colors.grey[100]!,
                child: Shimerlist(), // Replace with your loading content
              ),
            );
          } else if (snapshot.hasError) {
            return NoInternetScreen();
          } else {
            List<dynamic> data = snapshot.data as List<dynamic>;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, i) {
                return NotificationItem(
                  Twocardcombine: data[i]["active"],
                  TypeOfNotification: data[i]["type"],
                  action: data[i]["comment"],
                  Message: data[i]["message"],
                  Messagesender: data[i]["message_sender"],
                  MessagesenderPic: data[i]["sender_pic"],
                  name: data[i]["commented_by_users"],
                  postText: data[i]['comment'],
                  pictire: data[i]['commented_by_pics'],
                  timeAgo: data[i]['timestamp'],
                  notificSubtitle: data[i]['notific'],
                  notificTitle: data[i]['title'],
                  notificLogo: data[i]['logo'],
                  name2: i + 1 < data.length
                      ? data[i + 1]['commented_by_users']
                      : i + 2 < data.length
                          ? data[i + 2]['commented_by_users']
                          : i + 3 < data.length
                              ? data[i + 3]['commented_by_users']
                              : i + 4 < data.length
                                  ? data[i + 4]['commented_by_users']
                                  : i + 5 < data.length
                                      ? data[i + 5]['commented_by_users']
                                      : i + 6 < data.length
                                          ? data[i + 6]['commented_by_users']
                                          : i + 7 < data.length
                                              ? data[i + 7]
                                                  ['commented_by_users']
                                              : i + 8 < data.length
                                                  ? data[i + 8]
                                                      ['commented_by_users']
                                                  : i + 9 < data.length
                                                      ? data[i + 9]
                                                          ['commented_by_users']
                                                      : "null",
                  pictire2: i + 1 < data.length
                      ? data[i + 1]['commented_by_pics']
                      : i + 2 < data.length
                          ? data[i + 2]['commented_by_pics']
                          : i + 3 < data.length
                              ? data[i + 3]['commented_by_pics']
                              : i + 4 < data.length
                                  ? data[i + 4]['commented_by_pics']
                                  : i + 5 < data.length
                                      ? data[i + 5]['commented_by_pics']
                                      : i + 6 < data.length
                                          ? data[i + 6]['commented_by_pics']
                                          : i + 7 < data.length
                                              ? data[i + 7]['commented_by_pics']
                                              : i + 8 < data.length
                                                  ? data[i + 8]
                                                      ['commented_by_pics']
                                                  : i + 9 < data.length
                                                      ? data[i + 9]
                                                          ['commented_by_pics']
                                                      : "null",
                );
              },
            );
          }
        },
      ),
    );
  }
}

class NotificationItem extends StatefulWidget {
  String? notificLogo;
  String? notificTitle;
  String? name;
  String? name2;
  String? notificSubtitle;
  String? Message;
  String? MessagesenderPic;
  String? Messagesender;
  String? pictire;
  String? pictire2;
  String? action;
  String? postText;
  String? timeAgo;
  String? TypeOfNotification;
  bool? Twocardcombine;

  NotificationItem({
    this.notificTitle,
    this.notificLogo,
    this.notificSubtitle,
    this.name2,
    this.MessagesenderPic,
    this.Messagesender,
    this.Message,
    this.pictire2,
    this.pictire,
    this.Twocardcombine,
    this.name,
    this.action,
    this.postText,
    this.timeAgo,
    this.TypeOfNotification,
  });

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
     requestNotificationPermission();
    Debugs('2name : ${widget.name2}  2picture:${widget.pictire2}');
  }
Future<void> requestNotificationPermission() async {
  Debugs("Requesting permission for notifications...");

  try {
   
    await FirebaseMessaging.instance.requestPermission();

    Debugs("Notification permission granted.");
  } catch (e) {
    Debugs("Error requesting notification permission: $e");
    // Handle the error as needed
  }
}


  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: widget.TypeOfNotification == "post_view"
            ? InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Postscreen(bid: userid, btoken: usertoken),
                      ));
                },
                child: Row(
                  children: [
                    if (widget.Twocardcombine != true &&
                            widget.pictire2 != "null" ||
                        widget.pictire2 != null)
                      Row(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            child: Stack(
                              children: [
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: CircleAvatar(
                                    radius: 26,
                                    backgroundImage: CachedNetworkImageProvider(widget.pictire!),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  bottom: 0,
                                  child: CircleAvatar(
                                    radius: 26,
                                   backgroundImage: CachedNetworkImageProvider(widget.pictire2!),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    else
                      Container(
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: CachedNetworkImageProvider(widget.pictire!),
                        ),
                      ),

                    SizedBox(width: 16),

                    Expanded(
                        child: widget.Twocardcombine != true &&
                                    widget.pictire2 != "null" ||
                                widget.pictire2 != null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black, // Text color
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "${widget.name}",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: "Sofia",
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        TextSpan(
                                          text: " and ",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: "Sofia",
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "${widget.name2}",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: "Sofia",
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              ' rate your post and give suggestions',
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        widget.timeAgo!.replaceAll('Â', ' '),
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 11,
                                        ),
                                      ),
                                      Text(
                                        ' ago',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black, // Text color
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "${widget.name}",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: "Sofia",
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              ' rate your post and Write "${widget.postText!.length < 15 ? widget.postText! : widget.postText!.substring(0, 13)}..."',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: "Sofia",
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        widget.timeAgo!.replaceAll('Â', ' '),
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        ' ago',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ))
                    // Container(
                    //   height: 50,
                    //   width: 50,
                    //   decoration: BoxDecoration(
                    //     color: Colors.black,
                    //     borderRadius: BorderRadius.circular(8),
                    //   ),
                    //   child: Icon(
                    //     Icons.check,
                    //     color: Colors.white,
                    //   ),
                    // ),
                  ],
                ),
              )
            : widget.TypeOfNotification == 'web_notice'
                ? Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(widget.notificLogo!),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black, // Text color
                                ),
                                children: [
                                  TextSpan(
                                    text: widget.notificTitle,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "Sofia",
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  // TextSpan(
                                  //   text: "has ",
                                  //   style: TextStyle(
                                  //     fontSize: 18,
                                  //     fontFamily: "Sofia",
                                  //     fontWeight: FontWeight.w600,
                                  //   ),
                                  // ),
                                  // TextSpan(
                                  //   text: "${widget.action} ",
                                  //   style: TextStyle(
                                  //     fontSize: 20,
                                  //     fontFamily: "Sofia",
                                  //     fontWeight: FontWeight.w900,
                                  //   ),
                                  // ),
                                  // TextSpan(
                                  //   text: widget.notificSubtitle,
                                  // ),
                                ],
                              ),
                            ),
                            Text(
                              widget.notificSubtitle!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              '${widget.timeAgo!.replaceAll('Â', ' ')} ago',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 11),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: _isExpanded
                          ? BorderRadius.circular(20.0)
                          : BorderRadius.circular(10.0),
                    ),
                    child: GestureDetector(
                      onTap: () {},
                      child: ExpansionTile(
                        childrenPadding: EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        iconColor: Colors.yellow[700],
                        backgroundColor: Colors.deepPurple[50],
                        subtitle: Text(
                          '${widget.timeAgo!.replaceAll('Â', ' ')} ago',
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                        leading: CircleAvatar(
                          radius: 28,
                          backgroundImage:
                              NetworkImage(widget.MessagesenderPic!),
                        ),

                        title: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: widget.Messagesender!,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: "Sofia",
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        TextSpan(
                                          text: " Send ",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: "Sofia",
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "Message",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: "Sofia",
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Add content that should appear when the tile is expanded.
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 40, right: 10, bottom: 5),
                            child: Text(
                              widget.Message!,
                              style: TextStyle(fontFamily: "lemon"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
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

class Shimerlist extends StatefulWidget {
  const Shimerlist({super.key});

  @override
  State<Shimerlist> createState() => _ShimerlistState();
}

class _ShimerlistState extends State<Shimerlist> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Shimer(),
        SizedBox(
          height: 10,
        ),
        Shimer(),
        SizedBox(
          height: 10,
        ),
        Shimer(),
        SizedBox(
          height: 10,
        ),
        Shimer(),
        SizedBox(
          height: 10,
        ),
        Shimer(),
        SizedBox(
          height: 10,
        ),
        Shimer(),
        SizedBox(
          height: 10,
        ),
        Shimer(),
        SizedBox(
          height: 10,
        ),
        Shimer(),
        SizedBox(
          height: 10,
        ),
        Shimer(),
        SizedBox(
          height: 10,
        ),
        Shimer(),
        SizedBox(
          height: 10,
        ),
        Shimer(),
        SizedBox(
          height: 10,
        ),
        Shimer(),
        SizedBox(
          height: 10,
        ),
        Shimer(),
        SizedBox(
          height: 10,
        ),
        Shimer(),
        SizedBox(
          height: 10,
        ),
        Shimer(),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class Shimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage("assets/images/logo.png"),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        color: Colors.grey,
                        width: 300,
                        height: 14,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            color: Colors.grey,
                            width: 200,
                            height: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              color: Colors.grey,
                              width: 70,
                              height: 10,
                            )),
                      ],
                    ),
                  ],
                ),
                // Shimmer.fromColors(
                //   baseColor: Colors.grey[300]!,
                //   highlightColor: Colors.grey[100]!,
                //   child: Text(
                //     "ds",
                //     style: TextStyle(
                //       color: Colors.grey,
                //     ),
                //   ),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}



  //  Container(
  //                     height: 80,
  //                     width: 80,
  //                     child: Stack(
  //                       children: [
  //                         Positioned(
  //                           right: 0,
  //                           top: 0,
  //                           child: CircleAvatar(
  //                             radius: 25,
  //                             backgroundImage:
  //                                 AssetImage("assets/images/logo.png"),
  //                           ),
  //                         ),
  //                         Positioned(
  //                           left: 16,
  //                           bottom: 17,
  //                           child: CircleAvatar(
  //                             radius: 25,
  //                             backgroundImage:
  //                                 AssetImage("assets/images/logo.png"),
  //                           ),
  //                         ),
  //                         Positioned(
  //                           left: 0,
  //                           bottom: 0,
  //                           child:
  //                               Stack(alignment: Alignment.center, children: [
  //                             CircleAvatar(
  //                               radius: 25,
  //                               backgroundImage:
  //                                   AssetImage("assets/images/logo.png"),
  //                             ),
  //                             Text(
  //                               "+6",
  //                               style:
  //                                   TextStyle(fontSize: 20, color: Colors.blue),
  //                             ),
  //                           ]),
  //                         ),
  //                       ],
  //                     ),
  //                   ),