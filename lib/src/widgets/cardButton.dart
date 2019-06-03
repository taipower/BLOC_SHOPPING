import 'package:flutter/material.dart';

Container _cardButton({
  Function onClickAction,
}){
  return Container(
    width: 340,
    height: 90,
    child: InkWell(
      splashColor: Colors.blue.withAlpha(30) ,
      onTap: (){
        onClickAction();
      },
      child: Card(
        elevation: 5,
        child: null,
        ),
        ),
        );
}