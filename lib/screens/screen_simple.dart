import 'dart:developer';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ScreenSimple extends StatelessWidget {
  const ScreenSimple({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: GestureDetector(
          onTap: () async {
            List<Contact> contacts = await ContactsService.getContacts();
            for (var element in contacts) {
              element.phones?.forEach((elementPhone) {
                log(element.displayName! + elementPhone.value.toString());
              });
            }
          },
          child: Container(
            height: 100,
            width: 100,
            color: Colors.blue,
          ),
        ),
      )),
    );
  }
}
