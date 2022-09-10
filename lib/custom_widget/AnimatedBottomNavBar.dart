import 'package:flutter/material.dart';
import 'package:dailyexpenses/utils/size_utils.dart';

class AnimatedBottomBar extends StatefulWidget {
  final List<BarItem> barItems;
  final Duration animationDuration;
  final Function onBarTap;
  final BarStyle barStyle;

  final double height;

  AnimatedBottomBar(
      {this.barItems,
      this.animationDuration = const Duration(milliseconds: 500),
      this.onBarTap,
      this.height,
      this.barStyle});

  @override
  _AnimatedBottomBarState createState() => _AnimatedBottomBarState();
}

class _AnimatedBottomBarState extends State<AnimatedBottomBar>
    with TickerProviderStateMixin {
  int selectedBarIndex = 1;

  ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Container(
      height: widget.height ?? SizeUtils.get(60),
      child: Material(
        color: themeData.backgroundColor,
        elevation: 10,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildBarItems(context),
        ),
      ),
    );
  }

  List<Widget> _buildBarItems(BuildContext context) {
    List<Widget> _barItems = List();
    for (int i = 0; i < widget.barItems.length; i++) {
      BarItem item = widget.barItems[i];
      bool isSelected = selectedBarIndex == i;
      _barItems.add(InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          setState(() {
            selectedBarIndex = i;
            widget.onBarTap(selectedBarIndex);
          });
        },
        child: AnimatedContainer(
          padding: EdgeInsets.symmetric(
              horizontal: SizeUtils.get(15), vertical: SizeUtils.get(4)),
          duration: widget.animationDuration,
          decoration: BoxDecoration(
              color: isSelected
                  ? item.color.withOpacity(0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(
                item.iconData,
                color: isSelected ? item.color : Colors.grey,
                size: widget.barStyle.iconSize,
              ),
              SizedBox(width: SizeUtils.get(5)),
              AnimatedSize(
                duration: widget.animationDuration,
                curve: Curves.easeInOut,
                vsync: this,
                child: Text(
                  isSelected ? item.text : "",
                  style: TextStyle(
                      color: item.color,
                      fontWeight: widget.barStyle.fontWeight,
                      fontSize: widget.barStyle.fontSize),
                ),
              )
            ],
          ),
        ),
      ));
    }
    return _barItems;
  }
}

class BarStyle {
  final double fontSize, iconSize;
  final FontWeight fontWeight;

  BarStyle(
      {this.fontSize = 16.0,
      this.iconSize = 32,
      this.fontWeight = FontWeight.w600});
}

class BarItem {
  String text;
  IconData iconData;
  Color color;

  BarItem({this.text, this.iconData, this.color});
}
