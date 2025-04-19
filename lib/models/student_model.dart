class StudentModel {
  String name;
  String? gender;
  String email;
  String studentID;
  int? level;
  String password;
  String? profileImage;

  StudentModel({
    required this.name,
    this.gender,
    required this.email,
    required this.studentID,
    this.level,
    required this.password,
    this.profileImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'gender': gender,
      'email': email,
      'student_id': studentID,
      'level': level,
      'password': password,
      'profile_image': profileImage,
    };
  }

  static StudentModel mapToStudent(Map map) {
    return StudentModel(
      name: map['name'] ?? '',
      gender: map['gender'],
      email: map['email'] ?? '',
      studentID: map['student_id'] ?? '',
      level: map['level'],
      password: map['password'] ?? '',
      profileImage: map['profile_image'],
    );
  }

  static StudentModel fromJson(Map<String, dynamic> data) {
    return StudentModel(
      name: data['name'] ?? '',
      gender: data['gender'],
      email: data['email'] ?? '',
      studentID: data['student_id'] ?? '',
      level: data['level'],
      password: data['password'] ?? '',
      profileImage: data['profile_image'],
    );
  }
}
