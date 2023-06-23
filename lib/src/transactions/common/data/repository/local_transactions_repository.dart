import 'dart:math';

import 'package:flutter_transactions_test/src/auth/data/auth_storage.dart';
import 'package:flutter_transactions_test/src/common/constants.dart';
import 'package:flutter_transactions_test/src/transactions/common/data/models/account_info.dart';
import 'package:flutter_transactions_test/src/transactions/common/data/models/detailed_transaction.dart';
import 'package:flutter_transactions_test/src/transactions/common/data/models/transaction.dart';
import 'package:flutter_transactions_test/src/transactions/common/data/models/transaction_page.dart';
import 'package:flutter_transactions_test/src/transactions/common/data/models/transaction_type.dart';
import 'package:flutter_transactions_test/src/transactions/common/data/repository/repository.dart';
import 'package:sqflite/sqflite.dart' hide Transaction;
import 'package:path/path.dart';

class SqfliteTransactionsRepository implements TransactionsRepository {
  final AuthStorage _authStorage;

  Database? _database;

  SqfliteTransactionsRepository({
    required AuthStorage authStorage,
  }) : _authStorage = authStorage;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'transactions.db'),
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE transactions(id INTEGER PRIMARY KEY, username TEXT, type TEXT, amount REAL, date TEXT, fee REAL)",
        );
      },
      version: 1,
    );
  }

  @override
  Future<AccountInfo> getAccountInfo() async {
    final username = await _authStorage.username;
    final db = await database;

    if (username == null || username.isEmpty) {
      throw Exception('Username is empty');
    }

    int totalTransactions = await _getTotalTransactionsCount(db!, username);

    final totalIncome = (await db.rawQuery(
        'SELECT SUM(amount) FROM transactions WHERE username = ? AND type = ?',
        [username, 'deposit']));

    final totalWithdrawal = (await db.rawQuery(
        'SELECT SUM(amount) FROM transactions WHERE username = ? AND type IN (?, ?)',
        [username, 'withdrawal', 'transfer']));

    return AccountInfo(
      totalTransactionCount: totalTransactions,
      totalIncome: totalIncome.first.values.first as double? ?? 0.0,
      totalWithdrawal: totalWithdrawal.first.values.first as double? ?? 0.0,
    );
  }

  @override
  Future<TransactionPage> getTransactions(int offset, int limit) async {
    await Future.delayed(mockRequestsDelay);

    final username = await _authStorage.username;
    final db = await database;

    var totalTransactionsCount = await _getTotalTransactionsCount(db!, username);
    if (totalTransactionsCount == 0) {
      if (username == null || username.isEmpty) {
        throw Exception('Username is empty');
      }

      await insertNRandomTransactions(100, username);
    }

    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: "username = ? AND id > ?",
      whereArgs: [username, offset],
      limit: limit,
    );

    totalTransactionsCount = await _getTotalTransactionsCount(db, username);
    final list = List.generate(maps.length, (i) {
      return Transaction(
        id: maps[i]['id'],
        type: TransactionType.values.firstWhere(
            (e) => e.toString() == 'TransactionType.${maps[i]['type']}'),
        amount: maps[i]['amount'],
      );
    });
    return TransactionPage(
      transactions: list,
      totalTransactionsCount: totalTransactionsCount,
    );
  }

  Future<int> _getTotalTransactionsCount(Database db, String? username) async {
    return Sqflite.firstIntValue(await db.rawQuery(
            'SELECT COUNT(*) FROM transactions WHERE username = ?',
            [username])) ??
        0;
  }

  @override
  Future<DetailedTransaction> getTransactionDetails(int id) async {
    await Future.delayed(mockRequestsDelay);

    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(
      'transactions',
      where: "id = ?",
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return DetailedTransaction(
        id: maps[0]['id'],
        type: TransactionType.values.firstWhere(
            (e) => e.toString() == 'TransactionType.${maps[0]['type']}'),
        amount: maps[0]['amount'],
        date: DateTime.parse(maps[0]['date']),
        fee: maps[0]['fee'],
      );
    }

    throw Exception('ID $id not found');
  }

  @override
  Future<AccountInfo> deleteTransaction(int id) async {
    await Future.delayed(mockRequestsDelay);
    
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(
      'transactions',
      where: "id = ?",
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      await db.delete(
        'transactions',
        where: "id = ?",
        whereArgs: [id],
      );

      return getAccountInfo();
    }

    throw Exception('ID $id not found');
  }

  Future<void> insertNRandomTransactions(int n, String username) async {
    final db = await database;

    final random = Random();
    const types = TransactionType.values;

    for (var i = 0; i < n; i++) {
      final type = types[random.nextInt(types.length)];
      final amount = random.nextDouble() * 10000;
      final date = DateTime.now().subtract(Duration(days: n - i)).toString();
      final fee = amount * 0.01;

      await db!.insert(
        'transactions',
        {
          'username': username,
          'type': type.toString().split('.').last,
          'amount': amount,
          'date': date,
          'fee': fee,
        },
      );
    }
  }
}
