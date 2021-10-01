import 'dart:convert' as convert;

import 'package:account_app/entity/account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

enum RadioValue { SPENDING, INCOME }

class InputFormState extends StateNotifier<RadioValue> {
  InputFormState() : super(RadioValue.INCOME);

  void changeState(value) {
    this.state = value;
  }
}

final inputFormProvider = StateNotifierProvider<InputFormState, RadioValue>(
  (refs) => InputFormState());

class InputForm extends HookWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => InputForm(),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Account _data = Account(0, 0, '', 0);

  BuildContext _context;

  RadioValue _groupValue;

  @override
  Widget build(BuildContext context) {
    _groupValue = useProvider(inputFormProvider);
    _context = context;
    return Scaffold(
      appBar: AppBar(
        title: const Text('家計簿登録'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: <Widget>[
              _createRadioListColumn(context, _groupValue),
              _createTextFieldColumn(),
              _createSaveIconButton(_formKey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createRadioListColumn(BuildContext context, RadioValue groupValue) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          _createRadioList(context, groupValue, RadioValue.INCOME),
          _createRadioList(context, groupValue, RadioValue.SPENDING),
        ],
      ),
    );
  }

  Widget _createRadioList(
      BuildContext context, RadioValue groupValue, RadioValue value) {
    final text = value == RadioValue.SPENDING ? '支出' : '収入';

    return RadioListTile(
      title: Text(text),
      value: value,
      groupValue: groupValue,
      onChanged: (value) => _onRadioSelected(value, context),
    );
  }

  Widget _createTextFieldColumn() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _createItemTextField(),
          _createMoneyTextField(),
        ],
      ),
    );
  }

  Widget _createItemTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.library_books),
        hintText: '項目',
        labelText: 'Item',
      ),
      onSaved: (String value) {
        _data.item = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return '項目は必須入力項目です';
        }
        return null;
      },
      initialValue: _data.item,
    );
  }

  Widget _createMoneyTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        icon: Icon(CupertinoIcons.money_dollar),
        hintText: '金額',
        labelText: 'Money',
      ),
      onSaved: (String value) {
        _data.money = int.parse(value);
      },
      validator: (value) {
        if (value.isEmpty) {
          return '金額は必須入力項目です';
        }
        return null;
      },
      initialValue: _data.item,
    );
  }

  Widget _createSaveIconButton(GlobalKey<FormState> formKey) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: ElevatedButton(
        onPressed: () {
          formKey.currentState.save();
          _data.type =
          _context.read(inputFormProvider.notifier).state == RadioValue.INCOME
              ? 1
              : 0;
          saveHouseholdAccountData(_data);
          Navigator.of(_context).pop<dynamic>();
        },
        child: const Text('登録'),
      ),
    );
  }

  Future<void> saveHouseholdAccountData(Account data) async {
    final uri = Uri.parse(
      'https://script.google.com/macros/s/AKfycbwqSD3jNHnUvG30N0CKJyLEwqTtdRCs9ewuVTHDAOqf3dzea7_L/exec');
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final now = DateTime.now();
    final cost = data.money;
    final type = data.type;
    final detail = data.item;
    const amount = 0;

    final request = convert.json.encode({
      'date': now.toString(),
      'cost': cost.toString(),
      'type': type.toString(),
      'detail': detail,
      'amount': amount.toString(),
    });

    final response = await http.post(uri, body: request, headers: headers);
    if (response.statusCode == 200) {
      print('success----------------------------------------');
    } else {
      print('error----------------------------------------');
    }
  }

  void _onRadioSelected(dynamic value, BuildContext context) {
    context.read(inputFormProvider.notifier).changeState(value);
  }
}
