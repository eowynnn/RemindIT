import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:ionicons/ionicons.dart';
import 'package:remindits/Screen/notif_screen.dart';
import 'package:remindits/Screen/profil_screen.dart';
import 'package:remindits/utils/app_colors.dart';
import 'package:remindits/widgets/artickle.dart';
import 'package:remindits/widgets/list_notif.dart';

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
                icon: Ionicons.notifications,
                text: 'Reminder',
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

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final userCollection = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
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
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .doc(currentUser!.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final userData = snapshot.data!.data() as Map<String, dynamic>;
                            return Row(
                              children: [
                                Text(
                                  userData["firstName"],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "SFProText",
                                  ),
                                ),
                                SizedBox(width: media.width * 0.01,),
                                Text(
                                  userData["lastName"],
                                  style: TextStyle(
                                    fontSize: 18,
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
