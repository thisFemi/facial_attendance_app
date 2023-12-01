import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  TodoCard({super.key, required this.onTap, required this.title});
  Function onTap;
  String title;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      borderRadius: BorderRadius.circular(10),
      child: Card(
        color: Colors.blue.shade50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          height: 60,
          width: 80,
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
          ),
          child: Center(
              child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }
}
