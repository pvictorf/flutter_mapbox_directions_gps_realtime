import 'package:flutter/material.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _getUserLocation() async {
    Location location = Location();
    PermissionStatus hasPermissions = await location.hasPermission();

    if (hasPermissions != PermissionStatus.granted) {
      await location.requestPermission();
    } else {
      var locationData = await location.getLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Center(
         child: Text('We need your location!')
       ),
    );
  }
}