import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailyexpenses/custom_widget/background_widget.dart';
import 'package:dailyexpenses/custom_widget/dialogs.dart';
import 'package:dailyexpenses/data/local/currency_manager.dart';
import 'package:dailyexpenses/data/network/network_check.dart';
import 'package:dailyexpenses/language/application.dart';
import 'package:dailyexpenses/ui/home/AddEditTransactionDialog.dart';
import 'package:dailyexpenses/ui/settings/settings_page.dart';
import 'package:dailyexpenses/utils/app_translate.dart';
import 'package:dailyexpenses/utils/common_utils.dart';
import 'package:dailyexpenses/utils/constants/app_constants.dart';
import 'package:dailyexpenses/utils/size_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../custom_widget/item_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ThemeData themeData;

  bool showLeftArrow = true;
  bool showRightArrow = true;

  String selectedDate = "";

  DateTime selectedDateTime;

//  List<TransactionModel> transactionList = List();
  List<DocumentSnapshot> transactionList = List();

  bool isListInAscending = true;

  double creditAmount = 0.0;
  double debitAmount = 0.0;

  String currentBalance = "";

  final databaseReference = FirebaseDatabase.instance.reference();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore firestoreInstance = Firestore.instance;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  bool showLoading = false;

  String currencySymbol = '';

  @override
  void initState() {
    super.initState();

    setCurrentMonth(DateTime.now());
    application.onCurrencyChange = onCurrencyChange;
  }

  void onCurrencyChange(String currency) {
    CurrencyManager().updatePrimaryCurrency(currency);

    setState(() {
      currencySymbol = currency;
    });
//    getTransactionFromFireStore(selectedDateTime);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return Scaffold(
      body: compareBody(),
    );
  }

  Widget compareBody() {
    return BackgroundWidget(
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: _refreshController,
        onRefresh: _onRefresh,
        header: MaterialClassicHeader(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            titleAndSettings(),
            totalWidget(),
            dateSelection(),
            Divider(height: 1, color: Colors.black26),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: SizeUtils.get(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          totalDebitCreditWidget(
                              CommonUtils.getText(context, AppTranslate.DEBIT),
                              debitAmount),
                          totalDebitCreditWidget(
                              CommonUtils.getText(context, AppTranslate.CREDIT),
                              creditAmount),
                        ],
                      ),
                    ),
                    transactionAndShort(),
                    showLoading
                        ? Container(
                            margin: EdgeInsets.only(top: SizeUtils.get(50)),
                            child: CupertinoActivityIndicator(
                              animating: true,
                              radius: 15,
                            ),
                          )
                        : transactionList.length == 0
                            ? Container(
                                margin: EdgeInsets.only(top: SizeUtils.get(50)),
                                child: Center(
                                    child: Text(
                                  CommonUtils.getText(
                                      context, AppTranslate.NO_DATA_FOUND),
                                  style: themeData.textTheme.caption,
                                )),
                              )
                            : transactionListWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container titleAndSettings() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: SizeUtils.get(30), vertical: SizeUtils.get(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
//          Text(
//            CommonUtils.getText(context, AppTranslate.DAILY_EXPENSES),
//            style: themeData.textTheme.display1.copyWith(color: Colors.black12),
//          ),
          Expanded(
            child: AutoSizeText(
              CommonUtils.getText(context, AppTranslate.DAILY_EXPENSES),
              style:
                  themeData.textTheme.display1.copyWith(color: Colors.black12),
//            style: TextStyle(
//              color: themeData.accentColor,
//              fontWeight: FontWeight.w600,
//              fontSize: SizeUtils.getFontSize(38),
//            ),
              maxLines: 1,
            ),
          ),
          GestureDetector(
            onTap: () {
              navigateToSettings();
            },
            child: Padding(
              padding: EdgeInsets.all(SizeUtils.get(5)),
              child: Icon(
                Icons.settings,
                color: Colors.black12,
                size: SizeUtils.get(30),
              ),
            ),
          )
        ],
      ),
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
            color: Colors.lightGreen,
          ),
        ),
        Expanded(
          flex: 6,
          child: Container(color: Colors.white10),
        ),
      ],
    );
  }

  Widget totalWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeUtils.get(20)),
      child: Container(
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
//            color: Colors.white,
            color: themeData.backgroundColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 5, offset: Offset(0, 1))
//                  color: Colors.grey[400], blurRadius: 5, offset: Offset(0, 1))
            ]),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeUtils.get(15), vertical: SizeUtils.get(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: SizeUtils.get(10)),
              Text(
                CommonUtils.getText(context, AppTranslate.CURRENT_BALANCE),
                style: themeData.textTheme.display1
                    .copyWith(fontSize: SizeUtils.getFontSize(20)),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: SizeUtils.getWidthAsPerPercent(68),
                    child: AutoSizeText(
                      currentBalance == ""
                          ? currencySymbol + " 0.00"
                          : currencySymbol + " " + currentBalance,
                      style: TextStyle(
                        color: themeData.accentColor,
                        fontWeight: FontWeight.w600,
                        fontSize: SizeUtils.getFontSize(38),
                      ),
                      maxLines: 1,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      addTransaction();
                    },
                    child: Container(
                      width: SizeUtils.getWidthAsPerPercent(12),
                      height: SizeUtils.getWidthAsPerPercent(12),
                      //65,
                      decoration: BoxDecoration(
//                          color: AppConstants.TITLE_COLOR,
                          color: themeData.accentColor,
                          //Colors.indigo[400],
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
//                              color: Colors.grey,
                              color: Colors.black12,
                              blurRadius: 3,
                              offset: Offset(1, 1),
                            )
                          ]),
                      child: Icon(
                        Icons.add,
                        size: SizeUtils.getWidthAsPerPercent(7),
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: SizeUtils.getHeightAsPerPercent(0.8),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget totalDebitCreditWidget(title, amount) {
    return Container(
      width: SizeUtils.getWidthAsPerPercent(40),
      decoration: BoxDecoration(
//          color: title == Strings.DEBIT ? Colors.red[400] : Colors.green[400],
          color: title == CommonUtils.getText(context, AppTranslate.DEBIT)
              ? Colors.redAccent.withOpacity(0.8)
              : Colors.green.withOpacity(0.8),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))
//                color: Colors.grey[400], blurRadius: 5, offset: Offset(0, 2))
          ]),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeUtils.get(5)),
        child: Column(
          children: <Widget>[
            SizedBox(height: SizeUtils.get(10)),
            Text(
              title,
              style: themeData.textTheme.display1.copyWith(
                  color: Colors.black26, fontSize: SizeUtils.getFontSize(16)),
            ),
            AutoSizeText(
//              showLoading ? "₹ 0.00" :
              currencySymbol + " " + amount.toStringAsFixed(2),
              style: TextStyle(
                color: themeData.textTheme.subhead.color,
//                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: SizeUtils.getFontSize(25),
              ),
              maxLines: 1,
            ),
            SizedBox(
              height: SizeUtils.getHeightAsPerPercent(0.8),
            )
          ],
        ),
      ),
    );
  }

  Widget dateSelection() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: SizeUtils.get(15), vertical: SizeUtils.get(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              dateClickLeft();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: SizeUtils.get(5)),
              child: Container(
                width: SizeUtils.get(25),
                height: SizeUtils.get(25),
                child: Visibility(
                  visible: showLeftArrow,
                  child:
                      Icon(Icons.arrow_back_ios, color: themeData.accentColor),
                ),
              ),
            ),
          ),
          Text(
            selectedDate,
            style: themeData.textTheme.subtitle.copyWith(
                fontSize: SizeUtils.get(17),
                fontWeight: FontWeight.w600,
                color: themeData.accentColor),
          ),
          GestureDetector(
            onTap: () {
              dateClickRight();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: SizeUtils.get(5)),
              child: Container(
                width: SizeUtils.get(25),
                height: SizeUtils.get(25),
                child: Visibility(
                  visible: showRightArrow,
                  child: Icon(Icons.arrow_forward_ios,
                      color: themeData.accentColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget transactionAndShort() {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SizeUtils.get(20), vertical: SizeUtils.get(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              CommonUtils.getText(context, AppTranslate.TRANSACTION),
              style: TextStyle(
                  color: themeData.textTheme.caption.color,
                  fontSize: SizeUtils.getWidthAsPerPercent(4)),
            ),
            GestureDetector(
              onTap: () {
                isListInAscending = !isListInAscending;
                getTransactionFromFireStore(selectedDateTime);
              },
              child: Padding(
                padding:
                    EdgeInsets.only(right: SizeUtils.getWidthAsPerPercent(2)),
                child: Icon(
                  Icons.sort,
                  size: SizeUtils.getWidthAsPerPercent(7),
                  color: themeData.textTheme.caption.color,
                ),
              ),
            )
          ],
        ));
  }

  Widget transactionListWidget() {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      itemCount: transactionList.length,
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ItemCard(
          currencySymbol: currencySymbol,
          transactionModel: transactionList[index],
          onTap: () {
            selectOption(transactionList[index]);
          },
        );
      },
    );
  }

  void _onRefresh() async {
//    pageIndex = 1;
    getTransactionFromFireStore(selectedDateTime);
//    _refreshController.refreshCompleted();
  }

  void dateClickRight() {
    setCurrentMonth(DateTime(selectedDateTime.year, selectedDateTime.month + 1,
        selectedDateTime.day));
  }

  void dateClickLeft() {
    setCurrentMonth(DateTime(selectedDateTime.year, selectedDateTime.month - 1,
        selectedDateTime.day));
  }

  void setCurrentMonth(DateTime dateTime) {
    setState(() {
      currencySymbol = CurrencyManager().primaryCurrency ?? '';
    });
    String formattedDate = DateFormat("MMMM yyyy").format(dateTime);
    setState(() {
      selectedDateTime = dateTime;
      selectedDate = formattedDate;
    });

    if (CommonUtils.isLastMonth(selectedDateTime)) {
      setState(() {
        showRightArrow = false;
      });
    } else {
      setState(() {
        showRightArrow = true;
      });
    }

    getTransactionFromFireStore(selectedDateTime);
  }

  void addTransaction() {
    showDialog(
        context: context,
        builder: (context) {
          return AddEditTransactionDialog(
            updateList: () {
              getTransactionFromFireStore(selectedDateTime);
            },
          );
        });
  }

  Future<void> setTransactionList(DateTime dateTime) async {
//    databaseReference.once().then((DataSnapshot snapshot) {
//      print('Data : ${snapshot.value}');
//
////      itemCounts = snapshot['itemCount'].map<ItemCount>((item) {
////        return ItemCount.fromMap(item);
////      }).toList();
//    });

//    getTransactionFromFirestore(dateTime);
//
//    var endDate = new DateTime(dateTime.year, dateTime.month + 1, 0, 23, 59)
//        .millisecondsSinceEpoch
//        .toString();
//    var startDate = new DateTime(dateTime.year, dateTime.month, 1)
//        .millisecondsSinceEpoch
//        .toString();
//    print("startDate $startDate");
//    print("endDate $endDate");

//    var tempBalance = await TransactionManager.instance.fetchBalance();
//    setState(() {
//      currentBalance = tempBalance;
//    });

//    var tempList =
//        await TransactionManager.instance.fetchAll(startDate, endDate);
//    if (tempList != null) {
//      if (!isListInAscending) {
//        tempList = tempList.reversed.toList();
//      }
//      transactionList.clear();
//      transactionList.addAll(tempList);
//
//      double totalDebit = 0;
//      double totalCredit = 0;
//      for (int i = 0; i < tempList.length; i++) {
//        if (tempList[i].type == AppConstants.TYPE_DEBIT) {
//          if (tempList[i].value.contains(".")) {
//            totalDebit = totalDebit + double.parse(tempList[i].value);
//          } else {
//            totalDebit = totalDebit + int.parse(tempList[i].value);
//          }
//        } else {
//          if (tempList[i].value.contains(".")) {
//            totalCredit = totalCredit + double.parse(tempList[i].value);
//          } else {
//            totalCredit = totalCredit + int.parse(tempList[i].value);
//          }
//        }
//      }
//
//      creditAmount = totalCredit;
//      debitAmount = totalDebit;
//
//      setState(() {});
//    }
  }

  void selectOption(DocumentSnapshot transaction) {
    final act = CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(CommonUtils.getText(context, AppTranslate.UPDATE)),
            onPressed: () {
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (context) {
                    return AddEditTransactionDialog(
                      transactionModel: transaction,
                      updateList: () {
                        getTransactionFromFireStore(selectedDateTime);
                      },
                    );
                  });
            },
          ),
          CupertinoActionSheetAction(
            child: Text(CommonUtils.getText(context, AppTranslate.DELETE)),
            onPressed: () {
              Navigator.pop(context);
              Dialogs.showDialogWithTwoOptions(
                  context,
                  CommonUtils.getText(context, AppTranslate.DELETE_MESSAGE),
                  CommonUtils.getText(context, AppTranslate.YES),
                  positiveButtonCallBack: () async {
//                await TransactionManager.instance
//                    .removeTransaction(transaction.id);
                firestoreInstance
                    .collection("Transaction")
                    .document(transaction.documentID)
                    .delete()
                    .then((value) {
//          print("Transaction entry :: ${value.documentID}");
                  getTransactionFromFireStore(selectedDateTime);
                });
                Navigator.pop(context);
              });
            },
          )
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(CommonUtils.getText(context, AppTranslate.CANCEL)),
          onPressed: () {
            Navigator.pop(context);
          },
        ));

    showCupertinoModalPopup(
        context: context, builder: (BuildContext context) => act);
  }

  void navigateToSettings() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SettingsPage()));
  }

  Future<void> getTransactionFromFireStore(DateTime dateTime) async {
    NetworkCheck networkCheck = new NetworkCheck();
    final bool isConnect = await networkCheck.check();
    if (!isConnect) {
      _refreshController.refreshCompleted();
      Dialogs.showInfoDialog(
          context, CommonUtils.getText(context, AppTranslate.INTERNET_ERROR));
      return;
    }

//    setLoading(true);
    setLoading(_refreshController.isRefresh ? false : true);

    var endDate = new DateTime(dateTime.year, dateTime.month + 1, 0, 23, 59)
        .millisecondsSinceEpoch
        .toString();
    var startDate = new DateTime(dateTime.year, dateTime.month, 1)
        .millisecondsSinceEpoch
        .toString();
    print("startDate $startDate");
    print("endDate $endDate");

    FirebaseUser user = await _auth.currentUser();
    getBalance(user);
    await firestoreInstance
        .collection("Transaction")
        .where("uid", isEqualTo: user.uid)
        .where("date",
            isLessThanOrEqualTo: endDate, isGreaterThanOrEqualTo: startDate)
        .orderBy("date", descending: isListInAscending)
        .getDocuments()
        .then((querySnapshot) {
      transactionList.clear();
      transactionList.addAll(querySnapshot.documents);

      double totalDebit = 0;
      double totalCredit = 0;
      for (int i = 0; i < transactionList.length; i++) {
        if (transactionList[i].data["type"] == AppConstants.TYPE_DEBIT) {
          if (transactionList[i].data["value"].contains(".")) {
            totalDebit =
                totalDebit + double.parse(transactionList[i].data["value"]);
          } else {
            totalDebit =
                totalDebit + int.parse(transactionList[i].data["value"]);
          }
        } else {
          if (transactionList[i].data["value"].contains(".")) {
            totalCredit =
                totalCredit + double.parse(transactionList[i].data["value"]);
          } else {
            totalCredit =
                totalCredit + int.parse(transactionList[i].data["value"]);
          }
        }
      }

      creditAmount = totalCredit;
      debitAmount = totalDebit;

      setState(() {});

      querySnapshot.documents.forEach((result) {
        //        firestoreInstance
        //            .collection("Transaction")
        ////            .document(result.documentID)
        ////            .collection("pets")
        //            .getDocuments()
        //            .then((querySnapshot) {
        //          querySnapshot.documents.forEach((result) {
        print("result.data :: ${result.data}");
        //          });
        //        });
      });
    });

    setLoading(false);
    _refreshController.refreshCompleted();
  }

  void getBalance(FirebaseUser user) {
    firestoreInstance
        .collection("Transaction")
        .where("uid", isEqualTo: user.uid)
        .getDocuments()
        .then((querySnapshot) {
      if (querySnapshot.documents.isNotEmpty) {
        double balance = 0;
        for (int i = 0; i < querySnapshot.documents.length; i++) {
          if (querySnapshot.documents[i].data["type"] ==
              AppConstants.TYPE_DEBIT) {
            if (querySnapshot.documents[i].data["value"].contains(".")) {
              balance = balance -
                  double.parse(querySnapshot.documents[i].data["value"]);
            } else {
              balance =
                  balance - int.parse(querySnapshot.documents[i].data["value"]);
            }
          } else {
            if (querySnapshot.documents[i].data["value"].contains(".")) {
              balance = balance +
                  double.parse(querySnapshot.documents[i].data["value"]);
            } else {
              balance =
                  balance + int.parse(querySnapshot.documents[i].data["value"]);
            }
          }
        }

        setState(() {
          currentBalance = balance.toStringAsFixed(2);
        });
      } else {
        setState(() {
          currentBalance = "0.00";
        });
      }
    });
  }

  void setLoading(isShow) {
    setState(() {
      showLoading = isShow;
    });
  }
}
