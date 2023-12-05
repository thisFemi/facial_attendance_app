import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:printing/printing.dart';

import '../../models/attendance_models.dart';
import '../../utils/pdfexpot.dart';
import '../../widgets/custom_appBar.dart';

class PdfPreviewPage extends StatelessWidget {
  Session session;
  Course course;
  Attendance attendance;
  Semester semester;

  PdfPreviewPage(
      {Key? key,
      required this.session,
      required this.course,
      required this.attendance,
      required this.semester})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          context: context,
          showArrowBack: true,
          title: 'Attendance',
          centerTitle: true),
      body: PdfPreview(
        build: (context) => makePdf(session, semester, course, attendance),
      ),
    );
  }
}
