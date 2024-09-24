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
    title: "Selamat Datang di RemindIT",
    descriptions: "RemindIT Pengingat Sehat di Ujung Jari Anda",
  ),
  UnboardingContent(
    image: "assets/png/6.png",
    title: "Memulai",
    descriptions:
        "Buat akun atau masuk untuk mulai menerima pengingat cerdas yang disesuaikan dengan kebutuhan Anda.",
  ),
];
