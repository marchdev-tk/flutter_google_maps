// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' as math show Point;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_directions_api/google_directions_api.dart'
    show GeoCoord, GeoCoordBounds;

extension MobileLatLngExtensions on LatLng {
  math.Point<double> toPoint() => math.Point(this.latitude, this.longitude);
  GeoCoord toGeoCoord() => GeoCoord(this.latitude, this.longitude);
}

extension MobilePointExtensions on math.Point<double> {
  LatLng toLatLng() => LatLng(this.x, this.y);
}

extension MobileGeoCoordExtensions on GeoCoord {
  LatLng toLatLng() => LatLng(this.latitude, this.longitude);
}

extension MobileGeoCoordBoundsExtensions on GeoCoordBounds {
  LatLngBounds toLatLngBounds() => LatLngBounds(
        northeast: this.northeast.toLatLng(),
        southwest: this.southwest.toLatLng(),
      );
}

extension MobileLatLngBoundsExtensions on LatLngBounds {
  GeoCoordBounds toGeoCoordBounds() => GeoCoordBounds(
        northeast: this.northeast.toGeoCoord(),
        southwest: this.southwest.toGeoCoord(),
      );
}
