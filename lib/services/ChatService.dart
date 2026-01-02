import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:relationship_coach_flutter/enum/chat_option.dart';
import 'package:relationship_coach_flutter/enum/chat_type.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';
import 'package:relationship_coach_flutter/model/RealLifeExample.dart';
import 'package:relationship_coach_flutter/model/conversation_starter.dart';
import 'package:relationship_coach_flutter/model/step.dart';
import 'package:relationship_coach_flutter/utils/json_utils.dart';

class Chatservice {
  Future<List<RealLifeExample>> getRealTimeExamples(
    ChatType option,
    Gender gender,
  ) async {
    var json = await JSONUtils.loadJsonData('lib/resources/${option.key}.json');
    var realLifeExamplesJSON = json[gender.name]['real_life_examples'];
    return RealLifeExample.fromList(realLifeExamplesJSON);
  }

  Future<Steps> getSteps(ChatType option, Gender gender) async {
    var json = await JSONUtils.loadJsonData('lib/resources/${option.key}.json');
    var steps = json[gender.name]['steps'];
    return Steps.fromJson(steps);
  }

  Future<List<ConversationStarter>> getConversationStarters(
    ChatType option,
    Gender gender,
  ) async {
    var json = await JSONUtils.loadJsonData('lib/resources/${option.key}.json');
    var conversationStarters = json[gender.name]['conversation_starters'];
    return ConversationStarter.fromList(conversationStarters);
  }
}
