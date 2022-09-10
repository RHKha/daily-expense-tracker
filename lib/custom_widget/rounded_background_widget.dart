import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:dailyexpenses/ui/settings/ProfileDialog.dart';
import 'package:dailyexpenses/custom_widget/image_view.dart';
import 'package:dailyexpenses/utils/constants/app_constants.dart';
import 'package:dailyexpenses/utils/constants/icon_constants.dart';
import 'package:dailyexpenses/utils/constants/image_constants.dart';
import 'package:dailyexpenses/utils/size_utils.dart';
import 'package:dailyexpenses/utils/strings.dart';

class RoundedBackgroundWidget extends StatefulWidget {
  final Widget child;

  final EdgeInsetsGeometry padding;

  final Color backgroundColor;

  const RoundedBackgroundWidget(
      {Key key, this.child, this.padding, this.backgroundColor})
      : super(key: key);

  @override
  _RoundedBackgroundWidgetState createState() =>
      _RoundedBackgroundWidgetState();
}

class _RoundedBackgroundWidgetState extends State<RoundedBackgroundWidget> {
  int selectedBarIndex = 1;

  ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Container(
      padding: widget.padding ??
          EdgeInsets.symmetric(
              horizontal: SizeUtils.get(15), vertical: SizeUtils.get(35)),
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))
//                color: Colors.grey[400], blurRadius: 5, offset: Offset(0, 2))
          ]),
      child: widget.child,
    );
  }
}
