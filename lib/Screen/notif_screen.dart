import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
// import 'package:remindits/Screen/home_screen.dart';
import 'package:remindits/services/notification_logic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:remindits/utils/app_colors.dart';
import 'package:remindits/widgets/add_reminder.dart';
import 'package:remindits/widgets/delete_reminder.dart';
import 'package:remindits/widgets/switcher.dart';

class NotifPage extends StatefulWidget {
  @override
  State<NotifPage> createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {
  User? user;
  bool on = true;

  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    NotificationLogic.init(context, user!.uid);
    listenNotification();
  }

  void listenNotification() {
    NotificationLogic.onNotification.listen((value) {});
  }

  void OnClickedNotification() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => NotifPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        onPressed: () async {
          addReminder(context, user!.uid);
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.primaryButton,
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 5,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Ionicons.add,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          "Reminder",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            fontFamily: "SFProText",
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xffffffff),
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .collection('reminder')
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xff4fa8c5),
                ),
              ),
            );
          }
          if (snapshots.data!.docs.isEmpty) {
            return Center(
              child: Text("Nothing to show"),
            );
          }
          final data = snapshots.data;
          return ListView.builder(
            itemCount: data?.docs.length,
            itemBuilder: (context, index) {
              Timestamp t = data?.docs[index].get('time');
              DateTime date =
                  DateTime.fromMicrosecondsSinceEpoch(t.microsecondsSinceEpoch);
              String formattedTime = DateFormat.jm().format(date);
              String title = data!.docs[index].get('title');
              String descriptions = data.docs[index].get('description');
              bool prio = data.docs[index].get('isPriority');
              on = data.docs[index].get('onOff');
              if (on) {
                NotificationLogic.showNotification(
                    dateTime: date, id: 0, title: title, body: descriptions);
              }
              return SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.only(
                            left: 25, right: 15, top: 20, bottom: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "SFProText",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: media.height * 0.001,
                                    ),
                                    Text(
                                      descriptions,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "SFProText",
                                      ),
                                    ),
                                    Text(
                                      formattedTime,
                                      style: TextStyle(
                                          fontFamily: "SFProText",
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Switcher(
                                        on,
                                        user!.uid,
                                        data.docs[index].id,
                                        data.docs[index].get('time'),
                                        data.docs[index].get('title'),
                                        data.docs[index].get('description'),
                                        data.docs[index].get('isPriority'),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          if (prio == true) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    "Can't delete priority reminder"),
                                              ),
                                            );
                                          } else {
                                            deleteReminder(
                                              context,
                                              data.docs[index].id,
                                              user!.uid,
                                            );
                                          }
                                        },
                                        icon: prio == false
                                            ? FaIcon(
                                                FontAwesomeIcons.trash,
                                                color: Colors.red,
                                                size: 20,
                                              )
                                            : FaIcon(FontAwesomeIcons.ban),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: media.height * 0.02,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: AppColors.primaryColor2,
                              ),
                              width: media.width * 0.18,
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, top: 5, bottom: 5),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/svg/pushpin-fill.svg",
                                    width: 20,
                                    // ignore: deprecated_member_use
                                    color: AppColors.primaryColor1,
                                  ),
                                  SizedBox(width: 9),
                                  Text(
                                    "On",
                                    style: TextStyle(
                                        fontFamily: "SFProText",
                                        color: AppColors.textColor1,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
