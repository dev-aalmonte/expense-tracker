import 'package:expense_tracker/helpers/db_helper.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:flutter/material.dart';

class AccountProvider with ChangeNotifier {
  List<Account> _accounts = [];
  List<Account> get accounts {
    return [..._accounts];
  }

  Account? _activeAccount;
  Account? get activeAccount {
    return _activeAccount;
  }

  Future<void> fetchAccount() async {
    final dataList = await DBHelper.getData('accounts');
    _accounts = dataList
        .map(
          (item) => Account(
            id: item['id'],
            name: item['name'],
            accNumber: item['acc_number'],
            available: item['available'],
            spent: item['spent'],
          ),
        )
        .toList();
    notifyListeners();
  }

  Future<void> addAccount(Account account) async {
    var accountObject = {
      "name": account.name,
      "acc_number": account.accNumber,
      "available": account.available,
      "spent": account.spent
    };

    account.id = await DBHelper.insert('accounts', accountObject);
    _accounts.add(account);

    notifyListeners();
  }
}
