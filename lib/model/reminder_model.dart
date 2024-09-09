import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderModel {
  Timestamp? time;
  bool? onOff;
  bool? isPin;
  String? title;
  String? description;
  bool? isPriority;

  ReminderModel({this.time, this.onOff, this.isPin, this.title, this.description, this.isPriority});

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'onOff': onOff,
      'isPin': isPin,
      'title' : title,
      'description' : description,
      'isPriority' : isPriority
    };
  }

  factory ReminderModel.fromMap(map) {
    return ReminderModel(
      time: map['time'],
      onOff: map['onOff'],
      isPin: map['isPin'],
      title: map['title'],
      description: map['description'],
      isPriority: map['isPriority'],
    );
  }
}
