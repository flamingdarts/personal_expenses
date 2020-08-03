import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required Function deleteHandler,
  })  : _deleteHandler = deleteHandler,
        super(key: key);

  final Transaction transaction;
  final Function _deleteHandler;

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color _bgColor;

  @override
  void initState() {
    const availableColors = [
      Colors.green,
      Colors.red,
      Colors.purple,
      Colors.yellow,
    ];

    _bgColor = availableColors[Random().nextInt(availableColors.length)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(child: Text('${widget.transaction.amount}€')),
          ),
          radius: 30,
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(widget.transaction.date),
        ),
        trailing: MediaQuery.of(context).size.width > 460
            ? FlatButton.icon(
                icon: const Icon(Icons.delete),
                label: const Text('delete'),
                textColor: Theme.of(context).errorColor,
                onPressed: () => widget._deleteHandler(widget.transaction.id),
              )
            : IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () => widget._deleteHandler(widget.transaction.id),
              ),
      ),
    );
  }
}
