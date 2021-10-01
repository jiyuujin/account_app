import 'dart:convert' as convert;

import 'package:account_app/entity/account.dart';
import 'package:http/http.dart' as http;

Future<List<Account>> getHouseholdAccountDataList() async {
  final uri = Uri.parse(
      'https://script.google.com/macros/s/AKfycbwqSD3jNHnUvG30N0CKJyLEwqTtdRCs9ewuVTHDAOqf3dzea7_L/exec');

  final householdAccountData = <Account>[];

  final response = await http.get(uri);
  if (response.statusCode == 200) {
    final jsonResponse =
    convert.jsonDecode(response.body) as Map<String, dynamic>;
    final data = jsonResponse['data'];

    data.forEach((var item) {
      final id = int.parse(item['id']);
      final type = int.parse(item['type']);
      final String detail = item['detail'];
      final cost = int.parse(item['cost']);

      householdAccountData.add(Account(id, type, detail, cost));
    });
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  return householdAccountData;
}
