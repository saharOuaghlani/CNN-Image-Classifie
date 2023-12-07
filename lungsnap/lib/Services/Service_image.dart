import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:lungsnap/Constants/TextInputs.dart';
import 'package:http/http.dart' as http;

class ServiceImage {
  final String baseUrl = '$baseCnxUrl';

  Future<Map<String, dynamic>?> uploadImage(File imageFile) async {
    try {
      final url = Uri.parse('$baseCnxUrl/api/predict');
      final request = http.MultipartRequest('POST', url);
      request.files.add(http.MultipartFile(
        'file',
        imageFile.readAsBytes().asStream(),
        imageFile.lengthSync(),
        filename: "theFileName",
      ));

      final response = await request.send();
      if (response.statusCode == 200) {
        // Image uploaded successfully
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> data = json.decode(responseBody);
        print('Response from server: ${data['test']}');
        return data;
      } else {
        // Image upload failed
        print('Image upload failed with status code: ${response.statusCode}');
        print('Response from server: ${await response.stream.bytesToString()}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
    return null;
  }

  Future<String?> connectToServer() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/testcnx'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      Map res = json.decode(response.body) as Map<String, dynamic>;
      print(res);
      return res['testCnx'] as String;
    } else {
      throw Exception('Failed to register user');
    }
  }
}
