class User {
  String id;
  String name;
  UserType userType;
  String email;
  StudentInfo? studentInfo;

  User({
    required this.id,
    required this.name,
    required this.userType,
    required this.email,
    this.studentInfo,
  });

  // Factory constructor to create a User object from a Map (JSON)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      userType: UserTypeExtension.fromString(
          json['userType']), // Convert string to enum
      email: json['email'],
      studentInfo: json['studentInfo'] != null
          ? StudentInfo.fromJson(json['studentInfo'])
          : null,
    );
  }

  // Convert User object to a Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'userType': userType.toStringValue(), // Convert enum to string
      'email': email,
      'studentInfo':
          studentInfo?.toJson(), // Convert StudentInfo to JSON if not null
    };
  }
}

class StudentInfo {
  String imgUrl;
  String matricNumber;

  StudentInfo({
    required this.imgUrl,
    required this.matricNumber,
  });

  // Factory constructor to create a StudentInfo object from a Map (JSON)
  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    return StudentInfo(
      imgUrl: json['imgUrl'],
      matricNumber: json['matricNumber'],
    );
  }

  // Convert StudentInfo object to a Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'imgUrl': imgUrl,
      'matricNumber': matricNumber,
    };
  }
}

enum UserType {
  staff,
  student,
}

extension UserTypeExtension on UserType {
  // Convert enum to string
  String toStringValue() {
    return this.toString().split('.').last.toLowerCase();
  }

  // Factory method to create UserType from string
  static UserType fromString(String value) {
    if (value.toLowerCase() == 'student') {
      return UserType.student;
    } else {
      return UserType.staff;
    }
  }
}

class Course {
  String courseId;
  String courseName;

  Course({
    required this.courseId,
    required this.courseName,
  });

  // Factory constructor to create a Course object from a Map (JSON)
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseId: json['courseId'],
      courseName: json['courseName'],
    );
  }

  // Convert Course object to a Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'courseName': courseName,
    };
  }
}

class Session {
  String sessionYear;
  String sessionSemester;

  Session({
    required this.sessionYear,
    required this.sessionSemester,
  });

  // Factory constructor to create a Session object from a Map (JSON)
  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      sessionYear: json['sessionYear'],
      sessionSemester: json['sessionSemester'],
    );
  }

  // Convert Session object to a Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'sessionYear': sessionYear,
      'sessionSemester': sessionSemester,
    };
  }
}

class Attendance {
  String attendanceId;
  Course course;
  String lecturerName;
  Session session;
  DateTime startTime;
  DateTime endTime;
  String verificationCode;
  String range;

  Attendance({
    required this.attendanceId,
    required this.course,
    required this.lecturerName,
    required this.session,
    required this.startTime,
    required this.endTime,
    required this.verificationCode,
    required this.range,
  });

  // Factory constructor to create an Attendance object from a Map (JSON)
  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      attendanceId: json['attendanceId'],
      course: Course.fromJson(json['course']),
      lecturerName: json['lecturerName'],
      session: Session.fromJson(json['session']),
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      verificationCode: json['verificationCode'],
      range: json['range'],
    );
  }

  // Convert Attendance object to a Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'attendanceId': attendanceId,
      'course': course.toJson(),
      'lecturerName': lecturerName,
      'session': session.toJson(),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'verificationCode': verificationCode,
      'range': range,
    };
  }
}

class AttendanceVerification {
  String attendanceId;
  Course course;
  Session session; // Assuming you meant to use the combined class Term
  String lecturerName;
  bool status;
  DateTime date;

  AttendanceVerification({
    required this.attendanceId,
    required this.course,
    required this.session,
    required this.lecturerName,
    required this.status,
    required this.date,
  });

  // Factory constructor to create an AttendanceVerification object from a Map (JSON)
  factory AttendanceVerification.fromJson(Map<String, dynamic> json) {
    return AttendanceVerification(
      attendanceId: json['attendanceId'],
      course: Course.fromJson(json['course']),
      session: Session.fromJson(json['session']),
      lecturerName: json['lecturerName'],
      status: json['status'],
      date: DateTime.parse(json['date']),
    );
  }

  // Convert AttendanceVerification object to a Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'attendanceId': attendanceId,
      'course': course.toJson(),
      'term': session.toJson(),
      'lecturerName': lecturerName,
      'status': status,
      'date': date.toIso8601String(),
    };
  }
}
