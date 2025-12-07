import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/monument.dart';

class MonumentsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Monument>> getMonuments() {
    return _firestore.collection('monuments').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Monument.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<List<Monument>> getMonumentsFuture() async {
    final snapshot = await _firestore.collection('monuments').get();
    return snapshot.docs.map((doc) {
      return Monument.fromFirestore(doc.data(), doc.id);
    }).toList();
  }
}
