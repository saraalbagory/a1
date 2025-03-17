import 'dart:developer';
import 'package:a1/models/student_model.dart';
import 'localDBclass.dart';
import 'dart:developer';


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
    await db.insert('students', user.toMap());
    log("Signup success");
    return 'Signup success';
  } catch (e) {
    log("Signup failed: ${e.toString()}");
    return 'Signup failed: User already exists';
  }
}