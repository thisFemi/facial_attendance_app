import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../utils/Common.dart';
import '../../utils/colors.dart';
import '../../widgets/custom_appBar.dart';

class CourseRegScreen extends StatefulWidget {
  const CourseRegScreen({Key? key}) : super(key: key);

  @override
  State<CourseRegScreen> createState() => _CourseRegScreenState();
}

class _CourseRegScreenState extends State<CourseRegScreen> {
  String? selectedSession;
  String? selectedSemester;
  bool _isLoading = false;
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select Session',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      buildDropdown(
                        items: sessions,
                        value: selectedSession,
                        onChanged: (value) {
                          setState(() {
                            selectedSession = value.toString();
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
                      horizontal: 10, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select Semester',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      buildDropdown(
                        items: semesters,
                        value: selectedSemester,
                        onChanged: (value) {
                          setState(() {
                            selectedSemester = value.toString();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Open modal sheet to add/remove courses
                  _showAddCourseModal();
                },
                child: const Text("Add/Remove Courses"),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 40,
                ),
                child: SizedBox(
                  height: 50.0,
                   width: Screen.deviceSize(context).width * 0.85,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (_) => AttendanceCapture(
                      //             // user: widget.user,
                      //             )));
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
                                fontFamily: 'Raleway-SemiBold'),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDropdown({
    required List<String> items,
    required String? value,
    required Function onChanged,
  }) {
    return DropdownButton<String>(
      value: value,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (String? newValue) {
        onChanged(newValue);
      },
    );
  }

  void _showAddCourseModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10), topLeft: Radius.circular(10))),
      builder: (BuildContext context) {
        // You can implement the UI for adding/removing courses here
        // For simplicity, let's just show a text field for entering the course details
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
           crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Enter Course Details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              const TextField(
                decoration: InputDecoration(labelText: 'Course Name'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Implement the logic to add the course
                  // You can use the entered course details from the text field
                  // For now, let's just close the modal
                  Navigator.pop(context);
                },
                child: const Text("Add Course"),
              ),
            ],
          ),
        );
      },
    );
  }

  final sessions = ["2019/2020", "2020/2021", "2021/2022", "2022/2023"];
  final semesters = ["Semester 1", "Semester 2"];
}
