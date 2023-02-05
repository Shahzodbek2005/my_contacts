import 'dart:developer';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_contacts/api/api.dart';
import 'package:my_contacts/class/bottom_slide_page_route.dart';
import 'package:my_contacts/models/model_get_top_contacts.dart';
import 'package:my_contacts/screens/screen_new_post.dart';
import 'package:my_contacts/widgets/widget_drawer.dart';

class ScreenRedpost extends StatefulWidget {
  const ScreenRedpost({super.key});

  @override
  State<ScreenRedpost> createState() => _ScreenRedpostState();
}

class _ScreenRedpostState extends State<ScreenRedpost> {
  List<Map<String, dynamic>> list = [];

  @override
  void initState() {
    syncContact();
    super.initState();
  }

  syncContact() async {
    List<Contact> contacts = await ContactsService.getContacts();

    for (var element in contacts) {
      String? phone;
      for (var element in element.phones!) {
        phone = element.value.toString();
      }
      if (element.displayName!.contains("PERMISSION")) {
        continue;
      }
      list.add({
        "name": element.displayName,
        "number": phone,
      });
    }

    Api().syncContact(Hive.box("boxToken").get("token"), list);
  }

  final ImagePicker imagePicker = ImagePicker();
  XFile? xFile;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> key = GlobalKey();
    log("widget daraxti qurildi");
    return Scaffold(
      key: key,
      drawer: const WidgetDrawer(),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      floatingActionButton: InkWell(
        onTap: () async {
          xFile = await imagePicker.pickImage(source: ImageSource.gallery);
          Navigator.push(context, SlideTransitionBottom(ScreenNewPost(xfile: xFile,)));
        },
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFF003D),
            shape: BoxShape.circle,
          ),
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.add,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  const SizedBox(
                    width: 16,
                  ),
                  InkWell(
                    onTap: () {
                      key.currentState!.openDrawer();
                    },
                    child: const Icon(
                      Icons.menu,
                      size: 18,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "REDPost",
                    style: GoogleFonts.montserrat(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    width: 90,
                  ),
                  GestureDetector(
                    onTap: () {
                      log(Hive.box("boxToken").get("token") + " op");
                    },
                    child: Container(
                        height: 23,
                        width: 170,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color(0xFFD9D9D9).withOpacity(0.3)),
                        child: Stack(
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                  hintStyle: const TextStyle(fontSize: 2),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: const Color(0xFFD9D9D9)
                                              .withOpacity(0.3)),
                                      borderRadius: BorderRadius.circular(5)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: const Color(0xFFD9D9D9)
                                              .withOpacity(0.3)),
                                      borderRadius: BorderRadius.circular(5))),
                            ),
                            Positioned(
                                right: 6,
                                top: 6,
                                child: Image.asset("assets/Vector.png")),
                          ],
                        )),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 18),
              child: SizedBox(
                  height: 70,
                  child: FutureBuilder<ModelGetTopContactsList?>(
                    future:
                        Api().getTopContacts(Hive.box("boxToken").get("token")),
                    builder: (context, snapshot) {
                      log("qurildi");

                      if (snapshot.hasData) {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.list.length,
                          itemBuilder: (context, index) {
                            log("${snapshot.data!.list[index].firtsName} 877");

                            return circleContainer(
                              name: snapshot.data!.list[index].firtsName,
                              image: snapshot.data!.list[index].picture,
                            );
                          },
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  )),
            ),
            const Divider(
              color: Colors.black,
              indent: 0,
              endIndent: 0,
              thickness: 1,
            ),
            SizedBox(
              height: 569,
              child:
                  ListView(physics: const BouncingScrollPhysics(), children: [
                postContainer(),
                postContainer(),
                postContainer(),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget circleContainer({String name = "khorunaliyev", String image = ""}) {
    return Padding(
      padding: const EdgeInsets.only(right: 7),
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFF003D), width: 2)),
            child: ClipOval(
                child: image.startsWith("http")
                    ? Image.network(
                        image,
                        fit: BoxFit.cover,
                      )
                    : const Icon(
                        Icons.account_circle,
                        size: 45,
                      )),
          ),
          Text(
            name,
            style: GoogleFonts.montserrat(
                fontSize: 8, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }

  Widget postContainer() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 13, bottom: 6, top: 11),
          child: Row(
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: const Color(0xFFFF003D), width: 2)),
                child: ClipOval(
                  child: Image.asset(
                    "assets/man.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 6,
              ),
              Text(
                "khorunaliyev",
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
        Container(
          height: 220,
          width: 363,
          decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(5),
          ),
        )
      ],
    );
  }
}
