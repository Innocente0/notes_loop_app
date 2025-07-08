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
      body: Stack(
        children: [
          // Top pink bubble
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

          // Bottom pink wave
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

          // Safe-area content
          SafeArea(
            child: Column(
              children: [
                // ← Back arrow + “NOTES” title
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () =>
                            Navigator.pushReplacementNamed(context, '/login'),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'NOTES',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Notes list
                Expanded(
                  child: BlocBuilder<NotesBloc, NotesState>(
                    builder: (context, state) {
                      if (state is NotesLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFEA3C79),
                          ),
                        );
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
                          final updated = ts != null
                              ? ts.toDate().toString()
                              : '––';
                          final bg = [
                            Colors.lightBlue.shade100,
                            Colors.pink.shade100,
                            Colors.yellow.shade100
                          ][i % 3];

                          return Card(
                            color: bg,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(
                                note['text'] as String,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'Edited: $updated',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () async {
                                      final newText =
                                      await showDialog<String>(
                                        context: context,
                                        builder: (_) =>
                                            _EditDialog(initial: note['text']
                                            as String),
                                      );
                                      if (newText != null) {
                                        context.read<NotesBloc>().add(
                                            UpdateNote(note['id'], newText));
                                      }
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

                // Floating Add button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.add, color: Color(0xFFEA3C79)),
                    onPressed: () async {
                      final text = await showDialog<String>(
                        context: context,
                        builder: (_) => const _EditDialog(initial: ''),
                      );
                      if (text != null && text.trim().isNotEmpty) {
                        context.read<NotesBloc>().add(AddNote(text.trim()));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EditDialog extends StatefulWidget {
  final String initial;
  const _EditDialog({required this.initial});

  @override
  State<_EditDialog> createState() => __EditDialogState();
}

class __EditDialogState extends State<_EditDialog> {
  late TextEditingController _c;

  @override
  void initState() {
    super.initState();
    _c = TextEditingController(text: widget.initial);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initial.isEmpty ? 'New Note' : 'Edit Note'),
      content: TextField(
        controller: _c,
        maxLines: null,
        decoration: const InputDecoration(hintText: 'Enter note text'),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _c.text),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFEA3C79),
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _BottomWave extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final p = Path()
      ..lineTo(0, 30)
      ..quadraticBezierTo(size.width * .5, 0, size.width, 30)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> old) => false;
}
