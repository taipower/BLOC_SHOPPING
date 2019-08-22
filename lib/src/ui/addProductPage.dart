import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../blocs/products_bloc.dart';
import '../ui/map_product_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../utils/utils.dart';

class AddProductPage extends StatefulWidget{
  @override
  _AddProductPageState createState() => _AddProductPageState(); 
}

class _AddProductPageState extends State<AddProductPage>{
  TextEditingController _textControllerName;
  TextEditingController _textControllerPrice;
  TextEditingController _textControllerNumber;
  Future<File> _imageFile;
  String _name;
  int _number = 0;
  double _price = 0.00;
  String _path;
  VoidCallback listener;
  ProgressDialog pr;
  LocationData currentLocation;
  LatLng _lastPosition;
  LocationData _lastMapPosition;

  void _onImageButtonPressed(ImageSource source) {
    setState(() {
      _imageFile = ImagePicker.pickImage(source: source);
    });
  }

  Future<LocationData> getCurrentLocation() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        // Permission denied
      }
      return null;
    }
  }

  _openMap(BuildContext context) async{
    Location location = Location();
    try {
      pr = new ProgressDialog(context, ProgressDialogType.Normal);
      pr.setMessage("Current Location!");
      pr.show();
      _lastMapPosition = await location.getLocation();
      pr.hide();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        // Permission denied
      }
      return null;
    }

    final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MapProductPage(
          latitude: _lastMapPosition.latitude,
          longitude: _lastMapPosition.longitude,
        ))
      );

    setState(() {
      _lastPosition = LatLng(result.latitude,result.longitude);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _textControllerName = new TextEditingController();
    _textControllerPrice = new TextEditingController();
    _textControllerNumber = new TextEditingController();
    _lastPosition = LatLng(0.00,0.00);

    listener = () {
      setState(() {});
    };
  }

  Widget _previewImage() {
    return FutureBuilder<File>(
        future: _imageFile,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            _path = snapshot.data.path;
            return Image.file(
              snapshot.data,
              height: 240.0,
              fit: BoxFit.cover,
            );
          } else if (snapshot.error != null) {
            return const Text(
              'Error picking image.',
              textAlign: TextAlign.center,
            );
          } else {
            return const Text(
              'You have not yet picked an image.',
              textAlign: TextAlign.center,
            );
          }
        });
  }

  Future<String> uploadFile(String filepath, String fileName) async {
    ImageProperties properties = await FlutterNativeImage.getImageProperties(filepath);
    File compressedFile = await FlutterNativeImage.compressImage(filepath, quality: 60,
        targetWidth: 300, targetHeight: 600);

    final StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    final StorageUploadTask task = ref.putFile(compressedFile);

    var dowurl = await (await task.onComplete).ref.getDownloadURL();
    String url = dowurl.toString();

    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: _createAppBar(context),
            body: Column(
              children: <Widget>[
                ListTile(
                  title: _previewImage(),
                ),
                ListTile(
                  leading: Icon(Icons.title, color: Colors.grey[500]),
                  title: TextField(
                    decoration: InputDecoration(
                      hintText: 'Product Name'
                    ),
                    controller: _textControllerName,
                    onChanged: (value){
                      _name = value;
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.attach_money, color: Colors.grey[500]),
                  title: TextField(
                    decoration: new InputDecoration(
                      hintText: 'Price',
                    ),
                    controller: _textControllerPrice,
                    keyboardType: TextInputType.number,
                    onChanged: (value){
                      _price = double.parse(value);
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.content_paste, color: Colors.grey[500]),
                  title: TextField(
                    decoration: new InputDecoration(
                      hintText: 'Number'
                    ),
                    controller: _textControllerNumber,
                    keyboardType: TextInputType.number,
                    onChanged: (value){
                      _number = int.parse(value);
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.map, color: Colors.grey[500]),
                  title: _productLocation(_lastPosition),
                )
              ],
            ),
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: () {
                    _onImageButtonPressed(ImageSource.gallery);
                  },
                  heroTag: 'image0',
                  tooltip: 'Pick Image from gallery',
                  child: const Icon(Icons.photo_library),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      _onImageButtonPressed(ImageSource.camera);
                    },
                    heroTag: 'image1',
                    tooltip: 'Take a Photo',
                    child: const Icon(Icons.camera_alt),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: FloatingActionButton(
                    onPressed: (){
                      _openMap(context);
                  },
                  heroTag: 'map',
                  tooltip: 'Take a Map',
                  child: const Icon(Icons.map),
                  ),
                ),
              ]
          ),
        );
  }

  Widget _createAppBar(BuildContext context){
    TextStyle actionStyle =
        Theme.of(context).textTheme.subhead.copyWith(color: Colors.white);
    Text title = const Text("New Product");
    List<Widget> actions = [];
    actions.add(new FlatButton(
        onPressed: (){
          ProductBloc bloc = new ProductBloc();
          DateTime dateTime = new DateTime.now();
          String fileName = "${dateTime.millisecondsSinceEpoch.toString()}.jpg";
          String url = ''; 
          uploadFile(_path,fileName).then((link){
            url = link;

            if(_validateData(_lastPosition , _name, _number, _price)){
              bloc.saveProduct(_name, _number, _price, url, _lastPosition.latitude, _lastPosition.longitude);
              Navigator.of(context).pop();
            }else{
              Utils.showAlertDialog(context, "Warning", "Please check product data.", "OK");
            }
          });
        },
        child: Text(
          'SAVE',
          style: actionStyle,
        ),
    ));

    return new AppBar(
      title: title,
      actions: actions,
    );
  }

  Widget _productLocation(LatLng lastPosition){
    if(lastPosition.latitude == 0.00 || lastPosition.longitude == 0.00){
      return Text("Product Location: Please specify the product location.");
    }else{
      return Text("Product Location: ${lastPosition.latitude},${lastPosition.longitude}");
    }
  }

  bool _validateData(LatLng location, String name, int number, double price){
    bool validate = true;

    if(location.latitude == 0.00 || location.longitude == 0.00 || name.isEmpty || number == 0 || price == 0.00){
      validate = false;
    }

    return validate;
  }
}