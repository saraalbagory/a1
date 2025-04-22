import 'package:a1/stores/data/models/store_model.dart';
import 'package:a1/stores/database_service/stores_database_services.dart';
import 'package:a1/stores/providers/store_provider.dart';
import 'package:a1/stores/presentation/store_dist_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoresList extends StatefulWidget {
  final String studentId;
  const StoresList({super.key, required this.studentId});
  static const String routeName = "Stores List screen";

  @override
  State<StoresList> createState() => _StoresListState();
}

class _StoresListState extends State<StoresList> {
  
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<StoreProvider>(context, listen: false);
      provider.loadStores();
    });
  }

  bool isStoreFavorite( String fsqId) {
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    final favoritedStores = storeProvider.favStores;
    return favoritedStores.any((store) => store.fsqId == fsqId);
  }

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);
    final stores = storeProvider.stores;
    final favoritedStoreIds = storeProvider.favoritedStoreIds;

    return Scaffold(
      appBar: AppBar(title: const Text("Stores in Cairo")),
      body:
          stores.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: stores.length,
                itemBuilder: (context, index) {
                  final store = stores[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(store.name),
                      subtitle: Text(store.location.address ?? 'No address'),
                      leading: const Icon(Icons.store),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.navigation),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => StoreDistanceScreen(store: store),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.favorite,
                                color:
                                isStoreFavorite(store.fsqId)
                                        ? Colors.red
                                        : Colors.grey,
                              ),
                    
                              onPressed: () async {
                                final provider = Provider.of<StoreProvider>(
                                  context,
                                  listen: false,
                                );
                                await provider.addStoreToFavorites(
                                  store.fsqId,
                                  widget.studentId,
                                );
                    
                                setState(() {
                                 // mark as removed
                                  favoritedStoreIds.add(store.fsqId);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
