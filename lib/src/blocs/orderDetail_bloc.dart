import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class OrderDetailBloc{
  final _repository = Repository();
  final _showProgress = BehaviorSubject<bool>();

  Future<void> saveOrderDetail(String idOrder, String idProduct, String name, int number, double price, String imgFile){
    return _repository.saveOrderDetail(idOrder, idProduct, name, number, price, imgFile);
  }

  Future<QuerySnapshot> orderDetailList(String idOrder){
    return _repository.orderDetailList(idOrder);
  }

  //dispose all open sink
  void dispose() async {
    await _showProgress.drain();
    _showProgress.close();
  }
}