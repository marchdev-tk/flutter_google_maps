// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ui' as ui show Color;

import 'package:google_directions_api/google_directions_api.dart' show GeoCoord, GeoCoordBounds;
import 'package:google_maps/google_maps.dart';

extension WebLatLngExtensions on LatLng {
  GeoCoord toGeoCoord() => GeoCoord(this.lat as double, this.lng as double);
}

extension WebGeoCoordExtensions on GeoCoord {
  LatLng toLatLng() => LatLng(this.latitude, this.longitude);
}

extension WebGeoCoordBoundsExtensions on GeoCoordBounds {
  LatLngBounds toLatLngBounds() => LatLngBounds(
        this.southwest.toLatLng(),
        this.northeast.toLatLng(),
      );

  GeoCoord get center => GeoCoord(
        (this.northeast.latitude + this.southwest.latitude) / 2,
        (this.northeast.longitude + this.southwest.longitude) / 2,
      );
}

extension WebLatLngBoundsExtensions on LatLngBounds {
  GeoCoordBounds toGeoCoordBounds() => GeoCoordBounds(
        northeast: this.northEast.toGeoCoord(),
        southwest: this.southWest.toGeoCoord(),
      );
}

extension WebColorExtensions on ui.Color {
  String toHashString() => '#${this.red.toRadixString(16)}${this.green.toRadixString(16)}${this.blue.toRadixString(16)}';
}
