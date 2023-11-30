class User {
  String id;
  String name;
  UserType userType;
  String phoneNumber;
  String email;
  StudentInfo? studentInfo;

  User({
    required this.id,
    required this.name,
    required this.userType,
    required this.email,
    required this.phoneNumber,
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
      phoneNumber: json['phoneNumber'],
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

