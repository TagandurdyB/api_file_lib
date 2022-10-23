import 'package:http/http.dart' as http;
import 'dart:convert';

class Service {
  Future<bool> addImage(Map<String, String> body, String filepath) async {
    print("I am hear 1");
    String addimageUrl = 'https://it.net.tm/telfun/api/add';
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
    };
    var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
      ..fields.addAll(body)
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath('image', filepath));
    print("I am hear 2");
    var response = await request.send();
    print("+*+${response.statusCode}");
    if (response.statusCode == 201) {
      print("${response.statusCode}");
      return true;
    } else {
      print("${response.statusCode}");
      return false;
    }
  }
}