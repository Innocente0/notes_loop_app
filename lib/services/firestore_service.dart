// lib/services/firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final _notesRef = FirebaseFirestore.instance.collection('notes');
  final _auth = FirebaseAuth.instance;

  Future<List<Map<String, dynamic>>> fetchNotes() async {
    final user = _auth.currentUser;
    print('Current user: ${user?.uid}');
    if (user == null) {
      print('No user logged in');
      return [];
    }
    
    final snap = await _notesRef
        .where('userId', isEqualTo: user.uid)
        .orderBy('updatedAt', descending: true)
        .get();
    
    print('Found ${snap.docs.length} notes');
    final notes = snap.docs
        .map((doc) => {
      'id': doc.id,
      ...doc.data(),
    })
        .toList();
    print('Notes: $notes');
    return notes;
  }

  Future<void> addNote(String text) async {
    final user = _auth.currentUser;
    if (user == null) return;
    
    print('Adding note: $text for user: ${user.uid}');
    await _notesRef.add({
      'text': text,
      'userId': user.uid,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    print('Note added successfully');
  }

  Future<void> updateNote(String id, String text) async {
    await _notesRef.doc(id).update({
      'text': text,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteNote(String id) async {
    await _notesRef.doc(id).delete();
  }
}
