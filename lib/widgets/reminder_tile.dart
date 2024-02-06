import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_application_1/utilities/colors.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReminderTile extends StatefulWidget {
  final bool isLocationBased;

  final String title;
  final String description;
  final String? date;
  final String? time;
  final userLocation;
  final bool isChecked;
  final Function checkBoxCallBack;
  final Function deleteCallBack;

  ReminderTile({
    required this.title,
    required this.description,
    this.date,
    this.time,
    this.userLocation,
    required this.isLocationBased,
    required this.isChecked,
    required this.checkBoxCallBack,
    required this.deleteCallBack,
  });

  @override
  _ReminderTileState createState() => _ReminderTileState();
}

class _ReminderTileState extends State<ReminderTile> {
  final _random = new Random();
  Color? _color;

  void getColor() {
    setState(() {
      _color = colorsList[_random.nextInt(colorsList.length)];
    });
  }

  @override
  void initState() {
    getColor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(432.0, 816.0), minTextAdapt: true);

    return Padding(
      padding: EdgeInsets.only(top: 10.0.h),
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 110.0.h,
            padding: EdgeInsets.only(
              top: 20.0.h,
              left: 20.0.w,
            ),
            decoration: BoxDecoration(
              color: _color,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            child: Slidable(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 110.0.h,
                padding: EdgeInsets.only(
                  top: 20.0.h,
                  left: 20.0.w,
                ),
                decoration: BoxDecoration(
                  color: Color(0xfffafafa),
                  border: Border.all(
                      color: Colors.grey[200] ?? Colors.grey, width: 2.0.w),
                  borderRadius: BorderRadius.all(Radius.circular(20.0.h)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'WorkSans',
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              decoration: widget.isChecked
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                        Container(
                          width: 50.0.w,
                          height: 5.0.h,
                          decoration: BoxDecoration(
                              color: _color,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0.h),
                                  bottomLeft: Radius.circular(10.0.h))),
                        )
                      ],
                    ),
                    Expanded(
                      child: Text(
                        widget.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'WorkSans',
                          color: Colors.grey[450],
                        ),
                      ),
                    ),
                    widget.isLocationBased
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    // color: Colors.grey[350],
                                    color: _color,
                                    size: 15.0.h,
                                  ),
                                  Text(
                                    widget.userLocation,
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      fontFamily: 'WorkSans',
                                      fontWeight: FontWeight.w600,
                                      // color: Colors.grey[350],
                                      color: _color,
                                    ),
                                  ),
                                ],
                              ),
                              Transform.scale(
                                scale: 0.7,
                                child: CheckboxListTile(
                                  title: Text('Your title'),
                                  value: widget.isChecked,
                                  onChanged: (newValue) {
                                    setState(() {
                                      widget.checkBoxCallBack();
                                    });
                                  },
                                  controlAffinity: ListTileControlAffinity
                                      .leading, // places the checkbox at the start
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.alarm,
                                    // color: Colors.grey[350],
                                    color: _color,
                                    size: 15.0.h,
                                  ),
                                  Text(
                                    ' ${widget.date}, ${widget.time}',
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      fontFamily: 'WorkSans',
                                      fontWeight: FontWeight.w600,
                                      // color: Colors.grey[350],
                                      color: _color,
                                    ),
                                  ),
                                ],
                              ),
                              Transform.scale(
                                scale: 0.7,
                                child: CheckboxListTile(
                                  title: Text('Your title'),
                                  value: widget.isChecked,
                                  onChanged: (newValue) {
                                    setState(() {
                                      widget.checkBoxCallBack();
                                    });
                                  },
                                  controlAffinity: ListTileControlAffinity
                                      .leading, // places the checkbox at the start
                                ),
                              ),
                            ],
                          )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
