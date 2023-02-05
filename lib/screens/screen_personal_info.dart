import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_contacts/api/api.dart';
import 'package:my_contacts/screens/screen_redpost.dart';

class ScreenPersonalInfo extends StatefulWidget {
  final String phone;
  final String password;
  const ScreenPersonalInfo(
      {super.key, required this.phone, required this.password});

  @override
  State<ScreenPersonalInfo> createState() => _ScreenPersonalInfoState();
}

class _ScreenPersonalInfoState extends State<ScreenPersonalInfo> {
  bool firstnameEmpty = false;

  bool lastnameEmpty = false;

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  final ImagePicker picker = ImagePicker();
  XFile? file;

  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          const SizedBox(
            height: 80,
          ),
          Text(
            "Personal Info",
            style: GoogleFonts.montserrat(
                fontSize: 20,
                color: const Color(0xFFFF003D),
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 22,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () async {
                      file =
                          await picker.pickImage(source: ImageSource.gallery);
                      setState(() {
                        selected = true;
                      });
                      log(file!.name);
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 2)),
                      child: selected == true
                          ? ClipOval(
                              child: Image.file(
                                  File(
                                    file!.path,
                                  ),
                                  fit: BoxFit.cover),
                            )
                          : Image.asset("assets/icons8-customer-96.png"),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Profile photo",
                    style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 46),
                child: Column(
                  children: [
                    SizedBox(
                      width: 190,
                      child: TextField(
                        onChanged: (value) {
                          firstnameEmpty = false;
                          setState(() {});
                        },
                        controller: firstnameController,
                        cursorColor: const Color(0xFFB8B8B8),
                        decoration: InputDecoration(
                          hintText: "Firstname",
                          hintStyle: GoogleFonts.montserrat(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: firstnameEmpty == true
                                      ? Colors.red
                                      : const Color(0xFFB8B8B8),
                                  width: firstnameEmpty == true ? 2 : 1)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: firstnameEmpty == true
                                      ? Colors.red
                                      : const Color(0xFFB8B8B8),
                                  width: 2)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 190,
                      child: TextField(
                        controller: lastnameController,
                        cursorColor: const Color(0xFFB8B8B8),
                        decoration: InputDecoration(
                          hintText: "Lastname",
                          hintStyle: GoogleFonts.montserrat(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: lastnameEmpty == true
                                      ? Colors.red
                                      : const Color(0xFFB8B8B8),
                                  width: lastnameEmpty == true ? 2 : 1)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: lastnameEmpty == true
                                      ? Colors.red
                                      : const Color(0xFFB8B8B8),
                                  width: 2)),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 43,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: TextField(
              maxLength: 255,
              controller: bioController,
              cursorColor: const Color(0xFFB8B8B8),
              decoration: InputDecoration(
                  hintText: "Bio",
                  hintStyle: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                  border: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFB8B8B8))),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFB8B8B8), width: 2))),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              "Everyone has a unique lifestyle that contains full of the quotes, life experiance words, etc...",
              style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: const Color(0xFFFF003D),
                  fontWeight: FontWeight.w300),
            ),
          ),
          const SizedBox(
            height: 350,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Let’s Start",
                  style: GoogleFonts.montserrat(color: const Color(0xFF060606)),
                ),
                InkWell(
                    onTap: () {
                      if (firstnameController.text.isNotEmpty) {
                        log("ioo");
                        Api()
                            .register(
                                widget.phone,
                                widget.password,
                                firstnameController.text.trim(),
                                lastnameController.text.trim(),
                                bioController.text.trim(),
                                file == null ? "" : file!.path)
                            .then((value) {
                          if (value["status"] == true) {
                            Hive.box("boxToken").put("token", value["token"]);
                            Hive.box("boxEnter").put("enter", 1);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ScreenRedpost()));
                          }
                        });
                      }
                      if (firstnameController.text.isEmpty) {
                        firstnameEmpty = true;
                        setState(() {});
                      }
                    },
                    child: const Icon(Icons.arrow_forward_ios))
              ],
            ),
          )
        ],
      ),
    );
  }
}
