class Product{
  String _id;
  String _name;
  int _number;
  double _price;
  String _imgFile;

  Product(this._id,this._name,this._number,this._price,this._imgFile);

  String get id => _id;
  String get name => _name;
  int get number => _number;
  double get price => _price;
  String get imgFile => _imgFile;

  set id(String id){
    _id = id;
  }
  set name(String name){
    _name = name;
  }
  set number(int number){
    _number = number;
  }
  set price(double price){
    _price = price;
  }
  set imgFile(String imgFile){
    _imgFile = imgFile;
  }

}