import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoRemindersBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(432.0, 816.0), minTextAdapt: true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'No reminders',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'WorkSans',
          ),
        ),
        SizedBox(height: 5.0.h),
        Text(
          'Create a reminder and it will',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: 'WorkSans',
            color: Colors.grey[500],
          ),
        ),
        Text(
          'show up here',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: 'WorkSans',
            color: Colors.grey[500],
          ),
        ),
        SizedBox(height: 10.0.h),
        Icon(
          Icons.keyboard_arrow_down,
          color: Colors.grey[500],
        ),
      ],
    );
  }
}
