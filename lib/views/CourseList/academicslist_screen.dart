import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/Common.dart';
import '../../utils/colors.dart';
import 'semest_list_screen.dart';

class AcademicsScreen extends StatefulWidget {
  AcademicsScreen({super.key});

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Title(
                color: AppColors.black,
                child: Text(
                  'Sessions',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
            Spacer(),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  'Add',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.lightWhite),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
              itemCount: 20,
              shrinkWrap: true,
              itemBuilder: (ctx, index) {
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 4),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(5),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => SemestersScreen(
                                  // user: widget.user,
                                  )));
                    },
                    child: ListTile(
                      title: Text(
                        "2017/2018",
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
        )
      ]),
    );
  }
}
