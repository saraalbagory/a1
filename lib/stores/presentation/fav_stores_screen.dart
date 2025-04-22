import 'package:a1/stores/database_service/stores_database_services.dart';
import 'package:a1/stores/presentation/store_dist_screen.dart';
import 'package:a1/stores/providers/store_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavStoresScreen extends StatefulWidget {
  static const String routeName = "Fav Stores screen";
  final String studentID;
  const FavStoresScreen({super.key, required this.studentID});

  @override
  State<FavStoresScreen> createState() => _FavStoresScreenState();
}

class _FavStoresScreenState extends State<FavStoresScreen> {
//  Color _buttonColor = Colors.white; 
  

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<StoreProvider>(context, listen: false);
      provider.loadFavStores(widget.studentID);
    });
  }

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);
    final stores = storeProvider.favStores;


    return Scaffold(
      appBar: AppBar(title: const Text(" Fav Stores in Cairo")),
      body:
          storeProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : stores.isEmpty
              ? const Center(child: Text("No favorite stores found."))
              : ListView.builder(
                itemCount: stores.length,
                itemBuilder: (context, index) {
                  final store = stores[index];
                  return ListTile(
                    title: Text(store.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
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
                            onPressed: () async {
                              final provider = Provider.of<StoreProvider>(
                                context,
                                listen: false,
                              );
                              provider.removeStoreFromFavorites(
                                store.fsqId,
                                widget.studentID,
                              );
                              setState(() {
                                storeProvider.loadFavStores(widget.studentID);
                                
                              });
                            },
                            icon: Icon
                            (Icons.delete, color:Colors.red,),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
