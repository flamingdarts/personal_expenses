import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './widgets/chart.dart';
import './widgets/new_transactions.dart';
import 'models/transaction.dart';
import 'widgets/transaction_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenses App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.red,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
            subtitle2: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            button: TextStyle(color: Colors.white)),
        appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                  ),
                )),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _transactions = [
    /* Transaction(
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
    ), */
  ];
  bool _showChart = false;
  List<Transaction> get recentTransactions {
    return _transactions
        .where((trx) =>
            trx.date.isAfter(DateTime.now().subtract(Duration(days: 7))))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime pickedDate) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: txTitle,
        amount: txAmount,
        date: pickedDate);
    setState(() {
      _transactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tx) => tx.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(_addNewTransaction);
        });
  }

  List<Widget> _buildLandscapeContent(double space, Widget txListWidget) {
    Widget finalWidget = _showChart
        ? Container(
            height: space * 0.7,
            child: Chart(recentTransactions),
          )
        : txListWidget;
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'show table',
            style: Theme.of(context).textTheme.headline6,
          ),
          Switch.adaptive(
              activeColor: Theme.of(context).accentColor,
              value: _showChart,
              onChanged: (switchState) {
                setState(() {
                  _showChart = switchState;
                });
              }),
          finalWidget
        ],
      )
    ];
  }

  List<Widget> _buildPotraitContent(double space, Widget txListWidget) {
    return [
      Container(
        height: space * 0.3,
        child: Chart(recentTransactions),
      ),
      txListWidget,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final _isLandscape = mediaQuery.orientation == Orientation.landscape;

    final PreferredSizeWidget _appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text('Expenses App'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                    child: Icon(CupertinoIcons.add),
                    onTap: () => _startAddNewTransaction(context)),
              ],
            ),
          )
        : AppBar(
            title: const Text('Expenses App'),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => _startAddNewTransaction(context)),
            ],
          );

    final _occupiedSpace = mediaQuery.size.height -
        _appBar.preferredSize.height -
        mediaQuery.padding.top;

    final transactionListWidget = Container(
      height: _occupiedSpace * 0.7,
      child: TransactionList(_transactions, _deleteTransaction),
    );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (_isLandscape)
              ..._buildLandscapeContent(_occupiedSpace, transactionListWidget),
            if (!_isLandscape)
              ..._buildPotraitContent(_occupiedSpace,
                  transactionListWidget), //using spread operator
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: _appBar,
          )
        : Scaffold(
            appBar: _appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context)),
          );
  }
}
