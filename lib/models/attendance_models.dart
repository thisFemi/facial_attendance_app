class Attendance {
  String attendanceId;
  String lecturerName;
  String lecturerId;
  DateTime startTime;
  DateTime endTime;
  String verificationCode;
  String range;
  bool isPresent;
  List<UserData>? students; // New parameter

  Attendance({
    required this.attendanceId,
    required this.lecturerName,
    required this.lecturerId,
    required this.startTime,
    required this.endTime,
    required this.verificationCode,
    required this.range,
    required this.isPresent,
    this.students, // Include the new parameter
  });

  // Factory constructor to create an Attendance object from a Map (JSON)
  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      attendanceId: json['attendanceId'],
      lecturerName: json['lecturerName'],
      lecturerId: json['lecturerId'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      verificationCode: json['verificationCode'],
      range: json['range'],
      isPresent: json['isPresent'] ?? false,
      students: json['students'] != null
          ? List<UserData>.from(
              json['students']
                  .map((studentJson) => UserData.fromJson(studentJson)),
            )
          : null,
    );
  }

  // Convert Attendance object to a Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'attendanceId': attendanceId,
      'lecturerName': lecturerName,
      "lecturerId": lecturerId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'verificationCode': verificationCode,
      'range': range,
      'isPresent': isPresent,
      'students': students?.map((student) => student.toJson()).toList(),
    };
  }
}

class UserData {
  String studentId;
  String matricNumber;
  String studentName;
  bool isPresent;

  UserData({
    required this.studentId,
    required this.matricNumber,
    required this.studentName,
    required this.isPresent,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      studentId: json['studentId'],
      matricNumber: json['matricNumber'],
      studentName: json['studentName'],
      isPresent: json['isPresent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'matricNumber': matricNumber,
      'studentName': studentName,
      'isPresent': isPresent,
    };
  }
}

class Course {
  String courseId;
  String courseName;
  List<Attendance> attendanceList;

  Course({
    required this.courseId,
    required this.courseName,
    required this.attendanceList,
  });
  double calculateAttendancePercentage() {
    if (attendanceList.isEmpty) {
      return 0.0; // Avoid division by zero
    }

    int presentCount =
        attendanceList.where((attendance) => attendance.isPresent).length;
    double percentage = (presentCount / attendanceList.length) * 100;

    return percentage;
  }

  // Factory constructor to create a Course object from a Map (JSON)
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseId: json['courseId'],
      courseName: json['courseName'],
      attendanceList: (json['attendanceList'] as List<dynamic>? ?? [])
          .map((attendanceJson) => Attendance.fromJson(attendanceJson))
          .toList(),
    );
  }

  // Convert Course object to a Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'courseName': courseName,
      'attendanceList':
          attendanceList.map((attendance) => attendance.toJson()).toList(),
    };
  }
}

class Semester {
  int semesterNumber;
  List<Course> courses;

  Semester({
    required this.semesterNumber,
    required this.courses,
  });

  // Factory constructor to create a Semester object from a Map (JSON)
  factory Semester.fromJson(Map<String, dynamic> json) {
    return Semester(
      semesterNumber: json['semesterNumber'] as int,
      courses: (json['courses'] as List<dynamic>? ?? [])
          .map((courseJson) => Course.fromJson(courseJson))
          .toList(),
    );
  }

  // Convert Semester object to a Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'semesterName': semesterNumber,
      'courses': courses.map((course) => course.toJson()).toList(),
    };
  }
}

class Session {
  String sessionYear;
  List<Semester> semesters;

  Session({
    required this.sessionYear,
    required this.semesters,
  });

  // Factory constructor to create a Session object from a Map (JSON)
  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      sessionYear: json['sessionYear'],
      semesters: (json['semesters'] as List<dynamic>? ?? [])
          .map((semesterJson) => Semester.fromJson(semesterJson))
          .toList(),
    );
  }

  // Convert Session object to a Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'sessionYear': sessionYear,
      'semesters': semesters.map((semester) => semester.toJson()).toList(),
    };
  }
}

class StudentData {
  String studentId;
  String matricId;
  String studentName;
  List<Session> sessions;

  StudentData({
    required this.studentId,
    required this.studentName,
    required this.matricId,
    required this.sessions,
  });
  int getTotalSemesters() {
    return sessions.length;
  }

  int getTotalCourses() {
    int totalCourses = 0;
    for (var session in sessions) {
      for (var semester in session.semesters) {
        totalCourses += semester.courses.length;
      }
    }
    return totalCourses;
  }

  int getTotalPresent() {
    int totalPresent = 0;
    for (var session in sessions) {
      for (var semester in session.semesters) {
        for (var course in semester.courses) {
          totalPresent += course.attendanceList
              .where((attendance) => attendance.isPresent == true)
              .length;
        }
      }
    }
    return totalPresent;
  }

  int getTotalAbsent() {
    int totalAbsent = 0;
    for (var session in sessions) {
      for (var semester in session.semesters) {
        for (var course in semester.courses) {
          totalAbsent += course.attendanceList
              .where((attendance) => attendance.isPresent == false)
              .length;
        }
      }
    }
    return totalAbsent;
  }

  // Factory constructor to create a StudentData object from a Map (JSON)
  factory StudentData.fromJson(Map<String, dynamic> json) {
    return StudentData(
      studentId: json['studentId'],
      studentName: json['studentName'],
      matricId: json['matricId'],
      sessions: (json['sessions'] as List<dynamic>? ?? [])
          .map((sessionJson) => Session.fromJson(sessionJson))
          .toList(),
    );
  }

  // Convert StudentData object to a Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'matricId': matricId,
      'sessions': sessions.map((session) => session.toJson()).toList(),
    };
  }
}
