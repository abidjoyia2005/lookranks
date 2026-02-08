import 'package:flutter/material.dart';

class yourreciper extends StatefulWidget {
  const yourreciper({super.key});

  @override
  State<yourreciper> createState() => _yourreciperState();
}

class _yourreciperState extends State<yourreciper> {
  var input;
 TextEditingController name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(
      child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 100.0),
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
                                      BorderRadius.all(Radius.circular(40.0))),
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
                                        validator: (input) {
                                         
                                        },
                                        onSaved: (input) =>
                                            input = input,
                                        controller: name,
                                        decoration: InputDecoration(
                                          hintText: "Your Name",
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
    ));
  }
}
