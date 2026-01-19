import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/enum/chat_type.dart';
import 'package:relationship_coach_flutter/enum/feature_flag_key.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';
import 'package:relationship_coach_flutter/model/diy.dart';
import 'package:relationship_coach_flutter/screens/add_do_it_yourself_screen.dart';
import 'package:relationship_coach_flutter/services/ChatService.dart';
import 'package:relationship_coach_flutter/services/firestore_chat_service.dart';
import 'package:relationship_coach_flutter/services/local_feature_flag_manager.dart';

class AddDIYScreen extends StatefulWidget {
  const AddDIYScreen({
    super.key,
    required this.option,
    required this.gender,
    this.diyModel,
  });

  final ChatType option;
  final Gender gender;
  final DoItYourselfModel? diyModel;

  @override
  State<AddDIYScreen> createState() => _AddDIYScreenState();
}

class _AddDIYScreenState extends State<AddDIYScreen> {
  // Map to store controllers using the field ID as the key
  final Map<int, TextEditingController> _controllers = {};
  DoItYourselfModel? _diyModel;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.diyModel == null) {
      debugPrint('DIY model is not available. load data for empty form');
      _loadData();
    } else {
      debugPrint('DIY available');
      // var json = widget.diyModel?.toJson();
      debugPrint(widget.diyModel?.toJson().toString());
      _diyModel = widget.diyModel;
      for (var field in _diyModel!.formFields) {
        _controllers[field.id] = TextEditingController(text: field.response);
      }
      _isLoading = false;
    }
  }

  // 2. Added setState to trigger a UI refresh
  Future<void> _loadData() async {
    try {
      DoItYourselfModel diyModelResponse;
      ChatServiceType provider = LocalFeatureFlagManager()
          .getValue<ChatServiceType>(FeatureKey.chatProvider);

      if (provider == ChatServiceType.firebase) {
        debugPrint('Getting DIY template from firebase');
        try {
          diyModelResponse = await FirestoreChatService().getDIYFormFields(
            widget.option,
            widget.gender,
          );
        } catch (e) {
          return;
        }
      } else {
        debugPrint('Getting DIY template from local');
        diyModelResponse = await LocalChatService().getDIYFormFields(
          widget.option,
          widget.gender,
        );
      }

      for (var field in diyModelResponse.formFields) {
        _controllers[field.id] = TextEditingController(text: field.response);
      }

      setState(() {
        _diyModel = diyModelResponse;
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

  void _handleSubmit() async {
    if (_diyModel == null) return;

    // If/when you want to persist DIY responses, build/save them here:
    // final updatedFields = _diyModel!.formFields.map((field) { ... }).toList();
    // (Previously this was intended to go into DIYStorage.)

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Form Submitted Successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Do It Yourself'),
        backgroundColor: widget.gender.color,
        foregroundColor: Colors.white,
        // Adding the Right Bar Button we discussed
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _diyModel == null
                ? null
                : () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return AddDoItYourselfScreen(
                            type: widget.option,
                            gender: widget.gender,
                            diy: _diyModel,
                          );
                        },
                      ),
                    );
                    // Reload data after returning from edit screen
                    _loadData();
                  },
            tooltip: 'Edit Template',
          ),
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
                    _diyModel!.subtitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Build the list of text fields dynamically
                  ..._diyModel!.formFields.map(
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
