import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final displaySize = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: [
          Card(
            margin: EdgeInsets.only(top: 10),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all()),
              child: Column(),
            ),
          )
        ],
      ),
    );
  }
}
