import 'package:attend_sense/utils/date_util.dart';

import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart';

import 'package:pdf/pdf.dart';

import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

import '../models/attendance_models.dart';

Future<Uint8List> makePdf(
  Session session,
  Semester semester,
  Course course,
  Attendance attendance,
) async {
  final Document pdf = Document();
  final imageLogo = MemoryImage(
    (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List(),
  );

  pdf.addPage(Page(build: (Context context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: Image(imageLogo),
            ),
            Spacer(),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'ADEKUNLE AJASIN UNIVERSITY, AKUNGBA-AKOKO',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'PMB 001, AKUNGBA-AKOKO, ONDO STATE OF NIGERIA',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'ATTENDANCE REPORT',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
        Divider(
          height: 2,
        ),
        SizedBox(height: 20),
        Text(
          'INFORMATION',
          style: TextStyle(
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "ACADEMIC SESSION: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          session.sessionYear,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "SEMESTER  ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          semester.semesterNumber.toString(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Course Title ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          course.courseName,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Text(
          'ATTENDANCE LIST',
          style: TextStyle(
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 5),
        Table(
          border: TableBorder.all(color: PdfColors.black),
          children: [
            TableRow(children: [
              Expanded(child: PaddedText('Matric Number'), flex: 1),
              Expanded(child: PaddedText('Name'), flex: 2),
            ]),
            // Loop through students and include only those present
            for (var student in attendance.students ?? [])
              if (student.isPresent)
                TableRow(children: [
                  Expanded(
                    child: PaddedText(student.matricNumber ?? ''),
                    flex: 1,
                  ),
                  Expanded(
                    child: PaddedText(student.studentName ?? ''),
                    flex: 2,
                  ),
                ]),
          ],
        ),
        Spacer(),
        Divider(),
        Align(
            alignment: Alignment.center,
            child:
                Text('Generated on ${DateUtil.formatDateTime(DateTime.now())}'))
      ],
    );
  }));
  return pdf.save();
}

Widget PaddedText(
  final String text, {
  final TextAlign align = TextAlign.left,
}) =>
    Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        text,
        textAlign: align,
      ),
    );
