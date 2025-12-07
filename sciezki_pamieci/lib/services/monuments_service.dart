import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/monument.dart';
import '../data/new_monuments_seeder.dart';

class MonumentsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Monument>> getMonuments() {
    return _firestore.collection('monuments').snapshots().map((snapshot) {
      print('Firestore: Fetched ${snapshot.docs.length} documents');
      return snapshot.docs
          .map((doc) {
            try {
              return Monument.fromFirestore(doc.data(), doc.id);
            } catch (e) {
              print('Error parsing monument ${doc.id}: $e');
              return null;
            }
          })
          .whereType<Monument>()
          .toList();
    });
  }

  Future<List<Monument>> getMonumentsFuture() async {
    final snapshot = await _firestore.collection('monuments').get();
    return snapshot.docs.map((doc) {
      return Monument.fromFirestore(doc.data(), doc.id);
    }).toList();
  }

  // Batch upload seeds
  Future<void> seedMonuments(List<Monument> monuments) async {
    print('Starting seed of ${monuments.length} monuments...');
    final batch = _firestore.batch();
    for (var monument in monuments) {
      final docRef = _firestore.collection('monuments').doc(monument.id);

      final data = {
        'name': monument.name,
        'description': monument.description,
        'shortDescription': monument.shortDescription,
        'location':
            GeoPoint(monument.location.latitude, monument.location.longitude),
        'tier': monument.tier.toString().split('.').last,
        'imageUrl': monument.imageUrl,
        'year': monument.year,
        'style': monument.style,
        'architect': monument.architect,
        'tags': monument.tags,
        'aiPersonality': monument.aiPersonality,
        'sampleQuestions': monument.sampleQuestions,
      };

      batch.set(docRef, data, SetOptions(merge: true));
    }
    await batch.commit();
    print('Seeded ${monuments.length} monuments to Firestore successfully');
  }

  // Auto-update unique monuments (images, descriptions) from local source
  Future<void> autoUpdateUniqueMonuments() async {
    print('Starting auto-update of unique monuments...');
    final batch = _firestore.batch();

    for (var data in newUniqueMonuments) {
      final String id = data['id'];
      final docRef = _firestore.collection('monuments').doc(id);

      Map<String, dynamic> updateData = Map.from(data);

      // Ensure location is a GeoPoint
      if (updateData['location'] is Map) {
        final locMap = updateData['location'] as Map;
        updateData['location'] = GeoPoint(
            (locMap['latitude'] as num).toDouble(),
            (locMap['longitude'] as num).toDouble());
      }

      // Merge to overwrite specific fields like imageUrl
      batch.set(docRef, updateData, SetOptions(merge: true));
    }

    await batch.commit();
    print('Auto-update of unique monuments complete.');
  }
}
