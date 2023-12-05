import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:lungsnap/Constants/TextInputs.dart';

class ServiceImage {
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
}
