import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderModel {
  Timestamp? time;
  bool? onOff;
  String? title;
  String? description;

  ReminderModel({this.time, this.onOff, this.title, this.description, });

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'onOff': onOff,
      'title' : title,
      'description' : description,
    };
  }

  factory ReminderModel.fromMap(map) {
    return ReminderModel(
      time: map['time'],
      onOff: map['onOff'],
      title: map['title'],
      description: map['description'],
    );
  }
}
