import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailyexpenses/app_theme/input_decoration_theme.dart';
import 'package:dailyexpenses/custom_widget/dialogs.dart';
import 'package:dailyexpenses/data/network/network_check.dart';
import 'package:dailyexpenses/model/transaction_model.dart';
import 'package:dailyexpenses/utils/app_translate.dart';
import 'package:dailyexpenses/utils/common_utils.dart';
import 'package:dailyexpenses/utils/constants/app_constants.dart';
import 'package:dailyexpenses/utils/size_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddEditTransactionDialog extends StatefulWidget {
  final DocumentSnapshot transactionModel;
  final Function updateList;

  const AddEditTransactionDialog(
      {Key key, this.transactionModel, this.updateList})
      : super(key: key);

  @override
  _AddEditTransactionDialogState createState() =>
      _AddEditTransactionDialogState();
}

class _AddEditTransactionDialogState extends State<AddEditTransactionDialog> {
  bool edit;

  int _groupValueRadio = 1;

  Color _colorContainer = Colors.green[400];
  Color _colorTextButton = Colors.green;

  TextEditingController _controllerValue = TextEditingController();
  TextEditingController _controllerDescription = TextEditingController();

  ThemeData themeData;
  final _formKey = GlobalKey<FormState>();

  String _amount = "";
  String _description = "";

  bool _autoValidate = false;

  String selectedDateString = "";

  DateTime selectedDateTime;

  final databaseReference = FirebaseDatabase.instance.reference();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore firestoreInstance = Firestore.instance;

  bool showLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.transactionModel != null) {
      print(widget.transactionModel.toString());

      edit = true;
      if (widget.transactionModel.data['type'] == AppConstants.TYPE_DEBIT) {
        _groupValueRadio = 2;
        _colorContainer = Colors.red[300];
        _colorTextButton = Colors.red[300];
      }

      _controllerValue.text =
          widget.transactionModel.data['value'].toString().replaceAll("-", "");
      _controllerDescription.text = widget.transactionModel.data['description'];

      selectedDateTime = CommonUtils.getDateTimeFromTimestamp(
          widget.transactionModel.data['date']);
      selectedDateString = DateFormat('dd MMM, yyyy').format(selectedDateTime);
    } else {
      edit = false;
      selectedDateTime = DateTime.now();
      selectedDateString = DateFormat('dd MMM, yyyy').format(selectedDateTime);
    }
    print(" edit -> $edit");
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeUtils.get(20))),
        title: Text(
          CommonUtils.getText(context, AppTranslate.ADD_VALUES),
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: _colorContainer,
        content: Container(
          width: SizeUtils.screenWidth,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  typeSelection(),
                  SizedBox(height: SizeUtils.get(20)),
                  dateSelectionWidget(),
                  SizedBox(height: SizeUtils.get(20)),
                  amountWidget(),
                  SizedBox(height: SizeUtils.get(20)),
                  descriptionWidget(),
                  SizedBox(height: SizeUtils.get(20)),
                  buttonOptionsWidget(context)
                ],
              ),
            ),
          ),
        ));
  }

  Widget typeSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        typeWidgetWithRadio(
            title: CommonUtils.getText(context, AppTranslate.CREDIT),
            value: 1,
            onTap: () {
              if (_groupValueRadio == 2) {
                changeTypeValue(1);
              }
            },
            onChanged: (value) {
              print(value);
              changeTypeValue(value);
            }),
        typeWidgetWithRadio(
            title: CommonUtils.getText(context, AppTranslate.DEBIT),
            value: 2,
            onTap: () {
              if (_groupValueRadio == 1) {
                changeTypeValue(2);
              }
            },
            onChanged: (value) {
              print(value);
              changeTypeValue(value);
            }),
      ],
    );
  }

  void changeTypeValue(value) {
    setState(() {
      _groupValueRadio = value;
      _colorContainer = value == 1 ? Colors.green[400] : Colors.red[400];
      _colorTextButton = value == 1 ? Colors.green : Colors.red[400];
    });
  }

  Widget dateSelectionWidget() {
    return GestureDetector(
      onTap: () {
        selectDate();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: SizeUtils.get(30), vertical: SizeUtils.get(5)),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))
//                  color: Colors.grey[400], blurRadius: 5, offset: Offset(0, 2))
            ]),
        child: Text(
          selectedDateString == ""
              ? CommonUtils.getText(context, AppTranslate.SELECT_DATE)
              : selectedDateString,
          style: themeData.textTheme.subtitle
              .copyWith(fontSize: SizeUtils.getFontSize(16)),
        ),
      ),
    );
  }

  Widget amountWidget() {
    return InputTextFieldUtils.inputTextField(
      controller: _controllerValue,
      label: CommonUtils.getText(context, AppTranslate.AMOUNT),
      maxLength: 7,
      keyboardType: TextInputType.number,
      style: TextStyle(
          fontSize: SizeUtils.getFontSize(18),
          color: _groupValueRadio == 1 ? Colors.green[400] : Colors.red[400]),
      onSaved: (value) => _amount = value,
      validator: (value) {
        if (value.isEmpty) {
          return CommonUtils.getText(context, AppTranslate.PLEASE_ENTER_AMOUNT);
        }
        return null;
      },
    );
  }

  Widget descriptionWidget() {
    return InputTextFieldUtils.inputTextField(
      controller: _controllerDescription,
      label: CommonUtils.getText(context, AppTranslate.DESCRIPTION),
      capsText: true,
      maxLength: 40,
      style: TextStyle(
          fontSize: SizeUtils.getFontSize(18),
          color: _groupValueRadio == 1 ? Colors.green[400] : Colors.red[400]),
      onSaved: (value) => _description = value,
      validator: (value) {
        if (value.isEmpty) {
          return CommonUtils.getText(
              context, AppTranslate.PLEASE_ENTER_DESCRIPTION);
        }
        return null;
      },
    );
  }

  Widget buttonOptionsWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Text(
            CommonUtils.getText(context, AppTranslate.CANCEL),
            style: TextStyle(color: Colors.white),
          ),
        ),
        showLoading
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: SizeUtils.get(30)),
                child: CupertinoActivityIndicator(),
              )
            : GestureDetector(
                onTap: () {
                  onClickConfirm(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeUtils.get(10),
                    vertical: SizeUtils.get(5),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      edit == false
                          ? CommonUtils.getText(context, AppTranslate.CONFIRM)
                          : CommonUtils.getText(context, AppTranslate.UPDATE),
                      style: TextStyle(
                          color: _colorTextButton,
                          fontWeight: FontWeight.bold,
                          fontSize: SizeUtils.getFontSize(16)),
                    ),
                  ),
                ),
              )
      ],
    );
  }

  GestureDetector typeWidgetWithRadio({title, value, onTap, onChanged}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Radio(
            activeColor: Colors.white,
            value: value,
            groupValue: _groupValueRadio,
            onChanged: (value) => onChanged(value),
          ),
          Text(title,
              style:
                  themeData.textTheme.subtitle.copyWith(color: Colors.white)),
          value == 2 ? SizedBox(width: SizeUtils.get(15)) : Container()
        ],
      ),
    );
  }

  Future selectDate() async {
    DateTime initialData = new DateTime.now();

    DateTime selectedDate = await showDatePicker(
      context: context,
      initialDate: initialData,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );

    if (selectedDate != null) {
      setState(() {
        selectedDateTime = selectedDate;
        selectedDateString = DateFormat('dd MMM, yyyy').format(selectedDate);
      });
    }
  }

  Future<void> onClickConfirm(BuildContext context) async {
    if (selectedDateString.isEmpty) {
      Dialogs.showInfoDialog(context, "Please select date");
      return;
    }
    if (_formKey.currentState.validate()) {
      setState(() {
        showLoading = true;
      });
      _formKey.currentState.save();

      TransactionModel transaction = TransactionModel();
      String value;
      if (_controllerValue.text.contains(",")) {
        value = _controllerValue.text.replaceAll(RegExp(","), ".");
      } else {
        value = _controllerValue.text;
      }

      transaction.date = selectedDateTime.millisecondsSinceEpoch.toString();
      transaction.createAt = DateTime.now().millisecondsSinceEpoch.toString();
      transaction.description = _controllerDescription.text;
      transaction.value = double.parse(value).toStringAsFixed(2);

      if (_groupValueRadio == 1) {
        transaction.type = AppConstants.TYPE_CREDIT;
      } else if (_groupValueRadio == 2) {
        transaction.type = AppConstants.TYPE_DEBIT;
      }

      FirebaseUser user = await _auth.currentUser();
      transaction.uid = user.uid;

      NetworkCheck networkCheck = new NetworkCheck();
      final bool isConnect = await networkCheck.check();
      if (isConnect) {
        if (widget.transactionModel != null) {
          await firestoreInstance
              .collection("Transaction")
              .document(widget.transactionModel.documentID)
              .updateData(transaction.toJson())
              .then((value) {
            print("Transaction entry :: updated");
          }).whenComplete(() {
            setState(() {
              showLoading = false;
            });
            Navigator.pop(context);
            widget.updateList();
          });
        } else {
//        databaseReference
//            .child(user.uid)
//            .push()
//            .set(transaction.toJson())
//            .then((value) {
//          print("value :: ");
//        }).catchError((onError) {
//          print("onError :: ${onError}");
//        }).whenComplete(() => print("Success entry"));

//        firestoreInstance.collection("Transaction")
//            .document(user.uid).setData(transaction.toJson()).then((value) {
////          print("Transaction entry :: ${value.documentID}");
//        });
          await firestoreInstance
              .collection("Transaction")
              .add(transaction.toJson())
              .then((value) {
            print("Transaction entry :: ${value.documentID}");
          }).catchError((onError) {
//          Dialogs.showInfoDialog(context, onError.toString());
          }).whenComplete(() {
            setState(() {
              showLoading = false;
            });
            Navigator.pop(context);
            widget.updateList();
          });
        }
      } else {
        Dialogs.showInfoDialog(
            context, CommonUtils.getText(context, AppTranslate.INTERNET_ERROR));
      }
    } else {
      _autoValidate = true;
    }
  }
}
