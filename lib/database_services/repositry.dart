import 'package:a1/common/connectivity.dart';
import 'package:a1/database_services/api_services.dart';
import 'package:a1/database_services/local_database_service.dart';
import 'package:a1/models/sign_in_credentials.dart';
import 'package:a1/models/student_model.dart';

class Repository {
  Repository();
  final ApiService _apiService = ApiService();
  final CustomConnectivity _connectivity = CustomConnectivity();
  final DatabaseHelper _localDatabaseService = DatabaseHelper.instance;
  Future<StudentModel?> signIn(SignInCredentials credentials) async {
    // bool isConnected = await _connectivity.checkInternet();
    // if (isConnected) {
    //   var response = await _apiService.getRequest(
    //     "http://localhost:8080/api/students",
    //     queryParameters: {
    //       "student_id": credentials.studentId,
    //       "password": credentials.password,
    //     },
    //   );
    //   if (response.statusCode == 200) {
    //     final student = StudentModel.fromJson(response.data);
    //     _localDatabaseService.signIn(credentials);
    //     return student;
    //   }
    // } else {
    //   return _localDatabaseService.signIn(credentials);
    // }
    return _localDatabaseService.signIn(credentials);
  }

  Future<StudentModel?> updateStudent(StudentModel student) async {
    return _localDatabaseService.updateStudent(student);
  }

  // Future<String> signUp(StudentModel student) async {
  //   SignUpLogic signUpLogic = SignUpLogic();
  //   return signUpLogic.signUp(student);
  // }
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
  // }
}
