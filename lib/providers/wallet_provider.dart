import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

// This provider gives access to the correct FirebaseDatabase instance
final firebaseDatabaseProvider = Provider<FirebaseDatabase>((ref) {
  return FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://go-med-9a330-default-rtdb.firebaseio.com/',
  );
});

// This provider fetches the wallet value for a given distributor ID
final walletProvider = FutureProvider.family<int?, String>((ref, distributorId) async {
  final db = ref.watch(firebaseDatabaseProvider); // Use the configured instance
  final dbRef = db.ref('bookings');

  final snapshot = await dbRef.orderByChild('distributor_id').equalTo(distributorId).get();

  if (snapshot.exists) {
    for (final child in snapshot.children) {
      final walletValue = child.child('wallet').value;
      if (walletValue != null) {
        return int.tryParse(walletValue.toString());
      }
    }
  }

  return null; // No wallet value found
});
