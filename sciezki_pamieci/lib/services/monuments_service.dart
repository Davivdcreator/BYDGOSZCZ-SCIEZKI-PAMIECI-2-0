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

  // Cleanup duplicates from Firestore
  Future<void> removeDuplicates() async {
    print('Starting duplicate cleanup...');
    final snapshot = await _firestore.collection('monuments').get();
    final docs = snapshot.docs;

    // Group by name
    final Map<String, List<QueryDocumentSnapshot>> byName = {};
    for (var doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      final name = (data['name'] as String?)?.toLowerCase().trim() ?? '';
      if (name.isEmpty) continue;

      byName.putIfAbsent(name, () => []).add(doc);
    }

    final batch = _firestore.batch();
    int deletedCount = 0;

    // Sort and delete
    byName.forEach((name, list) {
      if (list.length > 1) {
        print('Found duplicate group: $name (${list.length} items)');

        // Sort critera:
        // 1. "Tier Unique" is best -> Tier S -> Tier A -> ...
        // 2. Has Image -> No Image
        // 3. Distance from default invalid location (further is better)

        list.sort((a, b) {
          final dataA = a.data() as Map<String, dynamic>;
          final dataB = b.data() as Map<String, dynamic>;

          // Check for unique tier
          final tierA = dataA['tier'] == 'tierUnique' ? 10 : 0;
          final tierB = dataB['tier'] == 'tierUnique' ? 10 : 0;
          if (tierA != tierB)
            return tierB.compareTo(tierA); // Higher tier first

          // Check for valid location (dist from 53.1235, 18.0084)
          final locA = _parseLoc(dataA['location']);
          final locB = _parseLoc(dataB['location']);
          final isBadA = _isBadLoc(locA) ? 1 : 0;
          final isBadB = _isBadLoc(locB) ? 1 : 0;
          if (isBadA != isBadB)
            return isBadA.compareTo(isBadB); // Lower badness (0) first

          return 0; // Equal
        });

        // Keep the first one (best), delete others
        for (var i = 1; i < list.length; i++) {
          print('Deleting duplicate: ${list[i].id} ($name)');
          batch.delete(list[i].reference);
          deletedCount++;
        }
      }
    });

    if (deletedCount > 0) {
      await batch.commit();
      print('Deleted $deletedCount duplicate monuments.');
    } else {
      print('No duplicates found.');
    }
  }

  bool _isBadLoc(GeoPoint? loc) {
    if (loc == null) return true;
    // Check if close to default center (within 0.0001)
    if ((loc.latitude - 53.1235).abs() < 0.0001 &&
        (loc.longitude - 18.0084).abs() < 0.0001) {
      return true;
    }
    return false;
  }

  GeoPoint? _parseLoc(dynamic loc) {
    if (loc is GeoPoint) return loc;
    if (loc is Map) {
      return GeoPoint((loc['latitude'] as num).toDouble(),
          (loc['longitude'] as num).toDouble());
    }
    return null;
  }
}
