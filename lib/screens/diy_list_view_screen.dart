import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/components/rc_card.dart';
import 'package:relationship_coach_flutter/constants.dart/constants.dart';
import 'package:relationship_coach_flutter/enum/chat_type.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';
import 'package:relationship_coach_flutter/model/diy.dart';
import 'package:relationship_coach_flutter/screens/add_diy_screen.dart';
import 'package:relationship_coach_flutter/services/diy_storage_service.dart';

class DiyListViewScreen extends StatefulWidget {
  const DiyListViewScreen({
    super.key,
    required this.option,
    required this.gender,
  });

  final ChatType option;
  final Gender gender;

  @override
  State<DiyListViewScreen> createState() => _DiyListViewScreenState();
}

class _DiyListViewScreenState extends State<DiyListViewScreen> {
  List<DoItYourselfModel> diys = [];
  late DIYStorage _storage;

  @override
  void initState() {
    super.initState();
    _storage = DIYStorage(widget.gender, widget.option);
    // _loadData();
  }

  Future<void> _loadData() async {
    var fetchedDiys = await _storage.getDIYList();
    setState(() {
      diys = fetchedDiys;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Do It Yourself Add'),
        backgroundColor: widget.gender.color,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => _navigateAndRefresh(null),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: diysBody,
    );
  }

  Widget get diysBody {
    if (diys.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'To \"DO IT YOURSELF\", click the  button on the top right corner.',
          style: kLabelTextStyle(context),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: diys.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _navigateAndRefresh(diys[index]);
            },
            child: RCCard(
              cardWidget: Row(
                children: [
                  Expanded(child: Text(diys[index].createdAt.toString())),
                  MaterialButton(
                    child: Icon(Icons.delete),
                    onPressed: () {
                      diys.removeAt(index);
                      _storage.saveDIYList(diys);
                      _loadData();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  // In your Main/List Screen
  void _navigateAndRefresh(DoItYourselfModel? model) async {
    // Execution stops here until AddDIYScreen is popped
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddDIYScreen(
          option: widget.option,
          gender: widget.gender,
          diyModel: model,
        ),
      ),
    );

    // This code runs AUTOMATICALLY when the user comes back
    print("User is back!");
    _loadData();
  }
}
