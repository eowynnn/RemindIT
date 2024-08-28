import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderModel {
  Timestamp? time;
  bool? onOff;

  ReminderModel({this.time, this.onOff});

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'onOff': onOff,
    };
  }

  factory ReminderModel.fromMap(map) {
    return ReminderModel(
      time: map['time'],
      onOff: map['onOff'],
    );
  }
}
