class PackageModel {
  String title;
  String desc;
  PackageModel({required this.title, required this.desc});
  factory PackageModel.fromMap(Map<String,dynamic>map){
    return PackageModel(title: map['title'], desc: map['desc']);
  }
}
