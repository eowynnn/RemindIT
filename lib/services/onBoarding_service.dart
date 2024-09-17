class UnboardingContent {
  String image;
  String title;
  String descriptions;

  UnboardingContent(
      {required this.image, required this.title, required this.descriptions});
}

List<UnboardingContent> contents = [
  UnboardingContent(
    image: "assets/png/5.png",
    title: "Welcome To RemindIT",
    descriptions: "Remind It Healthy Reminders at Your Fingertips",
  ),
  UnboardingContent(
    image: "assets/png/6.png",
    title: "RemindIT",
    descriptions: "lorem ipsum dolor sit amet",
  ),
  UnboardingContent(
    image: "assets/png/7.png",
    title: "RemindIT",
    descriptions: "lorem ipsum dolor sit amet",
  ),
];
