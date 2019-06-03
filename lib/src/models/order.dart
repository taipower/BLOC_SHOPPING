class Order{
  String _id;
  double _totalPrice;
  int _number;
  int _timeStamp;

  Order(this._id, this._totalPrice, this._number, this._timeStamp);

  String get id => _id;
  double get totalPrice => _totalPrice;
  int get number => _number;
  int get timeStamp => _timeStamp;

  set id(String id){
    _id = id;
  }
  set number(int number){
    _number = number;
  }
  set totalPrice(double totalPrice){
    _totalPrice = totalPrice;
  }
  set timeStamp(int timeStamp){
    _timeStamp = timeStamp;
  }
  
}