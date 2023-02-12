import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';
import 'package:my_contacts/screens/screen_login.dart';
import 'package:my_contacts/screens/screen_redpost.dart';

class ScreenLoading extends StatefulWidget {
  const ScreenLoading({super.key});

  @override
  State<ScreenLoading> createState() => _ScreenLoadingState();
}

class _ScreenLoadingState extends State<ScreenLoading> {
  @override
  void initState() {
    Timer(
      const Duration(seconds: 4),
      () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Hive.box("boxEnter").get("enter") == 1
                ? const ScreenRedpost()
                : const ScreenLogin(),
          )),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF003D),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "flinger",
            style: GoogleFonts.montserrat(
                color: Colors.white, fontSize: 32, fontWeight: FontWeight.w500),
          ),
          LottieBuilder.asset("assets/h9wnheuMEU.json")
        ],
      )),
    );
  }
}
