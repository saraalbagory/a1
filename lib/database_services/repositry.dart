import 'package:a1/database_services/local_database_service.dart';
import 'package:a1/models/sign_in_credentials.dart';
import 'package:a1/models/student_model.dart';

class Repository {
  Repository();
  final DatabaseHelper _localDatabaseService = DatabaseHelper.instance;
  Future<StudentModel?> signIn(SignInCredentials credentials) async {
    _localDatabaseService.signIn(credentials);
  }
  // Future<String> signUp(StudentModel student) async {
  //   try {
  //     final db = await _databaseService.database;
  //     await db.insert(
  //       _databaseService.studentsTableName,
  //       student.toMap(),
  //       conflictAlgorithm: ConflictAlgorithm.replace,
  //     );
  //     return "User registered successfully";
  //   } catch (e) {
  //     print("Error in signUp: ${e.toString()}");
  //     return "An error occurred during signup";
  //   }
  //}
}
