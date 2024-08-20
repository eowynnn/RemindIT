import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:ionicons/ionicons.dart';
import 'package:remindits/Screen/artickel_screen.dart';
import 'package:remindits/Screen/notif_screen.dart';
import 'package:remindits/Screen/profil_screen.dart';
import 'package:remindits/services/notification_logic.dart';
import 'package:remindits/utils/app_colors.dart';
import 'package:remindits/widgets/add_reminder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    NotifPage(),
    HomeScreen(),
    ProfilPage(),
  ];

  void _onTabChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  User? user;
  bool on = true;

  void initState() {
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
        builder: (context) => HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                color: Colors.black,
                blurRadius: 2,
                offset: Offset(0, 2),
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: Color(0xff42DCF9),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
            padding: EdgeInsets.all(12),
            tabBorderRadius: 100,
            gap: 8,
            tabBackgroundColor: Color(0xff00B4D8),
            backgroundColor: Color(0xff42DCF9),
            color: Colors.white,
            activeColor: Colors.white,
            selectedIndex: _selectedIndex,
            onTabChange: _onTabChanged,
            tabs: const [
              GButton(
                icon: Ionicons.notifications,
                text: 'Notification',
              ),
              GButton(
                icon: Ionicons.home,
                text: 'Home',
                iconSize: 24,
              ),
              GButton(
                icon: Ionicons.person,
                text: 'Profile',
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

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: SingleChildScrollView(
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
                        "Welcome back,",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "SFProText",
                        ),
                      ),
                      Text(
                        "Irfa Rizkya Fardhan",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: "SFProText",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 9,
              ),
              Center(
                child: Container(
                  width: 340,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xffffffff),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/svg/pushpin-fill.svg",
                            width: 20,
                          ),
                          SizedBox(width: 9),
                          Text(
                            "Pinned Reminders",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: "SFProText",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      ListNotifWidget(
                        no: "1",
                        name: "breakfast",
                        time: "08:00",
                      ),
                      SizedBox(height: 10),
                      ListNotifWidget(
                        no: "2",
                        name: "launch",
                        time: "12:00",
                      ),
                      SizedBox(height: 10),
                      ListNotifWidget(
                        no: "3",
                        name: "meeting",
                        time: "14:00",
                      ),
                      SizedBox(height: 10),
                      ListNotifWidget(
                        no: "4",
                        name: "dinner",
                        time: "18:00",
                      ),
                      SizedBox(height: 10),
                      ListNotifWidget(
                        no: "5",
                        name: "sleeping",
                        time: "21:00",
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 25),
              Text(
                "Healthy lifestyle tips",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  fontFamily: "SFProText",
                ),
              ),
              SizedBox(height: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ArtickelWidget(),
                  SizedBox(height: 15),
                  ArtickelWidget(),
                  SizedBox(height: 15),
                  ArtickelWidget(),
                  SizedBox(height: 15),
                  ArtickelWidget(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListNotifWidget extends StatelessWidget {
  const ListNotifWidget({
    super.key,
    required this.no,
    required this.name,
    required this.time,
  });
  final String no;
  final String name;
  final String time;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xffE6F7FF), borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      child: Row(
        children: [
          Text(
            no,
            style: TextStyle(
              fontFamily: "SFProText",
            ),
          ),
          Container(
            width: 230,
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontFamily: "SFProText",
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontFamily: "SFProText",
            ),
          )
        ],
      ),
    );
  }
}

class ArtickelWidget extends StatelessWidget {
  const ArtickelWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color(0xffE6F7FF),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 23, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ideal Hours for Sleep",
                style: TextStyle(
                  fontFamily: "SFProText",
                ),
              ),
              Text("8hours 30minutes",
                  style: TextStyle(
                    color: Color(0xFF16C1E3),
                    fontFamily: "SFProText",
                  )),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 35,
                width: 106,
                decoration: BoxDecoration(
                    color: Color(0xff42DCF9),
                    borderRadius: BorderRadius.circular(20)),
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ArtickelPage();
                      }));
                    },
                    child: Center(
                      child: Text(
                        "Learn More",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 17),
            child: Image(image: AssetImage("assets/png/Icon-Bed.png")))
      ]),
    );
  }
}
