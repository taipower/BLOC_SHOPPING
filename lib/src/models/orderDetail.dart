class OrderDetail{
  String _id;
  String _idOrder;
  String _idProduct;
  String _name;
  int _number;
  double _price;
  String _imgFile;

  OrderDetail(this._id, this._idOrder, this._idProduct, this._name, this._number, this._price, this._imgFile);

  String get id => _id;
  String get idOrder => _idOrder;
  String get idProduct => _idProduct;
  String get name => _name;
  int get number => _number;
  double get price => _price;
  String get imgFile => _imgFile;

  set id(String id){
    _id = id;
  }
  set idOrder(String idOrder){
    _idOrder = idOrder;
  }
  set idProduct(String idProduct){
    _idProduct = idProduct;
  }
  set name(String name){
    _name=name;
  }
  set number(int number){
    _number=number;
  }
  set price(double price){
    _price=price;
  }
  set imgFile(String imgFile){
    _imgFile=imgFile;
  }
  
}