import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:remindits/Screen/login_screen.dart';
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
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
                          "Create account",
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
                          "Sign up to get started!",
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
                    icon: "Message",
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
                    icon: "Message",
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
                          _isObsecure ? Icons.visibility : Icons.visibility_off,
                          size: 20,
                        ),
                        alignment: Alignment.center,
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: media.width * 0.08,
                  ),
                  RoundGradientButton(
                    title: "Create Account",
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        if (!_isCheck) {
                          try {
                            UserCredential userCredential =
                                await _auth.createUserWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                            String uid = userCredential.user!.uid;
                            await _users.doc(uid).set({
                              'email': _emailController.text,
                              'firstName': _firstNameController.text,
                              'lastName': _lastNameController.text,
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Account created successfully"),
                              ),
                            );
                            Navigator.push(
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
                          }
                        }
                      }
                    },
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
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
                            text: "Already have an account? ",
                            style: TextStyle(color: AppColors.textGrayColor),
                          ),
                          TextSpan(
                            text: "Sign In",
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
