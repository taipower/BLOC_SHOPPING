import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProvider{
  Firestore _firestore = Firestore.instance;

  Future<QuerySnapshot> productList() {
    return _firestore.collection("products").getDocuments();
  }

  Future<QuerySnapshot> orderList(){
    return _firestore.collection("orders").getDocuments();
  }

  Future<QuerySnapshot> orderDetailList(String idOrder){
    return _firestore.collection("orderDetail").where('idOrder',isEqualTo:idOrder).getDocuments();
  }

  Stream<DocumentSnapshot> product(String documentId){
    return _firestore.collection("products").document(documentId).snapshots();
  }

  String getDocIDOrder(){
    return _firestore.collection("orders").document().documentID;
  }

  Future<void> saveProduct(String name, int number, double price, String imgFile) async{
    return _firestore.collection("products").document()
      .setData({'name':name,'number':number,'price':price,'imgFile':imgFile}, merge: true);
  }

  Future<void> updateProduct(String id, String name, int number, double price, String imgFile) async{
    return _firestore.collection("products").document(id)
      .updateData({'name':name,'number':number,'price':price,'imgFile':imgFile});
  }

  Future<void> saveOrder(String id, double totalPrice, int number, int timeStamp) async{
    return _firestore.collection("orders").document()
      .setData({'id':id,'totalPrice':totalPrice,'number':number,'timeStamp':timeStamp}, merge: true);
  }

  Future<void> saveOrderDetail(String idOrder, String idProduct, String name, int number, double price, String imgFile) async{
    return _firestore.collection("orderDetail").document()
      .setData({'idOrder':idOrder,'idProduct':idProduct,'name':name,'number':number,'price':price,'imgFile':imgFile},merge: true);
  }
}