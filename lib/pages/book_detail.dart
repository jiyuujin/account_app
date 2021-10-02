import 'package:account_app/drawer_menu.dart';
import 'package:account_app/entity/account.dart';
import 'package:account_app/http/fetch.dart';
import 'package:account_app/pages/chart_container.dart';
import 'package:fl_chart/fl_chart.dart';
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
              child: Column(
                children: [
                  Expanded(
                    child: ChartContainer(
                        title: '収入支出',
                        color: const Color(0x00000000),
                        chart: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                value: generateData(
                                    snapshot.data!, Account.spendingFlg),
                                title: '支出',
                                color: const Color(0xffed733f),
                              ),
                              PieChartSectionData(
                                value: generateData(
                                    snapshot.data!, Account.incomeFlg),
                                title: '収入',
                                color: const Color(0xFF733FED),
                              ),
                            ],
                          ),
                        )),
                  ),
                ],
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

  double generateData(List<Account> householdAccountDataList, int type) {
    var income = 0.0;
    var outcome = 0.0;

    householdAccountDataList.forEach((Account householdAccountData) {
      if (householdAccountData.type == Account.incomeFlg) {
        income += householdAccountData.money;
      } else {
        outcome += householdAccountData.money;
      }
    });

    if (type == Account.spendingFlg) {
      return outcome;
    }
    return income;
  }
}
