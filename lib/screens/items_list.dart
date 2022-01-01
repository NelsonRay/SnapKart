import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grokart/models/item.dart';
import 'package:grokart/models/store.dart';
import 'package:grokart/widgets/item_tile.dart';

class ItemsList extends StatelessWidget {
  final Store? selectedStore;
  final List<Item> selectedItems;
  final void Function(Item item) handleItemTap;

  const ItemsList({
    Key? key,
    required this.selectedStore,
    required this.selectedItems,
    required this.handleItemTap,
  }) : super(key: key);

  Future<List<Item>> getItemsFromStore() async {
    final results = await FirebaseFirestore.instance
        .collection('items')
        .where('storeId', isEqualTo: selectedStore!.id)
        .get();
    return results.docs.map((doc) => Item.fromDoc(doc)).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (selectedStore == null) return Container();

    return FutureBuilder<List<Item>>(
      future: getItemsFromStore(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...(snapshot.data!..sort((a, b) => a.aisle.compareTo(b.aisle)))
                  .map(
                    (item) => ItemTile(
                      item: item,
                      handleTap: handleItemTap,
                      isItemSelected: selectedItems.any((e) => e.id == item.id),
                    ),
                  )
                  .toList(),
              const SizedBox(height: 60)
            ],
          ),
        );
      },
    );
  }
}
