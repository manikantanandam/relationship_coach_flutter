import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:relationship_coach_flutter/model/base_fire_store_model.dart';

class FirestoreService<T extends BaseFirestoreModel> {
  final String collectionPath;
  final T Function(Map<String, dynamic> json, String id) fromJson;

  FirestoreService({required this.collectionPath, required this.fromJson});

  // Reference with Converter for type safety
  CollectionReference<T> get _db => FirebaseFirestore.instance
      .collection(collectionPath)
      .withConverter<T>(
        fromFirestore: (snapshot, _) => fromJson(snapshot.data()!, snapshot.id),
        toFirestore: (model, _) => model.toJson(),
      );

  // CREATE
  Future<void> create(T item) async {
    await _db.add(item);
  }

  // READ (All - Stream)
  Stream<List<T>> streamAll() {
    return _db.snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
    );
  }

  // READ (Single - Future)
  Future<T?> getById(String id) async {
    final doc = await _db.doc(id).get();
    return doc.data();
  }

  // UPDATE
  Future<void> update(String id, Map<String, dynamic> data) async {
    await _db.doc(id).update(data);
  }

  // DELETE
  Future<void> delete(String id) async {
    await _db.doc(id).delete();
  }

  // Inside class FirestoreService<T>
  Future<List<T>> getAllOnce() async {
    final snapshot = await _db.get(); // Use .get() for a one-time fetch
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
