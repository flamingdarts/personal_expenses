import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/adaptive_flat_button.dart';

class NewTransaction extends StatefulWidget {
  final Function newTransactionHandler;

  NewTransaction(this.newTransactionHandler) {
    print('Constructor NewTransaction');
  }

  @override
  _NewTransactionState createState() {
    print('createState() _NewTransactionState');
    return _NewTransactionState();
  }
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleConroller = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  _NewTransactionState() {
    print('Constructor _NewTransactionState');
  }

  @override
  void initState() {
    super.initState();
    print('initState() _NewTransactionState');
  }

  @override
  void didUpdateWidget(NewTransaction oldWidget) {
    print('didUpdateWidget() _NewTransactionState');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    print('dispose() _NewTransactionState');
    super.dispose();
  }

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }

    final inputTitle = _titleConroller.text;
    final inputAmount = double.parse(_amountController.text);

    if (inputTitle.isEmpty || inputAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.newTransactionHandler(
      inputTitle,
      inputAmount,
      _selectedDate,
    );
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: "Title"),
                controller: _titleConroller,
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                decoration: InputDecoration(labelText: "Amount"),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: _amountController,
                onSubmitted: (_) => _submitData(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(_selectedDate == null
                          ? 'no date selected'
                          : 'Picked date: ${DateFormat.yMd().format(_selectedDate)}'),
                    ),
                    AdaptiveFlatButton(
                        title: 'Choose date', handler: _presentDatePicker),
                  ],
                ),
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
                onPressed: _submitData,
                child: Text('Add Transaction'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
