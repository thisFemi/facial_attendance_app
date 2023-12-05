import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../api/apis.dart';
import '../../models/attendance_models.dart';
import '../../utils/Common.dart';
import '../../utils/colors.dart';
import '../../widgets/custom_appBar.dart';

class AddOrDeleteScreen extends StatefulWidget {
  Session session;
  Semester semester;

  AddOrDeleteScreen({required this.semester, required this.session});

  @override
  State<AddOrDeleteScreen> createState() => _AddOrDeleteScreenState();
}

class _AddOrDeleteScreenState extends State<AddOrDeleteScreen> {
  List<Course> courses = [];
  bool _isLoading = false;
  @override
  void initState() {
    courses = widget.semester.courses;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        centerTitle: true,
        context: context,
        showArrowBack: true,
        title:
            "${widget.session.sessionYear} (${widget.semester.semesterNumber} semester)",
      ),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListView.builder(
              itemCount: courses.length,
              shrinkWrap: true,
              itemBuilder: (ctx, index) {
                final course = courses[index];
                return AddOrDeleteSessionCard(
                  course: course,
                  onDelete: () {
                    // Remove the course from the list
                    showDialog(
                        context: context,
                        builder: (context) => SimpleDialog(
                                alignment: Alignment.center,
                                contentPadding: EdgeInsets.all(10),
                                title: Text("Remove Student?"),
                                children: [
                                  Text(
                                    'Are you sure you want to remove ${course.courseId} from course list?',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            // vertical: 40,
                                          ),
                                          child: SizedBox(
                                            height: 35.0,
                                            // width: Screen.deviceSize(context).width * 0.85,
                                            child: TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              style: TextButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.white,
                                              ),
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    color: AppColors.black,
                                                    fontFamily:
                                                        'Raleway-SemiBold'),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            // vertical: 40,
                                          ),
                                          child: SizedBox(
                                            height: 35.0,
                                            // width: Screen.deviceSize(context).width * 0.85,
                                            child: TextButton(
                                              onPressed: () async {
                                                courses.removeAt(index);

                                                await APIs.updateRecord(
                                                  APIs.academicRecords!,
                                                  APIs.userInfo,
                                                );
                                                setState(() {});
                                                Navigator.pop(context);
                                              },
                                              style: TextButton.styleFrom(
                                                backgroundColor: AppColors.red,
                                              ),
                                              child: _isLoading
                                                  ? const SpinKitThreeBounce(
                                                      color: AppColors.offwhite,
                                                      size: 30)
                                                  : const Text(
                                                      'Remove',
                                                      style: TextStyle(
                                                          color:
                                                              AppColors.white,
                                                          fontFamily:
                                                              'Raleway-SemiBold'),
                                                    ),
                                            ),
                                          ),
                                        )
                                      ])
                                ]));
                  },
                );
              },
            ),
            courses.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20,
                    ),
                    child: SizedBox(
                      height: 50.0,
                      width: Screen.deviceSize(context).width * 0.85,
                      child: TextButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                addCoursesToAcademicRecord(
                                    courses,
                                    widget.session,
                                    widget.semester.semesterNumber);

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
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.black,
        onPressed: () {
          // Open a modal or navigate to a screen to add a new course
          _showAddCourseModal(context);
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  Future<void> addCoursesToAcademicRecord(List<Course> courses,
      Session selectedSession, int selectedSemester) async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (APIs.academicRecords == null) {
        // Handle the case where academicRecords is null (initialize it or show an error)
        APIs.academicRecords!.sessions.add(Session(
          sessionYear: selectedSession.sessionYear,
          semesters: [
            Semester(
              semesterNumber: selectedSemester,
              courses: List.from(courses),
            ),
          ],
        ));
      } else {
        // Find the index of the selected session in the academic records
        int sessionIndex = APIs.academicRecords!.sessions.indexWhere(
            (session) => session.sessionYear == selectedSession.sessionYear);

        if (sessionIndex != -1) {
          List<Semester> semesters =
              APIs.academicRecords!.sessions[sessionIndex].semesters;

          if (selectedSemester < semesters.length) {
            // Add the semester with the selected courses to the selected session
            semesters[selectedSemester - 1].courses = courses;
            print('added to existing session');
          } else {
            // Handle the case where selectedSemester is out of range
            throw ('Error: Invalid semester index');
          }
        } else {
          // If the session is not available, add it with the selected semester and courses
          throw ('Error: Session not found');
        }
      }
      await APIs.updateRecord(
        APIs.academicRecords!,
        APIs.userInfo,
      );
      setState(() {
        _isLoading = false;
      });
    } catch (eror) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showAddCourseModal(BuildContext context) {
    TextEditingController _title = TextEditingController();
    TextEditingController _code = TextEditingController();
    final _keyForm = GlobalKey<FormState>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10), topLeft: Radius.circular(10))),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _keyForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Add New Course',
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
}

class AddOrDeleteSessionCard extends StatelessWidget {
  final Course course;
  final VoidCallback onDelete;

  AddOrDeleteSessionCard({required this.course, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(course.courseId),
        subtitle: Text(course.courseName),
        trailing: IconButton(
          icon: const Icon(
            CupertinoIcons.delete,
            color: AppColors.red,
          ),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
