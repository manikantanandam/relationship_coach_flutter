import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/enum/chat_type.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';
import 'package:relationship_coach_flutter/model/diy.dart';

class AddDoItYourselfScreen extends StatefulWidget {
  final Gender gender;
  final ChatType type;
  final DoItYourselfModel? diy;

  const AddDoItYourselfScreen({
    super.key,
    required this.type,
    required this.gender,
    this.diy,
  });

  @override
  State<AddDoItYourselfScreen> createState() => _AddDoItYourselfScreenState();
}

class _AddDoItYourselfScreenState extends State<AddDoItYourselfScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();

  final List<_DIYFieldControllers> _fieldControllers = [];

  @override
  void initState() {
    super.initState();

    if (widget.diy != null) {
      _titleController.text = widget.diy!.title;
      _subtitleController.text = widget.diy!.subtitle;
      for (final f in widget.diy!.formFields) {
        _fieldControllers.add(
          _DIYFieldControllers(
            idController: TextEditingController(text: f.id.toString()),
            labelController: TextEditingController(text: f.label),
            promptController: TextEditingController(text: f.prompt ?? ''),
            typeController: TextEditingController(text: f.type),
            placeholderController: TextEditingController(text: f.placeholder),
          ),
        );
      }
    }

    if (_fieldControllers.isEmpty) {
      _addField();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    for (final c in _fieldControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _addField() {
    setState(() {
      final nextId = _nextSuggestedId();
      _fieldControllers.add(
        _DIYFieldControllers(
          idController: TextEditingController(text: nextId.toString()),
          labelController: TextEditingController(),
          promptController: TextEditingController(),
          typeController: TextEditingController(text: 'text_input'),
          placeholderController: TextEditingController(),
        ),
      );
    });
  }

  int _nextSuggestedId() {
    final ids = _fieldControllers
        .map((c) => int.tryParse(c.idController.text.trim()))
        .whereType<int>()
        .toList();
    if (ids.isEmpty) return 1;
    ids.sort();
    return ids.last + 1;
  }

  void _removeFieldAt(int index) {
    setState(() {
      final c = _fieldControllers.removeAt(index);
      c.dispose();
    });
  }

  DoItYourselfModel _buildModel() {
    final fields = _fieldControllers.map((c) {
      final id = int.tryParse(c.idController.text.trim()) ?? 0;
      final prompt = c.promptController.text.trim();
      return DIYFormField(
        id: id,
        label: c.labelController.text.trim(),
        prompt: prompt.isEmpty ? null : prompt,
        type: c.typeController.text.trim(),
        placeholder: c.placeholderController.text.trim(),
        response: '',
      );
    }).toList()..sort((a, b) => a.id.compareTo(b.id));

    final now = DateTime.now();
    return DoItYourselfModel(
      title: _titleController.text.trim(),
      subtitle: _subtitleController.text.trim(),
      formFields: fields,
      createdAt: widget.diy?.createdAt ?? now,
      updatedAt: now,
    );
  }

  Future<void> _saveToFirestore() async {
    if (!_formKey.currentState!.validate()) return;
    final model = _buildModel();
    try {
      await FirebaseFirestore.instance
          .collection(widget.type.name)
          .doc(widget.gender.name)
          .collection('diy')
          .doc('diy')
          .set(model.toJson());

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Saved successfully!')));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Do It Yourself'),
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
              validator: (v) =>
                  (v ?? '').trim().isEmpty ? 'Title is required' : null,
            ),
            TextFormField(
              controller: _subtitleController,
              decoration: const InputDecoration(labelText: 'Subtitle'),
              validator: (v) =>
                  (v ?? '').trim().isEmpty ? 'Subtitle is required' : null,
            ),
            const Divider(height: 40),
            Text(
              'Form Fields',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            ..._fieldControllers.asMap().entries.map(
              (entry) => _buildFieldCard(entry.key, entry.value),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _addField,
              icon: const Icon(Icons.add),
              label: const Text('Add Field'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldCard(int idx, _DIYFieldControllers c) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text('Field ${idx + 1}')),
                IconButton(
                  tooltip: 'Remove',
                  onPressed: _fieldControllers.length <= 1
                      ? null
                      : () => _removeFieldAt(idx),
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
                    controller: c.typeController,
                    decoration: const InputDecoration(
                      labelText: 'Type (e.g. text_input)',
                    ),
                    validator: (v) =>
                        (v ?? '').trim().isEmpty ? 'Type is required' : null,
                  ),
                ),
              ],
            ),
            TextFormField(
              controller: c.labelController,
              decoration: const InputDecoration(labelText: 'Label'),
              validator: (v) =>
                  (v ?? '').trim().isEmpty ? 'Label is required' : null,
            ),
            TextFormField(
              controller: c.promptController,
              decoration: const InputDecoration(labelText: 'Prompt (optional)'),
            ),
            TextFormField(
              controller: c.placeholderController,
              decoration: const InputDecoration(labelText: 'Placeholder'),
              validator: (v) =>
                  (v ?? '').trim().isEmpty ? 'Placeholder is required' : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _DIYFieldControllers {
  final TextEditingController idController;
  final TextEditingController labelController;
  final TextEditingController promptController;
  final TextEditingController typeController;
  final TextEditingController placeholderController;

  _DIYFieldControllers({
    required this.idController,
    required this.labelController,
    required this.promptController,
    required this.typeController,
    required this.placeholderController,
  });

  void dispose() {
    idController.dispose();
    labelController.dispose();
    promptController.dispose();
    typeController.dispose();
    placeholderController.dispose();
  }
}
