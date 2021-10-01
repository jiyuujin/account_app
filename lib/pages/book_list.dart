import 'package:account_app/drawer_menu.dart';
import 'package:account_app/entity/account.dart';
import 'package:account_app/http/fetch.dart';
import 'package:account_app/pages/input.dart';
import 'package:flutter/material.dart';

class BookList extends StatelessWidget {
  final List<Tab> _tabs = <Tab>[
    const Tab(text: '総合'),
    const Tab(text: '収入'),
    const Tab(text: '支出'),
  ];

  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => BookList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final householdAccountDataList = getHouseholdAccountDataList();

    return FutureBuilder<List<Account>>(
      future: householdAccountDataList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DefaultTabController(
            length: _tabs.length,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('家計簿一覧'),
                bottom: TabBar(
                  tabs: _tabs,
                ),
              ),
              drawer: DrawerMenu(),
              body: TabBarView(
                children: _tabs.map(
                  (Tab tab) {
                    return SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          _createHouseholdAccountBookDetail(
                              tab.text, snapshot.data),
                        ],
                      ),
                    );
                  },
                ).toList(),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  _onPressAddButton(context);
                },
                child: const Icon(Icons.add),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Text('error');
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _createHouseholdAccountBookDetail(
      String tabText, List<Account> householdAccountDataList) {
    int tabType;

    switch (tabText) {
      case '総合':
        tabType = 3;
        return Column(
          children: _createWordCards(tabType, householdAccountDataList),
        );
        break;
      case '収入':
        tabType = Account.incomeFlg;
        return Column(
          children: _createWordCards(tabType, householdAccountDataList),
        );
        break;
      case '支出':
        tabType = Account.spendingFlg;
        return Column(
          children: _createWordCards(tabType, householdAccountDataList),
        );
        break;
      default:
        return const Text('エラー');
    }
  }

  List<Widget> _createWordCards(
      int tabType, List<Account> householdAccountDataList) {
    return householdAccountDataList.map(
      (Account householdAccountData) {
        if (householdAccountData.type == tabType || tabType == 3) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _createWordTile(householdAccountData, tabType),
            ),
          );
        }
        return Container();
      },
    ).toList();
  }

  Widget _createWordTile(Account householdAccountData, int tabType) {
    final icon = householdAccountData.type == Account.spendingFlg
        ? const Icon(
            Icons.subdirectory_arrow_left_outlined,
            color: Colors.pink,
          )
        : const Icon(
            Icons.add_box,
            color: Colors.blue,
          );
    return ListTile(
      leading: icon,
      title: Text(householdAccountData.item),
      subtitle: Text(
        '${householdAccountData.money}円',
      ),
    );
  }

  void _onPressAddButton(BuildContext context) {
    Navigator.of(context).push<dynamic>(
      InputForm.route(),
    );
  }
}
