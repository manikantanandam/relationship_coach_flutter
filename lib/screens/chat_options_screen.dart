import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/enum/chat_type.dart';

class ChatOptionScreen extends StatelessWidget {
  const ChatOptionScreen({super.key, required this.option});

  final ChatType option;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(option.title)),
      body: Text(option.title),
    );
  }
}
