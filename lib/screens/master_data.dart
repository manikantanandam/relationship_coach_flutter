import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/enum/chat_option.dart';
import 'package:relationship_coach_flutter/enum/chat_type.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';

class MasterDataScreen extends StatefulWidget {
  const MasterDataScreen({super.key});

  @override
  State<MasterDataScreen> createState() => _MasterDataScreenState();
}

class _MasterDataScreenState extends State<MasterDataScreen> {
  ChatType? selectedChat = .hisFault;
  ChatOptionType? selectedChatOption = .realLifeExamples;
  Gender? selectedGender = .female;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              spacing: 16,
              children: [
                DropdownButton<Gender>(
                  value: selectedGender,
                  items: Gender.values.map((Gender value) {
                    return DropdownMenuItem<Gender>(
                      value: value,
                      child: Text(value.name),
                    );
                  }).toList(),
                  onChanged: (Gender? newValue) {
                    setState(() {
                      selectedGender = newValue;
                    });
                  },
                ),
                DropdownButton<ChatType>(
                  value: selectedChat,
                  items: ChatType.values.map((ChatType value) {
                    return DropdownMenuItem<ChatType>(
                      value: value,
                      child: Text(value.title),
                    );
                  }).toList(),
                  onChanged: (ChatType? newValue) {
                    setState(() {
                      selectedChat = newValue;
                    });
                  },
                ),
                DropdownButton<ChatOptionType>(
                  value: selectedChatOption,
                  items: ChatOptionType.values.map((ChatOptionType value) {
                    return DropdownMenuItem<ChatOptionType>(
                      value: value,
                      child: Text(value.title),
                    );
                  }).toList(),
                  onChanged: (ChatOptionType? newValue) {
                    setState(() {
                      selectedChatOption = newValue;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
