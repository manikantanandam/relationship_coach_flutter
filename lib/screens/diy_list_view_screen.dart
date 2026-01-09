import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/enum/chat_type.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';
import 'package:relationship_coach_flutter/screens/add_diy_screen.dart';

class DiyListViewScreen extends StatelessWidget {
  const DiyListViewScreen({
    super.key,
    required this.option,
    required this.gender,
  });

  final ChatType option;
  final Gender gender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Do It Yourself Add'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddDIYScreen(option: option, gender: gender),
                ),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Text(
        'To /"DO IT YOURSELF/",,click the  button on the top right corner.',
      ),
    );
  }
}
