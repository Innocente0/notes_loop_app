import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../bloc/notes_bloc.dart';
import '../bloc/notes_event.dart';
import '../bloc/notes_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        // Top bubble
        Positioned(
          top: -60,
          right: -60,
          child: Container(
            width: 160,
            height: 160,
            decoration: const BoxDecoration(
              color: Color(0xFFEA3C79),
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Bottom wave
        Align(
          alignment: Alignment.bottomCenter,
          child: ClipPath(
            clipper: _BottomWave(),
            child: Container(
              height: 160,
              color: const Color(0xFFEA3C79),
            ),
          ),
        ),

        // Content
        SafeArea(
          child: Column(children: [
            const SizedBox(height: 24),
            const Text(
              'Your Notes',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<NotesBloc, NotesState>(
                builder: (context, state) {
                  if (state is NotesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is NotesError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  final notes = (state as NotesLoaded).notes;
                  if (notes.isEmpty) {
                    return const Center(child: Text('No notes yet.'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: notes.length,
                    itemBuilder: (ctx, i) {
                      final note = notes[i];
                      final ts = note['updatedAt'] as Timestamp?;
                      final updated =
                      ts != null ? ts.toDate().toString() : '––';
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(note['text'] as String),
                          subtitle: Text(updated),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // …edit logic remains
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => context
                                    .read<NotesBloc>()
                                    .add(DeleteNote(note['id'])),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Add button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                onPressed: () {
                  // …add logic remains
                },
                backgroundColor: Colors.white,
                child: const Icon(Icons.add, color: Color(0xFFEA3C79)),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _BottomWave extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final p = Path();
    p.lineTo(0, 30);
    p.quadraticBezierTo(size.width * .5, 0, size.width, 30);
    p.lineTo(size.width, size.height);
    p.lineTo(0, size.height);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> old) => false;
}
