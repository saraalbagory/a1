import 'dart:convert';
import 'package:http/http.dart' as http;

class APIservice {
  //android emulator http://10.0.2.2
  //ios or device ipconfig
  static const String baseUrl = "http://localhost:8080/api/students";
  static Future<Map<String, dynamic>> signUp(
    Map<String, dynamic> studentData,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sign_up'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(studentData),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body); // Success - return student data
    } else {
      return {"error": response.body}; // Error message
    }
  }
}
