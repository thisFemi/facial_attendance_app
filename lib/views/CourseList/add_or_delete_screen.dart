import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../widgets/custom_appBar.dart';
import 'courses_add_or_delete.dart';

class AddOrDeleteListScreen extends StatelessWidget {
  AddOrDeleteListScreen({super.key});

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
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Expanded(
            child: ListView.builder(
                itemCount: sessions.length,
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  final sesion = sessions[index];
                  return AddOrDeleteSessionCard(session: sesion.session);
                })),
      ),
    );
  }

  final sessions = [
    AddOrDeleteSessionCard(session: "2019/2020"),
    AddOrDeleteSessionCard(session: "2020/2021"),
    AddOrDeleteSessionCard(session: "2021/2022")
  ];
}

class AddOrDeleteSessionCard extends StatelessWidget {
  String session;
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
                        session,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      expanded: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 1,
                        itemBuilder: (ctx, index) {
                          return Column(
                            children: [
                              SemesterCard(
                                semester: 1,
                                sessioon: session,
                              ),
                              SemesterCard(
                                semester: 2,
                                sessioon: session,
                              ),
                            ],
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
  int semester;
  String sessioon;
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
      title: Text("${semester} Semester"),
    );
  }
}
