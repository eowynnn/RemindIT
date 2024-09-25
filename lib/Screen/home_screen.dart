import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:remindits/Screen/login_screen.dart';
import 'package:remindits/services/notification_logic.dart';
import 'package:remindits/utils/app_colors.dart';
import 'package:remindits/widgets/add_reminder.dart';
import 'package:remindits/widgets/artickle.dart';
import 'package:remindits/widgets/delete_reminder.dart';
import 'package:remindits/widgets/detail_reminder.dart';
import 'package:remindits/widgets/edit_reminder.dart';
import 'package:remindits/widgets/switcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffbfbfb),
      body: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user;
  int? expandedIndex;
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          child: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      "Sign Out",
                                      style: TextStyle(
                                          color: AppColors.textColor1),
                                    ),
                                    content: Text(
                                        "Are you sure you want to sign out?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                              color: AppColors.textColor1),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          FirebaseAuth.instance.signOut();
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              fullscreenDialog: true,
                                              builder: (context) => LoginPage(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Sign Out",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Image.asset(
                              "assets/png/logo.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          width: media.width * 0.6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                    final userData = snapshot.data!.data()
                                        as Map<String, dynamic>;
                                    return Container(
                                      width: media.width,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            userData["firstName"],
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "SFProText",
                                              overflow: TextOverflow.clip,
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
                                              overflow: TextOverflow.clip,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              _createRoute(),
                            );
                          },
                          icon: FaIcon(
                            FontAwesomeIcons.newspaper,
                            size: 20,
                          ),
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
                        t.microsecondsSinceEpoch,
                      );
                      String formattedTime = DateFormat.jm().format(date);
                      String title = data!.docs[index].get('title');
                      String descriptions = data.docs[index].get('description');
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
                            FocusedMenuHolder(
                              menuItems: [
                                FocusedMenuItem(
                                  title: Text("Edit"),
                                  onPressed: () async {
                                    editReminder(
                                        context,
                                        user!.uid,
                                        data.docs[index].id,
                                        title,
                                        descriptions);
                                  },
                                  trailingIcon: Icon(FontAwesomeIcons.pen,size: 15,),
                                ),
                                FocusedMenuItem(
                                  title: Text("Detail"),
                                  onPressed: () async {
                                    detailReminder(
                                        context,
                                        title,
                                        descriptions,
                                        formattedTime,
                                        user!.uid,
                                        data.docs[index].id);
                                  },
                                  trailingIcon: Icon(FontAwesomeIcons.info,size: 15,),
                                ),
                                FocusedMenuItem(
                                  backgroundColor: Colors.red,
                                  title: Text(
                                    "Delete",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () {
                                    deleteReminder(context, data.docs[index].id,
                                        user!.uid);
                                  },
                                  trailingIcon: Icon(
                                    FontAwesomeIcons.trash,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                              blurBackgroundColor: Colors.blueGrey[300],
                              menuOffset: 20,
                              menuWidth: media.width * 0.5,
                              onPressed: () {},
                              openWithTap: true,
                              child: Container(
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
                                            Container(
                                              width: media.width * 0.43,
                                              child: Text(
                                                title,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: "SFProText",
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: media.height * 0.001,
                                            ),
                                            Container(
                                              width: media.width * 0.43,
                                              child: Text(
                                                descriptions,
                                                maxLines:
                                                    2, // Tampilkan semua deskripsi hanya jika expanded
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: "SFProText",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: media.height * 0.01,
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
                                              ),
                                              Container(
                                                width: 50,
                                                height: 50,
                                                child: Center(
                                                    child: FaIcon(
                                                        FontAwesomeIcons
                                                            .ellipsisVertical)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const ArtickelWidget(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
