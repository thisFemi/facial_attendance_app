import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../widgets/custom_appBar.dart';

class AddOrDeleteScreen extends StatefulWidget {
  final String session;
  final int semester;

  AddOrDeleteScreen({required this.semester, required this.session});

  @override
  State<AddOrDeleteScreen> createState() => _AddOrDeleteScreenState();
}

class _AddOrDeleteScreenState extends State<AddOrDeleteScreen> {
  List<String> courses = [
    "CSC301",
    "CSC321",
    "CSC315",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        centerTitle: true,
        context: context,
        showArrowBack: true,
        title: "${widget.session} (${widget.semester} semester)",
      ),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: courses.length,
          itemBuilder: (ctx, index) {
            final course = courses[index];
            return AddOrDeleteSessionCard(
              session: course,
              onDelete: () {
                // Remove the course from the list
                setState(() {
                  courses.removeAt(index);
                });
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.black,
        onPressed: () {
          // Open a modal or navigate to a screen to add a new course
          _showAddCourseModal(context);
        },
        child: Icon(Icons.add,),
      ),
    );
  }

  void _showAddCourseModal(BuildContext context) {
    String newCourse = "";

    showModalBottomSheet(
  
      context: context,
       shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10), topLeft: Radius.circular(10))),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
             crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Add New Course',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              TextField(
                onChanged: (value) {
                  newCourse = value;
                },
                decoration: InputDecoration(labelText: 'Course Name'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Add the new course to the list
                  setState(() {
                    courses.add(newCourse);
                  });
                  Navigator.pop(context); // Close the modal sheet
                },
                child: Text("Add Course"),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AddOrDeleteSessionCard extends StatelessWidget {
  final String session;
  final VoidCallback onDelete;

  AddOrDeleteSessionCard({required this.session, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(session),
        trailing: IconButton(
          icon: Icon(CupertinoIcons.delete, color: AppColors.red,),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
