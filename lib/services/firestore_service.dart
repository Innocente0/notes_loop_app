// lib/services/firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fetch all notes for current user
  Future<List<Map<String, dynamic>>> fetchNotes() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final snapshot = await _firestore
        .collection('notes')
        .where('userId', isEqualTo: user.uid)
        .orderBy('updatedAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data()})
        .toList();
  }

  // Create a new note
  Future<void> addNote(String text) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _firestore.collection('notes').add({
      'text': text,
      'userId': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Update an existing note
  Future<void> updateNote(String id, String text) async {
    await _firestore.collection('notes').doc(id).update({
      'text': text,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Delete a note
  Future<void> deleteNote(String id) async {
    await _firestore.collection('notes').doc(id).delete();
  }
}
