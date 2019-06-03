import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class OrderBloc{
  final _repository = Repository();
  final _showProgress = BehaviorSubject<bool>();

  Future<QuerySnapshot> orderList(){
    return _repository.orderList();
  }

  String getDocIDOrder(){
    return _repository.getDocIDOrder();
  }

  Future<void> saveOrder(String id, double totalPrice, int number, int timeStamp){
    return _repository.saveOrder(id, totalPrice, number, timeStamp);
  }

  //dispose all open sink
  void dispose() async {
    await _showProgress.drain();
    _showProgress.close();
  }
}