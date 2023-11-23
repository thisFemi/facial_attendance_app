class UniModel {
  String country;
  List<String> domains;
  String name;
  List<String> webPages;
  UniModel(
      {required this.country,
      required this.domains,
      required this.name,
      required this.webPages});
}

class User {
  String id;
  String name;
  UserType userType;
  String email;
  StudentInfo? studentInfo;
  
}

class StudentInfo {
  String imgUrl;
  String matricNumber;
}

enum UserType {
  staff,
  student,
}
