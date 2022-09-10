import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dailyexpenses/model/transaction_model.dart';
import 'package:dailyexpenses/utils/common_utils.dart';
import 'package:dailyexpenses/utils/constants/app_constants.dart';
import 'package:dailyexpenses/utils/constants/color_constants.dart';
import 'package:dailyexpenses/utils/size_utils.dart';
import 'package:intl/intl.dart';

class ItemCard extends StatefulWidget {
  final DocumentSnapshot transactionModel;
  final Function onTap;
  final String currencySymbol;

  ItemCard({Key key, this.transactionModel, this.onTap, this.currencySymbol})
      : super(key: key);

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return itemCell();
  }

  Widget itemCell() {
    String date = CommonUtils.getOnlyDateFromTimestamp(
        widget.transactionModel.data["date"]);

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: SizeUtils.get(15), vertical: SizeUtils.get(5)),
      decoration: BoxDecoration(
//          color: Colors.white,
          color: themeData.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 10, offset: Offset(2, 3))
//                color: Colors.grey[300], blurRadius: 10, offset: Offset(2, 3))
          ]),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
                  horizontal: SizeUtils.get(22), vertical: SizeUtils.get(8))
              .copyWith(left: SizeUtils.get(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(width: SizeUtils.get(3)),
              Text(
                date + "th",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: widget.transactionModel.data["type"] ==
                          AppConstants.TYPE_CREDIT
                      ? Colors.green[700]
                      : Colors.red[700],
                  fontWeight: FontWeight.bold,
                  fontSize: SizeUtils.getFontSize(15),
                ),
              ),
              SizedBox(width: SizeUtils.get(5)),
              iconUpDown(),
              SizedBox(width: SizeUtils.get(10)),
              Expanded(
                child: descriptionWidget(),
              ),
              SizedBox(width: SizeUtils.get(10)),
              amountWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Text amountWidget() {
    return Text(
      widget.currencySymbol +
          " " +
          double.parse(widget.transactionModel.data["value"])
              .toStringAsFixed(2),
      style: TextStyle(
        color: widget.transactionModel.data["type"] == AppConstants.TYPE_CREDIT
            ? Colors.green[700]
            : Colors.red[700],
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  Widget descriptionWidget() {
    return Text(
      widget.transactionModel.data["description"],
      textAlign: TextAlign.start,
      style: TextStyle(
        color: widget.transactionModel.data["type"] == AppConstants.TYPE_CREDIT
            ? Colors.green[700]
            : Colors.red[700],
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  Container iconUpDown() {
    return Container(
      child: Padding(
          padding: EdgeInsets.all(8),
          child:
              widget.transactionModel.data["type"] == AppConstants.TYPE_CREDIT
                  ? Icon(
                      Icons.arrow_downward,
                      color: Colors.green,
                      size: SizeUtils.get(25),
                    )
                  : Icon(Icons.arrow_upward,
                      color: Colors.red, size: SizeUtils.get(25))),
    );
  }
}
