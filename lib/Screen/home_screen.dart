import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:remindits/Screen/profil_screen.dart';
import 'package:remindits/services/notification_logic.dart';
import 'package:remindits/utils/app_colors.dart';
import 'package:remindits/widgets/add_reminder.dart';
import 'package:remindits/widgets/artickle.dart';
import 'package:remindits/widgets/delete_reminder.dart';
import 'package:remindits/widgets/switcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    ArtickelWidget(),
    HomeScreen(),
    ProfilPage(),
  ];

  void _onTabChanged(int index) {
    setState(
      () {
        _selectedIndex = index;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, 0),
            ),
          ],
          color: Color(0xffffffff),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: GNav(
            padding: EdgeInsets.all(12),
            tabBorderRadius: 100,
            gap: 8,
            backgroundColor: Colors.white,
            color: AppColors.textColor1,
            activeColor: AppColors.primaryColor1,
            selectedIndex: _selectedIndex,
            onTabChange: _onTabChanged,
            tabs: const [
              GButton(
                icon: FontAwesomeIcons.scroll,
              ),
              GButton(
                icon: FontAwesomeIcons.house,
              ),
              GButton(
                icon: FontAwesomeIcons.userLarge,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xfffbfbfb),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user;
  bool on = true;
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    NotificationLogic.init(context, user!.uid);
  _requestNotificationPermission();
    listenNotification();
  }

  void listenNotification() {
    NotificationLogic.onNotification.listen((value) {});
  }

  Future<void> _requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }

  void OnClickedNotification() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  final currentUser = FirebaseAuth.instance.currentUser;
  final userCollection = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
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
              FontAwesomeIcons.plus,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
      backgroundColor: Color(0xfffbfbfb),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome back,",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "SFProText",
                          ),
                        ),
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .doc(currentUser!.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final userData =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              return Row(
                                children: [
                                  Text(
                                    userData["firstName"],
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "SFProText",
                                    ),
                                  ),
                                  SizedBox(
                                    width: media.width * 0.01,
                                  ),
                                  Text(
                                    userData["lastName"],
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "SFProText",
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(user!.uid)
                    .collection('reminder')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshots) {
                  if (snapshots.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xff4fa8c5),
                        ),
                      ),
                    );
                  }
                  if (snapshots.hasError) {
                    return Text('Error : ${snapshots.error}');
                  }
                  if (snapshots.data!.docs.isEmpty) {
                    return Center(
                      child: Container(
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                top: media.height * 0.63,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Add reminder here',
                                  ),
                                  Image.asset(
                                    'assets/png/black-arrow-png.png',
                                    width: 100,
                                  ),
                                ],
                              ),
                            ),
                            Text("you don't have reminders"),
                          ],
                        ),
                      ),
                    );
                  }
                  final data = snapshots.data;
                  return ListView.builder(
                    itemCount: data?.docs.length,
                    itemBuilder: (context, index) {
                      Timestamp t = data?.docs[index].get('time');
                      DateTime date = DateTime.fromMicrosecondsSinceEpoch(
                          t.microsecondsSinceEpoch);
                      String formattedTime = DateFormat.jm().format(date);
                      String title = data!.docs[index].get('title');
                      String descriptions = data.docs[index].get('description');
                      bool prio = data.docs[index].get('isPriority');
                      on = data.docs[index].get('onOff');
                      if (on) {
                        NotificationLogic.showNotification(
                            dateTime: date,
                            id: 0,
                            title: title,
                            body: descriptions);
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                overflow: TextOverflow.clip),
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
                                              data.docs[index]
                                                  .get('description'),
                                              data.docs[index]
                                                  .get('isPriority'),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                if (prio == true) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          "Can't delete Suggest reminder"),
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
                                                      size: 18,
                                                    )
                                                  : FaIcon(
                                                      FontAwesomeIcons.ban,
                                                      size: 18,
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
