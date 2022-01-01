import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grokart/models/store.dart';
import 'package:grokart/widgets/store_tile.dart';

class StoresList extends StatelessWidget {
  final Store? selectedStore;
  final void Function(Store store) handleStoreTap;

  const StoresList({
    Key? key,
    required this.selectedStore,
    required this.handleStoreTap,
  }) : super(key: key);

  Future<List<Store>> getStores() async {
    final results = await FirebaseFirestore.instance.collection('stores').get();
    return results.docs.map((doc) => Store.fromDoc(doc)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Store>>(
      future: getStores(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Container(
            color: Colors.grey.shade50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: snapshot.data!
                  .map((store) => StoreTile(
                        store: store,
                        isSelected: selectedStore?.id == store.id,
                        handleTap: handleStoreTap,
                      ))
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}
