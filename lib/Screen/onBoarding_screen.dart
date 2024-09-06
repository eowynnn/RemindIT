import 'package:flutter/material.dart';

class onBoarding extends StatefulWidget {
  const onBoarding({super.key});

  @override
  State<onBoarding> createState() => _onBoardingState();
}

class _onBoardingState extends State<onBoarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
          itemCount: 3,
          itemBuilder: (_, i) {
            return Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  Image.asset("assets\png\logo.png"),
                ],
              ),
            );
          }),
    );
  }
}
