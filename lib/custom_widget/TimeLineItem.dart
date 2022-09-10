import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dailyexpenses/model/transaction_model.dart';
import 'package:dailyexpenses/utils/constants/app_constants.dart';
import 'package:dailyexpenses/utils/size_utils.dart';
import 'package:intl/intl.dart';

class TimeLineItem extends StatelessWidget {
  final DocumentSnapshot transaction;
  final bool isLast;
  final Color colorItem;
  final String currencySymbol;

  const TimeLineItem(
      {Key key,
      this.transaction,
      this.isLast,
      this.colorItem,
      this.currencySymbol})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? SizeUtils.get(20) : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          leftIcon(),
          Expanded(
            child: descriptionAndDate(),
          ),
          amount()
        ],
      ),
    );
  }

  Column leftIcon() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          width: SizeUtils.getWidthAsPerPercent(3),
          height: SizeUtils.getHeightAsPerPercent(1.5),
          decoration: BoxDecoration(
              color: colorItem, borderRadius: BorderRadius.circular(10)),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: SizeUtils.getWidthAsPerPercent(2),
              bottom: SizeUtils.getWidthAsPerPercent(2)),
          child: Container(
            width: SizeUtils.getWidthAsPerPercent(0.4),
            height: isLast != true
                ? SizeUtils.getHeightAsPerPercent(5)
                : SizeUtils.getHeightAsPerPercent(5),
            decoration: BoxDecoration(
              color: Colors.grey[850],
            ),
          ),
        )
      ],
    );
  }

  Widget descriptionAndDate() {
    var date = DateFormat('dd MMMM, yyyy').format(
        DateTime.fromMicrosecondsSinceEpoch(
            int.parse(transaction.data['date']) * 1000));

    return Padding(
      padding: EdgeInsets.only(left: SizeUtils.get(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: SizeUtils.get(15)),
          Text(
            transaction.data['description'],
            style: TextStyle(
              color: Colors.white,
              fontSize: SizeUtils.getFontSize(20),
            ),
          ),
          Text(
            date,
            style: TextStyle(
              color: Colors.white70,
              fontSize: SizeUtils.getFontSize(16),
            ),
          ),
        ],
      ),
    );
  }

  Padding amount() {
    return Padding(
      padding:
          EdgeInsets.only(right: SizeUtils.get(20), top: SizeUtils.get(20)),
      child: Text(
        currencySymbol +
            " " +
            double.parse(transaction.data['value']).toStringAsFixed(2),
        textAlign: TextAlign.end,
        style: TextStyle(
            color: Colors.white,
            fontSize: SizeUtils.getFontSize(20),
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
