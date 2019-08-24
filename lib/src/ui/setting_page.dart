import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../blocs/products_bloc.dart';
import '../widgets/product_grid.dart';
import '../ui/addProductPage.dart';

class SettingPage extends StatefulWidget{
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>{
  ProductBloc _bloc = new ProductBloc();

  @override
  void initState() {
    super.initState();
    _bloc.productList();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _bloc.productList().asStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
           if (snapshot.hasData) {
             return buildList(snapshot,context);
           } else if (snapshot.hasError) {
             return Text(snapshot.error.toString());
           }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  @override
  void didUpdateWidget(SettingPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {});
  }

  Widget buildList(AsyncSnapshot<QuerySnapshot> snapshot, BuildContext context) {
    List<Product> listProduct = new List();
    Product product;
    String id;
    snapshot.data.documents.forEach((doc){
      id = doc.documentID;
      product = new Product(id,doc.data["name"], doc.data["number"], doc.data["price"], doc.data["imgFile"], doc.data["latitude"], doc.data["longitude"]);
      listProduct.add(product);
    });
    return Scaffold(
            body: ProductGrid(
              products: listProduct,
              page: "SettingPage"
            ),
            floatingActionButton: new FloatingActionButton(
              onPressed: () => _onAddProduct(context),
              tooltip: 'Add Product',
              child: new Icon(Icons.add),
            ),
          );
  }

  _onAddProduct(BuildContext context){
    Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context){
            return new AddProductPage();
          }
    ));
  }
}