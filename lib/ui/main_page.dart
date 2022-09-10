import 'package:dailyexpenses/ui/credit/credit_list_page.dart';
import 'package:dailyexpenses/ui/debit/debit_list_page.dart';
import 'package:dailyexpenses/utils/app_translate.dart';
import 'package:dailyexpenses/utils/common_utils.dart';
import 'package:dailyexpenses/utils/size_utils.dart';
import 'package:flutter/material.dart';

import '../custom_widget/AnimatedBottomNavBar.dart';
import 'home/home_page.dart';

class MainPage extends StatefulWidget {
//  final List<BarItem> barItems = [
//    BarItem(
//      text: CommonUtils.getText(context, AppTranslate.DEBIT),
//      iconData: Icons.remove_circle_outline,
//      color: Colors.pinkAccent,
//    ),
//    BarItem(
//      text: CommonUtils.getText(context, AppTranslate.HOME),
//      iconData: Icons.home,
//      color: Colors.indigo,
//    ),
//    BarItem(
//      text: CommonUtils.getText(context, AppTranslate.CREDIT),
//      iconData: Icons.add_circle_outline,
//      color: Colors.teal,
//    ),
//  ];

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedBarIndex = 1;
  List<BarItem> barItems = [];

  @override
  void initState() {
    super.initState();
//    setMenu();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
//    if (barItems.isEmpty) {
    setMenu();
//    }
  }

  void setMenu() {
    barItems = [
      BarItem(
        text: CommonUtils.getText(context, AppTranslate.DEBIT),
        iconData: Icons.remove_circle_outline,
        color: Colors.pinkAccent,
      ),
      BarItem(
        text: CommonUtils.getText(context, AppTranslate.HOME),
        iconData: Icons.home,
        color: Colors.indigo,
      ),
      BarItem(
        text: CommonUtils.getText(context, AppTranslate.CREDIT),
        iconData: Icons.add_circle_outline,
        color: Colors.teal,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pagesList = [DebitListPage(), HomePage(), CreditListPage()];

    return Scaffold(
      body: pagesList[selectedBarIndex],
      bottomNavigationBar: AnimatedBottomBar(
        barItems: barItems,
        animationDuration: const Duration(milliseconds: 150),
        barStyle: BarStyle(
            fontSize: SizeUtils.getFontSize(18), iconSize: SizeUtils.get(30)),
        onBarTap: (index) {
          setState(() {
            selectedBarIndex = index;
          });
        },
      ),
    );
  }
}
