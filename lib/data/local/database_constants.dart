abstract class DatabaseConstant {
  // Database details
  static const DATABASE_NAME = "daily_expenses.db";
  static const DATABASE_VERSION = 1;
}

abstract class DatabaseQuery {
  // Database create query's
  static const CREATE_TABLE_TRANSACTION = '''
      CREATE TABLE ${DatabaseTable.TABLE_TRANSACTION}(
        ${DatabaseColumn.COLUMN_MOBILE_ID} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DatabaseColumn.COLUMN_USER_ID} TEXT,
        ${DatabaseColumn.COLUMN_TRANSACTION_DATE} TEXT,
        ${DatabaseColumn.COLUMN_TRANSACTION_VALUE} TEXT,
        ${DatabaseColumn.COLUMN_TRANSACTION_TYPE} TEXT,
        ${DatabaseColumn.COLUMN_TRANSACTION_DESCRIPTION} TEXT,
        ${DatabaseColumn.COLUMN_TRANSACTION_CREATE_AT} TEXT)
    ''';
}

abstract class DatabaseTable {
  // Database tables
  static const TABLE_TRANSACTION = "table_transaction";
}

abstract class DatabaseColumn {
  // Database common columns
  static const COLUMN_MOBILE_ID = "mobileId";
  static const COLUMN_USER_ID = "uid";

  static const String COLUMN_TRANSACTION_DATE = "date";
  static const String COLUMN_TRANSACTION_VALUE = "value";
  static const String COLUMN_TRANSACTION_TYPE = "type";
  static const String COLUMN_TRANSACTION_DESCRIPTION = "description";
  static const String COLUMN_TRANSACTION_CREATE_AT = "createAt";
}
