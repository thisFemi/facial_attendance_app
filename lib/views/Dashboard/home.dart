import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/Common.dart';
import '../../utils/colors.dart';
import '../../widgets/notification_icon.dart';
import '../Settings/Profile/notification_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 40, left: 20, right: 20),
      width: Screen.deviceSize(context).width,
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                    Screen.deviceSize(context).height * .03),
                child: CachedNetworkImage(
                  height: Screen.deviceSize(context).height * .05,
                  width: Screen.deviceSize(context).height * .05,
                  fit: BoxFit.cover,
                  imageUrl: "APIs.userInfo.image",
                  errorWidget: (context, url, error) => CircleAvatar(
                    child: Icon(CupertinoIcons.person),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: Screen.deviceSize(context).width / 2,
                    child: Text(
                      'Hello ${"APIs.userInfo.name"} 🎉',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Be on time!',
                    style: TextStyle(
                        color: AppColors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => NotificationScreen()));
                },
                child: NotificationIcon(
                  iconData: Icons.notifications_none_rounded,
                  showDot: true,
                ),
              )
            ],
          ),
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
