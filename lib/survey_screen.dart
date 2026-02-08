import 'dart:math';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Survey extends StatefulWidget {
  const Survey({super.key});

  @override
  State<Survey> createState() => _SurveyState();
}

class _SurveyState extends State<Survey> {
  List<String> imageUrls = [
    //"https://static.teamviewer.com/resources/2016/12/is-this-link-safe-1024x726.jpg",
    "https://static.teamviewer.com/resources/2016/12/is-this-link-safe-1024x726.jpg",
    "https://images.pexels.com/photos/2853592/pexels-photo-2853592.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
    "https://images.pexels.com/photos/2853592/pexels-photo-2853592.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Survey")),
        body: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 13, left: 13),
                child: Row(
                  children: [
                    CircleAvatar(radius: 25),
                    SizedBox(width: 10),
                    Text(
                      'Username',
                      style: TextStyle(
                        fontFamily: "Sofia",
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      child: Icon(Icons.flag_circle_sharp, size: 30),
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
                          "4.4",
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (imageUrls.length > 1)
                CarouselSlider(
                  options: CarouselOptions(
                    height: 350,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                  ),
                  items: imageUrls.map((imageUrl) {
                    return Stack(children: [
                      Center(child: Image.network(imageUrl, fit: BoxFit.cover)),
                      Positioned(
                          bottom: 50,
                          left: 47,
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
                                  Text("LookRanks",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: "Sofia",
                                          fontWeight: FontWeight.w800)),
                                ],
                              ),
                              Text(
                                "@username",
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          )),
                      Positioned(
                        bottom: 10,
                        left: 50,
                        child: CircularProgressWithPercentage(
                          color: Colors.red,
                          progressicon: Icons.local_activity_rounded,

                          percentage:
                              58, // Change this to the desired percentage
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 100,
                        child: CircularProgressWithPercentage(
                          color: Colors.blue,
                          progressicon: Icons.bar_chart_rounded,

                          percentage:
                              45, // Change this to the desired percentage
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 150,
                        child: CircularProgressWithPercentage(
                          color: Colors.green,
                          progressicon: Icons.radar_sharp,

                          percentage:
                              25, // Change this to the desired percentage
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              if (imageUrls.length == 1)
                Stack(
                  children: [
                    Center(
                      child: Container(
                        height: 400,
                        width: double.infinity,
                        child: Image.network(
                          imageUrls.first,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 50,
                        left: 10,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                    width: 16,
                                    height: 16,
                                    child: Image(
                                      image:
                                          AssetImage("assets/images/logo.png"),
                                    )),
                                Text("LookRanks",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: "Sofia",
                                        fontWeight: FontWeight.w800)),
                              ],
                            ),
                            Text(
                              "@username",
                              style: TextStyle(fontSize: 10),
                            )
                          ],
                        )),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: CircularProgressWithPercentage(
                        color: Colors.red,
                        progressicon: Icons.local_activity_rounded,

                        percentage: 75, // Change this to the desired percentage
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 60,
                      child: CircularProgressWithPercentage(
                        color: Colors.blue,
                        progressicon: Icons.bar_chart_rounded,

                        percentage: 75, // Change this to the desired percentage
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 110,
                      child: CircularProgressWithPercentage(
                        color: Colors.green,
                        progressicon: Icons.radar_sharp,

                        percentage: 75, // Change this to the desired percentage
                      ),
                    ),
                  ],
                ),
              Container(
                child: ContainerAnimationScreen(),
              ),
            
            ])));
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
                  width: 35,
                  height: 35,
                  child: CircularProgressIndicator(
                    value: percentage / 100,
                    strokeWidth: 3.5,
                    backgroundColor: Colors.white30,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ],
            ),
            Icon(
              progressicon,
              size: 32,
              color: Colors.black12,
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

class ContainerAnimationScreen extends StatefulWidget {
  @override
  _ContainerAnimationScreenState createState() =>
      _ContainerAnimationScreenState();
}

class _ContainerAnimationScreenState extends State<ContainerAnimationScreen> {
  int currentIndex = 0;
  double starRating = 0.0;

  List<String> Questions = [
    "how are your",
    "how dsfnajnfgdsafgoikgvsdgdsfgtrghbt",
    "jdfiwjsoidfjisfvodsoi",
    "ijsoifdjewoijfisdjfcijeojfcoisdjfcgtrgtgtrfg",
    "foewkfcokdspofckwedkwekdfedf",
    "sasadasdfgvdhbfg kj"
  ];

  void nextContainer() {
    if (currentIndex < Questions.length - 1) {
      setState(() {
        currentIndex++;
        starRating =
            0.0; // Reset the star rating when moving to the next container
      });
    }
  }

  void setStarRating(double rating) {
    setState(() {
      starRating = rating;
    });

    // Optionally, you can move to the next container when a star is tapped
    if (rating > 0) {
      nextContainer();
    }
  }

  Widget buildStar(int index) {
    return IconButton(
      icon: Icon(
        size: 43,
        index <= starRating
            ? Icons.star_border_rounded
            : Icons.star_border_rounded,
        color: Colors.yellow,
      ),
      onPressed: () {
        setStarRating(index.toDouble() + 1);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            height: 220,
            duration: Duration(seconds: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35)),
              color: Colors.white,
            ),
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 30,
                      right: 30,
                      top: 20,
                    ),
                    child: Text(
                      '${currentIndex + 1} ${Questions[currentIndex]}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontFamily: "Sofia"),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) => buildStar(index)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      nextContainer();
                    },
                    child: Text('Next'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
