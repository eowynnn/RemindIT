import 'package:flutter/material.dart';

class ArtickelPage extends StatelessWidget {
  const ArtickelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Artickel",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            fontFamily: "SFProText",
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xffffffff),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 23, horizontal: 20),
                height: 140,
                width: 315,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color(0xffE6F7FF),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ideal Hours for Sleep",
                          style: TextStyle(
                            fontFamily: "SFProText",
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "8hours 30minutes",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF16C1E3),
                            fontFamily: "SFProText",
                          ),
                        )
                      ],
                    ),
                    Container(
                        child:
                            Image(image: AssetImage("assets/png/Icon-Bed.png")))
                  ],
                ),
              ),
              SizedBox(
                height: 23,
              ),
              Text(
                "Why is 8 hours the recommended sleep time?",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  height: 1,
                  fontFamily: "SFProText",
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "When you are sleeping a full 8 hours, you are allowing your body to get the much-needed and well-deserved rest that it deserves. Without this rest and time to recuperate for your busy day, it can increase your chances of becoming diabetic or developing heart disease.",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "SFProText",
                      ),
                    ),
                    SizedBox(
                      height: 9,
                    ),
                    Text(
                      "Source : https://jaxsleepcenter.com/",
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: "SFProText",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
