class Product{
  String _id;
  String _name;
  int _number;
  double _price;
  String _imgFile;
  double _latitude;
  double _longitude;

  Product(this._id,this._name,this._number,this._price,this._imgFile,this._latitude,this._longitude);

  String get id => _id;
  String get name => _name;
  int get number => _number;
  double get price => _price;
  String get imgFile => _imgFile;
  double get latitude => _latitude;
  double get longitude => _longitude;

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
  set latitude(double latitude){
    _latitude = latitude;
  }
  set longitude(double longitude){
    _longitude = longitude;
  }

}