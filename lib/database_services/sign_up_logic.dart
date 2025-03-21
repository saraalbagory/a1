import 'dart:developer';
import 'package:a1/models/student_model.dart';
import 'local_database_service.dart';
//import 'dart:developer';

Future<String> signUp(StudentModel user) async {
  log("Fetching database...");
  final db = await DatabaseHelper.instance.database;
  log("Database initialized");

  // Validate ID with email
  if (!user.email.startsWith(user.studentID)) {
    log("Student ID does not match email prefix");
    return 'Student ID must match email prefix';
  }

  try {
    user.profileImage = "assets/Images/Profile-PNG-Photo.png";
    await db.insert('studentsProfile', user.toMap());
    log("Signup success");
    return 'Signup success';
  } catch (e) {
    log("Signup failed: ${e.toString()}");
    return 'Signup failed: User already exists';
  }
}
