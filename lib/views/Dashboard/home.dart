import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../utils/Common.dart';
import '../../utils/colors.dart';
import '../../widgets/notification_icon.dart';
import '../Settings/Profile/notification_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
      width: Screen.deviceSize(context).width,
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                    Screen.deviceSize(context).height * .03),
                child: CachedNetworkImage(
                  color: AppColors.black,
                  width: Screen.deviceSize(context).height * .05,
                  fit: BoxFit.cover,
                  imageUrl: "APIs.userInfo.image",
                  errorWidget: (context, url, error) => const CircleAvatar(
                    backgroundColor: AppColors.black,
                    child: Icon(
                      CupertinoIcons.person,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: Screen.deviceSize(context).width / 2.7,
                        child: const Text(
                          'Hello, ${"APIs.userInfo.name"}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      const Text(
                        '🎉',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    'Be on time!',
                    style: TextStyle(
                        color: AppColors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const NotificationScreen()));
                },
                child: NotificationIcon(
                  iconData: Icons.notifications_none_rounded,
                  showDot: true,
                ),
              )
            ],
          ),
          Card(
            margin: const EdgeInsets.only(top: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 3,
            child: Container(
              height: Screen.deviceSize(context).height / 5,
              width: Screen.deviceSize(context).width,
              padding: const EdgeInsets.all(10),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircularPercentIndicator(
                    radius: Screen.deviceSize(context).height * .08,
                    curve: Curves.linear,
                    animation: true,
                    animationDuration: 1200,
                    lineWidth: 15.0,
                    circularStrokeCap: CircularStrokeCap.round,
                    percent: 0.50,
                    center: new Text(
                      "50%",
                      style: new TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                    backgroundColor: AppColors.lightGrey,
                    progressColor: AppColors.black,
                  ),
                  const Spacer(),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Overall Stats',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.circle,
                            color: AppColors.algaeBrown,
                            size: 18,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5.0),
                            child: SizedBox(
                              child: Text(
                                "Total Courses: 45",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
