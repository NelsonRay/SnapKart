import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String id;
  final String name;
  final String photoUrl;
  final int aisle;

  const Item({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.aisle,
  });

  factory Item.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    return Item(
      id: doc.id,
      name: doc.data()['name'] ?? '',
      photoUrl: doc.data()['photoUrl'] ?? '',
      aisle: doc.data()['aisle'] ?? 1,
    );
  }
}
