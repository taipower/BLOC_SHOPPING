import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import '../blocs/products_bloc.dart';

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
  int _number;
  double _price;
  String _path;
  VoidCallback listener;

  void _onImageButtonPressed(ImageSource source) {
    setState(() {
      _imageFile = ImagePicker.pickImage(source: source);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textControllerName = new TextEditingController();
    _textControllerPrice = new TextEditingController();
    _textControllerNumber = new TextEditingController();

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

  Future<Null> uploadFile(String filepath, String fileName) async {
    final ByteData bytes = await rootBundle.load(filepath);
    final Directory tempDir = Directory.systemTemp;
    final File file = await File('${tempDir.path}/$fileName').create();
    await file.writeAsBytes(bytes.buffer.asInt8List(), mode: FileMode.write);

    ImageProperties properties = await FlutterNativeImage.getImageProperties(file.path);
    File compressedFile = await FlutterNativeImage.compressImage(file.path, quality: 60,
        targetWidth: 300, targetHeight: 600);

    final StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    final StorageUploadTask task = ref.putFile(compressedFile);
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
                new ListTile(
                  leading: new Icon(Icons.attach_money, color: Colors.grey[500]),
                  title: new TextField(
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
                new ListTile(
                  leading: new Icon(Icons.content_paste, color: Colors.grey[500]),
                  title: new TextField(
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
          uploadFile(_path,fileName);
          bloc.saveProduct(_name, _number, _price, fileName);
          Navigator.of(context).pop();
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
}