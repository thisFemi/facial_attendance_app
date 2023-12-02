import 'package:attend_sense/models/attendance_models.dart';

class DUMMY {
  static List<UserData> dummyAcademicRecords = [
    UserData(
      studentId: '1',
      studentName: 'John Doe',
      matricId: '2021001',
      sessions: [
        Session(
          sessionYear: '2023/2024',
          semesters: [
            Semester(
              semesterNumber: 1,
              courses: [
                Course(
                  courseId: 'CSE101',
                  courseName: 'Introduction to Computer Science',
                  attendanceList: [
                    Attendance(
                      attendanceId: '1',
                      lecturerName: 'Dr. Smith',
                      lecturerId: '101',
                      startTime: DateTime(2021, 9, 1, 8, 0),
                      endTime: DateTime(2023, 9, 1, 10, 0),
                      verificationCode: 'ABC123',
                      range: 20,
                      latitude: 6.5627514,
                      longitude: 3.2459489,
                      isPresent: true,
                      students: [
                        StudentData(
                          studentId: '1',
                          matricNumber: '2021001',
                          studentName: 'John Doe',
                          isPresent: true,
                        ),
                        // Add more students as needed
                      ],
                    ),
                    // Add more attendance records as needed
                  ],
                ),
                // Add more courses as needed
              ],
            ),
            Semester(
              semesterNumber: 2,
              courses: [
                Course(
                  courseId: 'CSE111',
                  courseName: 'Introduction to Computer Science',
                  attendanceList: [
                    Attendance(
                      attendanceId: '01',
                      lecturerName: 'Dr. Smith',
                      lecturerId: '101',
                      latitude: 6.5627514,
                      longitude: 3.2459489,
                      startTime: DateTime(2021, 9, 1, 8, 0),
                      endTime: DateTime(2024, 9, 1, 10, 0),
                      verificationCode: 'ABC123',
                      range: 50,
                      isPresent: true,
                      students: [
                        StudentData(
                          studentId: '1',
                          matricNumber: '2021001',
                          studentName: 'John Doe',
                          isPresent: true,
                        ),
                        // Add more students as needed
                      ],
                    ),
                    // Add more attendance records as needed
                  ],
                ),
                // Add more courses as needed
              ],
            ),
            // Add more semesters as needed
          ],
        ),
        Session(
          sessionYear: '2024/2025',
          semesters: [
            Semester(
              semesterNumber: 1,
              courses: [
                Course(
                  courseId: 'CSE101',
                  courseName: 'Introduction to Computer Science',
                  attendanceList: [
                    Attendance(
                      attendanceId: '1',
                      lecturerName: 'Dr. Smith',
                      lecturerId: '101',
                      startTime: DateTime(2021, 9, 1, 8, 0),
                      endTime: DateTime(2025, 9, 1, 10, 0),
                      verificationCode: 'ABC123',
                      latitude: 6.5627514,
                      longitude: 3.2459489,
                      range: 20,
                      isPresent: true,
                      students: [
                        StudentData(
                          studentId: '1',
                          matricNumber: '2021001',
                          studentName: 'John Doe',
                          isPresent: true,
                        ),
                        // Add more students as needed
                      ],
                    ),
                    // Add more attendance records as needed
                  ],
                ),
                // Add more courses as needed
              ],
            ),
            // Add more semesters as needed
          ],
        ),
      ],
    ),
    // Add more students as needed
  ];
}
