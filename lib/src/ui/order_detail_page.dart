import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../blocs/orderDetail_bloc.dart';
import '../models/product.dart';
import '../widgets/product_grid.dart';

class OrderDetailPage extends StatefulWidget{
  OrderDetailPage({
    @required this.idOrder
  });
  final String idOrder;

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState(idOrder);
}

class _OrderDetailPageState extends State<OrderDetailPage>{
  _OrderDetailPageState(this.idOrder);
  final String idOrder;

  @override
  Widget build(BuildContext context) {
    OrderDetailBloc orderDetailBloc = new OrderDetailBloc();

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Detail'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: orderDetailBloc.orderDetailList(idOrder).asStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
           if (snapshot.hasData) {
             return buildList(snapshot,context);
           } else if (snapshot.hasError) {
             return Text(snapshot.error.toString());
           }
          return Center(child: CircularProgressIndicator());
        },
      )
    );
  }

  Widget buildList(AsyncSnapshot<QuerySnapshot> snapshot, BuildContext context) {
    List<Product> listProduct = new List();
    snapshot.data.documents.forEach((doc){
      Product product = new Product(doc.data["idProduct"], doc.data["name"], doc.data["number"], doc.data["price"], doc.data["imgFile"], doc.data["latitude"], doc.data["longitude"]);
      listProduct.add(product);
    });
    return Scaffold(
            body: ProductGrid(
              products: listProduct,
              page: "OrderDetailPage"
            ),
          );
  }
}