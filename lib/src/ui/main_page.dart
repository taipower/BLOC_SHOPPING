import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../ui/product_list_page.dart';
import '../ui/history_page.dart';
import '../models/product.dart';
import '../blocs/products_bloc.dart';

class MainPage extends StatefulWidget{
  const MainPage();

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin{
  TabController _controller;
  ProductBloc _bloc = new ProductBloc();

  @override
  void initState(){
    super.initState();
    _controller = TabController(length: 2, vsync: this);
    _bloc.productList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    _bloc.dispose();
  }

  @override
  void didUpdateWidget(MainPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {});
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Yes Order App'),
        bottom: TabBar(
          controller: _controller,
          isScrollable: true,
          tabs: const <Tab>[
            const Tab(text: 'Product'),
            const Tab(text: 'History'),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _bloc.productList().asStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
           if (snapshot.hasData) {
             return buildList(snapshot);
           } else if (snapshot.hasError) {
             return Text(snapshot.error.toString());
           }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildList(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<Product> listProduct = new List();
    List<Product> listStock = new List();
    Product product,productStock;
    String id;
    snapshot.data.documents.forEach((doc){
      id = doc.documentID;
      productStock = new Product(id, doc.data["name"], doc.data["number"], doc.data["price"], doc.data["imgFile"], doc.data["latitude"], doc.data["longitude"]);
      product = new Product(id,doc.data["name"], 0, doc.data["price"], doc.data["imgFile"], doc.data["latitude"], doc.data["longitude"]);
      listStock.add(productStock);
      listProduct.add(product);
    });
    return TabBarView(
        controller: _controller,
        children: <Widget>[
          new ProductListPage(
            listProduct: listProduct,
            listStock: listStock,
          ),
          new HistoryPage()
        ],
      );
  }
}