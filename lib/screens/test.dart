import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0088CC),
        title: Row(
          children: const [
            Icon(Icons.menu),
            SizedBox(
              width: 10,
            ),
            Text("Telegram"),
          ],
        ),
      ),
      body: ListView(
        children: [
          container(
              text: "Elon Toga", miniText: "qachan qarzini berasan iplos"),
          container(
              text: "Shohrux artis",
              miniText: "ushavosam teskari shapalaq qoyaman",
              pictures: "assets/500168.jpg"),
          container(
              text: "Dalbalbek",
              miniText: "tori gapir",
              pictures: "assets/felipe-simo-HBop_t9V9kM-unsplash.jpg"),
        ],
      ),
      floatingActionButton: Container(
          height: 50,
          width: 50,
          decoration: const BoxDecoration(
              color: Color(0xFF0088CC), shape: BoxShape.circle),
          child: const Icon(
            CupertinoIcons.pencil,
            color: Colors.white,
          )),
    );
  }

  container(
      {String text = "...",
      pictures = "assets/Elon_Musk_Royal_Society_(crop1).jpg",
      miniText = "salom"}) {
    return ListTile(
      leading: ClipRRect(
          borderRadius: BorderRadius.circular(400),
          child: Image.asset(
            pictures,
            fit: BoxFit.cover,
            height: 50,
            width: 50,
          )),
      title: Text(text),
      subtitle: Text(miniText),
      
     focusColor: Colors.grey,
    );
  }
}
