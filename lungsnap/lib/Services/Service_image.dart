import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:lungsnap/Constants/TextInputs.dart';
import 'package:http/http.dart' as http;

class ServiceImage {
  final String baseUrl = '$baseCnxUrl';

  uploadImage(File imageFile) async {
    print(await imageFile.length());
    /*  final url = Uri.parse('$baseCnxUrl/ressource/upload');
    final request = http.MultipartRequest('POST', url);
    request.files.add(http.MultipartFile(
      'file',
      imageFile!.readAsBytes().asStream(),
      imageFile!.lengthSync(),
      filename: "theFileName"
          .toString(), //the name of the image shoul be by the idBlog-idUser.jpg
    ));

    final response = await request.send();
    if (response.statusCode == 200) {
      print('Image uploaded successfully');
    } else {
      print(response);
      print('Image upload failed');
    } */
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
