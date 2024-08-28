import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:remindits/model/reminder_model.dart';
import 'package:remindits/utils/app_colors.dart';
// import 'package:remindits/services/notification_logic.dart';

class Switcher extends StatefulWidget {
  bool onOff;
  String uid;
  Timestamp timestamp;
  String id;

  Switcher(this.onOff, this.uid, this.id, this.timestamp);

  @override
  State<Switcher> createState() => _SwitcherState();
}

class _SwitcherState extends State<Switcher> {
  @override
  Widget build(BuildContext context) {
    return Switch(
      activeColor: AppColors.primaryColor1,
      onChanged: (bool value) {
        // if (value){
        //   NotificationLogic.showNotification(id: widget.id.toString(), dateTime: widget.timestamp.toDate());
        // }else {
        //   NotificationLogic.cancelNotification(id: widget.id);
        // }
        ReminderModel reminderModel = ReminderModel();
        reminderModel.onOff = value;
        reminderModel.time = widget.timestamp;
        FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .collection('reminder')
            .doc(widget.id)
            .set(reminderModel.toMap());
      },
      value: widget.onOff,
    );
  }
}
