import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:collection/collection.dart';

import '../../api/apis.dart';
import '../../models/attendance_models.dart';
import '../../utils/Common.dart';
import '../../utils/colors.dart';
import '../../utils/dialogs.dart';
import '../../widgets/custom_appBar.dart';
import '../../widgets/custom_text_form_field.dart';

class CourseRegScreen extends StatefulWidget {
  const CourseRegScreen({Key? key}) : super(key: key);

  @override
  State<CourseRegScreen> createState() => _CourseRegScreenState();
}

class _CourseRegScreenState extends State<CourseRegScreen> {
  Session? selectedSession;
  int? selectedSemester;
  bool _isLoading = false;

  List<Session> sessions = [];
  List<int> semesters = [];
  List<int> defaultSemester = [1, 2];

  @override
  void initState() {
    sessions = availableSessions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        showArrowBack: true,
        title: "Course Registration",
        centerTitle: true,
      ),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select Session',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      buildSessionDropdown(
                        items: sessions,
                        value: selectedSession,
                        onChanged: (value) {
                          setState(() {
                            selectedSession = value;
                            semesters = availableSemesters(selectedSession!);
                            courses.clear();
                            // selectedSemester =
                            //     semesters.isNotEmpty ? semesters.first : null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select Semester',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      buildDropdown(
                        items: semesters,
                        value: selectedSemester,
                        onChanged: (value) {
                          setState(() {
                            selectedSemester = value;
                            courses.clear();
                            final result = isSemesterSelected(
                                selectedSession!, selectedSemester!);
                            if (result) {
                              Dialogs.showSnackbar(context,
                                  "You can no longer regsiter for this semester");
                              selectedSemester = null;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              selectedSemester!=null? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Open modal sheet to add/remove courses
                    _showAddCourseModal();
                  },
                  child: const Text("Add Course"),
                ),
              ):SizedBox.shrink(),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                    itemCount: courses.length,
                    shrinkWrap: true,
                    itemBuilder: (ctx, index) {
                      final course = courses[index];
                      return Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          margin: const EdgeInsets.all(4),
                          child: ListTile(
                            title: Text(
                              course.courseId,
                            ),
                            subtitle: Text(course.courseName),
                            trailing: IconButton(
                                onPressed: () {
                                  courses.remove(course);
                                  setState(() {});
                                },
                                icon: Icon(
                                  CupertinoIcons.delete,
                                  color: AppColors.red,
                                )),
                          ));
                    }),
              ),
        courses.isNotEmpty?      Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: SizedBox(
                  height: 50.0,
                  width: Screen.deviceSize(context).width * 0.85,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.black,
                    ),
                    child: _isLoading
                        ? const SpinKitThreeBounce(
                            color: AppColors.offwhite, size: 40)
                        : const Text(
                            'Submit',
                            style: TextStyle(
                              color: AppColors.white,
                              fontFamily: 'Raleway-SemiBold',
                            ),
                          ),
                  ),
                ),
              ):SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }

  List<Session> availableSessions() {
    if (APIs.academicRecords == null) {
      return defaultSessions;
    } else {
      List<Session> filteredSessions = List.from(defaultSessions);

      for (int i = 0; i < APIs.academicRecords!.sessions.length; i++) {
        Session session = APIs.academicRecords!.sessions[i];
        if (session.semesters.length == 2) {
          // Exclude this session
          filteredSessions
              .removeWhere((s) => s.sessionYear == session.sessionYear);
          continue;
        }

        // Check if the session has 1 semester
        bool hasSemester1 =
            session.semesters.any((semester) => semester.semesterNumber == 1);
        bool hasSemester2 =
            session.semesters.any((semester) => semester.semesterNumber == 2);

        // If it has both semesters, exclude this session
        if (hasSemester1 && hasSemester2) {
          continue;
        }

        // If it has only 1 semester, include the missing semester
        if (hasSemester2 && !hasSemester1) {
          filteredSessions[i] = Session(
            sessionYear: session.sessionYear,
            semesters: [Semester(semesterNumber: 1, courses: [])],
          );
        } else if (hasSemester1 && !hasSemester2) {
          filteredSessions[i] = Session(
            sessionYear: session.sessionYear,
            semesters: [Semester(semesterNumber: 2, courses: [])],
          );
        } else {
          // If it's an empty session, include both semesters

          filteredSessions[i] = Session(
            sessionYear: session.sessionYear,
            semesters: [
              Semester(semesterNumber: 1, courses: []),
              Semester(semesterNumber: 2, courses: []),
            ],
          );
        }
      }

      // Add default sessions only if no matching sessions found
      if (filteredSessions.isEmpty) {
        filteredSessions.addAll(defaultSessions);
      }

      return filteredSessions;
    }
  }

  bool isSemesterSelected(Session selectedSession, int selectedSemester) {
    // Check if the selected semester exists for the selected session
    bool semesterExists = APIs.academicRecords?.sessions
            .where(
                (session) => session.sessionYear == selectedSession.sessionYear)
            .expand((session) => session.semesters)
            .any((semester) => semester.semesterNumber == selectedSemester) ??
        false;

    return semesterExists;
  }

  List<int> availableSemesters(Session selectedSession) {
    // If the selected session has both semesters, return [1, 2]
    if (selectedSession.semesters.isEmpty) {
      return defaultSemester;
    }
    if (selectedSession.semesters.length == 2) {
      return [];
    }

    // If the selected session has only one semester, return the other semester
    int existingSemester = selectedSession.semesters.first.semesterNumber;
    return [3 - existingSemester];
  }

  Widget buildSessionDropdown({
    required List<Session> items,
    required Session? value,
    required Function onChanged,
  }) {
    return DropdownButton<Session>(
      value: value,
      items: items.map((Session item) {
        return DropdownMenuItem<Session>(
          value: item,
          child: Text(item.sessionYear),
        );
      }).toList(),
      onChanged: (Session? newValue) {
        onChanged(newValue);
        // If you need the selected session object, use newValue
      },
    );
  }

  Widget buildDropdown({
    required List<int> items,
    required int? value,
    required Function onChanged,
  }) {
    return DropdownButton<int>(
      value: value,
      items: items.map((int item) {
        return DropdownMenuItem<int>(
          value: item,
          child: Text("Semester $item"),
        );
      }).toList(),
      onChanged: (int? newValue) {
        onChanged(newValue);
      },
    );
  }

  void _showAddCourseModal() {
    TextEditingController _title = TextEditingController();
    TextEditingController _code = TextEditingController();
    final _keyForm = GlobalKey<FormState>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
      ),
      builder: (BuildContext context) {
        // You can implement the UI for adding/removing courses here
        // For simplicity, let's just show a text field for entering the course details
        return Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _keyForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: const Text(
                    'Enter Course Details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Course Code',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _code,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintStyle: TextStyle(color: AppColors.grey, fontSize: 12),
                    hintText: "enter course code",
                    counterStyle: const TextStyle(height: double.minPositive),
                    labelStyle: TextStyle(
                        color: AppColors.grey,
                        fontFamily: 'Raleway-SemiBold',
                        fontSize: 15.0),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                  validator: (value) {
                    RegExp regex = RegExp(r'\d');
                    if (value == null || value.isEmpty || value.length < 3) {
                      return 'course code is too  short or empty';
                    }
                    if (value.length > 7) {
                      return 'invalid course code';
                    }
                    if (!regex.hasMatch(value)) {
                      return "expected format XXX111";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                const Text(
                  'Course Title',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _title,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxLines: 2,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintStyle: TextStyle(color: AppColors.grey, fontSize: 12),
                    hintText: "enter course title",
                    counterStyle: const TextStyle(height: double.minPositive),
                    labelStyle: TextStyle(
                        color: AppColors.grey,
                        fontFamily: 'Raleway-SemiBold',
                        fontSize: 15.0),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 3) {
                      return 'title is too  short or empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!_keyForm.currentState!.validate()) {
                        return;
                      }
                      _keyForm.currentState!.save();
                      courses.add(Course(
                          courseId: _code.text.trim().toUpperCase(),
                          courseName: _title.text.trim(),
                          attendanceList: []));
                      Navigator.pop(context);
                      setState(() {});
                    },
                    child: const Text("Add Course"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Course> courses = [];
  final List<Session> defaultSessions = [
    Session(sessionYear: "2023/2024", semesters: []),
    Session(sessionYear: "2024/2025", semesters: []),
    Session(sessionYear: "2025/2026", semesters: []),
    Session(sessionYear: "2026/2027", semesters: []),
    Session(sessionYear: "2027/2028", semesters: []),
    Session(sessionYear: "2028/2029", semesters: []),
  ];
}
