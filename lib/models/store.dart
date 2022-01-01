import 'package:cloud_firestore/cloud_firestore.dart';

class Store {
  final String id;
  final String name;
  final String location;
  final String photoUrl;

  const Store({
    required this.id,
    required this.name,
    required this.location,
    required this.photoUrl,
  });

  factory Store.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    return Store(
      id: doc.id,
      name: doc.data()['name'] ?? '',
      location: doc.data()['location'] ?? '',
      photoUrl: doc.data()['photoUrl'] ?? '',
    );
  }
}
