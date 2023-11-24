import 'package:flutter/material.dart';

class NotificationIcon extends StatelessWidget {
  final IconData iconData; // Icon to display
  final bool showDot; // Whether to show the red dot indicator

  NotificationIcon({
    required this.iconData,
    this.showDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(5),
          decoration:BoxDecoration(color: Colors.grey[200], shape:BoxShape.circle)
         , child: Icon(
            iconData,
            size: 24,
          ),
        ), // Display the main icon
        if (showDot)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                '1', // You can change this to display the number of notifications
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
