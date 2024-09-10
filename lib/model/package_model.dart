class PackageModel {
  String title;
  String desc;
  String link;
  PackageModel({required this.title, required this.desc,required this.link});
  factory PackageModel.fromMap(Map<String,dynamic>map){
    return PackageModel(title: map['title'], desc: map['desc'],link: map['link']);
  }
}
