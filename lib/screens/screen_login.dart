import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_contacts/api/api.dart';
import 'package:my_contacts/screens/screen_personal_info.dart';
import 'package:my_contacts/screens/screen_redpost.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  List<Map<String, dynamic>> list = [];

  Future permissionHandler() async {
    var status = await Permission.contacts.request();
    if (status.isDenied) {
      log("no");
    }
    if (status.isGranted) {
      log("yes");
      List<Contact> contacts = await ContactsService.getContacts(
        photoHighResolution: false,
        androidLocalizedLabels: false,
        withThumbnails: false,
        iOSLocalizedLabels: false,
        orderByGivenName: false,
      );

      for (var elementContacts in contacts) {
        if (elementContacts.phones!.isNotEmpty) {
          String? phone;
          for (var elementPhones in elementContacts.phones!) {
            phone = elementPhones.value.toString();
          }
          if (elementContacts.displayName!.contains("PERMISSION")) {
            continue;
          }

          list.add({
            "name": elementContacts.displayName,
            "number": phone,
          });
        }
      }

      Api().saveContact(Hive.box("boxToken").get("token"), list);
    }
  }

  TextEditingController phoneField = TextEditingController();
  TextEditingController passwordField = TextEditingController();

  bool phoneEmpty = false;
  bool passwordEmpty = false;

  @override
  void initState() {
    permissionHandler();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 120),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                log(Hive.box("boxToken").get("token"));
                permissionHandler();
              },
              child: Text(
                "Sign up",
                style: GoogleFonts.montserrat(
                    fontSize: 20,
                    color: const Color(0xFFFF003D),
                    fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 44),
              child: TextField(
                maxLength: 13,
                controller: phoneField,
                onChanged: (value) {
                  phoneEmpty = false;
                  setState(() {});
                },
                cursorColor: const Color(0xFFB8B8B8),
                decoration: InputDecoration(
                  //8
                  hintText: "Phone number",
                  hintStyle: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: phoneEmpty == true
                              ? Colors.red
                              : const Color(0xFFB8B8B8),
                          width: phoneEmpty == true ? 2 : 1)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: phoneEmpty == true
                              ? Colors.red
                              : const Color(0xFFB8B8B8),
                          width: 2)),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 44),
              child: TextField(
                controller: passwordField,
                onChanged: (value) {
                  passwordEmpty = false;
                  setState(() {});
                },
                cursorColor: const Color(0xFFB8B8B8),
                decoration: InputDecoration(
                  hintText: "Create Password",
                  hintStyle: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: passwordEmpty == true
                              ? Colors.red
                              : const Color(0xFFB8B8B8),
                          width: passwordEmpty == true ? 2 : 1)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: passwordEmpty == true
                              ? Colors.red
                              : const Color(0xFFB8B8B8),
                          width: 2)),
                ),
              ),
            ),
            const SizedBox(
              height: 39,
            ),
            GestureDetector(
              onTap: () async {
                if (phoneField.text.isNotEmpty &&
                    passwordField.text.isNotEmpty &&
                    passwordField.text.length >= 8 &&
                    phoneField.text.length == 13) {
                  await Api()
                      .checkLogin(phoneField.text.trim())
                      .then((value) async {
                    log(value.toString());
                    if (value == true) {
                      await Api()
                          .login(
                              phoneField.text.trim(), passwordField.text.trim())
                          .then((value) {
                        if (value["status"] == true) {
                          String token = value["token"];
                          log(token);

                          Hive.box("boxToken").put("token", token);
                          Hive.box("boxEnter").put("enter", 1);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ScreenRedpost()));
                        } else if (value["status"] == false) {
                          log("bad kridin");
                          passwordEmpty = true;
                          setState(() {});
                        }
                      });
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScreenPersonalInfo(
                              phone: phoneField.text,
                              password: passwordField.text,
                            ),
                          ));
                    }
                  });
                }

                if (phoneField.text.isEmpty) {
                  phoneEmpty = true;
                  setState(() {});
                }
                if (phoneField.text.length < 13) {
                  phoneEmpty = true;
                  setState(() {});
                }
                if (passwordField.text.isEmpty) {
                  passwordEmpty = true;
                  setState(() {});
                }
                if (passwordField.text.length < 8) {
                  passwordEmpty = true;
                  setState(() {});
                }
              },
              child: Container(
                alignment: Alignment.center,
                height: 36,
                width: 316,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFB8B8B8), width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  "Let’s Start",
                  style: GoogleFonts.montserrat(
                      color: const Color(0xFFFF003D),
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
