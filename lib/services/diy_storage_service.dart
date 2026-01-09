import 'dart:convert';
import 'package:relationship_coach_flutter/enum/chat_type.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';
import 'package:relationship_coach_flutter/model/diy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DIYStorage {
  ChatType type;
  Gender gender;

  DIYStorage(this.gender, this.type);

  String get _key {
    // Logic: "male_toxic", "female_sweet", etc.
    return "${gender.name}_${type.name}";
  }

  // --- GET ALL ITEMS ---
  Future<List<DoItYourselfModel>> getDIYList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_key);

    if (jsonString == null || jsonString.isEmpty) return [];

    try {
      List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((item) => DoItYourselfModel.fromJson(item)).toList();
    } catch (e) {
      print("Error decoding DIY list: $e");
      return [];
    }
  }

  // --- SAVE ENTIRE LIST (Overwrite) ---
  Future<void> saveDIYList(List<DoItYourselfModel> diyList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(
      diyList.map((item) => item.toJson()).toList(),
    );
    await prefs.setString(_key, jsonString);
  }

  // --- ADD SINGLE ITEM TO EXISTING LIST ---
  Future<void> addDIYItem(DoItYourselfModel newItem) async {
    // 1. Fetch the existing list
    List<DoItYourselfModel> currentList = await getDIYList();

    // 2. Add the new item to the local list
    currentList.add(newItem);

    // 3. Save the updated list back to SharedPreferences
    await saveDIYList(currentList);
  }

  // --- CLEAR ALL ---
  Future<void> clearData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
