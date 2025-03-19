import 'package:a1/models/sign_in_credentials.dart';
import 'package:a1/models/student_model.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
//import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'dart:io';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'; //Web support

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  final String _studentsTableName = "students";
  // private constructor
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }
  //get the database

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'students.db');

    return await openDatabase(
      path,
      version: 1, // 🔹 **ADD THIS LINE** to specify the database version
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_studentsTableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        gender TEXT,
        email TEXT UNIQUE NOT NULL,
        student_id TEXT UNIQUE NOT NULL,
        level INTEGER,
        password TEXT NOT NULL)''');
      },
    );
  }

  Future<StudentModel?> signIn(SignInCredentials credentials) async {
    final db = await instance.database;
    final result = await db.query(
      _studentsTableName,
      where: 'student_id = ?',
      whereArgs: [credentials.studentId],
    );
    if (result.isNotEmpty) {
      StudentModel student =
          result.map((e) => StudentModel.mapToStudent(e)).first;
      return student;
    }
    print(result);
    return null;
  }

  // static final DatabaseHelper instance = DatabaseHelper._init();
  // static Database? _database;

  // DatabaseHelper._init();

  // Future<Database> get database async {
  //   if (_database != null) return _database!;

  //   //  Use different database factories for web and non-web platforms
  //   if (kIsWeb) {
  //     databaseFactory = databaseFactoryFfiWeb; //  Web database
  //   } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
  //     sqfliteFfiInit();
  //     databaseFactory = databaseFactoryFfi; //  Desktop database
  //   }
  //   // //
  //   databaseFactory = databaseFactoryFfi;
  //   _database = await _initDB('students.db');
  //   return _database!;
  // }

  // Future<Database> _initDB(String filePath) async {
  //   final dbPath = await getDatabasesPath();
  //   final path = join(dbPath, filePath);

  //   return await openDatabase(path, version: 1, onCreate: _createDB);
  // }

  // Future _createDB(Database db, int version) async {
  //   await db.execute('''
  //     CREATE TABLE students (
  //       id INTEGER PRIMARY KEY AUTOINCREMENT,
  //       name TEXT NOT NULL,
  //       gender TEXT,
  //       email TEXT UNIQUE NOT NULL,
  //       student_id TEXT UNIQUE NOT NULL,
  //       level INTEGER,
  //       password TEXT NOT NULL
  //     )
  //   ''');
  // }
}
