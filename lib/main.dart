import 'package:flutter/material.dart';
import 'package:flutter_maps/src/views/fullscreenmap.dart';

void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: FullScreenMap(),
    );
  }
}
