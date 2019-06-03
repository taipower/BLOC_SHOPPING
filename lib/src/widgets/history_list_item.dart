import 'package:flutter/material.dart';
import '../models/order.dart';

class HistoryListItem extends StatelessWidget{
  HistoryListItem(this.orders);
  final Order orders;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Widget titleScreen = Container(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    orders.totalPrice.toString() + " Bath",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                    new DateTime.fromMillisecondsSinceEpoch(orders.timeStamp).year.toString() + "-"
                    +  new DateTime.fromMillisecondsSinceEpoch(orders.timeStamp).month.toString() + "-"
                    + new DateTime.fromMillisecondsSinceEpoch(orders.timeStamp).day.toString() + " "
                    + new DateTime.fromMillisecondsSinceEpoch(orders.timeStamp).hour.toString() + ":"
                    + new DateTime.fromMillisecondsSinceEpoch(orders.timeStamp).minute.toString() + ":"
                    + new DateTime.fromMillisecondsSinceEpoch(orders.timeStamp).second.toString(),
                    style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Text(
            orders.number.toString(),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0
            ),
          ),
        ],
      ),
    );

    return titleScreen;
  }
}