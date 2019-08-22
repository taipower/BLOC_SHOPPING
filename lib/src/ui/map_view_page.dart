import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/product.dart';

class MapViewPage extends StatefulWidget{
  MapViewPage({
    @required this.listProduct,
    this.lastPosition
  });

  final List<Product> listProduct;
  final LatLng lastPosition;

  @override
  _MapViewPageState createState() => _MapViewPageState(listProduct, lastPosition);
}

class _MapViewPageState extends State<MapViewPage>{
  _MapViewPageState(this._listProduct, this._lastPosition);

  GoogleMapController mapController;
  final Set<Marker> _markers = {};
  final List<Product> _listProduct;
  LatLng _lastMapPosition;
  LatLng _lastPosition;

  @override
  void initState() {
    super.initState();

    _listProduct.forEach((product){
      _lastMapPosition = LatLng(product.latitude, product.longitude);
      _markers.add(Marker(
      // This marker id can be anything that uniquely identifies each marker.
      markerId: MarkerId(_lastMapPosition.toString()),
      position: _lastMapPosition,
      infoWindow: InfoWindow(
        title: "${product.latitude},${product.longitude}",
      ),
      icon: BitmapDescriptor.defaultMarker,
      draggable: true,
      onTap: (){
        showModalBottomSheet(
          context: context,
      builder: (BuildContext bc){
          return Container(
            child: Wrap(
            children: <Widget>[
          ListTile(
            leading: Icon(Icons.title, color: Colors.grey[500]),
            title: Text(product.name),
            onTap: () => {}          
          ),
          ListTile(
            leading: Icon(Icons.attach_money, color: Colors.grey[500]),
            title: Text(product.price.toString()),
            onTap: () => {},          
          ),
            ],
          ),
          );
      }
        );
      }
    ));
    });
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
                  target: LatLng(_lastPosition.latitude, _lastPosition.longitude),
                  zoom: 10.0,
                ),
            compassEnabled: true,
            tiltGesturesEnabled: false,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: onMapCreated,
            markers: _markers,
          ),
        ]
      ),
    );
  }

  void onMapCreated(controller){
    setState(() {
      mapController = controller;
    });
  }
}