import 'package:flutter/material.dart';

class OnboardingSlide extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  OnboardingSlide(
      {required this.description, required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          image,
          height: 200,
        ),
        SizedBox(
          height: 32.0,
        ),
        Text(
          title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 16.0,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 48.0,
          ),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
          ),
        )
      ],
    );
  }
}
