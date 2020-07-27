import 'package:flutter/material.dart';
import 'new_transactions.dart';
import 'transaction_list.dart';
import '../models/transaction.dart';

class TransactionViewModel extends StatefulWidget {
  @override
  _TransactionViewModelState createState() => _TransactionViewModelState();
}

//Handles data changes and updates the view
class _TransactionViewModelState extends State<TransactionViewModel> {
  final List<Transaction> transactions = [
    Transaction(
      id: 't1',
      title: 'Neue Gaming Headset',
      amount: 199.90,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Neue Schuhe',
      amount: 30.99,
      date: DateTime.now(),
    ),
  ];

  void _addNewTransaction(String txTitle, double txAmount) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: txTitle,
        amount: txAmount,
        date: DateTime.now());
    setState(() {
      transactions.add(newTx);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        NewTransaction(_addNewTransaction), //pointer to function is passed
        TransactionList(transactions),
      ],
    );
  }
}
