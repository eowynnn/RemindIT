import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:remindits/model/reminder_model.dart';
import 'package:remindits/utils/app_colors.dart';

editReminder(BuildContext context, String uid,String reminderID,String title,String description) {
  TimeOfDay time = TimeOfDay.now();
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  edit(String uid, TimeOfDay time) {
    try {
      DateTime dateTime = DateTime(1970, 1, 1, time.hour, time.minute);
      Timestamp timestamp = Timestamp.fromDate(dateTime);
      ReminderModel reminderModel = ReminderModel();
      reminderModel.time = timestamp;
      reminderModel.onOff = false;
      if (titleController.text.isNotEmpty) {
        reminderModel.title = titleController.text;
      } else {
        reminderModel.title = title;
      }
      if (descController.text.isNotEmpty) {
        reminderModel.description = descController.text;
      } else {
        reminderModel.description = description;
      }
        FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('reminder')
            .doc(reminderID)
            .set(reminderModel.toMap());
      Fluttertoast.showToast(msg: 'Reminder Berhasil diedit');
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder:
            (BuildContext context, void Function(void Function()) setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text('Edit Reminder'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Edit reminder kamu"),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightGreyColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      maxLines: 1,
                      controller: titleController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: title,
                        hintStyle: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor1,
                            fontFamily: 'SFProText',
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightGreyColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      maxLines: 3,
                      controller: descController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: description,
                        hintStyle: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor1,
                            fontFamily: 'SFProText',
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    onPressed: () async {
                      TimeOfDay? newTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (newTime == null) return;
                      setState(
                        () {
                          time = newTime;
                        },
                      );
                    },
                    child: Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.clock,
                          color: AppColors.primaryColor1,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          time.format(context).toString(),
                          style: TextStyle(
                              color: AppColors.primaryColor1, fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: AppColors.textColor1),
                ),
              ),
              TextButton(
                onPressed: () {
                  edit(uid, time);
                  Navigator.pop(context);
                },
                child: Text(
                  "Add",
                  style: TextStyle(color: AppColors.primaryColor1),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
