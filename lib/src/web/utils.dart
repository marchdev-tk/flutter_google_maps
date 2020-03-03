// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ui' as ui show Color;
import 'dart:math' as math show Point, Rectangle;

import 'package:google_maps/google_maps.dart';

extension WebLatLngExtensions on LatLng {
  math.Point<double> toPoint() => math.Point(this.lat, this.lng);
}

extension WebPointExtensions on math.Point<double> {
  LatLng toLatLng() => LatLng(this.x, this.y);
}

extension WebColorExtensions on ui.Color {
  String toHashString() =>
      '#${this.red.toRadixString(16)}${this.green.toRadixString(16)}${this.blue.toRadixString(16)}';
}

extension WebRectangleExtensions on math.Rectangle<double> {
  LatLngBounds toLatLngBounds() => LatLngBounds(
        LatLng(this.top, this.left),
        LatLng(this.width, this.height),
      );

  math.Point<double> get center => math.Point(
      this.top + (this.bottom - this.top / 2),
      this.left + (this.right - this.left / 2));
}

extension WebLatLngBoundsExtensions on LatLngBounds {
  math.Rectangle<double> toRectangle() => math.Rectangle(
        this.northEast.lng,
        this.northEast.lat,
        this.southWest.lng,
        this.southWest.lat,
      );
}
