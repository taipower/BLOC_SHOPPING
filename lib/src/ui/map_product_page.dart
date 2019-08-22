import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapProductPage extends StatefulWidget{
  MapProductPage({
    @required this.latitude,
    @required this.longitude
  });
  final double latitude;
  final double longitude;

  @override
  _MapProductPageState createState() => _MapProductPageState(latitude,longitude);
}

class _MapProductPageState extends State<MapProductPage>{
  _MapProductPageState(this._latitude,this._longitude);

  double _latitude;
  double _longitude;
  GoogleMapController mapController;
  String searchAddr;
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition;

  @override
  void initState() {
    super.initState();

    _lastMapPosition = LatLng(_latitude,_longitude);
    _markers.add(Marker(
      // This marker id can be anything that uniquely identifies each marker.
      markerId: MarkerId(_lastMapPosition.toString()),
      position: _lastMapPosition,
      icon: BitmapDescriptor.defaultMarker,
      draggable: true,
      onTap: (){
        _selectLocation(context, _lastMapPosition);
      },
    ));
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Location"),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition: CameraPosition(
                  target: LatLng(_latitude, _longitude),
                  zoom: 10.0,
                ),
            compassEnabled: true,
            tiltGesturesEnabled: false,
            onTap: (latlang){
              if(_markers.length >= 1){
                _markers.clear();
              }

              _onAddMarker(latlang);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: onMapCreated,
            markers: _markers,
          ),
          Positioned(
            top: 30.0,
            right: 15.0,
            left: 15.0,
            child: Container(
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Enter Address',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15.0,top: 15.0),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: searchandNavigate,
                    iconSize: 30.0,)),
                onChanged: (val){
                  setState(() {
                    searchAddr = val;
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onAddMarker(LatLng latlang){
    _lastMapPosition = latlang;
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        icon: BitmapDescriptor.defaultMarker,
        draggable: true,
      onTap: (){
        _selectLocation(context, _lastMapPosition);
      },
      ));
    });
  }

  searchandNavigate(){
    Geolocator().placemarkFromAddress(searchAddr).then((result){
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(result[0].position.latitude, result[0].position.longitude),
        zoom: 10.0,
      )));
      _lastMapPosition = LatLng(result[0].position.latitude, result[0].position.longitude);  
      _markers.clear();
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        icon: BitmapDescriptor.defaultMarker,
        draggable: true,
      onTap: (){
        _selectLocation(context, _lastMapPosition);
      },
      ));
    });
  }

  void onMapCreated(controller){
    setState(() {
      mapController = controller;
    });
  }

  void _selectLocation(BuildContext context, LatLng location){
    Navigator.pop(context, location);
  }
}