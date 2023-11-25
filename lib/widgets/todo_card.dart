import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  const TodoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
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
            "Complete\nRegistration",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }
}
