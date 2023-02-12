import 'dart:developer';
import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_contacts/api/api.dart';
import 'package:my_contacts/class/bottom_slide_page_route.dart';
import 'package:my_contacts/models/model_finger.dart';
import 'package:my_contacts/models/model_get_top_contacts.dart';
import 'package:my_contacts/models/model_main_data.dart';
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

    Api().syncContact(Hive.box("boxToken").get("token"), list);
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> key = GlobalKey();
    return Scaffold(
      key: key,
      drawer: const WidgetDrawer(),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.push(context, SlideTransitionBottom(const ScreenNewPost()));
        },
        child: Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
              color: const Color(0xFFFF003D),
              borderRadius: BorderRadius.circular(16)),
          child: const Icon(
            Icons.add,
            size: 30,
            color: Colors.white,
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
                      child: Image.asset("assets/menu_icon.png")),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Flinger",
                    style: GoogleFonts.montserrat(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    width: 102,
                  ),
                  GestureDetector(
                    onTap: () {
                      log(Hive.box("boxToken").get("token") + " op");
                    },
                    child: Container(
                        height: 23,
                        width: 179,
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
              padding: const EdgeInsets.only(top: 20, left: 18, right: 18),
              child: SizedBox(
                  height: 70,
                  child: FutureBuilder<ModelMainDataMain?>(
                    future:
                        Api().getMainData(Hive.box("boxToken").get("token")),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!.data.circleList.list.isEmpty
                            ? const Center(
                                child: Text("Kontaktlarga ega emassiz !"))
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    snapshot.data!.data.circleList.list.length,
                                itemBuilder: (context, index) {
                                  return circleContainer(
                                      name: snapshot.data!.data.circleList
                                          .list[index].username,
                                      image: snapshot.data!.data.circleList
                                              .list[index].proPic ??
                                          "assets/istockphoto.jpg");
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
              color: Color(0xFFACACAC),
              indent: 0,
              endIndent: 0,
              thickness: 1,
            ),
            SizedBox(
              height: 569,
              child: FutureBuilder<ModelMainDataMain?>(
                  future: Api().getMainData(Hive.box("boxToken").get("token")),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.data.postsList.list.length,
                        itemBuilder: (context, index) {
                          return postContainer(
                              proPhoto: snapshot.data!.data.postsList
                                  .list[index].postsUser.proPic,
                              name: snapshot
                                  .data!.data.postsList.list[index].comments,
                              bigPhoto: snapshot
                                  .data!.data.postsList.list[index].picture);
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
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
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipOval(
                child: image.startsWith("http")
                    ? Image.network(
                        image,
                        fit: BoxFit.cover,
                      )
                    : Image.asset("assets/icons8-male-user-100.png")),
          ),
          SizedBox(
            width: 50,
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.montserrat(
                  fontSize: 8, fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }

  Widget postContainer(
      {String proPhoto = "assets/Ellipse.png",
      String name = "khorunaliyev",
      String bigPhoto = ""}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 13, bottom: 6, top: 20),
          child: Row(
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset(
                    proPhoto,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 6,
              ),
              Text(
                name,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 13),
          child: Row(
            children: [
              Container(
                height: 230,
                width: 280,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Image.file(File(bigPhoto)),
              ),
              SizedBox(
                height: 230,
                width: 80,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    miniContainer(),
                    miniContainer(),
                    miniContainer(),
                    miniContainer(),
                    miniContainer(),
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 3),
                child: Image.asset(
                  "assets/aass.png",
                  height: 20,
                  width: 20,
                ),
              ),
              Text(
                "12K",
                style: GoogleFonts.montserrat(
                    fontSize: 13, fontWeight: FontWeight.w500),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 3),
                child: Image.asset(
                  "assets/icons8-topic-96 1.png",
                  height: 20,
                ),
              ),
              Text(
                "2340",
                style: GoogleFonts.montserrat(
                    fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget miniContainer() {
    return Padding(
      padding: const EdgeInsets.only(left: 9, bottom: 5),
      child: Container(
        height: 50,
        width: 80,
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
