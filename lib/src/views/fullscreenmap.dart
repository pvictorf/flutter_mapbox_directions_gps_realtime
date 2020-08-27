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
  String _mapStyle = "mapbox://styles/mapbox/streets-v11";
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MapboxMap(
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
    );
  }
}
