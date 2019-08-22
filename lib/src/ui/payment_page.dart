import 'dart:async';

import 'package:bloc_shopping/src/blocs/orders_bloc.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../utils/utils.dart';
import '../blocs/products_bloc.dart';
import '../blocs/orderDetail_bloc.dart';
import '../ui/thanks_page.dart';

class PaymentPage extends StatefulWidget{
  PaymentPage({
    @required this.cart,
    @required this.totalPrice,
    @required this.listStock
  });
  final List<Product> cart;
  final List<Product> listStock;
  final double totalPrice;

  @override
  _PaymentPageState createState() => _PaymentPageState(cart,totalPrice,listStock);
}

class _PaymentPageState extends State<PaymentPage>{
  _PaymentPageState(this.cart,this.totalPrice,this.listStock);
  final List<Product> cart;
  final List<Product> listStock;
  TextEditingController _textControllerName;
  TextEditingController _textControllerNumer;
  TextEditingController _textControllerExpire;
  TextEditingController _textControllerCVV;
  double totalPrice;
  String _bankName;
  String _cardNumber;
  String _date;
  String _cvv;
  bool _successful = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textControllerName = new TextEditingController();
    _textControllerNumer = new TextEditingController();
    _textControllerExpire = new TextEditingController();
    _textControllerCVV = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
              appBar: _createAppBar(context),
              body: new Column(
                children: [
                  new Text("Total Price : " + totalPrice.toString()),
                  new ListTile(
                    leading: new Icon(Icons.account_balance, color: Colors.grey[500]),
                    title: new TextField(
                      decoration: new InputDecoration(
                          hintText: 'Cardholder Name'
                      ),
                      controller: _textControllerName,
                      onChanged: (value){
                        _bankName = value;
                      },
                    ),
                  ),
                  new ListTile(
                    leading: new Icon(Icons.credit_card, color: Colors.grey[500]),
                    title: new TextField(
                      decoration: new InputDecoration(
                          hintText: 'Card Number'
                      ),
                      controller: _textControllerNumer,
                      keyboardType: TextInputType.number,
                      maxLength: 16,
                      onChanged: (value){
                        _cardNumber = value;
                      },
                    ),
                  ),
                  new ListTile(
                    leading: new Icon(Icons.today, color: Colors.grey[500]),
                    title: new TextField(
                      decoration: new InputDecoration(
                          hintText: 'MM/YYYY'
                      ),
                      controller: _textControllerExpire,
                      keyboardType: TextInputType.datetime,
                      maxLength: 7,
                      onChanged: (value){
                        _date = value;
                      },
                    ),
                  ),
                  new ListTile(
                    leading: new Icon(Icons.dvr, color: Colors.grey[500]),
                    title: new TextField(
                      decoration: new InputDecoration(
                          hintText: 'CVV'
                      ),
                      controller: _textControllerCVV,
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                      onChanged: (value){
                        _cvv = value;
                      },
                    ),
                  )
                ],
              )
          );
  }

  Widget _createAppBar(BuildContext context){
    TextStyle actionStyle =
    Theme
        .of(context)
        .textTheme
        .subhead
        .copyWith(color: Colors.white);
    Text title = const Text("Payment");
    List<Widget> actions = [];
    actions.add(new FlatButton(
      onPressed: _paymentProcess,
      child: new Text(
        'Confirm',
        style: actionStyle,
      ),
    ));

    return new AppBar(
      title: title,
      actions: actions,
    );
  }

  _paymentProcess(){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => new Dialog(
        child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          new Container(
                padding: new EdgeInsets.all(8.0),
                color: Colors.blue[100],
                child: new Center(
                  child: new Column(
                    children: <Widget>[
                      new CircularProgressIndicator(),
                      new Text("Payment Processing..."),
                    ],
                  ),
                ),
            )
        ],
        ),
      ),
    );
    new Future.delayed(new Duration(seconds: 2), (){
      Navigator.of(context).pop();
      _successful = Utils.validateCreditCard(_textControllerName.text,
                      _textControllerNumer.text, _textControllerExpire.text,
                      _textControllerCVV.text);

      if(!_successful){
        Utils.showAlertDialog(context, "Alert Dialog",
              "Please chek your credit card!", "OK");
      }else{
        ProductBloc productBloc = new ProductBloc();
        OrderBloc orderBloc = new OrderBloc();
        OrderDetailBloc orderDetailBloc = new OrderDetailBloc();

        listStock.forEach((product){
          productBloc.updateProduct(product.id, product.name, product.number, product.price, product.imgFile);
        });

        int number=0;
        cart.forEach((product){
          number+=product.number;
        });

        String id = orderBloc.getDocIDOrder();
        orderBloc.saveOrder(id, totalPrice, number, new DateTime.now().millisecondsSinceEpoch);

        cart.forEach((product){
          orderDetailBloc.saveOrderDetail(id, product.id, product.name, product.number, product.price, product.imgFile);
        });

        Navigator.of(context).pushReplacement(new MaterialPageRoute(
                      builder: (BuildContext context) => new ThanksPage()));
      }
    });
  }
}