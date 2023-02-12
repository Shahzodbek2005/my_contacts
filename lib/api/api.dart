import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:my_contacts/models/model_finger.dart';
import 'package:my_contacts/models/model_get_top_contacts.dart';
import 'package:my_contacts/models/model_main_data.dart';

class Api {
  String host = "132.145.138.206:8080";
  Future<Map> register(String phone, String pasword, String firstname,
      String lastname, String bio, String picture) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://$host/api/auth/register'));
    request.fields.addAll({
      'phone': phone,
      'password': pasword,
      'firstname': firstname,
      'lastname': lastname,
      'bio': bio,
    });
    if (picture.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('picture', picture));
      log("hhhjhhfdiudfsih");
    }

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      log("hhh");
      return jsonDecode(await response.stream.bytesToString());
    } else {
      return {"status": false, "message": "Nimadur xato ketdi !"};
    }
  }

  Future<bool> checkLogin(String phone) async {
    var request = http.MultipartRequest(
        'GET', Uri.parse('http://$host/api/auth/checkUser'));
    request.fields.addAll({'phone': phone});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString());
    } else {
      return false;
    }
  }

  Future<Map> login(String phone, String password) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('http://$host/api/auth/login'));
    request.fields.addAll({'phone': phone, 'password': password});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString());
    } else if (response.statusCode == 401) {
      String message = await response.stream.bytesToString();
      return {
        "status": false,
        "message": message,
      };
    } else {
      return {
        "message": "Nimadur xato ketdi",
        "tokenType": null,
        "status": false,
        "token": null
      };
    }
  }

  saveContact(String token, List str) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request =
        http.Request('POST', Uri.parse('http://$host/api/contacts/sync'));

    request.body = json.encode(str);
    log(json.encode(str));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      log("save contact 200");
    } else {
      response.stream.bytesToString().then((value) {
        log("$value save contact");
      });
    }
  }

  getProfilePhoto(String token) async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request(
        'GET', Uri.parse('http://$host/api/info/picture/dKerKqyN5.jpg'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      log("200 profile photo");
      response.stream.bytesToString().then((value) {
        log(value + " jk");
      });
    } else {
      log("200 emas !!! profil");
    }
  }

  syncContact(String token, List str) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request =
        http.Request('POST', Uri.parse('http://$host/api/contacts/sync'));
    request.body = json.encode(str);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      log("sync contact 200");
    } else {
      response.stream.bytesToString().then((value) {
        log("$value sync contact error");
      });
    }
  }

  /*  Future<ModelGetTopContactsList?> getTopContacts(String token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('GET', Uri.parse('http://$host/api/find/check'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      log("200 get top contacts");
      return ModelGetTopContactsList.fromMap(
          jsonDecode(await response.stream.bytesToString()));
    } else {
      response.stream.bytesToString().then((value) {
        log("$value get top contacts error");
      });
      return null;
    }
  } */

  Future<ModelMainDataMain?> getMainData(String token) async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request('GET', Uri.parse('http://$host/api/posts/full'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      log("200 get main data");

      return ModelMainDataMain.fromMap(
          jsonDecode(await response.stream.bytesToString()));
    } else {
      response.stream.bytesToString().then((value) {
        log("$value get top contacts error");
      });
      return null;
    }
  }
}
