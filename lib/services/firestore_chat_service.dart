import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:relationship_coach_flutter/enum/chat_type.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';
import 'package:relationship_coach_flutter/model/coaching_tips.dart';
import 'package:relationship_coach_flutter/model/diy.dart';
import 'package:relationship_coach_flutter/model/real_life_example.dart';
import 'package:relationship_coach_flutter/model/conversation_starter.dart';
import 'package:relationship_coach_flutter/model/step.dart';
import 'package:relationship_coach_flutter/services/firestore_service.dart';
import 'package:relationship_coach_flutter/utils/json_utils.dart';

class FirestoreChatService {
  Future<List<RealLifeExample>> getRealTimeExamples(
    ChatType option,
    Gender gender,
  ) async {
    // 1. Define the full nested path
    String collectionPath = "${option.name}/${gender.name}/real_life_examples";

    // 2. Initialize the service with this specific path
    final exampleService = FirestoreService<RealLifeExample>(
      collectionPath: collectionPath,
      fromJson: RealLifeExample.fromFirestore,
    );
    debugPrint('Get all once');
    var examples = await exampleService.getAllOnce();
    debugPrint('Got Real Life examples');
    return examples;
  }

  Future<Steps> getSteps(ChatType option, Gender gender) async {
    final snap = await FirebaseFirestore.instance
        .collection(option.name)
        .doc(gender.name)
        .collection('steps')
        .doc('steps')
        .get();

    final data = snap.data();
    if (data == null) {
      throw StateError('No steps found in Firestore for $option/$gender');
    }
    return Steps.fromJson(data);
  }

  Future<List<ConversationStarter>> getConversationStarters(
    ChatType option,
    Gender gender,
  ) async {
    final collectionPath =
        "${option.name}/${gender.name}/conversation_starters";
    final starterService = FirestoreService<ConversationStarter>(
      collectionPath: collectionPath,
      fromJson: ConversationStarter.fromFirestore,
    );
    final starters = await starterService.getAllOnce();
    starters.sort((a, b) => a.stepId.compareTo(b.stepId));
    return starters;
  }

  Future<CoachingTips> getCoachingTips(ChatType option, Gender gender) async {
    var json = await JSONUtils.loadJsonData('lib/resources/${option.key}.json');
    var conversationStarters = json[gender.name]['coaching_tips'];
    return CoachingTips.fromJson(conversationStarters);
  }

  Future<DoItYourselfModel> getDIYFormFields(
    ChatType option,
    Gender gender,
  ) async {
    var json = await JSONUtils.loadJsonData('lib/resources/${option.key}.json');
    var diyFormFields = json[gender.name]['diy'];
    return DoItYourselfModel.fromJson(diyFormFields);
  }
}
