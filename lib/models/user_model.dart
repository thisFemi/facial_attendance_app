class User {
  String id;
  String name;
  UserType userType;
  String phoneNumber;
  String email;
  StudentData? userInfo;

  User({
    required this.id,
    required this.name,
    required this.userType,
    required this.email,
    required this.phoneNumber,
    this.userInfo,
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
      userInfo: json['userInfo'] != null
          ? StudentData.fromJson(json['userInfo'])
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
      'phoneNumber':phoneNumber,
      'userInfo': userInfo?.toJson(), // Convert userInfo to JSON if not null
    };
  }
}

class StudentData {
  String imgUrl;
  String matricNumber;

  StudentData({
    required this.imgUrl,
    required this.matricNumber,
  });

  // Factory constructor to create a userInfo object from a Map (JSON)
  factory StudentData.fromJson(Map<String, dynamic> json) {
    return StudentData(
      imgUrl: json['imgUrl'],
      matricNumber: json['matricNumber'],
    );
  }

  // Convert userInfo object to a Map (JSON)
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
