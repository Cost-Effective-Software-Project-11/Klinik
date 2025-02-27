import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_gp5/config/log.dart';
import 'package:flutter_gp5/models/workplace.dart';

class HospitalService {
  static const String _hospitalsJsonFile = 'assets/hospitals.json';

  Future<List<Workplace>> fetchWorkplaces() async {
    try {
      String jsonString = await _readJsonFile(_hospitalsJsonFile);
      List<dynamic> jsonData = _parseJson(jsonString);

      List<Workplace> hospitals = jsonData.map((hospitalData) {
        return Workplace.fromJson(hospitalData);
      }).toList();

      Log.info('All hospitals have been loaded successfully.');
      return hospitals;
    } catch (error) {
      Log.error('Error loading hospitals: $error');
      rethrow;
    }
  }

  Future<String> _readJsonFile(String filePath) async {
    try {
      return await rootBundle.loadString(filePath);
    } catch (error) {
      throw Exception('Error reading JSON file: $error');
    }
  }

  List<dynamic> _parseJson(String jsonString) {
    try {
      return jsonDecode(jsonString) as List<dynamic>;
    } catch (error) {
      throw Exception('Error parsing JSON: $error');
    }
  }
}
