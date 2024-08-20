import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';

class NotifPage extends StatefulWidget {
  const NotifPage({super.key});

  @override
  State<NotifPage> createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
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
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(height: 23),
                  ListNotif(
                    name: "Drink Water",
                    time: "30 minutes",
                    title: "Its time to drink water",
                    desc: "Hello Irfa, Its time to drink water",
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ListNotif(
                    name: "Eat",
                    time: "5 Hours",
                    title: "Its time to Eat",
                    desc: "Hello Irfa, Its time to Eat",
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ListNotif(
                    name: "Stretching",
                    time: "1 hour",
                    title: "Its time to stretch",
                    desc: "Hello Irfa, Its time to Stretch",
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ListNotif(
                    name: "Drink Water",
                    time: "30 minutes",
                    title: "Its time to drink water",
                    desc: "Hello Irfa, Its time to drink water",
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ListNotif(
                    name: "Eat",
                    time: "5 Hours",
                    title: "Its time to Eat",
                    desc: "Hello Irfa, Its time to Eat",
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ListNotif extends StatelessWidget {
  const ListNotif({
    super.key,
    required this.name,
    required this.time,
    required this.title,
    required this.desc,
  });

  final String name;
  final String time;
  final String desc;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 150,
        width: 360,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xffffffff),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xff00B4D8),
                    fontFamily: "SFProText",
                  ),
                ),
                Text(
                  "Remind Every " + time,
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: "SFProText",
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "- Title : " + title,
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: "SFProText",
                  ),
                ),
                Text(
                  "- Description : " + desc,
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: "SFProText",
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 17),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Ionicons.notifications_off,
                  size: 20,
                  color: Color(0xff7B6F72),
                ),
                SvgPicture.asset(
                  "assets/svg/pushpin-fill.svg",
                  width: 20,
                  color: Color(0xff7B6F72),
                ),
                Icon(
                  Ionicons.pencil,
                  size: 20,
                  color: Color(0xff7B6F72),
                ),
                SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    child: Icon(Icons.delete_outline,
                        size: 20, color: Color(0xffFF0004)),
                  ),
                ),
              ],
            ),
          ),
        ]));
  }
}
