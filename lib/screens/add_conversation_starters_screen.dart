import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide Step;
import 'package:relationship_coach_flutter/enum/chat_type.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';
import 'package:relationship_coach_flutter/model/conversation_starter.dart';
import 'package:relationship_coach_flutter/model/rc_statement.dart';
import 'package:relationship_coach_flutter/model/rc_statement_part.dart';

class AddConversationStartersScreen extends StatefulWidget {
  final Gender gender;
  final ChatType type;
  final ConversationStarter? starter;

  const AddConversationStartersScreen({
    super.key,
    required this.type,
    required this.gender,
    this.starter,
  });

  @override
  State<AddConversationStartersScreen> createState() =>
      _AddConversationStartersScreenState();
}

class _AddConversationStartersScreenState
    extends State<AddConversationStartersScreen> {
  final _formKey = GlobalKey<FormState>();

  final _stepIdController = TextEditingController();
  final _titleController = TextEditingController();

  List<_StatementControllers> _statementControllers = [];

  @override
  void initState() {
    super.initState();

    if (widget.starter != null) {
      _stepIdController.text = widget.starter!.stepId.toString();
      _titleController.text = widget.starter!.title;
      _statementControllers = widget.starter!.statements.map((statement) {
        return _StatementControllers(
          speakerController: TextEditingController(text: statement.speaker),
          parts: statement.statementParts.map((part) {
            return _PartControllers(
              type: part.type,
              contentController: TextEditingController(text: part.content),
            );
          }).toList(),
        );
      }).toList();
    } else {
      _addStatement();
    }
  }

  @override
  void dispose() {
    _stepIdController.dispose();
    _titleController.dispose();
    for (final s in _statementControllers) {
      s.speakerController.dispose();
      for (final p in s.parts) {
        p.contentController.dispose();
      }
    }
    super.dispose();
  }

  void _addStatement() {
    setState(() {
      _statementControllers.add(
        _StatementControllers(
          speakerController: TextEditingController(),
          parts: [
            _PartControllers(
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

    final stepId = int.tryParse(_stepIdController.text.trim()) ?? 0;

    final statements = _statementControllers.map((s) {
      final parts = s.parts
          .map(
            (p) => RCStatementPart(type: p.type, content: p.contentController.text),
          )
          .toList();
      return RCStatement(speaker: s.speakerController.text, statementParts: parts);
    }).toList();

    final starter = ConversationStarter(
      stepId: stepId,
      title: _titleController.text.trim(),
      statements: statements,
    );

    try {
      await FirebaseFirestore.instance
          .collection(widget.type.name)
          .doc(widget.gender.name)
          .collection('conversation_starters')
          .doc(stepId.toString())
          .set(starter.toJson());

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
        title: const Text('Add Conversation Starters'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveToFirestore),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _stepIdController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Step ID'),
              validator: (v) {
                final parsed = int.tryParse((v ?? '').trim());
                if (parsed == null) return 'Step ID must be a number';
                if (parsed <= 0) return 'Step ID must be > 0';
                return null;
              },
            ),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (v) {
                if ((v ?? '').trim().isEmpty) return 'Title is required';
                return null;
              },
            ),
            const Divider(height: 40),
            Text(
              'Starters',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            ..._statementControllers.asMap().entries.map(
              (entry) => _buildStatementFields(entry.key, entry.value),
            ),
            ElevatedButton.icon(
              onPressed: _addStatement,
              icon: const Icon(Icons.add),
              label: const Text('Add Starter'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatementFields(int sIdx, _StatementControllers sCont) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: sCont.speakerController,
              decoration: const InputDecoration(labelText: 'Speaker (optional)'),
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
                      validator: (v) {
                        if ((v ?? '').trim().isEmpty) return 'Content is required';
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.swap_horiz),
                    onPressed: () => setState(
                      () => pEntry.value.type =
                          pEntry.value.type == 'text' ? 'metadata' : 'text',
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () => setState(
                    () => sCont.parts.add(
                      _PartControllers(
                        type: 'text',
                        contentController: TextEditingController(),
                      ),
                    ),
                  ),
                  child: const Text('Add Part'),
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'Remove starter',
                  onPressed: _statementControllers.length <= 1
                      ? null
                      : () => setState(() {
                            final removed =
                                _statementControllers.removeAt(sIdx);
                            removed.speakerController.dispose();
                            for (final p in removed.parts) {
                              p.contentController.dispose();
                            }
                          }),
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatementControllers {
  TextEditingController speakerController;
  List<_PartControllers> parts;
  _StatementControllers({required this.speakerController, required this.parts});
}

class _PartControllers {
  String type;
  TextEditingController contentController;
  _PartControllers({required this.type, required this.contentController});
}

