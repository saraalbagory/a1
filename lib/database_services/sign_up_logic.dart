import 'dart:developer';
import 'package:a1/database_services/api.dart';
import 'package:a1/models/student_model.dart';
import 'local_database_service.dart';
//import 'dart:developer';

Future<Map<String, dynamic>> signUp(StudentModel user) async {
  var response = await APIservice.signUp(user.toMap());
  return response;
  // log("Fetching database...");
  // final db = await DatabaseHelper.instance.database;
  // log("Database initialized");

  // // Validate ID with email
  // if (!user.email.startsWith(user.studentID)) {
  //   log("Student ID does not match email prefix");
  //   return 'Student ID must match email prefix';
  // }

  // try {
  //   await db.insert('students', user.toMap());
  //   log("Signup success");
  //   //if online signup with api to
  //   return 'Signup success';
  // } catch (e) {
  //   log("Signup failed: ${e.toString()}");
  //   return 'Signup failed: User already exists';
  // }
}
