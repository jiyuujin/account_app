import 'package:account_app/drawer_menu.dart';
import 'package:account_app/entity/account.dart';
import 'package:account_app/entity/pie.dart';
import 'package:account_app/http/fetch.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class BookDetail extends StatelessWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => BookDetail(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final householdAccountDataList = getHouseholdAccountDataList();

    return FutureBuilder<List<Account>>(
      future: householdAccountDataList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('収入支出'),
            ),
            drawer: DrawerMenu(),
            body: Center(
              child: charts.PieChart(
                generateData(snapshot.data),
                animate: true,
                animationDuration: const Duration(seconds: 1),
                defaultRenderer: charts.ArcRendererConfig(
                  arcRendererDecorators: [
                    charts.ArcLabelDecorator(
                        labelPosition: charts.ArcLabelPosition.inside)
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Text('error');
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  List<charts.Series<Pie, String>> generateData(
      List<Account> householdAccountDataList) {
    final _pieData = <charts.Series<Pie, String>>[];
    var income = 0.0;
    var outcome = 0.0;

    householdAccountDataList
        .forEach((Account householdAccountData) {
      if (householdAccountData.type == Account.incomeFlg) {
        income += householdAccountData.money;
      } else {
        outcome += householdAccountData.money;
      }
    });
    final pieData = [
      Pie('支出 ', outcome),
      Pie('収入', income),
    ];
    _pieData.add(
      charts.Series(
        domainFn: (Pie data, _) => data.activity,
        measureFn: (Pie data, _) => data.money,
        id: 'Time spent',
        data: pieData,
        labelAccessorFn: (Pie data, _) => '${data.activity}:${data.money}円',
      ),
    );
    return _pieData;
  }
}
