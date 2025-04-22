import 'package:a1/common/database_utilities.dart';
import 'package:a1/database_services/local_database_service.dart';
import 'package:a1/stores/data/models/store_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class StoresDatabaseServices {
  Future<List<StoreModel>> getStores() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> storesMaps = await db.query(
      DatabaseUtilities.storeTableName,
    );
    if (storesMaps.isEmpty) {
      return [];
    }
    return List.generate(storesMaps.length, (i) {
      return StoreModel(
        fsqId: storesMaps[i]['fsq_id'],
        name: storesMaps[i]['name'],
        distance: storesMaps[i]['distance'],
        geocodes: Geocodes(
          main: storeCenter(
            latitude: storesMaps[i]['latitude'],
            longitude: storesMaps[i]['longitude'],
          ),
        ),
        link: storesMaps[i]['link'],
        location: Location(
          address: storesMaps[i]['address'],
          country: Country.EG,
          formattedAddress: storesMaps[i]['formatted_address'],
        ),
      );
    });
  }

  Future<StoreModel> getStoresByID(String fsq_id) async {
    final db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> storeMap = await db.query(
      DatabaseUtilities.storeTableName,
      where: 'fsq_id=?',
      whereArgs: [fsq_id],
    );
    return StoreModel(
      fsqId: storeMap[0]['fsq_id'],
      name: storeMap[0]['name'],
      distance: storeMap[0]['distance'],
      geocodes: Geocodes(
        main: storeCenter(
          latitude: storeMap[0]['latitude'],
          longitude: storeMap[0]['longitude'],
        ),
      ),
      link: storeMap[0]['link'],
      location: Location(
        address: storeMap[0]['address'],
        country: Country.EG,
        formattedAddress: storeMap[0]['formatted_address'],
      ),
    );
  }

  Future<List<StoreModel>> getFavoriteStores(String studentId) async {
    final db = await DatabaseHelper.instance.database;
    print("Fetching favorite stores for student ID: $studentId");
    final List<Map<String, dynamic>> favoriteIds = await db.query(
      DatabaseUtilities.favoriteStore,
      where: 'student_id = ?',
      whereArgs: [studentId],
    );

    if (favoriteIds.isEmpty) {
      print("No favorite stores found for this student.");
      return [];
    }

    final List<String> storeIds =
        favoriteIds.map((e) => e['fsq_id'] as String).toList();

    //fetch the store details for each fsq_id
    final List<Map<String, dynamic>> storeMaps = await db.query(
      DatabaseUtilities.storeTableName,
      where: 'fsq_id IN (${List.filled(storeIds.length, '?').join(', ')})',
      whereArgs: storeIds,
    );

    return storeMaps
        .map(
          (map) => StoreModel(
            fsqId: map['fsq_id'],
            name: map['name'],
            distance: map['distance'],
            geocodes: Geocodes(
              main: storeCenter(
                latitude: map['latitude'],
                longitude: map['longitude'],
              ),
            ),
            link: map['link'],
            location: Location(
              address: map['address'],
              formattedAddress: map['formatted_address'],
              country: Country.EG,
            ),
          ),
        )
        .toList();
  }

  Future<bool> addFavoriteStore(String fsq_id, String studentId) async {
    final db = await DatabaseHelper.instance.database;
    int effectedRows = await db.insert(
      DatabaseUtilities.favoriteStore,
      {'fsq_id': fsq_id, 'student_id': studentId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (effectedRows > 0) {
      print("Store added to favorites successfully");
      return true;
    } else {
      print("Failed to add store to favorites");
      return false;
    }
  }

  Future<bool> isFavorite(String fsqId, String studentId) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      DatabaseUtilities.favoriteStore,
      where: 'fsq_id = ? AND student_id = ?',
      whereArgs: [fsqId, studentId],
    );
    return result.isNotEmpty;
  }

  Future<bool> removeFavoriteStore(String fsq_id, String studentId) async {
    final db = await DatabaseHelper.instance.database;
    int numOfDeletedRows = await db.delete(
      DatabaseUtilities.favoriteStore,
      where: 'fsq_id = ? AND student_id = ?',
      whereArgs: [fsq_id, studentId],
    );
    if (numOfDeletedRows > 0) {
      return true;
    } else {
      return false;
    }
  }
}
