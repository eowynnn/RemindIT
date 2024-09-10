import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:remindits/model/reminder_model.dart';

import '../utils/app_colors.dart';

class Pins extends StatefulWidget {
  bool onOff;
  String uid;
  Timestamp timestamp;
  String id;
  bool isPin;
  bool isPriority;
  final String title;
  final String description;

  Pins(this.onOff, this.uid, this.id, this.timestamp, this.title,
      this.description, this.isPriority,
      {this.isPin = false});

  @override
  State<Pins> createState() => _PinsState();
}

class _PinsState extends State<Pins> {
  @override
  Widget build(BuildContext context) {
    return Switch(
      activeColor: AppColors.primaryColor1,
      onChanged: (bool value){
        ReminderModel reminderModel = ReminderModel();
        if (value == true){
          reminderModel.onOff = true;
        }else {
          reminderModel.onOff = false;
        }
        reminderModel.time = widget.timestamp;
        reminderModel.isPin = value;
        reminderModel.title = widget.title;
        reminderModel.isPriority = widget.isPriority;
        reminderModel.description = widget.description;
        FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .collection('reminder')
            .doc(widget.id)
            .set(reminderModel.toMap());
      },
      value: widget.isPin,
    );
  }
}
