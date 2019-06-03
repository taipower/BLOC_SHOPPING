import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:meta/meta.dart';
import 'package:numberpicker/numberpicker.dart';
import '../utils/utils.dart';
import '../widgets/product_grid_item.dart';

class ProductGrid extends StatelessWidget{
  static const Key emptyViewKey = const Key('emptyview');
  static const Key contentKey = const Key('content');

  ProductGrid({
    @required this.products,
    @required this.page,
    this.productStock
  });

  final List<Product> products;
  final String page;
  final List<Product> productStock;

  _showOrderPicker(BuildContext context, int index){
  if(page == "ProductPage"){
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

          successful = Utils.checkStock(value, products[index].id, productStock);

          if(successful){
            productStock[index].number -= value;
            products[index].number += value;
          }else{
            Utils.showAlertDialog(context, "Alert Dialog",
                "Sorry our product less than your need!", "OK");
          }
        }
      });
    }
  }

  Widget _buildContent(BuildContext context){
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    var crossAxisChildCount = isPortrait ? 2 : 4;

    return Container(
      key: contentKey,
      color: Colors.blue,
      child: Scrollbar(
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisChildCount,
              childAspectRatio: 2 / 3,
              ),
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index){
                var product = products[index];
                return ProductGridItem(
                  product: product,
                  onTapped: () => _showOrderPicker(context, index),
                );
              },
          ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _buildContent(context);
  }
}