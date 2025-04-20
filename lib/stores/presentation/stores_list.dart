import 'package:a1/stores/api_services/stores_api_service.dart';
import 'package:a1/stores/data/models/store_model.dart';
import 'package:a1/stores/database_service/stores_database_services.dart';
import 'package:a1/view/store_dist_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class StoresList extends StatelessWidget {
  static const String routeName = "Stores List screen";

  final StoresDatabaseServices _storesDatabaseServices =
      StoresDatabaseServices();

  StoresList({super.key});

  Future<List<StoreModel>> getStores() async {
    return await _storesDatabaseServices.getStores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stores in Cairo")),
      body: FutureBuilder<List<StoreModel>>(
        future: getStores(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No stores found."));
          }

          final stores = snapshot.data!;

          return ListView.builder(
            itemCount: stores.length,
            itemBuilder: (context, index) {
              final store = stores[index];
              return ListTile(
                title: Text(store.name),
                subtitle: Text(store.location.address ?? 'No address'),
                leading: const Icon(Icons.store),
                trailing: //const Icon(Icons.arrow_forward),
                    IconButton(
                  icon: const Icon(Icons.navigation),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StoreDistanceScreen(store: store),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
