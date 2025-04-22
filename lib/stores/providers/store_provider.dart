import 'package:a1/stores/data/models/store_model.dart';
import 'package:a1/stores/database_service/stores_database_services.dart';
import 'package:flutter/material.dart';

class StoreProvider extends ChangeNotifier {
  List<StoreModel> stores = [];
  List<StoreModel> favStores = [];
  Set<String> favoritedStoreIds = {};
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

  Future<void> loadFavStores(String studId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      favStores = await _dbService.getFavoriteStores(studId);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addStoreToFavorites(String studentId, String fsqId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await _dbService.addFavoriteStore(studentId, fsqId);
      favStores = await _dbService.getFavoriteStores(studentId);
      favoritedStoreIds.add(fsqId);
      //stores = await _dbService.getStores();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeStoreFromFavorites(String studentId, String fsqId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await _dbService.removeFavoriteStore(studentId, fsqId);
      favStores = await _dbService.getFavoriteStores(studentId);
      favoritedStoreIds.remove(fsqId);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(String fsqId, String studentId) async {
    bool isFavorite = await _dbService.isFavorite(fsqId, studentId);
    if (isFavorite) {
      await _dbService.removeFavoriteStore(fsqId, studentId);
    } else {
      await _dbService.addFavoriteStore(fsqId, studentId);
    }
    notifyListeners();
  }

  Future isFavorite(String fsqId, String studentId) async {
    bool isFavorite = await _dbService.isFavorite(fsqId, studentId);
    return isFavorite;
  }
}
