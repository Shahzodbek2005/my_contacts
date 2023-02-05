import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_contacts/api/api.dart';
import 'package:my_contacts/screens/screen_login.dart';

class WidgetDrawer extends StatelessWidget {
  const WidgetDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Api().getProfilePhoto(Hive.box("boxToken").get("token"));
                },
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2)),
                  child: Image.asset("assets/icons8-customer-96.png"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "Shahzodbek Komilov",
                  style: GoogleFonts.montserrat(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: GestureDetector(
                  onTap: () {
                    Hive.box("boxEnter").clear();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ScreenLogin(),
                        ));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.login),
                        Text(
                          "Log out",
                          style: GoogleFonts.montserrat(),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
