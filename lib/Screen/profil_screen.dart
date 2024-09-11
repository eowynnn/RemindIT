import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:remindits/Screen/login_screen.dart';
import 'package:remindits/utils/app_colors.dart';
import 'package:remindits/widgets/text_box_profile.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final userCollection = FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _deleteAcc() async {
    try {
      await _auth.currentUser!.delete();
      print('Akun berhasil dihapus');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          "Edit $field",
          style: TextStyle(color: AppColors.textColor1),
        ),
        content: TextField(
          autofocus: true,
          style: TextStyle(color: AppColors.textColor1),
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: AppColors.textColor1),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text(
              "Save",
              style: TextStyle(color: AppColors.textColor1),
            ),
            onPressed: () => Navigator.of(context).pop(newValue),
          ),
        ],
      ),
    );

    if (newValue.trim().length > 0) {
      await userCollection.doc(currentUser!.uid).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              fontFamily: "SFProText"),
        ),
        centerTitle: true,
        backgroundColor: Color(0xffffffff),
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return SafeArea(
              child: ListView(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const Icon(
                    FontAwesomeIcons.user,
                    size: 75,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    currentUser!.email!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textColor1,
                      fontFamily: "SFProText",
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 40),
                    child: Text(
                      "My Details",
                      style: TextStyle(
                          color: AppColors.textColor1, fontFamily: "SFProText"),
                    ),
                  ),
                  MyTextBox(
                    text: userData["firstName"],
                    sectionName: "First Name",
                    onPressed: () => editField("firstName"),
                  ),
                  MyTextBox(
                    text: userData["lastName"],
                    sectionName: "Last name",
                    onPressed: () => editField("lastName"),
                  ),
                  SizedBox(
                    height: media.height * 0.020,
                  ),
                  Padding(
                    padding: EdgeInsets.all(50),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 2,
                                offset: Offset(0, 2),
                              )
                            ],
                          ),
                          child: MaterialButton(
                            onPressed: _deleteAcc,
                            minWidth: double.maxFinite,
                            height: 50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            textColor: AppColors.textColor1,
                            child: Text(
                              "Delete Account",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: AppColors.primaryButton,
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 2,
                                offset: Offset(0, 2),
                              )
                            ],
                          ),
                          child: MaterialButton(
                            onPressed: _signOut,
                            minWidth: double.maxFinite,
                            height: 50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            textColor: AppColors.textColor1,
                            child: Text(
                              "Sign Out",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error${snapshot.error}"),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
