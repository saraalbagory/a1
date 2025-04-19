import 'package:a1/common/utilities.dart';
import 'package:a1/stores/data/models/store_model.dart';
import 'package:dio/dio.dart';

class StoresApiService {
  final Dio _dio = Dio();
  Future<List<StoreModel>> fetchStores() async {
  List<StoreModel> stores = [];

  try {
    final response = await _dio.get(
      ApiUtilities.baseUrl,
      queryParameters: {
        'll': ApiUtilities.cairoCoordinates,
        'categories': ApiUtilities.storesCategoryId,
        'limit':50
      },
      options: Options(
        headers: {
          'Authorization': ApiUtilities.apikey,
          'accept': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data;
      for (var item in data['results']) {
        stores.add(StoreModel.fromJson(item));
      }
    } else {
      throw Exception('Failed to load stores');
    }
  } catch (error) {
    print('Error: $error');
    rethrow; // or return [];
  }

  return stores;
}

}
