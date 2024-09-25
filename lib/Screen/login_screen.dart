import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:remindits/Screen/home_screen.dart';
import 'package:remindits/Screen/register_screen.dart';
import 'package:remindits/utils/app_colors.dart';
import 'package:remindits/widgets/round_gradient_button.dart';
import 'package:remindits/widgets/round_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isObsecure = true;
  final _formkey = GlobalKey<FormState>();

  Future<User?> _signIn(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User? user = userCredential.user;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
      return user;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal Masuk"),
        ),
      );
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                      height: media.height * 0.1,
                    ),
                    SizedBox(
                      width: media.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: media.width * 0.2,
                          ),
                          Text(
                            "Selamat Datang kembali",
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
                            "Mulailah perjalanan Anda menuju kehidupan yang sehat dan produktif. Masuk untuk melanjutkan.",
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
                      textEditingController: _passController,
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
                      height: media.width * 0.08,
                    ),
                    RoundGradientButton(
                      title: "Login",
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          _signIn(context, _emailController.text,
                              _passController.text);
                        }
                      },
                    ),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegistPage(),
                          ),
                        );
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
                              text: "Tidak punya akun? ",
                              style: TextStyle(color: AppColors.textGrayColor),
                            ),
                            TextSpan(
                              text: "Register",
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
      ),
    );
  }
}
