import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:dailyexpenses/ui/settings/ProfileDialog.dart';
import 'package:dailyexpenses/custom_widget/image_view.dart';
import 'package:dailyexpenses/utils/constants/app_constants.dart';
import 'package:dailyexpenses/utils/constants/icon_constants.dart';
import 'package:dailyexpenses/utils/constants/image_constants.dart';
import 'package:dailyexpenses/utils/size_utils.dart';
import 'package:dailyexpenses/utils/strings.dart';

class BackgroundWidget extends StatefulWidget {
  final Widget child;

  const BackgroundWidget({Key key, this.child}) : super(key: key);

  @override
  _BackgroundWidgetState createState() => _BackgroundWidgetState();
}

class _BackgroundWidgetState extends State<BackgroundWidget> {
  int selectedBarIndex = 1;

  ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Scaffold(
      body: backgroundBody(),
    );
  }

  Widget backgroundBody() {
    return Stack(
      children: <Widget>[
        backgroundBaseWidget(),
        SafeArea(child: widget.child),
      ],
    );
  }

  Column backgroundBaseWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Container(
            padding: EdgeInsets.all(SizeUtils.get(40))
                .copyWith(left: SizeUtils.get(30)),
//            color: AppConstants.PRIMARY_COLOR,
            color: themeData.primaryColor,
          ),
        ),
        Expanded(
          flex: 6,
          child: Container(color: Colors.white10),
        ),
      ],
    );
  }
}
