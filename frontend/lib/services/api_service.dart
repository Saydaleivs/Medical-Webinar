import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:3000'; // Base URL for API

  // Method to handle user login
  static Future login({required String role, required String username}) async {
    const url = '$_baseUrl/user'; // Endpoint for user login
    final Map<String, String> body = {
      'username': username,
      'role': role
    }; // Request body

    // Send POST request to the login endpoint
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'}, // Set headers
    );

    return jsonDecode(response.body); // Return response data
  }

  // Method to create a new webinar
  static Future createWebinar({
    required String authorId,
    required String image,
    required String title,
    required String date,
  }) async {
    const url = '$_baseUrl/webinar'; // Endpoint for creating a webinar
    final Map<String, String> body = {
      'authorId': authorId,
      'image': image,
      'title': title,
      'date': date,
    }; // Request body

    // Send POST request to create a webinar
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'}, // Set headers
    );

    return jsonDecode(response.body); // Return response data
  }

  // Method to get a list of webinars
  static Future<List<Map<String, dynamic>>?> getWebinars() async {
    const url = '$_baseUrl/webinar'; // Endpoint for retrieving webinars

    // Send GET request to retrieve webinars
    final response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'}, // Set headers
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>(); // Return list of webinars
    }

    return null;
  }

  // Method to end a webinar
  static Future<Map<String, dynamic>?> endWebinar(String webinarId) async {
    final url = '$_baseUrl/webinar/$webinarId'; // Endpoint for ending a webinar

    // Send DELETE request to end a webinar
    final response = await http.delete(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'}, // Set headers
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data; // Return response data
    }

    return null;
  }

  // Method to upload an image
  static Future uploadImage(File imageFile) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('$_baseUrl/files/upload'));

    // Add the image file to the request
    var file = await http.MultipartFile.fromPath('file', imageFile.path);
    request.files.add(file);

    // Send the request
    final response = await request.send();

    var responseBody = await response.stream.bytesToString();

    return '$_baseUrl/files/$responseBody'; // Return uploaded image URL
  }
}
