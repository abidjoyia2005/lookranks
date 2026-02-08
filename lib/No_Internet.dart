import 'package:flutter/material.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/images/404Eror.png'),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No Internet',
                style: TextStyle(
                    fontFamily: 'Lemon',
                    fontWeight: FontWeight.w800,
                    fontSize: 20),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(
            'Page not found. Please check your internet connection and then refresh.',
            style: TextStyle(
                fontFamily: 'Sofia', fontWeight: FontWeight.w600, fontSize: 17),
          ),
        ),
      ],
    );
  }
}
