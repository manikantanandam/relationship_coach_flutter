import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/enum/chat_option.dart';
import 'package:relationship_coach_flutter/enum/chat_type.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';
import 'package:relationship_coach_flutter/model/rc_statement.dart';
import 'package:relationship_coach_flutter/model/rc_statement_part.dart';
import 'package:relationship_coach_flutter/model/real_life_example.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Import your models here

class AddRealLifeExampleScreen extends StatefulWidget {
  final Gender gender;
  final ChatType type;
  final RealLifeExample? example;

  const AddRealLifeExampleScreen({
    super.key,
    required this.type,
    required this.gender,
    this.example,
  });

  @override
  _AddRealLifeExampleScreenState createState() =>
      _AddRealLifeExampleScreenState();
}

class _AddRealLifeExampleScreenState extends State<AddRealLifeExampleScreen> {
  final _formKey = GlobalKey<FormState>();

  // Top-level controllers
  final _idController = TextEditingController();
  final _titleController = TextEditingController();
  final _scenarioController = TextEditingController();

  // Nested controllers for Statements and their Parts
  List<StatementControllers> _statementControllers = [];

  @override
  void initState() {
    super.initState();

    // If we have initial data, populate the controllers
    if (widget.example != null) {
      _idController.text = widget.example!.id;
      _titleController.text = widget.example!.title;
      _scenarioController.text = widget.example!.scenario;

      // Map existing statements to their controllers
      _statementControllers = widget.example!.statements.map((statement) {
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

    final example = RealLifeExample(
      id: _idController.text,
      title: _titleController.text,
      scenario: _scenarioController.text,
      statements: statements,
    );

    try {
      // Using the toJson() method from your model
      await FirebaseFirestore.instance
          .collection(widget.type.name)
          .doc(widget.gender.name)
          .collection('real_life_examples')
          .doc(example.id)
          .set(example.toJson());

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Saved successfully!')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Real Life Example'),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: _saveToFirestore),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _idController,
              decoration: InputDecoration(labelText: 'ID'),
            ),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextFormField(
              controller: _scenarioController,
              decoration: InputDecoration(labelText: 'Scenario'),
            ),
            Divider(height: 40),
            Text(
              'Statements',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            ..._statementControllers.asMap().entries.map(
              (entry) => _buildStatementFields(entry.key, entry.value),
            ),
            ElevatedButton.icon(
              onPressed: _addStatement,
              icon: Icon(Icons.add),
              label: Text('Add Statement'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatementFields(int sIdx, StatementControllers sCont) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: sCont.speakerController,
              decoration: InputDecoration(labelText: 'Speaker'),
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
                    icon: Icon(Icons.swap_horiz),
                    onPressed: () => setState(
                      () => pEntry.value.type = pEntry.value.type == 'text'
                          ? 'metadata'
                          : 'text',
                    ),
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
              child: Text('Add Part'),
            ),
          ],
        ),
      ),
    );
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
