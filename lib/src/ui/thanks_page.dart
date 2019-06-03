import 'package:flutter/material.dart';

class ThanksPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: Text("Yes Order"),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text("Yes Order Thank You."),
            SizedBox(height: 10.0),
            new RaisedButton(
              padding: const EdgeInsets.all(8.0),
              textColor: Colors.white,
              color: Colors.blue,
              onPressed: () => _processComplete(context),
              child: Text("OK"),
            ),
          ],
        ),
      ),
    );
  }

  _processComplete(BuildContext context){
    Navigator.of(context).pop();
  }
}