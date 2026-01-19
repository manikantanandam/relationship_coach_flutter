import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide Step;
import 'package:relationship_coach_flutter/enum/chat_type.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';
import 'package:relationship_coach_flutter/model/step.dart';

class AddStepsScreen extends StatefulWidget {
  final Gender gender;
  final ChatType type;
  final Steps? steps;

  const AddStepsScreen({
    super.key,
    required this.type,
    required this.gender,
    this.steps,
  });

  @override
  State<AddStepsScreen> createState() => _AddStepsScreenState();
}

class _AddStepsScreenState extends State<AddStepsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  final List<_StepControllers> _stepControllers = [];

  @override
  void initState() {
    super.initState();

    if (widget.steps != null) {
      _titleController.text = widget.steps!.title;
      for (final s in widget.steps!.steps) {
        _stepControllers.add(
          _StepControllers(
            idController: TextEditingController(text: s.id.toString()),
            stepController: TextEditingController(text: s.step),
          ),
        );
      }
    }

    if (_stepControllers.isEmpty) {
      _addStep();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (final c in _stepControllers) {
      c.idController.dispose();
      c.stepController.dispose();
    }
    super.dispose();
  }

  void _addStep() {
    setState(() {
      final nextId = _nextSuggestedId();
      _stepControllers.add(
        _StepControllers(
          idController: TextEditingController(text: nextId.toString()),
          stepController: TextEditingController(),
        ),
      );
    });
  }

  int _nextSuggestedId() {
    final ids = _stepControllers
        .map((c) => int.tryParse(c.idController.text.trim()))
        .whereType<int>()
        .toList();
    if (ids.isEmpty) return 1;
    ids.sort();
    return ids.last + 1;
  }

  void _removeStepAt(int index) {
    setState(() {
      final c = _stepControllers.removeAt(index);
      c.idController.dispose();
      c.stepController.dispose();
    });
  }

  Steps _buildStepsModel() {
    final steps = <Step>[];
    for (final c in _stepControllers) {
      final id = int.tryParse(c.idController.text.trim()) ?? 0;
      final text = c.stepController.text.trim();
      steps.add(Step(id: id, step: text));
    }
    steps.sort((a, b) => a.id.compareTo(b.id));
    return Steps(title: _titleController.text.trim(), steps: steps);
  }

  Future<void> _saveToFirestore() async {
    if (!_formKey.currentState!.validate()) return;

    final model = _buildStepsModel();
    try {
      // Path mirrors how RealLifeExamples are stored:
      // <chat_type>/<gender>/steps/steps
      await FirebaseFirestore.instance
          .collection(widget.type.name)
          .doc(widget.gender.name)
          .collection('steps')
          .doc('steps')
          .set(model.toJson());

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
        title: const Text('Add Steps'),
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
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (v) {
                if ((v ?? '').trim().isEmpty) return 'Title is required';
                return null;
              },
            ),
            const Divider(height: 40),
            Text(
              'Steps',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            ..._stepControllers.asMap().entries.map(
              (entry) => _buildStepFields(entry.key, entry.value),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _addStep,
              icon: const Icon(Icons.add),
              label: const Text('Add Step'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepFields(int idx, _StepControllers c) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Step ${idx + 1}'),
                ),
                IconButton(
                  tooltip: 'Remove',
                  onPressed: _stepControllers.length <= 1
                      ? null
                      : () => _removeStepAt(idx),
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 90,
                  child: TextFormField(
                    controller: c.idController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'ID'),
                    validator: (v) {
                      final parsed = int.tryParse((v ?? '').trim());
                      if (parsed == null) return 'ID must be a number';
                      if (parsed <= 0) return 'ID must be > 0';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: c.stepController,
                    decoration: const InputDecoration(labelText: 'Step text'),
                    validator: (v) {
                      if ((v ?? '').trim().isEmpty) return 'Step is required';
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StepControllers {
  TextEditingController idController;
  TextEditingController stepController;
  _StepControllers({required this.idController, required this.stepController});
}

