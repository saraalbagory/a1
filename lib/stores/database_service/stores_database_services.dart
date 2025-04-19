import 'package:a1/common/database_utilities.dart';
import 'package:a1/database_services/local_database_service.dart';
import 'package:a1/stores/data/models/store_model.dart';

 class StoresDatabaseServices {
  Future<List<StoreModel>> getStores() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> storesMaps = await db.query(
      DatabaseUtilities.storeTableName,
    );
    if (storesMaps.isEmpty){
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

  // Get all fsq_ids from the favorites table for this student
  final List<Map<String, dynamic>> favoriteIds = await db.query(
    'favorites', // Replace with your actual favorites table name
    where: 'student_id = ?',
    whereArgs: [studentId],
  );

  if (favoriteIds.isEmpty) return [];

  final List<String> storeIds = favoriteIds.map((e) => e['fsq_id'] as String).toList();

  // Now fetch the store details for each fsq_id from the stores table
  final List<Map<String, dynamic>> storeMaps = await db.query(
    'stores', // Your actual store table name
    where: 'fsq_id IN (${List.filled(storeIds.length, '?').join(', ')})',
    whereArgs: storeIds,
  );

  // Convert each row to StoreModel
  return storeMaps.map((map) => StoreModel(
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
    )).toList();
}


}
