import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as https;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'Bottom.dart';
import 'guider/notification_sender.dart';

class Rating extends StatefulWidget {
  final void Function() Updateonebutton;
  var grade;
  var username;
  var flag;
  var five_star;
  var images;
  var grade_per;
  var rating_per;
  var view_per;
  var profile_pic;
  var pid;

  Rating({
    required this.Updateonebutton,
    required this.pid,
    required this.grade,
    required this.username,
    required this.flag,
    required this.five_star,
    required this.grade_per,
    required this.images,
    required this.rating_per,
    required this.view_per,
    required this.profile_pic,
  });

  @override
  State<Rating> createState() => _RatingState(
      pid: pid,
      grade: grade,
      username: username,
      flag: flag,
      five_star: five_star,
      images: images,
      grade_per: grade_per,
      rating_per: rating_per,
      profile_pic: profile_pic,
      view_per: view_per);
}

class _RatingState extends State<Rating> {
  var grade;
  var pid;
  var username;
  var flag;
  var five_star;
  var images;
  var grade_per;
  var rating_per;
  var view_per;
  var profile_pic;
  @override
  _RatingState({
    required this.grade,
    required this.pid,
    required this.username,
    required this.flag,
    required this.five_star,
    required this.grade_per,
    required this.images,
    required this.rating_per,
    required this.view_per,
    required this.profile_pic,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.yellow[700]),
        centerTitle: true,
        toolbarHeight: 30,
        backgroundColor: Colors.white,
        title: Text("Survey"),
      ),
      body: Container(
          color: Colors.black12,
          height: double.infinity,
          child: YourWidget(
            onebutton: widget.Updateonebutton,
            pid: pid,
            five_star: five_star,
            flag: flag,
            grade: grade,
            grade_per: grade_per,
            images: images,
            rating_per: rating_per,
            username: username,
            view_per: view_per,
            profile_pic: profile_pic,
          )),
    );
  }
}

class YourWidget extends StatefulWidget {
  var onebutton;
  var grade;
  var pid;
  var username;
  var flag;
  var five_star;
  var images;
  var grade_per;
  var rating_per;
  var view_per;
  var profile_pic;
  YourWidget({
    required this.onebutton,
    required this.pid,
    required this.grade,
    required this.username,
    required this.flag,
    required this.five_star,
    required this.grade_per,
    required this.images,
    required this.rating_per,
    required this.view_per,
    required this.profile_pic,
  });
  @override
  _YourWidgetState createState() => _YourWidgetState(
      pid: pid,
      five_star: five_star,
      flag: flag,
      grade: grade,
      grade_per: grade_per,
      images: images,
      rating_per: rating_per,
      username: username,
      view_per: view_per,
      profile_pic: profile_pic);
}

class _YourWidgetState extends State<YourWidget> {
  var grade;
  var username;
  var pid;
  var flag;
  var five_star;
  var images;
  var grade_per;
  var rating_per;
  var view_per;
  var profile_pic;
  _YourWidgetState({
    required this.grade,
    required this.pid,
    required this.username,
    required this.flag,
    required this.five_star,
    required this.grade_per,
    required this.images,
    required this.rating_per,
    required this.view_per,
    required this.profile_pic,
  });

  double _userRating = 0.0;

  @override
  Widget build(BuildContext context) {
    List<dynamic> imageUrls = images;
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30))),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 13, left: 13),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(profile_pic),
                  ),
                  SizedBox(width: 10),
                  Text(
                    username.length >= 14
                        ? '${username.substring(0, 11)}...'
                        : username,
                    style: TextStyle(
                      fontFamily: "Sofia",
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(width: 8),
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
                        size: 50,
                        color: Colors.yellow[600],
                      ),
                      Text(
                        "$five_star",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (imageUrls.length >= 1)
              Hero(
                tag: grade,
                child: CarouselSlider(
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
                                      color: Colors.white38,
                                      width: 16,
                                      height: 16,
                                      child: Image(
                                        image: AssetImage(
                                            "assets/images/logo.png"),
                                      )),
                                  Container(
                                    color: Colors.white38,
                                    child: Text("LookRanks",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: "Sofia",
                                            fontWeight: FontWeight.w800)),
                                  ),
                                ],
                              ),
                              Container(
                                color: Colors
                                    .white38, // Set the background color to white
                                child: Row(
                                  children: [
                                    Text(
                                      '@',
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 10,
                                        // You can set other text styles here
                                      ),
                                    ),
                                    Text(
                                      '$username',
                                      style: TextStyle(
                                        fontSize: 10,
                                        // You can set other text styles here
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )),
                      Positioned(
                        bottom: 5,
                        left: 50,
                        child: CircularProgressWithPercentage(
                          color: Colors.red,
                          progressicon: Icons.local_activity_rounded,

                          percentage:
                              grade_per, // Change this to the desired percentage
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        left: 100,
                        child: CircularProgressWithPercentage(
                          color: Colors.blue,
                          progressicon: Icons.bar_chart_rounded,

                          percentage:
                              rating_per, // Change this to the desired percentage
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        left: 150,
                        child: CircularProgressWithPercentage(
                          color: Colors.green,
                          progressicon: Icons.radar_sharp,

                          percentage:
                              view_per, // Change this to the desired percentage
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            if (imageUrls.length < 1)
              Hero(
                tag: grade,
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        height: 450,
                        width: double.infinity,
                        child: Image.network(
                          imageUrls.first,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 55,
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
                                Container(
                                  decoration:
                                      BoxDecoration(color: Colors.white38),
                                  child: Text("LookRanks",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: "Sofia",
                                          fontWeight: FontWeight.w800)),
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(color: Colors.white38),
                              child: Row(
                                children: [
                                  Text(
                                    '@',
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.redAccent),
                                  ),
                                  Text(
                                    username,
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: CircularProgressWithPercentage(
                        color: Colors.red,
                        progressicon: Icons.local_activity_rounded,

                        percentage:
                            grade_per, // Change this to the desired percentage
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 60,
                      child: CircularProgressWithPercentage(
                        color: Colors.blue,
                        progressicon: Icons.bar_chart_rounded,

                        percentage:
                            rating_per, // Change this to the desired percentage
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 110,
                      child: CircularProgressWithPercentage(
                        color: Colors.green,
                        progressicon: Icons.radar_sharp,

                        percentage:
                            view_per, // Change this to the desired percentage
                      ),
                    ),
                  ],
                ),
              ),
            QuizWidget(
                onebutton: widget.onebutton,
                profile_pic: profile_pic,
                username: username,
                pid: pid),
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
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
                Container(
                  width: 38,
                  height: 38,
                  child: CircularProgressIndicator(
                    value: percentage / 100,
                    strokeWidth: 3.5,
                    backgroundColor: Colors.white38,
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
                fontSize: 14,
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

class QuizWidget extends StatefulWidget {
  var pid;
  var onebutton;
  var username;
  var profile_pic;
  QuizWidget(
      {required this.onebutton,
      required this.profile_pic,
      required this.username,
      required this.pid});
  @override
  _QuizWidgetState createState() => _QuizWidgetState(pid: pid);
}

class _QuizWidgetState extends State<QuizWidget> {
  var pid;
  List<String> questions = [];
  _QuizWidgetState({required this.pid});

  Future<void> ApiQuestions() async {
    try {
      final res = await https.get(
        Uri.parse("https://lookranks.com/and_api/questions/$pid"),
      );
      if (res.statusCode == 200) {
        var apiData = jsonDecode(res.body);
        Debugs('Question api data :$apiData');
        // Assuming that apiData contains a list of questions, change this line accordingly
        questions = List<String>.from(apiData['poll']);
        
      } else if (res.statusCode == 404) {
        // Handle a 404 error...
        Debugs("API Error 404: Resource not found");
      } else if (res.statusCode == 401) {
        // Handle a 401 error...
        Debugs("API Error 401: Unauthorized");
      } else if (res.statusCode == 500) {
        // Handle a 500 error...
        Debugs("API Error 500: Internal Server Error");
      } else {
        // Handle other API errors...
        Debugs("API Error: ${res.statusCode}");
      }
    } catch (e) {
      // Handle exceptions...
      Debugs("Error in server request: $e");
    }
  }

  bool firsttime = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FutureBuilder(
          future: ApiQuestions(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ShimerDown();
            } else if (snapshot.hasError) {
              return Text('Error: ');
            } else {
              // Assuming Douwnpic is a widget that takes a list of questions
              return Douwnpic(
                onebutton: widget.onebutton,
                pid: pid,
                questions: questions,
                name: widget.username,
                picture: widget.profile_pic,
              );
            }
          },
        ),
      ],
    );
  }
}

class Douwnpic extends StatefulWidget {
  var pid;
  var onebutton;
  var picture;
  var name;
  var questions;
  Douwnpic(
      {required this.onebutton,
      required this.questions,
      required this.pid,
      required this.name,
      required this.picture});

  @override
  State<Douwnpic> createState() => _DouwnpicState(pid: pid);
}

class _DouwnpicState extends State<Douwnpic> {
  var pid;
  _DouwnpicState({required this.pid});

  int _currentQuestionIndex = 0;
     void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog cannot be dismissed by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black45,
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

  Future<void> Survey() async {
    _showLoadingDialog(context);
    Debugs("ans 1:${Askquestion1.text} ");
    Debugs("coment:${Discr.text} ");
    var coment = '........';
    if (Discr.text.isNotEmpty) {
      Debugs('coment not empty');
      setState(() {
        coment = Discr.text;
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
          'rating': starRating.toInt(),
          'comment':Discr.text.isNotEmpty? Discr.text:coment,
          'user': pid,
          'quiz1': _selectedAnswers[0],
          'quiz2': _selectedAnswers[1],
          'quiz3': _selectedAnswers[2],
          'quiz4': _selectedAnswers[3],
          'answer1': Askquestion1.text,
          //'answer2': Askquestion2.toString(),
          //'answer3': Askquestion3.toString(),
        },
      ),
    );

    if (res.statusCode == 201) {
      Navigator.pop(context);
      Navigator.pop(context);
      var perfs = await SharedPreferences.getInstance();
      perfs.setBool('Checksurveyed$pid', true);
      widget.onebutton();
      var data= res.body;
       Map<String, dynamic> decodedResponse = jsonDecode(data);
    

      
      var token=decodedResponse['fb_token'];
      Debugs("Survey is done...");
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
      await NotificationService.sendNotificationToSelectedDevice(' $UserName Survey Your Post' , coment == '........'? '       Check Out Your Post!' :Discr.text,token);
      Debugs(res.body);
    } else {
      Navigator.pop(context);
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              'Something Went Wrong',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ),
      );
      Debugs('Failed to load data. Status code: ${res.statusCode}');
    }
  }

  int? choice;

  TextEditingController Discr = TextEditingController();
  TextEditingController Askquestion1 = TextEditingController();
  TextEditingController Askquestion2 = TextEditingController();
  TextEditingController Askquestion3 = TextEditingController();
  List<int> SelectedAnswers = [];

  String? _selectedOption;

  List<String> _selectedAnswers = [];
  final List<List<dynamic>> _options = [
    ['🥵', '😢', '🤔', '😍', '🥰'],
    ['🥵', '😢', '🤔', '😍', '🥰'],
    ['🥵', '😢', '🤔', '😍', '🥰'],
    ['🥵', '😢', '🤔', '😍', '🥰'],
  ];

  Widget buildStar() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      child: RatingBar.builder(
        itemSize: 53,
        initialRating: starRating,
        minRating: 0.5,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        glowColor: Colors.black,
        itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
        itemBuilder: (context, _) => Icon(
          Icons.star_rounded,
          color: Colors.amber,
        ),
        onRatingUpdate: (rating) {
          setState(() {
            setStarRating(rating.toDouble());

            Debugs(rating);

            Future.delayed(Duration(seconds: 1), () {
              setState(() {});
            });
          });
        },
      ),
    );
  }

  bool Startext = true;
  bool textfield = true;
  bool completeSurvey = true;

  void _nextQuestion() {
    setState(() {
      if (_selectedOption != null) {
        if (_selectedOption == '🥵') {
          choice = 1;
        } else if (_selectedOption == '😢') {
          choice = 2;
        } else if (_selectedOption == '🤔') {
          choice = 3;
        } else if (_selectedOption == '😍') {
          choice = 4;
        } else if (_selectedOption == '🥰') {
          choice = 5;
        }

        _selectedAnswers.add(_selectedOption!);

        SelectedAnswers.add(choice!);
        _selectedOption = null;

        // Check if there are more questions, and if so, advance to the next one.
        if (_currentQuestionIndex < widget.questions.length - 1) {
          _currentQuestionIndex++;
          Debugs(_currentQuestionIndex);
        } else {
          // Handle quiz completion here (e.g., show results or navigate to another screen).
          // For now, we'll just Debugs the selected answers.
          Debugs(_selectedAnswers);
        }
      } else {
        _currentQuestionIndex++;
      }
    });
  }

  int? numPages;
  @override
  void initState() {
    super.initState();
    Debugs('questions is : ${widget.questions}');
    numPages = widget.questions.length;
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < numPages!; i++) {
      list.add(
          i == _currentQuestionIndex ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 7.0,
      width: isActive ? 24.0 : 12.0,
      decoration: BoxDecoration(
        color: isActive ? Color(0xFFFF942F) : Colors.black26,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  var starRating = 1.0;

  void setStarRating(double rating) {
    setState(() {
      starRating = rating;
    });
  } // <- Missing closing brace for setStarRating method\

  void _showAlert(BuildContext context, String Emoji) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Hero(
          tag: 'Sticker',
          child: Center(
            child: AnimatedContainer(
              duration: Duration(seconds: 2),
              child: Text(
                "$Emoji",
                style: TextStyle(color: Colors.red, fontSize: 100),
              ),
            ),
          ),
        );
      },
    );
  }

  void ShowStar(BuildContext context, double Emoji) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Hero(
          tag: 'Sticker',
          child: Center(
            child: AnimatedContainer(
              duration: Duration(seconds: 1),
              child: Stack(alignment: Alignment.center, children: [
                Icon(
                  Icons.star_rounded,
                  color: Colors.yellowAccent,
                  size: 200,
                ),
                Text(
                  "$Emoji",
                  style: TextStyle(color: Colors.redAccent, fontSize: 50),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildPageIndicator(),
        ),
        SizedBox(
          height: 5,
        ),
        if (_currentQuestionIndex > 5)
          Padding(
            padding: const EdgeInsets.only(left: 18, right: 18),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.deepPurple[50],
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundImage: NetworkImage(widget.picture),
                      ),
                      SizedBox(width: 10),
                      Text(
                        widget.name.length >= 14
                            ? '${widget.name.substring(0, 11)}...'
                            : widget.name,
                        style: TextStyle(
                          fontFamily: "Sofia",
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'asked',
                        style: TextStyle(
                          fontFamily: "Sofia",
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30, right: 10),
                      child: Text(
                        widget.questions[_currentQuestionIndex],
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: "lemon",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 20, bottom: 20),
            child: Text(
              widget.questions[_currentQuestionIndex],
              style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500),
            ),
          ),
        textfield
            ? Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _options[_currentQuestionIndex]
                      .map((option) => TextButton(
                            onPressed: () async {
                              setState(() {
                                _selectedOption = option;
                                _showAlert(context, _selectedOption!);

                                Future.delayed(Duration(milliseconds: 400), () {
                                  Navigator.pop(context);
                                });
                              });
                              _nextQuestion();
                              if (_currentQuestionIndex == 4) {
                                Debugs("heeel");
                                setState(() {
                                  textfield = false;
                                });
                              }
                            },
                            style: ButtonStyle(
                              side: MaterialStateProperty.all<BorderSide>(
                                BorderSide(
                                  color: _selectedOption == option
                                      ? Colors
                                          .yellowAccent // Selected option color
                                      : Colors.black, // Default color
                                  width: 0.1,
                                ),
                              ),
                            ),
                            child: Hero(
                              tag: 'Sticker',
                              child: Text(
                                option,
                                style: TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              )
            : Startext
                ? Container(
                    child: buildStar(),
                  )
                : completeSurvey
                    ? Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 20.0,
                          ),
                          child: Container(
                            height: 50.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 10.0,
                                      color: Colors.black12.withOpacity(0.1)),
                                ],
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0))),
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
                                      onSaved: (input) => input = input,
                                      controller: Discr,
                                      decoration: InputDecoration(
                                        hintText:
                                            "Write Suggestion or Comment (Opticonal)",
                                        hintStyle: TextStyle(
                                            fontSize: 13,
                                            fontFamily: "Sofia",
                                            color: Colors.black),
                                        enabledBorder: new UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 1.0,
                                              style: BorderStyle.none),
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : _currentQuestionIndex == 6 && _currentQuestionIndex != ""
                        ? Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 50.0,
                                right: 20.0,
                              ),
                              child: Container(
                                height: 50.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 10.0,
                                          color:
                                              Colors.black12.withOpacity(0.1)),
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0))),
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
                                          onSaved: (input) => input = input,
                                          controller: Askquestion1,
                                          decoration: InputDecoration(
                                            hintText:
                                                "Replay to ${widget.name} (Opticonal)",
                                            hintStyle: TextStyle(
                                                fontFamily: "Sofia",
                                                color: Colors.black),
                                            enabledBorder:
                                                new UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 1.0,
                                                  style: BorderStyle.none),
                                            ),
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : _currentQuestionIndex == 7 &&
                                _currentQuestionIndex != ""
                            ? Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 50.0,
                                    right: 20.0,
                                  ),
                                  child: Container(
                                    height: 50.0,
                                    width: double.infinity,
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
                                              onSaved: (input) => input = input,
                                              controller: Askquestion2,
                                              decoration: InputDecoration(
                                                hintText:
                                                    "Replay to ${widget.name} (Opticonal)",
                                                hintStyle: TextStyle(
                                                    fontFamily: "Sofia",
                                                    color: Colors.black),
                                                enabledBorder:
                                                    new UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white,
                                                      width: 1.0,
                                                      style: BorderStyle.none),
                                                ),
                                              )),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : _currentQuestionIndex == 8 &&
                                    _currentQuestionIndex != ""
                                ? Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 50.0,
                                        right: 20.0,
                                      ),
                                      child: Container(
                                        height: 50.0,
                                        width: double.infinity,
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
                                                  onSaved: (input) =>
                                                      input = input,
                                                  controller: Askquestion3,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Replay to ${widget.name} (Opticonal)",
                                                    hintStyle: TextStyle(
                                                        fontFamily: "Sofia",
                                                        color: Colors.black),
                                                    enabledBorder:
                                                        new UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.white,
                                                          width: 1.0,
                                                          style:
                                                              BorderStyle.none),
                                                    ),
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
        SizedBox(height: 10.0),
        if (_currentQuestionIndex > 3)
          ElevatedButton(
            onPressed: () async {
              Debugs('_currentQuestionIndex:$_currentQuestionIndex');

              if (_currentQuestionIndex == 4) {
                setState(() {
                  Startext = false;
                  _currentQuestionIndex++;
                  ShowStar(context, starRating);

                  Future.delayed(Duration(milliseconds: 400), () {
                    Navigator.pop(context);
                  });
                });
              } else if (_currentQuestionIndex == 5 &&
                  widget.questions.length - 1 > 5) {
                setState(() {
                  completeSurvey = false;
                  _currentQuestionIndex++;
                });
              } else if (_currentQuestionIndex == widget.questions.length - 1) {
                Debugs("question end");
                Survey();
              } else {
                _nextQuestion();
              }
            },
            child: _currentQuestionIndex > 4 &&
                    widget.questions.length - 1 == _currentQuestionIndex
                ? Text(
                    'Post',
                    style: TextStyle(fontSize: 18.0),
                  )
                : Text(
                    'Next',
                    style: TextStyle(fontSize: 18.0),
                  ),
          ),
      ],
    );
  }
}

class ShimerDown extends StatelessWidget {
  const ShimerDown({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!, // Color when not shimmering
              highlightColor: Colors.grey[100]!, // Color when shimmering
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                height: 7.0,
                width: 24.0,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!, // Color when not shimmering
              highlightColor: Colors.grey[100]!, // Color when shimmering
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                height: 7.0,
                width: 12.0,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!, // Color when not shimmering
              highlightColor: Colors.grey[100]!, // Color when shimmering
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                height: 7.0,
                width: 12.0,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!, // Color when not shimmering
              highlightColor: Colors.grey[100]!, // Color when shimmering
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                height: 7.0,
                width: 12.0,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!, // Color when not shimmering
              highlightColor: Colors.grey[100]!, // Color when shimmering
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                height: 7.0,
                width: 12.0,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!, // Color when not shimmering
              highlightColor: Colors.grey[100]!, // Color when shimmering
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                height: 7.0,
                width: 12.0,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!, // Color when not shimmering
              highlightColor: Colors.grey[100]!, // Color when shimmering
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                height: 7.0,
                width: 12.0,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!, // Color when not shimmering
              highlightColor: Colors.grey[100]!, // Color when shimmering
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                height: 7.0,
                width: 12.0,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!, // Color when not shimmering
              highlightColor: Colors.grey[100]!, // Color when shimmering
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                height: 7.0,
                width: 12.0,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!, // Color when not shimmering
          highlightColor: Colors.grey[100]!, // Color when shimmering
          child: Container(
            height: 18.0,
            width: 270.0,
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
          ),
        ),
        SizedBox(
          height: 18,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 45,
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!, // Color when not shimmering
              highlightColor: Colors.grey[100]!, // Color when shimmering
              child: Container(
                height: 18.0,
                width: 55.0,
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 18,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Shimmer.fromColors(
              child: Container(
                width: 55,
                height: 43,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(22))),
              ),
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
            ),
            Shimmer.fromColors(
              child: Container(
                width: 55,
                height: 43,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(22))),
              ),
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
            ),
            Shimmer.fromColors(
              child: Container(
                width: 55,
                height: 43,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(22))),
              ),
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
            ),
            Shimmer.fromColors(
              child: Container(
                width: 55,
                height: 43,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
            ),
            Shimmer.fromColors(
              child: Container(
                width: 55,
                height: 43,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(22))),
              ),
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
            ),
          ],
        ),
        SizedBox(
          height: 7,
        ),
      ],
    );
  }
}




  // Widget build(BuildContext context) {
  //   return Container(
  //     width: double.infinity,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.only(
  //         bottomLeft: Radius.circular(30),
  //         bottomRight: Radius.circular(30),
  //       ),
  //     ),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         AnimatedContainer(
  //           duration: Duration(seconds: 2),
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.only(
  //               bottomLeft: Radius.circular(35),
  //               bottomRight: Radius.circular(35),
  //             ),
  //             color: Colors.white,
  //           ),
  //           child: Center(
  //             child: Column(
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.only(
  //                     left: 30,
  //                     right: 30,
  //                     top: 20,
  //                   ),
  //                   child: Text(
  //                     '${currentIndex + 1} ${Questions[currentIndex]}',
  //                     style: TextStyle(
  //                       color: Colors.black,
  //                       fontSize: 22,
  //                       fontFamily: "Sofia",
  //                     ),
  //                   ),
  //                 ),
  //                 if (showDialog) // Conditionally render based on showDialog
  //                   _buildRatingWidget()
  //                 else if (q == 5)
  //                   _buildStarRow()
  //                 else if (q < 6)
  //                   _buildTextButtons()
  //                 else
  //                   _buildReviewInput(),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildRatingWidget() {
  //   return Stack(
  //     alignment: Alignment.center,
  //     children: [
  //       Icon(
  //         Icons.star_rounded,
  //         size: 100,
  //         color: Colors.yellow,
  //       ),
  //       Text(
  //         "4.4",
  //         style: TextStyle(color: Colors.redAccent, fontSize: 20),
  //       ),
  //     ],
  //   );
  // }

//   Widget _buildStarRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(1, (index) => buildStar(index)),
//     );
//   }

//   Widget _buildTextButtons() {
//     return Row(
//       children: [
//         _buildTextButton("good"),
//         _buildTextButton("good"),
//         _buildTextButton("good"),
//         _buildTextButton("good"),
//         _buildTextButton("good"),
//       ],
//     );
//   }

//   Widget _buildTextButton(String label) {
//     return TextButton(
//       onPressed: () {
//         setState(() {
//           q = q + 1;
//           setStarRating(q.toDouble());
//         });
//       },
//       child: Text(label),
//     );
//   }

//   Widget _buildReviewInput() {
//     return Column(
//       children: [
//         Container(
//           height: 50.0,
//           width: 300,
//           decoration: BoxDecoration(
//             boxShadow: [
//               BoxShadow(
//                 blurRadius: 10.0,
//                 color: Colors.black12.withOpacity(0.1),
//               ),
//             ],
//             color: Colors.white,
//             borderRadius: BorderRadius.all(
//               Radius.circular(40.0),
//             ),
//           ),
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//               child: Theme(
//                 data: ThemeData(
//                   highlightColor: Colors.white,
//                   hintColor: Colors.white,
//                 ),
//                 child: TextFormField(
//                   validator: (input) {},
//                   onSaved: (input) => input = input,
//                   controller: Review,
//                   decoration: InputDecoration(
//                     hintText: "Suggestion or Review",
//                     hintStyle:
//                         TextStyle(fontFamily: "Sofia", color: Colors.black),
//                     enabledBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Colors.white,
//                         width: 1.0,
//                         style: BorderStyle.none,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         ElevatedButton.icon(
//           onPressed: () {},
//           icon: Icon(Icons.upload),
//           label: Text("Upload"),
//         ),
//       ],
//     );
//   }
// }