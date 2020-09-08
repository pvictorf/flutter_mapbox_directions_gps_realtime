import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:location/location.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class FullScreenMap extends StatefulWidget {
  const FullScreenMap({Key key}) : super(key: key);

  @override
  _FullScreenMapState createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  MapboxMapController mapController;
  String _mapStyle = "mapbox://styles/mapbox/streets-v11";
  String _access_token = "YOUR_ACCESS_TOKEN";
  MinMaxZoomPreference _minMaxZoomPreference = MinMaxZoomPreference.unbounded;
  CameraTargetBounds _cameraTargetBounds = CameraTargetBounds.unbounded;
  bool _scrollGesturesEnabled = true;
  bool _tiltGesturesEnabled = true;
  bool _zoomGesturesEnabled = true;
  bool _myLocationEnabled = true;
  bool _rotateGesturesEnabled = true;
  bool _compassEnabled = true;
  bool _trackCameraPosition = true;
  LatLng _currentLocation = LatLng(-22.4891277, -43.4798553);
  LatLng _userPosition;
  String _userCoords;

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
      setState(() {
        _userPosition = LatLng(locationData.latitude, locationData.longitude);
        _userCoords = "${locationData.longitude},${locationData.latitude}";
      });
    }
  }

  void _moveCameraToUser(LatLng latLng) {
    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newLatLng(latLng));
    }
  }

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    mapController.setTelemetryEnabled(false);
    mapController.invalidateAmbientCache();
    mapController.clearLines();
  }

  void _add() async {
    String startCoords = _userCoords;
    String endCoords = "-43.119890,-22.896176";
    String geometries = "geojson";
    List<dynamic> coordinates = [];
    List<LatLng> _geometry = [];

    String url =
        "https://api.mapbox.com/directions/v5/mapbox/driving-traffic/$startCoords;$endCoords?alternatives=false&geometries=$geometries&steps=false&overview=full&access_token=$_access_token";

    var response = await http.get(url);
    print(url);
        
    if (response.statusCode == 200) {
      var json = convert.jsonDecode(response.body);

      coordinates = json["routes"][0]["geometry"]["coordinates"];

      coordinates
              .forEach((coords) => _geometry.add(LatLng(coords[1], coords[0])));
      
      await mapController.clearLines();
      await mapController.addLine(
        LineOptions(
            geometry: _geometry,
            lineColor: "#458de1",
            lineWidth: 9.4,
            lineJoin: "LINE_JOIN_ROUND",
            lineOpacity: 1.0,
            draggable: true),
      );

    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MapboxMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition:
              CameraPosition(target: _currentLocation, zoom: 14),
          myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
          myLocationRenderMode: MyLocationRenderMode.GPS,
          myLocationEnabled: _myLocationEnabled,
          zoomGesturesEnabled: _zoomGesturesEnabled,
          tiltGesturesEnabled: _tiltGesturesEnabled,
          scrollGesturesEnabled: _scrollGesturesEnabled,
          rotateGesturesEnabled: _rotateGesturesEnabled,
          minMaxZoomPreference: _minMaxZoomPreference,
          compassEnabled: _compassEnabled,
          cameraTargetBounds: _cameraTargetBounds,
          trackCameraPosition: _trackCameraPosition,
          styleString: _mapStyle,
        ),
        Container(
            alignment: Alignment.bottomRight,
            margin: EdgeInsets.only(bottom: 80, right: 10),
            child: FloatingActionButton(
              elevation: 2,
              backgroundColor: Color(0xff458de1),
              child: Icon(Icons.line_style),
              onPressed: () {
                _add();
              },
            )),
        Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.all(10),
            child: FloatingActionButton(
              elevation: 2,
              backgroundColor: Color(0xff458de1),
              child: Icon(Icons.gps_fixed),
              onPressed: () {
                _moveCameraToUser(_userPosition);
              },
            )),
      ],
    );
  }
}
