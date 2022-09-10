import 'package:dailyexpenses/data/local/database_constants.dart';

class TransactionModel {
  int id;
  String uid;
  String date;
  String createAt;
  String value;
  String type;
  String description;

  TransactionModel();

  TransactionModel.fromJson(Map map) {
    id = map[DatabaseColumn.COLUMN_MOBILE_ID];
    uid = map[DatabaseColumn.COLUMN_USER_ID];
    date = map[DatabaseColumn.COLUMN_TRANSACTION_DATE];
    createAt = map[DatabaseColumn.COLUMN_TRANSACTION_CREATE_AT];
    value = map[DatabaseColumn.COLUMN_TRANSACTION_VALUE];
    type = map[DatabaseColumn.COLUMN_TRANSACTION_TYPE];
    description = map[DatabaseColumn.COLUMN_TRANSACTION_DESCRIPTION];
  }

  Map toJson() {
    Map<String, dynamic> map = {
      DatabaseColumn.COLUMN_MOBILE_ID: id,
      DatabaseColumn.COLUMN_USER_ID: uid,
      DatabaseColumn.COLUMN_TRANSACTION_DATE: date,
      DatabaseColumn.COLUMN_TRANSACTION_CREATE_AT: createAt,
      DatabaseColumn.COLUMN_TRANSACTION_VALUE: value,
      DatabaseColumn.COLUMN_TRANSACTION_TYPE: type,
      DatabaseColumn.COLUMN_TRANSACTION_DESCRIPTION: description,
    };

    return map;
  }

  String toString() {
    return "TransactionModel(id: $id, value: $value, date: $date, type: $type, description: $description, )";
  }
}
