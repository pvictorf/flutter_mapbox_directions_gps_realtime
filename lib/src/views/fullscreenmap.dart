import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:location/location.dart';

class FullScreenMap extends StatefulWidget {
  const FullScreenMap({Key key}) : super(key: key);

  @override
  _FullScreenMapState createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {  
  MapboxMapController mapController;
  String _mapStyle = "mapbox://styles/impervictor/ckebyw5h91c5719rmxrv9erhl";
  bool _scrollGesturesEnabled = true;
  bool _tiltGesturesEnabled = true;
  bool _zoomGesturesEnabled = true;
  bool _myLocationEnabled = true;
  bool _rotateGesturesEnabled = true;
  LatLng _currentLocation = LatLng(-22.4891277, -43.4798553);
  LatLng _userPosition;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _getUserLocation() async {
    Location location = Location();
    PermissionStatus hasPermissions = await location.hasPermission();

    if (hasPermissions != PermissionStatus.granted) {
      hasPermissions = await location.requestPermission();
    } 

    if (hasPermissions != PermissionStatus.denied) {
      var locationData = await location.getLocation();
      _userPosition = LatLng(locationData.latitude, locationData.longitude);
      _moveCameraToUser(_userPosition);
    }
    
  }

  void _moveCameraToUser(LatLng latLng) {
    print(latLng);
    if(mapController != null) {
      mapController.animateCamera(CameraUpdate.newLatLng(latLng));
    }
  }

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    mapController.setTelemetryEnabled(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapboxMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: _currentLocation, zoom: 15),
        myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
        myLocationRenderMode: MyLocationRenderMode.GPS,
        myLocationEnabled: _myLocationEnabled,
        zoomGesturesEnabled: _zoomGesturesEnabled,
        tiltGesturesEnabled: _tiltGesturesEnabled,
        scrollGesturesEnabled: _scrollGesturesEnabled,
        rotateGesturesEnabled: _rotateGesturesEnabled,
        styleString: _mapStyle,
        
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { _moveCameraToUser(_userPosition); },
        child: Icon(Icons.gps_fixed),
      ),
    );
  }
}
