import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../api/apis.dart';
import '../../models/attendance_models.dart';
import '../../utils/Common.dart';
import '../../utils/colors.dart';
import 'semest_list_screen.dart';

class AcademicsScreen extends StatefulWidget {
  const AcademicsScreen({super.key});

  @override
  State<AcademicsScreen> createState() => _AcademicsScreenState();
}

class _AcademicsScreenState extends State<AcademicsScreen> {
  List _searchList = [];

  List list = [];

  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Screen.deviceSize(context).width,
      padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
      color: AppColors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Title(
                color: AppColors.black,
                child: const Text(
                  'Sessions',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),

            // GestureDetector(
            //   onTap: () {},
            //   child: Container(
            //     padding: EdgeInsets.all(5),
            //     decoration: BoxDecoration(
            //         color: AppColors.black,
            //         borderRadius: BorderRadius.circular(5)),
            //     child: Text(
            //       'Add',
            //       style: TextStyle(
            //           fontWeight: FontWeight.bold, color: AppColors.lightWhite),
            //     ),
            //   ),
            // ),
          ],
        ),
        StreamBuilder(
            stream: APIs.fetchAcademicData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Loading indicator while waiting for data
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Text('Student Info does not exist');
              }
              final studentData = StudentData.fromJson(snapshot.data!.data()!);

              return Expanded(
                child: ListView.builder(
                    itemCount: studentData.sessions.length,
                    shrinkWrap: true,
                    itemBuilder: (ctx, index) {
                      final session = studentData.sessions[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(5),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => SemestersScreen(
                                 session: session,
                                        )));
                          },
                          child: ListTile(
                            title: Text(
                              session.sessionYear,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                            ),
                          ),
                        ),
                      );
                    }),
              );
            })
      ]),
    );
  }
}
