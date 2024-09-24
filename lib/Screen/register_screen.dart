import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:remindits/Screen/login_screen.dart';
import 'package:remindits/model/reminder_model.dart';
import 'package:remindits/utils/app_colors.dart';
import 'package:remindits/widgets/round_gradient_button.dart';
import 'package:remindits/widgets/round_text_field.dart';

class RegistPage extends StatefulWidget {
  const RegistPage({super.key});

  @override
  State<RegistPage> createState() => _RegistPageState();
}

class _RegistPageState extends State<RegistPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference _users = FirebaseFirestore.instance.collection("users");

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObsecure = true;
  bool _isCheck = false;
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    bool isLoading = false;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: media.height * 0.1, horizontal: 25),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: media.height * 0.01,
                  ),
                  SizedBox(
                    width: media.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: media.width * 0.1,
                        ),
                        Text(
                          "Buat akun",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            height: .8,
                            color: AppColors.textColor1,
                            fontSize: 50,
                            fontWeight: FontWeight.w700,
                            fontFamily: "SFProText",
                          ),
                        ),
                        SizedBox(
                          height: media.width * 0.04,
                        ),
                        Text(
                          "Daftar untuk memulai!",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: AppColors.textColor1,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: "SFProText",
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: media.width * 0.1,
                  ),
                  RoundTextField(
                    textEditingController: _firstNameController,
                    hintText: "First Name",
                    icon: "Profile",
                    textInputType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your First Name";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  RoundTextField(
                    textEditingController: _lastNameController,
                    hintText: "Last Name",
                    icon: "Profile",
                    textInputType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your Last Name";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  RoundTextField(
                    textEditingController: _emailController,
                    hintText: "Email",
                    icon: "Message",
                    textInputType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  RoundTextField(
                    textEditingController: _passwordController,
                    hintText: "Password",
                    icon: "Lock",
                    textInputType: TextInputType.text,
                    isObsecureText: _isObsecure,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      } else if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                    rightIcon: TextButton(
                      onPressed: () {
                        setState(
                          () {
                            _isObsecure = !_isObsecure;
                          },
                        );
                      },
                      child: Container(
                        child: Icon(
                          _isObsecure ? Icons.visibility_off : Icons.visibility,
                          size: 20,
                          color: AppColors.textColor1,
                        ),
                        alignment: Alignment.center,
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: media.width * 0.04,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isCheck = !_isCheck;
                          });
                        },
                        icon: Icon(
                          _isCheck
                              ? Icons.check_box_outline_blank
                              : Icons.check_box,
                          color: AppColors.textGrayColor,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "By continuing you accept our Privacy Police and\nterms of Use",
                          style: TextStyle(color: AppColors.textGrayColor),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: media.width * 0.06,
                  ),
                  RoundGradientButton(
                    title: isLoading ? "Loading..." : "Create Account",
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        if (!_isCheck) {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            UserCredential userCredential =
                                await _auth.createUserWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                            String uid = userCredential.user!.uid;
                            await _users.doc(uid).set(
                              {
                                'email': _emailController.text,
                                'firstName': _firstNameController.text,
                                'lastName': _lastNameController.text,
                              },
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Akun berhasil dibuat"),
                              ),
                            );
                            ReminderModel reminderModel1 = ReminderModel();
                            DateTime reminderTime1 =
                                DateTime(1970, 1, 1, 6, 0, 0);
                            reminderModel1.time =
                                Timestamp.fromDate(reminderTime1);
                            reminderModel1.onOff = true;
                            reminderModel1.title = 'Mulailah Hari';
                            reminderModel1.description =
                                'Mulailah hari dengan melakukan peregangan ringan.';
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(uid)
                                .collection('reminder')
                                .doc("1")
                                .set(
                                  reminderModel1.toMap(),
                                );
                            ReminderModel reminderModel2 = ReminderModel();
                            DateTime reminderTime2 =
                                DateTime(1970, 1, 1, 7, 0, 0);
                            reminderModel2.time =
                                Timestamp.fromDate(reminderTime2);
                            reminderModel2.onOff = true;
                            reminderModel2.title = 'Sarapan Sehat';
                            reminderModel2.description =
                                'Nikmati sarapan yang kaya nutrisi';
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(uid)
                                .collection('reminder')
                                .doc("2")
                                .set(reminderModel2.toMap());
                            ReminderModel reminderModel3 = ReminderModel();
                            DateTime reminderTime3 =
                                DateTime(1970, 1, 1, 9, 0, 0);
                            reminderModel3.time =
                                Timestamp.fromDate(reminderTime3);
                            reminderModel3.onOff = true;
                            reminderModel3.title = 'Jangan lupa minum';
                            reminderModel3.description =
                                'Jangan lupakan minuman yang sehat.';
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(uid)
                                .collection('reminder')
                                .doc("3")
                                .set(
                                  reminderModel3.toMap(),
                                );
                            ReminderModel reminderModel4 = ReminderModel();
                            DateTime reminderTime4 =
                                DateTime(1970, 1, 1, 12, 00, 0);
                            reminderModel4.time =
                                Timestamp.fromDate(reminderTime4);
                            reminderModel4.onOff = true;
                            reminderModel4.title = 'Waktunya Makan Siang';
                            reminderModel4.description =
                                'Sajikan makan siang seimbang dengan protein.';
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(uid)
                                .collection('reminder')
                                .doc("4")
                                .set(
                                  reminderModel4.toMap(),
                                );
                            ReminderModel reminderModel5 = ReminderModel();
                            DateTime reminderTime5 =
                                DateTime(1970, 1, 1, 17, 0, 0);
                            reminderModel5.time =
                                Timestamp.fromDate(reminderTime5);
                            reminderModel5.onOff = true;
                            reminderModel5.title =
                                'Aktivitas Fisik Sore Hari';
                            reminderModel5.description =
                                'Lakukan olahraga atau latihan untuk menghilangkan stres';
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(uid)
                                .collection('reminder')
                                .doc("5")
                                .set(
                                  reminderModel5.toMap(),
                                );
                            ReminderModel reminderModel6 = ReminderModel();
                            DateTime reminderTime6 =
                                DateTime(1970, 1, 1, 19, 0, 0);
                            reminderModel6.time =
                                Timestamp.fromDate(reminderTime6);
                            reminderModel6.onOff = true;
                            reminderModel6.title = 'Makan Malam Sehat';
                            reminderModel6.description =
                                'Pilihlah makan malam yang sehat dan bergizi untuk mendukung pemulihan tubuh dan menjaga kesehatan.';
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(uid)
                                .collection('reminder')
                                .doc("6")
                                .set(
                                  reminderModel6.toMap(),
                                );
                            ReminderModel reminderModel7 = ReminderModel();
                            DateTime reminderTime7 =
                                DateTime(1970, 1, 1, 20, 0, 0);
                            reminderModel7.time =
                                Timestamp.fromDate(reminderTime7);
                            reminderModel7.onOff = true;
                            reminderModel7.title = 'Luangkan Waktu';
                            reminderModel7.description =
                                'Luangkan waktu untuk melakukan kegiatan yang menenangkan seperti membaca buku, meditasi, atau melakukan hobi untuk menenangkan pikiran setelah seharian beraktivitas.';
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(uid)
                                .collection('reminder')
                                .doc("7")
                                .set(
                                  reminderModel7.toMap(),
                                );
                            ReminderModel reminderModel8 = ReminderModel();
                            DateTime reminderTime8 =
                                DateTime(1970, 1, 1, 21, 0, 0);
                            reminderModel8.time =
                                Timestamp.fromDate(reminderTime8);
                            reminderModel8.onOff = true;
                            reminderModel8.title = 'Waktunya untuk Tidur';
                            reminderModel8.description =
                                'Tidurlah tepat waktu untuk memberi tubuh Anda kesempatan beristirahat.';
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(uid)
                                .collection('reminder')
                                .doc("8")
                                .set(
                                  reminderModel8.toMap(),
                                );
                            ReminderModel reminderModel9 = ReminderModel();
                            DateTime reminderTime9 =
                                DateTime(1970, 1, 1, 5, 0, 0);
                            reminderModel9.time =
                                Timestamp.fromDate(reminderTime9);
                            reminderModel9.onOff = true;
                            reminderModel9.title = 'Waktu Bangun';
                            reminderModel9.description =
                                'Bangun tepat waktu untuk mendapatkan kembali energi dan membantu Anda pulih dari aktivitas hari itu.';
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(uid)
                                .collection('reminder')
                                .doc("9")
                                .set(
                                  reminderModel9.toMap(),
                                );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                              ),
                            );
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        }
                      }
                    },
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  if (isLoading)
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryColor1),
                    ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ));
                    },
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          color: AppColors.lightGreyColor,
                          fontFamily: "SFProText",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          TextSpan(
                            text: "Sudah memiliki akun? ",
                            style: TextStyle(color: AppColors.textGrayColor),
                          ),
                          TextSpan(
                            text: "Login",
                            style: TextStyle(color: AppColors.primaryColor1),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
