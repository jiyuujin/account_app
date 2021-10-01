class Account {
  Account(this._id, this._type, this._item, this._money);
  static const _spendingFlg = 0;
  static const _incomeFlg = 1;
  int _id;
  int _type;
  String _item;
  int _money;

  static int get incomeFlg => _incomeFlg;
  static int get spendingFlg => _spendingFlg;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  int get type => _type;

  set type(int value) {
    _type = value;
  }

  String get item => _item;

  set item(String value) {
    _item = value;
  }

  int get money => _money;

  set money(int value) {
    _money = value;
  }

}