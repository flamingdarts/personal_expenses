import 'package:flutter/material.dart';
import '../widgets/chart_bar.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTrxs;

  Chart(this.recentTrxs);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final previousWeekday = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;
      for (var trx in recentTrxs) {
        if (trx.date.day == previousWeekday.day &&
            trx.date.month == previousWeekday.month &&
            trx.date.year == previousWeekday.year) {
          totalSum += trx.amount;
        }
      }
      print(DateFormat.E().format(previousWeekday));
      print(totalSum);
      return {
        'day': DateFormat.E().format(previousWeekday).substring(0, 2),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(
        0.0, (sum, element) => sum + element['amount']);
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransactionValues);
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            return Flexible(
              //each child has similar space
              fit: FlexFit.tight,
              child: ChartBar(
                  label: data['day'],
                  spendingAmount: data['amount'],
                  pctOfTotal: totalSpending == 0.0
                      ? 0.0
                      : (data['amount'] as double) / totalSpending),
            );
          }).toList(),
        ),
      ),
    );
  }
}
