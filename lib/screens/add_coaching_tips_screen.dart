import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/enum/chat_type.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';
import 'package:relationship_coach_flutter/model/coaching_tips.dart';
import 'package:relationship_coach_flutter/model/rc_statement.dart';
import 'package:relationship_coach_flutter/model/rc_statement_part.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCoachingTipsScreen extends StatefulWidget {
  final Gender gender;
  final ChatType type;
  final CoachingTips? coachingTips;

  const AddCoachingTipsScreen({
    super.key,
    required this.type,
    required this.gender,
    this.coachingTips,
  });

  @override
  _AddCoachingTipsScreenState createState() => _AddCoachingTipsScreenState();
}

class _AddCoachingTipsScreenState extends State<AddCoachingTipsScreen> {
  final _formKey = GlobalKey<FormState>();

  // Nested controllers for Statements and their Parts
  List<StatementControllers> _statementControllers = [];

  @override
  void initState() {
    super.initState();

    // If we have initial data, populate the controllers
    if (widget.coachingTips != null) {
      // Map existing statements to their controllers
      _statementControllers = widget.coachingTips!.statements.map((statement) {
        return StatementControllers(
          speakerController: TextEditingController(text: statement.speaker),
          parts: statement.statementParts.map((part) {
            return PartControllers(
              type: part.type, // "text" or "metadata"
              contentController: TextEditingController(text: part.content),
            );
          }).toList(),
        );
      }).toList();
    } else {
      // Default state for a brand new entry
      _addStatement();
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (final controller in _statementControllers) {
      controller.speakerController.dispose();
      for (final part in controller.parts) {
        part.contentController.dispose();
      }
    }
    super.dispose();
  }

  void _addStatement() {
    setState(() {
      _statementControllers.add(
        StatementControllers(
          speakerController: TextEditingController(),
          parts: [
            PartControllers(
              type: 'text',
              contentController: TextEditingController(),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _saveToFirestore() async {
    if (!_formKey.currentState!.validate()) return;

    // Convert controllers back into Model objects
    final statements = _statementControllers.map((s) {
      final parts = s.parts
          .map(
            (p) => RCStatementPart(
              type: p.type,
              content: p.contentController.text,
            ),
          )
          .toList();

      return RCStatement(
        speaker: s.speakerController.text,
        statementParts: parts,
      );
    }).toList();

    final coachingTips = CoachingTips(statements: statements);

    try {
      // Path: <chat_type>/<gender>/coaching_tips
      await FirebaseFirestore.instance
          .collection(widget.type.name)
          .doc(widget.gender.name)
          .collection('coaching_tips')
          .doc('coaching_tips')
          .set(coachingTips.toJson());

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Coaching Tips'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveToFirestore),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Statements',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ..._statementControllers.asMap().entries.map(
              (entry) => _buildStatementFields(entry.key, entry.value),
            ),
            ElevatedButton.icon(
              onPressed: _addStatement,
              icon: const Icon(Icons.add),
              label: const Text('Add Statement'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatementFields(int sIdx, StatementControllers sCont) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: sCont.speakerController,
                    decoration: const InputDecoration(labelText: 'Speaker'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeStatementAt(sIdx),
                ),
              ],
            ),
            ...sCont.parts.asMap().entries.map(
              (pEntry) => Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: pEntry.value.contentController,
                      decoration: InputDecoration(
                        labelText: 'Part Content (${pEntry.value.type})',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.swap_horiz),
                    onPressed: () => setState(
                      () => pEntry.value.type = pEntry.value.type == 'text'
                          ? 'metadata'
                          : 'text',
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removePartAt(sIdx, pEntry.key),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => setState(
                () => sCont.parts.add(
                  PartControllers(
                    type: 'text',
                    contentController: TextEditingController(),
                  ),
                ),
              ),
              child: const Text('Add Part'),
            ),
          ],
        ),
      ),
    );
  }

  void _removeStatementAt(int index) {
    setState(() {
      final c = _statementControllers.removeAt(index);
      c.speakerController.dispose();
      for (final part in c.parts) {
        part.contentController.dispose();
      }
    });
  }

  void _removePartAt(int statementIndex, int partIndex) {
    setState(() {
      final statement = _statementControllers[statementIndex];
      final part = statement.parts.removeAt(partIndex);
      part.contentController.dispose();
    });
  }
}

// Helper classes to manage the state of the controllers
class StatementControllers {
  TextEditingController speakerController;
  List<PartControllers> parts;
  StatementControllers({required this.speakerController, required this.parts});
}

class PartControllers {
  String type;
  TextEditingController contentController;
  PartControllers({required this.type, required this.contentController});
}
