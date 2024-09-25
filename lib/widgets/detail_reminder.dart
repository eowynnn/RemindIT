import 'package:flutter/material.dart';
import 'package:remindits/utils/app_colors.dart';

detailReminder(BuildContext context, String title, String description,
    String time, String uid, String reminderID) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text("Detail Reminder"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Title : ",
                style: TextStyle(
                  fontFamily: "SFPro",
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              Container(
                // width: 100,
                child: Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(overflow: TextOverflow.clip),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Deskripsi : ",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Container(
                child: Row(
                  children: [
                    Container(
                      width: 200,
                      child: Text(
                        description,
                        style: TextStyle(
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Text(
                "Waktu : ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(time),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Tutup",style: TextStyle(color: AppColors.textColor1),),
          )
        ],
      );
    },
  );
}
