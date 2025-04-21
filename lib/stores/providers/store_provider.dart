import 'package:a1/stores/data/models/store_model.dart';
import 'package:a1/stores/database_service/stores_database_services.dart';
import 'package:flutter/material.dart';

class StoreProvider extends ChangeNotifier {
  List<StoreModel> stores = [];
  bool isLoading = false;
  String? error;

  final StoresDatabaseServices _dbService = StoresDatabaseServices();

  Future<void> loadStores() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      stores = await _dbService.getStores();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
