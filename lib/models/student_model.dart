class StudentModel {
  String name;
  String? gender;
  String email;
  String studentID;
  int? level;
  String password;

  StudentModel({
    required this.name,
    this.gender,
    required this.email,
    required this.studentID,
    this.level,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'gender': gender,
      'email': email,
      'student_id': studentID,
      'level': level,
      'password': password,
    };
  }
}
