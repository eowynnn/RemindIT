import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderModel {
  Timestamp? time;
  bool? onOff;
  bool? isPin;

  ReminderModel({this.time, this.onOff, this.isPin});

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'onOff': onOff,
      'isPin': isPin,
    };
  }

  factory ReminderModel.fromMap(map) {
    return ReminderModel(
      time: map['time'],
      onOff: map['onOff'],
      isPin: map['isPin'],
    );
  }
}
