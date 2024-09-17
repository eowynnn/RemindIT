import 'package:flutter/material.dart';
import 'package:remindits/Screen/login_screen.dart';
import 'package:remindits/services/onBoarding_service.dart';
import 'package:remindits/utils/app_colors.dart';

class onBoarding extends StatefulWidget {
  const onBoarding({super.key});

  @override
  State<onBoarding> createState() => _onBoardingState();
}

class _onBoardingState extends State<onBoarding> {
  int currentIndex = 0;
  PageController _controller = PageController(initialPage: 0);

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SafeArea(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginPage(),
                  ),
                );
              },
              child: Text(
                "Skip",
                style: TextStyle(color: AppColors.textColor1),
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return Padding(
                  padding: const EdgeInsets.all(80.0),
                  child: Column(
                    children: [
                      Image.asset(
                        contents[i].image,
                        height: 300,
                      ),
                      Text(
                        contents[i].title,
                        style: TextStyle(
                          fontFamily: "SFProText",
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        contents[i].descriptions,
                        style: TextStyle(
                          fontFamily: "SFProText",
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                contents.length,
                (index) => buildDot(index, context),
              ),
            ),
          ),
          Container(
            height: 60,
            margin: EdgeInsets.all(40),
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                if (currentIndex == contents.length - 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LoginPage(),
                    ),
                  );
                }
                _controller.nextPage(
                  duration: Duration(milliseconds: 200),
                  curve: Cubic(0.4, 0.0, 0.2, 1.0),
                );
              },
              child: Text(
                currentIndex == contents.length - 1 ? "Continue" : "Next",
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                backgroundColor: WidgetStateProperty.all<Color>(
                  AppColors.primaryColor1,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 25 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.primaryColor1,
      ),
    );
  }
}
