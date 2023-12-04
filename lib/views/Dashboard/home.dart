import 'package:attend_sense/widgets/course_card.dart';
import 'package:attend_sense/widgets/todo_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../api/apis.dart';
import '../../models/attendance_models.dart';
import '../../models/dummy.dart';
import '../../models/user_model.dart';
import '../../utils/Common.dart';
import '../../utils/colors.dart';
import '../../widgets/notification_icon.dart';
import '../CourseList/course_registration.dart';
import '../Settings/Profile/notification_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TodoCard> todos = [];

  @override
  void initState() {
    initTodos();
    // APIs.academicRecords = DUMMY.dummyAcademicRecords.last;
    super.initState();
  }

  void initTodos() {
    if (APIs.userInfo.phoneNumber == "") {
      todos.add(
        TodoCard(
            onTap: () {
              print("do registratin");
            },
            title: "Compelete\nRegistation"),
      );
    }
    if (APIs.academicRecords == null) {
      todos.add(
        TodoCard(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const CourseRegScreen()));
            },
            title: "Register\nSession"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLecturer = APIs.userInfo.userType == UserType.staff;
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
                  // color: AppColors.black,
              height: Screen.deviceSize(context).height * .05,
                  width: Screen.deviceSize(context).height * .05,
                  fit: BoxFit.cover,
                  imageUrl: APIs.userInfo.userInfo != null
                      ? APIs.userInfo.userInfo!.imgUrl
                      : "",
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
                        child: Text(
                          'Hello, ${APIs.userInfo.name}🎉',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
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
          StreamBuilder(
              stream: APIs.fetchAcademicData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  /// print(snapshot.data!.data()!);
                  return const Center(
                      child:
                          CircularProgressIndicator()); // Loading indicator while waiting for data
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 30.0),
                        child:
                            Center(child: Text('Academic records not found!')),
                      ));
                }
                // print(snapshot.data!.data()!['academicRecords']);
                final studentData = UserData.fromJson(
                    snapshot.data!.data()!['academicRecords']);
                print(studentData);
                APIs.academicRecords = studentData;

                return Column(
                  children: [
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
                              percent: studentData.getTotalPresent().toDouble(),
                              center: Text(
                                "${studentData.getTotalPresent() * 100}%",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                              backgroundColor: AppColors.lightGrey,
                              progressColor: AppColors.black,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              height: double.infinity,
                              width: 1,
                              color: AppColors.lightGrey,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Overall Stats',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      child: Text(
                                        "Total Semesters : ${studentData.getTotalSemesters()}",
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      child: Text(
                                        "Total Courses : ${studentData.getTotalCourses()}",
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                !isLecturer
                                    ? Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(11),
                                                decoration: const BoxDecoration(
                                                    color: AppColors.black,
                                                    shape: BoxShape.circle),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0),
                                                child: SizedBox(
                                                  child: Text(
                                                    "Total Present : ${studentData.getTotalPresent()}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(11),
                                                decoration: const BoxDecoration(
                                                    color: AppColors.lightGrey,
                                                    shape: BoxShape.circle),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0),
                                                child: SizedBox(
                                                  child: Text(
                                                    "Total Absent : ${studentData.getTotalAbsent()}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                    : SizedBox.shrink()
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SingleChildScrollView(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Frequent Courses ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        ListView.builder(
                            itemCount: studentData
                                .sessions.last.semesters.last.courses.length,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (ctx, index) {
                              final course =  studentData
                                .sessions.last.semesters.last.courses[index];
                              return CourseCard(
                                  progress:
                                      course.calculateAttendancePercentage(),
                                  showPecentage: true,
                                  onTap: () {},
                                  title: course.courseId);
                            }),
                      ],
                    )),
                  ],
                );
              }),
          (APIs.userInfo.phoneNumber == "" || APIs.academicRecords == null)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'To Do  ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                          itemCount: todos.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (ctx, index) {
                            final todo = todos[index];
                            return TodoCard(
                              onTap: todo.onTap,
                              title: todo.title,
                            );
                          }),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}
