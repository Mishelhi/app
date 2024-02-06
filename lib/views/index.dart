// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter_application_1/models/check_if_user_logged_in.dart';
import 'package:flutter_application_1/widgets/bottom_reminder_modal_sheet.dart';
import 'package:flutter_application_1/widgets/fab_bottom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'account_view.dart';
import 'reminders_view.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class IndexView extends StatefulWidget {
  @override
  _IndexViewState createState() => _IndexViewState();
}

class _IndexViewState extends State<IndexView> {
  bool _searchPressed = false;

  int _index = 0;

  // int _index = 1;
  List<Widget> _widgetList = [
    RemindersView(),
    AccountView(),
  ];

  @override
  Widget build(BuildContext context) {
    print('IndexView');
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;

    ScreenUtil.init(context,
        designSize: Size(_width, _height), minTextAdapt: true);

    return ChangeNotifierProvider<CheckIfUserLoggedIn>(
      create: (context) => CheckIfUserLoggedIn(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0.h,
          backgroundColor: Color(0xfffafafa),
          centerTitle: false,
          title: Text(
            'Checklst.',
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.black,
              fontFamily: 'Playfair',
              fontWeight: FontWeight.w900,
            ),
          ),
          actions: [
            Container(
              width: _width - 180.0.w,
              margin: EdgeInsets.only(right: 15.0.w, top: 5.0.h),
              child: TextField(
                onTap: () {
                  setState(() {
                    print('Search Pressed');
                    _searchPressed = true;
                  });
                },
                onChanged: (value) {},
                // controller: editingController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: "Search reminder...",
                  hintStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[350],
                    fontSize: 13.0,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: _searchPressed ? Colors.black : Colors.grey[500],
                    ),
                    onPressed: () {
                      setState(() {
                        _searchPressed = true;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey[500] ?? Colors.grey),
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0.h),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0.h),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: _widgetList[_index],
        bottomNavigationBar: FABBottomAppBar(
          centerItemText: 'Add Reminder',
          color: Colors.grey,
          backgroundColor: Colors.white,
          selectedColor: Colors.black,
          notchedShape: CircularNotchedRectangle(),
          onTabSelected: (index) {
            setState(() {
              _index = index;
            });
          },
          items: [
            FABBottomAppBarItem(iconData: Icons.menu, text: 'Reminders'),
            FABBottomAppBarItem(iconData: Icons.face, text: 'Account'),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print('Add Reminder');
            showModalBottomSheet<dynamic>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return Wrap(
                  children: [
                    BottomReminderSheet(),
                  ],
                );
              },
            );
          },
          highlightElevation: 3.0.h,
          child: Icon(
            Icons.add,
            color: Colors.black,
          ),
          elevation: 2.0.h,
          backgroundColor: Colors.white,
        ),
        extendBody:
            true, // ensures that that scaffold's body will be visible through the bottom navigation bar's notch
      ),
    );
  }
}
