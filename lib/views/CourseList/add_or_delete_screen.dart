import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import '../../api/apis.dart';
import '../../models/attendance_models.dart';
import '../../utils/colors.dart';
import '../../widgets/custom_appBar.dart';
import 'courses_add_or_delete.dart';

class AddOrDeleteListScreen extends StatefulWidget {
  AddOrDeleteListScreen({super.key});

  @override
  State<AddOrDeleteListScreen> createState() => _AddOrDeleteListScreenState();
}

class _AddOrDeleteListScreenState extends State<AddOrDeleteListScreen> {
  List<Session> sessions = [];

  @override
  void initState() {
    sessions =
        APIs.academicRecords == null ? [] : APIs.academicRecords!.sessions;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          centerTitle: true,
          context: context,
          showArrowBack: true,
          actions: [
            // GestureDetector(
            //   onTap: () {},
            //   child: Container(
            //     margin: EdgeInsets.all(15),
            //     padding: EdgeInsets.all(5),
            //     decoration: BoxDecoration(
            //         color: AppColors.black,
            //         borderRadius: BorderRadius.circular(5)),
            //     child: Text(
            //       'Add',
            //       style: const TextStyle(
            //           fontWeight: FontWeight.bold, color: AppColors.lightWhite),
            //     ),
            //   ),
            // ),
          ],
          title: "Add Or Delete"),
      backgroundColor: AppColors.white,
      body:sessions.isNotEmpty? Padding(
        padding: EdgeInsets.all(16),
        child: ListView.builder(
            itemCount: sessions.length,
            shrinkWrap: true,
            itemBuilder: (ctx, index) {
              final sesion = sessions[index];
              return AddOrDeleteSessionCard(session: sesion);
            })
      ):Center(child: Text("No Records found."),),
    );
  }
}

class AddOrDeleteSessionCard extends StatelessWidget {
  Session session;
  AddOrDeleteSessionCard({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: ExpandableNotifier(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              children: [
                ScrollOnExpand(
                    scrollOnExpand: true,
                    scrollOnCollapse: false,
                    child: ExpandablePanel(
                      collapsed: SizedBox.shrink(),
                      theme: const ExpandableThemeData(
                        headerAlignment: ExpandablePanelHeaderAlignment.center,
                        tapBodyToCollapse: true,
                      ),
                      header: Text(
                        session.sessionYear,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      expanded: ListView.builder(
                        shrinkWrap: true,
                        itemCount: session.semesters.length,
                        itemBuilder: (ctx, index) {
                          final semester = session.semesters[index];
                          return SemesterCard(
                            semester: semester,
                            sessioon: session,
                          );
                        },
                      ),
                      builder: (_, collapsed, expanded) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          child: Expandable(
                            collapsed: collapsed,
                            expanded: expanded,
                            theme: const ExpandableThemeData(crossFadePoint: 0),
                          ),
                        );
                      },
                    )),
              ],
            ),
          ),
        ));
  }
}

class SemesterCard extends StatelessWidget {
  Semester semester;
  Session sessioon;
  SemesterCard({super.key, required this.semester, required this.sessioon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => AddOrDeleteScreen(
                      semester: semester,
                      session: sessioon,
                    )));
      },
      title: Text("Semester ${semester.semesterNumber}"),
    );
  }
}
