import 'package:flutter/material.dart';
import 'package:flutter_application_1/search_result.dart';
import 'package:http/http.dart' as https;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class search_screen extends StatefulWidget {
  var btoken;
  search_screen({required this.btoken});
  @override
  State<search_screen> createState() => _search_screenState(btoken: btoken);
}

class _search_screenState extends State<search_screen> {
  var btoken;
  _search_screenState({required this.btoken});
  TextEditingController search = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Create a GlobalKey for the Form

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "search",
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.yellow[700]),
          centerTitle: true, // Center the title
          title: Text("Search"),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Image.asset('assets/images/searchscreen.png'),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              child: Form(
                key: _formKey, // Associate the GlobalKey with the Form
                child: Container(
                  height: 60.0,
                  width: double.infinity,
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
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Theme(
                        data: ThemeData(
                          highlightColor: Colors.white,
                          hintColor: Colors.white,
                        ),
                        child: TextFormField(
                          validator: (input) {
                            if (input == null || input.isEmpty) {
                              return 'Please Enter UserName in this field';
                            }
                            return null; // Return null to indicate no error.
                          },
                          onSaved: (input) => input = input,
                          controller: search,
                          decoration: InputDecoration(
                            hintText: "      Enter User Name",
                            hintStyle: TextStyle(
                              fontFamily: "Sofia",
                              color: Colors.black,
                            ),
                            enabledBorder: new UnderlineInputBorder(
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
              ),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  // Only perform the search if the form is valid
                  String sr = search.text;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Search_result(btoken: btoken, search: search.text),
                      ));
                  // loadData(sr, btoken);
                  // Debugs(sr);
                }
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
                        Color(0xFFFEE140),
                        Color(0xFFFF942F),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Search",
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
          ]),
        ),
      ),
    );
  }
}
