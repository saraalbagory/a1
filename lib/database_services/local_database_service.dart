import 'package:a1/models/sign_in_credentials.dart';
import 'package:a1/models/student_model.dart';
import 'package:a1/stores/api_services/stores_api_service.dart';
import 'package:a1/stores/data/models/store_model.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:a1/common/database_utilities.dart';
// imp

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  final String _studentsTableName = DatabaseUtilities.studentsTableName;
  final String _databaseName = DatabaseUtilities.databaseName;
  final String _storeTableName = DatabaseUtilities.storeTableName;
  final String _favoriteStore = DatabaseUtilities.favoriteStore;
  final StoresApiService storesApiService = StoresApiService();
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
    final path = join(dbPath, '$_databaseName.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_studentsTableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        gender TEXT,
        email TEXT UNIQUE NOT NULL,
        student_id TEXT UNIQUE NOT NULL,
        level INTEGER,
        password TEXT NOT NULL,
        profile_image TEXT
        )
        ''');

        await db.execute('''
          CREATE TABLE $_storeTableName (
            fsq_id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            distance INTEGER,
            latitude REAL,
            longitude REAL,
            link TEXT,
            address TEXT,
            country TEXT,
            formatted_address TEXT,
            timezone TEXT
          );
        ''');
        await db.execute('''
            CREATE TABLE favoriteStore (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              fsq_id TEXT NOT NULL,
              student_id TEXT NOT NULL,
              FOREIGN KEY (fsq_id) REFERENCES Store(fsq_id),
              FOREIGN KEY (student_id) REFERENCES studentsProfile(student_id)
            );       ''');
        //Future<List<StoreModel>> stores = storesApiService.fetchStores();
        final stores = await storesApiService.fetchStores();
        for (var store in stores) {
          await db.insert(
            _storeTableName,
            store.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
        print("Stores inserted successfully");
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

  Future<StudentModel?> updateStudent(StudentModel student) async {
    final db = await instance.database;
    final result = await db.update(
      _studentsTableName,
      student.toMap(),
      where: 'student_id = ?',
      whereArgs: [student.studentID],
    );
    if (result != 0) {
      return student;
    }
    return null;
  }
}
