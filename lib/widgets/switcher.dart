import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:remindits/model/reminder_model.dart';
import 'package:remindits/utils/app_colors.dart';
// import 'package:remindits/services/notification_logic.dart';

// ignore: must_be_immutable
class Switcher extends StatefulWidget {
  bool onOff;
  String uid;
  Timestamp timestamp;
  String id;
  final String title;
  final String description;

  Switcher(
    this.onOff,
    this.uid,
    this.id,
    this.timestamp,
    this.title,
    this.description,
  );

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
        reminderModel.title = widget.title;
        reminderModel.description = widget.description;
        FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .collection('reminder')
            .doc(widget.id)
            .set(
              reminderModel.toMap(),
            );
        if (value == true) {
          Fluttertoast.showToast(msg: 'Reminder Aktif');
        } else {
          Fluttertoast.showToast(msg: 'Reminder Mati');
        }
      },
      value: widget.onOff,
    );
  }
}
