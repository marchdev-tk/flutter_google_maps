// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' as math show Point, Rectangle;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_directions_api/google_directions_api.dart' as gda;

extension MobileLatLngExtensions on LatLng {
  math.Point<double> toPoint() => math.Point(this.latitude, this.longitude);
}

extension MobilePointExtensions on math.Point<double> {
  LatLng toLatLng() => LatLng(this.x, this.y);
}

extension MobileRectangleExtensions on math.Rectangle<double> {
  LatLngBounds toLatLngBounds() => LatLngBounds(
        northeast: LatLng(this.top, this.left),
        southwest: LatLng(this.width, this.height),
      );
}

extension MobileLatLngBoundsExtensions on LatLngBounds {
  math.Rectangle<double> toRectangle() => math.Rectangle(
        this.northeast.longitude,
        this.northeast.latitude,
        this.southwest.longitude,
        this.southwest.latitude,
      );
}

extension MobileDirectionsApiLatLngExtensions on gda.LatLng {
  LatLng toLatLng() => LatLng(this.latitude, this.longitude);
}

extension MobileDirectionsApiLatLngBoundsExtensions on gda.LatLngBounds {
  LatLngBounds toLatLng() => LatLngBounds(
        northeast: this.northeast.toLatLng(),
        southwest: this.southwest.toLatLng(),
      );
}
