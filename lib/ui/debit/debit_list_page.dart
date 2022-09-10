import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailyexpenses/custom_widget/TimeLineItem.dart';
import 'package:dailyexpenses/custom_widget/dialogs.dart';
import 'package:dailyexpenses/data/local/currency_manager.dart';
import 'package:dailyexpenses/data/network/network_check.dart';
import 'package:dailyexpenses/language/application.dart';
import 'package:dailyexpenses/utils/app_translate.dart';
import 'package:dailyexpenses/utils/common_utils.dart';
import 'package:dailyexpenses/utils/size_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DebitListPage extends StatefulWidget {
  @override
  _DebitListPageState createState() => _DebitListPageState();
}

class _DebitListPageState extends State<DebitListPage> {
  List<DocumentSnapshot> transactionList = List();

  ThemeData themeData;
  final Firestore firestoreInstance = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool showLoading = false;
  String currencySymbol = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      currencySymbol = CurrencyManager().primaryCurrency ?? '';
    });
    setList();
    application.onCurrencyChange = onCurrencyChange;
  }

  void onCurrencyChange(String currency) {
    setState(() {
      currencySymbol = currency;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    themeData = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.redAccent.withOpacity(0.8),
      body: showLoading
          ? Center(
              child: Container(
                child: CupertinoActivityIndicator(animating: true, radius: 15),
              ),
            )
          : SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.only(left: width * 0.05, top: width * 0.2),
                    child: Text(
                      CommonUtils.getText(context, AppTranslate.DEBIT),
                      style: TextStyle(
                          color: Colors.white, //Colors.grey[400],
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.08),
                    ),
                  ),
                  transactionList.length == 0
                      ? Container(
                          margin: EdgeInsets.only(top: SizeUtils.get(180)),
                          child: Center(
                              child: Text(
                            CommonUtils.getText(
                                context, AppTranslate.NO_DATA_FOUND),
                            style: themeData.textTheme.caption,
                          )),
                        )
                      : Padding(
                          padding: EdgeInsets.only(
                              left: width * 0.03, top: width * 0.08),
                          child: SizedBox(
                            width: width,
                            height: height * 0.74,
                            child: ListView.builder(
                              itemCount: transactionList.length,
                              itemBuilder: (context, index) {
                                List<DocumentSnapshot> movReverse =
                                    transactionList;
                                DocumentSnapshot transaction =
                                    movReverse[index];

                                if (movReverse[index] == movReverse.last) {
                                  return TimeLineItem(
                                    currencySymbol: currencySymbol,
                                    transaction: transaction,
                                    colorItem: Colors.red[900],
                                    isLast: true,
                                  );
                                } else {
                                  return TimeLineItem(
                                    currencySymbol: currencySymbol,
                                    transaction: transaction,
                                    colorItem: Colors.red[900],
                                    isLast: false,
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                ],
              ),
            ),
    );
  }

  void _onRefresh() async {
    setList();
  }

  setList() async {
    NetworkCheck networkCheck = new NetworkCheck();
    final bool isConnect = await networkCheck.check();
    if (!isConnect) {
      Dialogs.showInfoDialog(
          context, CommonUtils.getText(context, AppTranslate.INTERNET_ERROR));
      return;
    }

    setLoading(true);
    FirebaseUser user = await _auth.currentUser();

    await firestoreInstance
        .collection("Transaction")
        .where("type", isEqualTo: "2")
        .where("uid", isEqualTo: user.uid)
        .getDocuments()
        .then((querySnapshot) {
      transactionList.clear();
      transactionList.addAll(querySnapshot.documents);
      transactionList.sort((a, b) => b.data['date'].compareTo(a.data['date']));

      setState(() {});

      querySnapshot.documents.forEach((result) {
        print("result.data :: ${result.data}");
      });
    });

    setLoading(false);
  }

  void setLoading(isShow) {
    setState(() {
      showLoading = isShow;
    });
  }
}
