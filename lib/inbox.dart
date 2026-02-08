import 'package:flutter/material.dart';
import 'package:flutter_application_1/listview/first.dart';

class InboxApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InboxScreen(),
    );
  }
}

class InboxScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 262.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 67.0, left: 20.0),
                    child: Row(
                      children: [
                        Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png",
                              ),
                              fit: BoxFit.cover,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(75.0)),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 7.0,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "John Doe",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Sofia",
                                fontWeight: FontWeight.w700,
                                fontSize: 20.0,
                              ),
                            ),
                            Text(
                              "john.doe@example.com",
                              style: TextStyle(
                                color: Colors.black54,
                                fontFamily: "Sofia",
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(height: 5.0),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => new yourreciper()));
                    },
                    child: Category(
                      txt: "Meal Plan",
                      image: "assets/images/yourRecipes.png",
                      padding: 20.0,
                    ),
                  ),
                ])),
            Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => new yourreciper()));
                    },
                    child: Category(
                      txt: "Meal Plan",
                      image: "assets/images/yourRecipes.png",
                      padding: 20.0,
                    ),
                  ),
                ])),
            Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => new yourreciper()));
                    },
                    child: Category(
                      txt: "Meal Plan",
                      image: "assets/images/editProfile.png",
                      padding: 20.0,
                    ),
                  ),
                ]))
          ],
        ),
      ),
    );
  }
}

class Category extends StatelessWidget {
  final String? txt; // Use final keyword to define instance variables
  final String? image;
  final GestureTapCallback? tap;
  final double padding; // Avoid nullable for padding

  Category({this.txt, this.image, this.tap, this.padding = 0.0});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 15.0, left: 30.0),
            child: Row(
              children: <Widget>[
                if (image != null) // Check if image is not null before using it
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Image.asset(
                      image!,
                      height: 25.0,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Text(
                    txt ?? "", // Use a default empty string if txt is null
                    style: TextStyle(
                      fontSize: 14.5,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Sofia",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 160),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black26,
                    size: 15.0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Divider(
            color: Colors.black12,
          ),
        ],
      ),
    );
  }
}
