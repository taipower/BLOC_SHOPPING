import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:meta/meta.dart';
import 'package:bloc_shopping/src/widgets/product_poster.dart';

class ProductGridItem extends StatelessWidget{
  ProductGridItem({
    @required this.product,
    @required this.onTapped,
  });

  final Product product;
  final VoidCallback onTapped;

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

  Widget _buildTextualInfo(){
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
              "X " + product.number.toString(),
              style: const TextStyle(
              fontSize: 12.0,
              color: Colors.white70,
              ),
            ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
            child: _buildTextualInfo(),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTapped,
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }

}