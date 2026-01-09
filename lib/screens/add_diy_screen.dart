import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/enum/chat_type.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';
import 'package:relationship_coach_flutter/model/diy.dart';
import 'package:relationship_coach_flutter/services/ChatService.dart';

class AddDIYScreen extends StatefulWidget {
  const AddDIYScreen({super.key, required this.option, required this.gender});

  final ChatType option;
  final Gender gender;

  @override
  State<AddDIYScreen> createState() => _AddDIYScreenState();
}

class _AddDIYScreenState extends State<AddDIYScreen> {
  // Map to store controllers using the field ID as the key
  final Map<int, TextEditingController> _controllers = {};
  DoItYourselfModel? diyModel;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // 2. Added setState to trigger a UI refresh
  Future<void> _loadData() async {
    try {
      var diyModelResponse = await Chatservice().getDIYFormFields(
        widget.option,
        widget.gender,
      );

      for (var field in diyModelResponse.formFields) {
        _controllers[field.id] = TextEditingController();
      }

      setState(() {
        diyModel = diyModelResponse;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading data: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    // Clean up controllers to avoid memory leaks
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _handleSubmit() {
    // Collect all data into a simple map
    final responses = diyModel?.formFields.map((field) {
      return {
        "id": field.id,
        "label": field.label,
        "response": _controllers[field.id]?.text,
      };
    }).toList();

    print("Submitting Form: $responses");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Form Submitted Successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Do It Yourself'),
        // Adding the Right Bar Button we discussed
        actions: [
          TextButton(
            onPressed: _handleSubmit,
            child: const Text(
              'SUBMIT',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    diyModel!.subtitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Build the list of text fields dynamically
                  ...diyModel!.formFields.map(
                    (field) => _buildInputField(field),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInputField(DIYFormField field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Field Label
          Text(
            field.label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          // Field Prompt (Optional)
          if (field.prompt != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                field.prompt!,
                style: TextStyle(color: Colors.blueGrey[600], fontSize: 13),
              ),
            ),
          const SizedBox(height: 8),
          // Text Input Field
          TextField(
            controller: _controllers[field.id],
            decoration: InputDecoration(
              hintText: field.placeholder,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            maxLines: field.type == 'text_input'
                ? 3
                : 1, // Larger for descriptions
          ),
        ],
      ),
    );
  }
}
