import 'dart:convert';
import 'package:flutter/services.dart';

class JSONUtils {
  static Future<Map<String, dynamic>> loadJsonData(String filePath) async {
    // 1. Load the file as a string
    final String response = await rootBundle.loadString(filePath);

    // 2. Decode the string into a Map or List
    final data = await json.decode(response);

    return data;
  }
}
