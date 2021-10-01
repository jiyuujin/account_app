import 'package:account_app/pages/book_detail.dart';
import 'package:account_app/pages/book_list.dart';
import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Drawer build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const UserAccountsDrawerHeader(
            accountName: Text('お問い合わせは以下まで'),
            accountEmail: Text('jiyuujinunite@gmail.com'),
          ),
          ListTile(
            title: const Text('収入支出'),
            onTap: () {
              Navigator.of(context).push<dynamic>(
                BookDetail.route(),
              );
            },
          ),
          ListTile(
            title: const Text('家計簿一覧'),
            onTap: () {
              Navigator.of(context).push<dynamic>(
                BookList.route(),
              );
            },
          ),
        ],
      ),
    );
  }
}
