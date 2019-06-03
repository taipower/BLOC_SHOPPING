import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:meta/meta.dart';
import '../utils/widget_utils.dart';
import 'package:cache_image/cache_image.dart';

class ProductPoster extends StatelessWidget{
  ProductPoster({
    @required this.product,
    this.size,
  });

  final Product product;
  final Size size;

  BoxDecoration _buildDecorations(){
    return const  BoxDecoration(
      boxShadow: <BoxShadow>[
        const BoxShadow(
          offset: const Offset(1.0, 1.0),
          spreadRadius: 1.0,
          blurRadius: 2.0,
          color: Colors.black38,
        ),
      ],
      gradient: const LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: const <Color>[
            const Color(0xFF222222),
            const Color(0xFF424242),
          ],
      ),
    );
  }

  Widget _buildPosterImage(){
    if(product.imgFile == ''){
      return null;
    }

    return CacheImage.firebase(
      path: 'gs://shopping-ba750.appspot.com/' + product.imgFile,
        placeholder: new Container(
          padding: EdgeInsets.all(16.0),
          color: Colors.grey[100],
          child: new Center(
            child: new Icon(Icons.add_a_photo,
              color: Colors.white24,
              size: 72.0,),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var content = <Widget>[
      const Icon(
        Icons.add_a_photo,
        color: Colors.white24,
        size: 72.0,
      )
    ];

    addIfNonNull(_buildPosterImage(), content);

    return Container(
      decoration: _buildDecorations(),
      width: size?.width,
      height: size?.height,
      child: Stack(
        alignment: Alignment.center,
        children: content,
      ),
    );
  }
}