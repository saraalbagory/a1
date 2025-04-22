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
    Future.microtask(() async {
      final provider = Provider.of<StoreProvider>(context, listen: false);
      await provider.loadStores();
      await provider.loadFavStores(widget.studentId);
    });
  }

  bool isStoreFavorite(String fsqId) {
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
                                        (_) =>
                                            StoreDistanceScreen(store: store),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.favorite,
                                color:
                                    storeProvider.favoritedStoreIds.contains(
                                          store.fsqId,
                                        )
                                        ? Colors.red
                                        : Colors.grey,
                              ),
                              onPressed: () async {
                                final provider = Provider.of<StoreProvider>(
                                  context,
                                  listen: false,
                                );
                                final isCurrentlyFavorite = provider
                                    .favoritedStoreIds
                                    .contains(store.fsqId);
                                // await provider.addStoreToFavorites(
                                //   store.fsqId,
                                //   widget.studentId,
                                // );
                                // setState(() {
                                //   provider.favoritedStoreIds.add(
                                //     store.fsqId,
                                //   ); // for animation
                                // });
                                if (isCurrentlyFavorite) {
                                  await provider.removeStoreFromFavorites(
                                    store.fsqId,
                                    widget.studentId,
                                  );
                                  setState(() {
                                    provider.favoritedStoreIds.remove(
                                      store.fsqId,
                                    ); // for animation
                                  });
                                } else {
                                  await provider.addStoreToFavorites(
                                    store.fsqId,
                                    widget.studentId,
                                  );
                                  setState(() {
                                    provider.favoritedStoreIds.add(
                                      store.fsqId,
                                    ); // for animation
                                  });
                                }
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
