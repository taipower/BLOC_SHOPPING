import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:numberpicker/numberpicker.dart';
import '../utils/utils.dart';
import 'package:bloc_shopping/src/widgets/product_poster.dart';
import '../ui/cart_page.dart';

class ProductListPage extends StatefulWidget{
  ProductListPage({
    @required this.listProduct,
    @required this.listStock
  });

  final List<Product> listProduct;
  final List<Product> listStock;

  @override
  _ProductListPageState createState() => _ProductListPageState(
    listProduct: listProduct,
    listStock: listStock);
}

class _ProductListPageState extends State<ProductListPage> {
  _ProductListPageState({
    @required this.listProduct,
    @required this.listStock
  });

  List<Product> listProduct;
  List<Product> listStock;
  int indexRef;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildList(),
    );
  }

   Widget buildList() {
    return Scaffold(
      body: _buildContent(context),
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: () {
                    _openCartDialog(context);
                  },
                  heroTag: 'cart',
                  tooltip: 'Cart',
                  child: const Icon(Icons.add_shopping_cart),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      _resetProduct();
                    },
                    heroTag: 'Reset Product List',
                    tooltip: 'Reset Product List',
                    child: const Icon(Icons.refresh),
                  ),
                ),
              ]
          ), 
          );
  }

  _showOrderPicker(BuildContext context, int index){
      showDialog<int>(
        context: context,
        builder: (context) =>
        new NumberPickerDialog.integer(
          minValue: 0,
          maxValue: 99,
          initialIntegerValue: 0,
          title: new Text("Enter your order"),
        ),
      ).then((int value){
        if(value != null){
          bool successful = false;
          successful = Utils.checkStock(value, listProduct[index].id, listStock);

          if(successful){
            setState(() {
              listStock[index].number -= value;
              listProduct[index].number += value;
              indexRef = index;
            });
          }else{
            Utils.showAlertDialog(context, "Alert Dialog",
                "Sorry our product less than your need!", "OK");
          }
        }
      });
  }

  Widget _buildContent(BuildContext context){
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    var crossAxisChildCount = isPortrait ? 2 : 4;

    return Container(
      color: Colors.blue,
      child: Scrollbar(
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisChildCount,
              childAspectRatio: 2 / 3,
              ),
              itemCount: listProduct.length,
              itemBuilder: (BuildContext context, int index){
                var product = listProduct[index];
                return DefaultTextStyle(
                  style: const TextStyle(color: Colors.white),
                  child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                  ProductPoster(product: product),
                  Container(
                    decoration: _buildGradientBackground(),
                    padding: const EdgeInsets.only(
                    bottom: 16.0,
                    left: 16.0,
                    right: 16.0,
                ),
                child: _buildTextualInfo(product),
                ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                onTap: () => _showOrderPicker(context, index),
                child: Container(),
              ),
          ),
        ],
      ),
    );
    },),
    ),
    );
  }

  BoxDecoration _buildGradientBackground(){
    return const BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: <double>[0.0,0.7,0.7],
          colors: <Color>[
            Colors.blue,
            Colors.transparent,
            Colors.transparent,
          ],
      ),
    );
  }

  Widget _buildTextualInfo(Product product){
    String number = product.number.toString();
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          product.name,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          product.price.toString() + " Bath",
          style: const TextStyle(
            fontSize: 12.0,
            color: Colors.white70,
          ),
        ),
        Text(
          "X $number",
          style: const TextStyle(
            fontSize: 12.0,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
  
  _openCartDialog(BuildContext context) async{
    List<Product> cart = new List();
    listProduct.forEach((entry){
      if(entry.number > 0){
        cart.add(entry);
      }
    });

    if(cart.length > 0){
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context){
            return new CartPage(cart: cart,
              listStock: listStock,);
          }
      ));
    }
  }

  _resetProduct(){
    setState(() {
        listProduct.forEach((product){
          listStock.forEach((stock){
            if(product.id == stock.id){
              stock.number += product.number;
            }
          });
        });

        listProduct.forEach((product){
          product.number = 0;
        });
    });
  }
}