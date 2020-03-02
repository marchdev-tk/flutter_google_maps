// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:google_directions_api/google_directions_api.dart';

import 'map_operations.dart';

import 'google_map.state.dart'
    if (dart.library.html) '../web/google_map.state.dart'
    if (dart.library.io) '../mobile/google_map.state.dart';

/// This widget will try to occupy all available space
class GoogleMap extends StatefulWidget {
  const GoogleMap({
    Key key,
    this.lat = defaultLat,
    this.lng = defaultLng,
  }) : super(key: key);

  final double lat;
  final double lng;

  static const defaultLat = 34.0469058;
  static const defaultLng = -118.3503948;
  static const zoom = 12;

  static MapOperations of(GlobalKey<GoogleMapStateBase> key) =>
      key.currentState;

  /// Initializer of [GoogleMap].
  ///
  /// `Required` if `Directions API` will be needed.
  /// For other cases, could be ignored.
  static void init(String apiKey) => DirectionsService.init(apiKey);

  @override
  GoogleMapState createState() => GoogleMapState();
}

abstract class GoogleMapStateBase extends State<GoogleMap>
    implements MapOperations {}
