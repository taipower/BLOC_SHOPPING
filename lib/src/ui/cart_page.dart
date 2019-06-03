import 'package:flutter/material.dart';
import '../models/product.dart';
import '../utils/utils.dart';
import '../widgets/product_grid.dart';
import '../ui/payment_page.dart';

class CartPage extends StatefulWidget{
  CartPage({
    @required this.cart,
    @required this.listStock
  });
  final List<Product> cart;
  final List<Product> listStock;

  @override
  State<StatefulWidget> createState(){
    return new _CartPageState(cart,listStock);
  }
}

class _CartPageState extends State<CartPage>{
  _CartPageState(this.cart,this.listStock);
  final List<Product> cart;
  final List<Product> listStock;
  double totalPrice;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalPrice = Utils.computeTotalPrice(cart);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Total Cart : " + totalPrice.toString() + " Bath"),
      ),
      body: ProductGrid(products: cart,
        page: "CartPage",
      ),
      floatingActionButton: new FloatingActionButton(
          onPressed: () => _openPaymentPage(context),
          tooltip: 'Confirm Cart',
          child: new Text("OK")
      ),
    );
  }

  _openPaymentPage(BuildContext context) async{
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (BuildContext context){
          return new PaymentPage(
            cart: cart,
            totalPrice: totalPrice,
            listStock: listStock,);
        }
     ));
  }
}