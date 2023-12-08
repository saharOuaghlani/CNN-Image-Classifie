import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:lungsnap/Constants/TextInputs.dart';
import 'package:http/http.dart' as http;

class ServiceImage {
  final String baseUrl = '$baseCnxUrl/api';

  Future<Map<String, dynamic>?> uploadImageAndPredict(File imageFile) async {
    try {
      final url = Uri.parse('$baseUrl/predict');
      final request = http.MultipartRequest('POST', url);
      request.files.add(http.MultipartFile(
        'file',
        imageFile.readAsBytes().asStream(),
        imageFile.lengthSync(),
        filename: "userImage",
      ));

      final response = await request.send();
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> data = json.decode(responseBody);
        print(
            'Response from server: ${data['class_name']} ${data['prediction']}');
        return data;
      } else {
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
      Uri.parse('$baseUrl/testcnx'),
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
