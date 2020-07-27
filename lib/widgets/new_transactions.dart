import 'package:flutter/material.dart';

class NewTransaction extends StatelessWidget {
  final titleConroller = TextEditingController();
  final amountController = TextEditingController();
  final Function newTransactionHandler;

  NewTransaction(this.newTransactionHandler);

  void _submitData() {
    final inputTitle = titleConroller.text;
    final inputAmount = double.parse(amountController.text);

    if (inputTitle.isEmpty || inputAmount <= 0) {
      return;
    }

    newTransactionHandler(
      inputTitle,
      inputAmount,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: "Title"),
              controller: titleConroller,
              onSubmitted: (_) => _submitData(),
            ),
            TextField(
              decoration: InputDecoration(labelText: "Amount"),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              controller: amountController,
              onSubmitted: (_) => _submitData(),
            ),
            FlatButton(
              onPressed: _submitData,
              child: Text(
                'Add Transaction',
                style: TextStyle(
                  color: Colors.purple,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
