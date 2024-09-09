import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:remindits/model/reminder_model.dart';
import 'package:remindits/utils/app_colors.dart';
// import 'package:remindits/services/notification_logic.dart';

// ignore: must_be_immutable
class Switcher extends StatefulWidget {
  bool onOff;
  String uid;
  Timestamp timestamp;
  String id;
  bool isPin;
  final String title;
  final String description;
  final bool isPriority;

  Switcher(this.onOff, this.uid, this.id, this.timestamp, this.title,
      this.description,
      this.isPriority,
      {this.isPin = false});

  @override
  State<Switcher> createState() => _SwitcherState();
}

class _SwitcherState extends State<Switcher> {
  @override
  Widget build(BuildContext context) {
    return Switch(
      activeColor: AppColors.primaryColor1,
      onChanged: (bool value) {
        ReminderModel reminderModel = ReminderModel();
        reminderModel.onOff = value;
        reminderModel.time = widget.timestamp;
        reminderModel.isPin = value ? widget.isPin : false;
        reminderModel.title = widget.title;
        reminderModel.description = widget.description;
        reminderModel.isPriority = widget.isPriority;
        FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .collection('reminder')
            .doc(widget.id)
            .set(
              reminderModel.toMap(),
            );
      },
      value: widget.onOff,
    );
  }
}
