// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' show Point;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';

void main() {
  GoogleMap.init('API_KEY');
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Map Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<GoogleMapStateBase> _key = GlobalKey<GoogleMapStateBase>();
  bool _polygonAdded = false;

  List<Widget> _buildClearButtons() => [
        RaisedButton.icon(
          color: Colors.red,
          textColor: Colors.white,
          icon: Icon(Icons.bubble_chart),
          label: Text('CLEAR POLYGONS'),
          onPressed: () {
            GoogleMap.of(_key).clearPolygons();
            setState(() => _polygonAdded = false);
          },
        ),
        const SizedBox(width: 16),
        RaisedButton.icon(
          color: Colors.red,
          textColor: Colors.white,
          icon: Icon(Icons.pin_drop),
          label: Text('CLEAR MARKERS'),
          onPressed: () {
            GoogleMap.of(_key).clearMarkers();
          },
        ),
        const SizedBox(width: 16),
        RaisedButton.icon(
          color: Colors.red,
          textColor: Colors.white,
          icon: Icon(Icons.directions),
          label: Text('CLEAR DIRECTIONS'),
          onPressed: () {
            GoogleMap.of(_key).clearDirections();
          },
        ),
      ];

  List<Widget> _buildAddButtons() => [
        FloatingActionButton(
          child: Icon(_polygonAdded ? Icons.edit : Icons.bubble_chart),
          backgroundColor: _polygonAdded ? Colors.orange : null,
          onPressed: () {
            if (!_polygonAdded) {
              GoogleMap.of(_key).addPolygon(
                '1',
                polygon,
              );
            } else {
              GoogleMap.of(_key).editPolygon(
                '1',
                polygon,
                fillColor: Colors.purple,
                strokeColor: Colors.purple,
              );
            }

            setState(() => _polygonAdded = true);
          },
        ),
        const SizedBox(width: 16),
        FloatingActionButton(
          child: Icon(Icons.pin_drop),
          onPressed: () {
            GoogleMap.of(_key).addMarker(
              Point(33.875513, -117.550257),
              info: 'test info',
            );
            GoogleMap.of(_key).addMarker(
              Point(33.775513, -117.450257),
              icon: 'assets/images/map-marker-warehouse.png',
              info: contentString,
            );
          },
        ),
        const SizedBox(width: 16),
        FloatingActionButton(
          child: Icon(Icons.directions),
          onPressed: () {
            GoogleMap.of(_key).addDirection(
              'salinas municipal airport sns',
              '1353 Dayton Street, Unit B, salinas',
              startLabel: '1',
              startInfo: 'salinas municipal airport sns',
              endIcon: 'assets/images/map-marker-warehouse.png',
              endInfo: '1353 Dayton Street, Unit B, salinas',
            );
          },
        ),
      ];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Google Map'),
        ),
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: GoogleMap(
                key: _key,
                initialZoom: 12,
                initialPosition:
                    GeoCoord(34.0469058, -118.3503948), // Los Angeles, CA
                mapType: MapType.terrain,
                mobilePreferences: const MobileMapPreferences(
                  trafficEnabled: true,
                ),
                webPreferences: WebMapPreferences(
                  fullscreenControl: true,
                ),
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: FloatingActionButton(
                child: Icon(Icons.person_pin_circle),
                onPressed: () {
                  GoogleMap.of(_key).moveCamera(GeoCoordBounds(
                    northeast: GeoCoord(34.021307, -117.432317),
                    southwest: GeoCoord(33.835745, -117.712785),
                  ));
                },
              ),
            ),
            Positioned(
              left: 16,
              right: kIsWeb ? 60 : 16,
              bottom: 16,
              child: Row(
                children: <Widget>[
                  LayoutBuilder(
                    builder: (context, constraints) =>
                        constraints.maxWidth < 1000
                            ? Row(children: _buildClearButtons())
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _buildClearButtons(),
                              ),
                  ),
                  Spacer(),
                  ..._buildAddButtons(),
                ],
              ),
            ),
          ],
        ),
      );
}

const contentString = r'''
<div id="content">
  <div id="siteNotice"></div>
  <h1 id="firstHeading" class="firstHeading">Uluru</h1>
  <div id="bodyContent">
    <p>
      <b>Uluru</b>, also referred to as <b>Ayers Rock</b>, is a large 
      sandstone rock formation in the southern part of the 
      Northern Territory, central Australia. It lies 335&#160;km (208&#160;mi) 
      south west of the nearest large town, Alice Springs; 450&#160;km 
      (280&#160;mi) by road. Kata Tjuta and Uluru are the two major 
      features of the Uluru - Kata Tjuta National Park. Uluru is 
      sacred to the Pitjantjatjara and Yankunytjatjara, the 
      Aboriginal people of the area. It has many springs, waterholes, 
      rock caves and ancient paintings. Uluru is listed as a World 
      Heritage Site.
    </p>
    <p>
      Attribution: Uluru, 
      <a href="http://en.wikipedia.org/w/index.php?title=Uluru&oldid=297882194">
        http://en.wikipedia.org/w/index.php?title=Uluru
      </a>
      (last visited June 22, 2009).
    </p>
  </div>
</div>
''';

const polygon = <Point<double>>[
  Point<double>(32.707868, -117.191018),
  Point<double>(32.705645, -117.191096),
  Point<double>(32.697756, -117.166664),
  Point<double>(32.686486, -117.163206),
  Point<double>(32.675876, -117.169452),
  Point<double>(32.674726, -117.165233),
  Point<double>(32.679833, -117.158487),
  Point<double>(32.677571, -117.153893),
  Point<double>(32.671987, -117.160079),
  Point<double>(32.667547, -117.160477),
  Point<double>(32.654748, -117.147579),
  Point<double>(32.651933, -117.150312),
  Point<double>(32.649676, -117.144334),
  Point<double>(32.631665, -117.138201),
  Point<double>(32.632033, -117.132249),
  Point<double>(32.630156, -117.137234),
  Point<double>(32.628072, -117.136479),
  Point<double>(32.630315, -117.131443),
  Point<double>(32.625930, -117.135312),
  Point<double>(32.623754, -117.131664),
  Point<double>(32.627465, -117.130883),
  Point<double>(32.622598, -117.128791),
  Point<double>(32.622622, -117.133183),
  Point<double>(32.618690, -117.133634),
  Point<double>(32.618980, -117.128403),
  Point<double>(32.609847, -117.132502),
  Point<double>(32.604198, -117.125333),
  Point<double>(32.588260, -117.122032),
  Point<double>(32.591164, -117.116851),
  Point<double>(32.587601, -117.105968),
  Point<double>(32.583792, -117.104434),
  Point<double>(32.570566, -117.101382),
  Point<double>(32.569256, -117.122378),
  Point<double>(32.560825, -117.122903),
  Point<double>(32.557753, -117.131040),
  Point<double>(32.542737, -117.124883),
  Point<double>(32.534156, -117.126062),
  Point<double>(32.563255, -117.134963),
  Point<double>(32.584055, -117.134263),
  Point<double>(32.619405, -117.140001),
  Point<double>(32.655293, -117.157349),
  Point<double>(32.669944, -117.169624),
  Point<double>(32.682710, -117.189445),
  Point<double>(32.685297, -117.208773),
  Point<double>(32.679814, -117.224882),
  Point<double>(32.697212, -117.227058),
  Point<double>(32.707701, -117.219816),
  Point<double>(32.711931, -117.214107),
  Point<double>(32.715026, -117.196521),
  Point<double>(32.713053, -117.189703),
  Point<double>(32.707868, -117.191018),
];
