import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:remindits/utils/app_colors.dart';

deleteReminder(BuildContext context, String id, String uid) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        title: Text('Delete Reminder'),
        content: Text("Are you sure you want to delete this reminder?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel",style: TextStyle(color: AppColors.textColor1),),
          ),
          TextButton(
            onPressed: () {
              try {
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(uid)
                    .collection("reminder")
                    .doc(id)
                    .delete();
                Fluttertoast.showToast(msg: "Reminder Deleted");
                Navigator.pop(context);
              } catch (e) {
                Fluttertoast.showToast(msg: e.toString());
              }
            },
            child: Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      );
    },
  );
}
