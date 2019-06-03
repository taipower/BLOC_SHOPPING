import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../blocs/orders_bloc.dart';
import '../models/order.dart';
import '../widgets/history_list_item.dart';
import '../ui/order_detail_page.dart';

class HistoryPage extends StatefulWidget{
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>{
  @override
  Widget build(BuildContext context){
    OrderBloc orderBloc = new OrderBloc();

    return Scaffold(
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       Text('History Page'),
      //     ],
      //   ),
      // ),
      body: StreamBuilder<QuerySnapshot>(
        stream: orderBloc.orderList().asStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
           if (snapshot.hasData) {
             return buildList(snapshot);
           } else if (snapshot.hasError) {
             return Text(snapshot.error.toString());
           }
          return Center(child: CircularProgressIndicator());
        },
      )
    );
  }

  Widget buildList(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<Order> listOrder = new List();
    Order order;
    snapshot.data.documents.forEach((doc){
      order = new Order(doc.data["id"], doc.data["totalPrice"], doc.data["number"], doc.data["timeStamp"]);
      listOrder.add(order);
    });
    return new Scaffold(
        body: new ListView.builder(
        shrinkWrap: true,
        itemCount: listOrder.length,
        itemBuilder: (buildContext, index){
          return new InkWell(
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context){
                    return new OrderDetailPage(
                      idOrder: listOrder[index].id,
                    );
                  }
              ));
            },
            child: new HistoryListItem(listOrder[index]),);
          })
    );
  }
}