import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc{
  final _repository = Repository();
  final _showProgress = BehaviorSubject<bool>();

  Stream<DocumentSnapshot> product(String documentId){
    return _repository.product(documentId);
  }

  Future<QuerySnapshot> productList(){
    return _repository.productList();
  }

  Future<void> saveProduct(String name, int number, double price, String imgFile){
    return _repository.saveProduct(name, number, price, imgFile);
  }

  Future<void> updateProduct(String id, String name, int number, double price, String imgFile){
    return _repository.updateProduct(id, name, number, price, imgFile);
  }

  //dispose all open sink
  void dispose() async {
    await _showProgress.drain();
    _showProgress.close();
  }

}