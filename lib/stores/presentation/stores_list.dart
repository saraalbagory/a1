import 'package:a1/stores/providers/store_provider.dart';
import 'package:a1/view/store_dist_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoresList extends StatefulWidget {
  const StoresList({super.key});
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

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);
    final stores = storeProvider.stores;

    return Scaffold(
      appBar: AppBar(title: const Text("Stores in Cairo")),
      body:
          stores.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: stores.length,
                itemBuilder: (context, index) {
                  final store = stores[index];
                  return ListTile(
                    title: Text(store.name),
                    subtitle: Text(store.location.address ?? 'No address'),
                    leading: const Icon(Icons.store),
                    trailing: IconButton(
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
              ),
    );
  }
}
