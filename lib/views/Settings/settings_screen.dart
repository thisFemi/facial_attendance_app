import 'package:attend_sense/views/Auth/login.dart';
import 'package:attend_sense/views/Settings/Profile/edit_profile_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../api/apis.dart';
import '../../utils/Common.dart';
import '../../utils/colors.dart';
import '../Others/coming_soon_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
    // APIs.getSelfInfo();APIs.fetchApplication();
    print('updated');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Container(
        height: Screen.deviceSize(context).height,
        color: AppColors.white,
        padding: const EdgeInsets.only(top: 40, bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              width: Screen.deviceSize(context).width,
              padding: const EdgeInsets.only(bottom: 10, top: 0),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: .5, color: AppColors.grey))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                        Screen.deviceSize(context).height * .03),
                    child: CachedNetworkImage(
                      height: Screen.deviceSize(context).height * .08,
                      width: Screen.deviceSize(context).height * .08,
                      fit: BoxFit.cover,
                      imageUrl: APIs.userInfo.userInfo == null
                          ? ""
                          : APIs.userInfo.userInfo!.imgUrl,
                      // placeholder: (context, url) => CircularProgressIndicator(
                      //   color: color3,
                      // ),
                      errorWidget: (context, url, error) => const CircleAvatar(
                        child: Icon(CupertinoIcons.person),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    APIs.userInfo.name,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    APIs.userInfo.userInfo != null &&
                            APIs.userInfo.userInfo!.matricNumber != ""
                        ? APIs.userInfo.userInfo!.matricNumber
                        : APIs.userInfo.email,
                    style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1),
                  ),
                ],
              ),
            ),
            profileTiles(CupertinoIcons.person, 'Edit profile', () async {
              print("object");
              final profileUpdated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => EditProfileScreen(
                            userInfo: APIs.userInfo,
                          )));
              if (profileUpdated == true) {
                setState(() {});
              }
            }),

            profileTiles(Icons.contact_support_rounded, 'Help center', () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ComingSoon(
                            label: 'Support ',
                          )));
            }),
            // profileTiles(CupertinoIcons.person_3, 'Invite friends', () {}),
            profileTiles(CupertinoIcons.info, 'App info', () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ComingSoon(
                            label: 'App Info',
                          )));
            }),

            ListTile(
              minLeadingWidth: 2,
              leading: const Icon(
                Icons.logout,
                color: AppColors.red,
              ),
              title: const Text(
                'Log Out',
                style: TextStyle(
                    color: AppColors.red, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                logoutDialog();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget profileTiles(
    IconData icon,
    String title,
    Function() function,
  ) {
    return ListTile(
      minLeadingWidth: 2,
      leading: Icon(
        icon,
        color: AppColors.black,
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: const Icon(
        CupertinoIcons.forward,
        color: AppColors.lightGrey,
      ),
      onTap: function,
    );
  }

  void logoutDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          alignment: Alignment.center,
          actionsPadding:
              const EdgeInsets.only(bottom: 11, left: 10, right: 10),
          titlePadding: const EdgeInsets.only(top: 20, bottom: 1),
          title: const Text(
            "Logout",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Are you sure you want to logout this accoount?.You will loose all information and can't undo this action.",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.grey),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          actions: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Adjust the radius as needed
                      ),
                      side: const BorderSide(color: Colors.grey),
                    ),
                    // Customize the button's appearance
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: AppColors.grey),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ),
                const SizedBox(width: 8), // Add a small space between buttons
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                      backgroundColor: AppColors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Adjust the radius as needed
                      ),
                    ),
                    //color: Colors.green, // Customize the button's appearance
                    child: const Text(
                      "Logout",
                      style: TextStyle(color: AppColors.white),
                    ),
                    onPressed: () async {
                      await APIs.logOut();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => Login()),
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
