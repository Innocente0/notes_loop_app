// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../bloc/notes_bloc.dart';
import '../bloc/notes_event.dart';
import '../bloc/notes_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hasLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasLoaded) {
      context.read<NotesBloc>().add(LoadNotes());
      _hasLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Top bubble
          Positioned(
            top: -60, right: -60,
            child: Container(
              width: 160, height: 160,
              decoration: const BoxDecoration(
                  color: Color(0xFFEA3C79), shape: BoxShape.circle),
            ),
          ),
          // Bottom wave
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: _BottomWave(),
              child: Container(
                height: 160, color: const Color(0xFFEA3C79),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                // ← Back + title
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: () {
                        context.read<NotesBloc>().add(LoadNotes());
                      },
                    ),
                  ]),
                ),

                // Notes list
                Expanded(
                  child: BlocBuilder<NotesBloc, NotesState>(
                    builder: (ctx, state) {
                      if (state is NotesLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFFEA3C79)),
                        );
                      }
                      if (state is NotesError) {
                        return Center(child: Text('Error: ${state.message}'));
                      }
                      if (state is NotesLoaded) {
                        final notes = state.notes;
                        print('UI: Displaying ${notes.length} notes');
                        if (notes.isEmpty) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.note_add, size: 64, color: Colors.grey),
                                SizedBox(height: 16),
                                Text('No notes yet. Tap + to add one!'),
                              ],
                            ),
                          );
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: notes.length,
                          itemBuilder: (iCtx, i) {
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
                              margin:
                              const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                title: Text(
                                  note['text'] as String,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  'Edited: $updated',
                                  style:
                                  TextStyle(color: Colors.grey[700]),
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
                                              _EditDialog(
                                                  initial: note['text']
                                                  as String),
                                        );
                                        if (newText != null) {
                                          context.read<NotesBloc>().add(
                                              UpdateNote(
                                                  note['id'], newText));
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
                      }
                      print('UI: Unknown state: $state');
                      return const Center(child: Text('Unknown state'));
                    },
                  ),
                ),

                // Add button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () async {
                      final text = await showDialog<String>(
                        context: context,
                        builder: (_) =>
                        const _EditDialog(initial: ''),
                      );
                      if (text != null && text.trim().isNotEmpty) {
                        context.read<NotesBloc>().add(AddNote(text));
                      }
                    },
                    child: const Icon(Icons.add, color: Color(0xFFEA3C79)),
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
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<_EditDialog> {
  late final TextEditingController _c;

  @override
  void initState() {
    super.initState();
    _c = TextEditingController(text: widget.initial);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
      Text(widget.initial.isEmpty ? 'New Note' : 'Edit Note'),
      content: TextField(
        controller: _c,
        maxLines: null,
        autofocus: true,
        decoration: const InputDecoration(
            hintText: 'Enter note text'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _c.text),
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEA3C79)),
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _BottomWave extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, 30)
      ..quadraticBezierTo(size.width * .5, 0, size.width, 30)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> old) =>
      false;
}
