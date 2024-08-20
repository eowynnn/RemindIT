import 'package:flutter/material.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xffffffff),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: SingleChildScrollView(
                  child: Center(
                child: Column(
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          color: Color(0xff000000),
                          borderRadius: BorderRadius.circular(100)),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Irfa Rizkya Fardhan",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'SFProText'),
                    ),
                    Text(
                      "Test",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'SFProText',
                      ),
                    ),
                  ],
                ),
              )))),
    );
  }
}
