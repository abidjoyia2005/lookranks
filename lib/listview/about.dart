import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class aboutApps extends StatefulWidget {
  @override
  _aboutAppsState createState() => _aboutAppsState();
}

class _aboutAppsState extends State<aboutApps> {
  @override
  static var _txtCustomHead = TextStyle(
    color: Colors.black54,
    fontSize: 17.0,
    fontWeight: FontWeight.w600,
    fontFamily: "Gotik",
  );

  static var _txtCustomSub = TextStyle(
    color: Colors.black38,
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
    fontFamily: "Gotik",
  );

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "About Application",
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15.0,
              color: Colors.black54,
              fontFamily: "Gotik"),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.orangeAccent),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Divider(
                  height: 0.5,
                  color: Colors.black12,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, left: 15.0),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "LookRanks",
                            style: _txtCustomSub.copyWith(
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Divider(
                  height: 0.5,
                  color: Colors.black12,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "The first impression we make is strongly influenced by our looks. LookRanks app helps you find which style suits you best.It allows you to be part of a worldwide ranking for good-looking people.Share your post and discover the highest-rated fashion styles to boost your confidence in your look. Also, visit our website www.lookranks.com , At LookRanks, we provide an online platform where users can check their beauty rank levels through engaging surveys. Users can upload their pictures, receive feedback, and participate in our community.",
                  style: _txtCustomSub,
                  textAlign: TextAlign.justify,
                ),
              ),
           SizedBox(height: 20,),
             
              GradientText(
              "Developed by Abid Joyia",
              style: TextStyle(
                fontFamily: "Lemon",
                fontSize: 17,
                fontWeight: FontWeight.w100,
              ),
              colors: [
                Colors.blueAccent,
                Colors.pinkAccent,
                // Colors.blueGrey,
                // Colors.green
              ],
            ),
            ],
          ),
        ),
      ),
    );
  }
}
