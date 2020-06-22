// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_directions_api/google_directions_api.dart'
    show GeoCoord, GeoCoordBounds;

extension MobileLatLngExtensions on LatLng {
  GeoCoord toGeoCoord() => GeoCoord(this.latitude, this.longitude);
}

extension MobileGeoCoordExtensions on GeoCoord {
  LatLng toLatLng() => LatLng(this.latitude, this.longitude);
}

extension MobileGeoCoordBoundsExtensions on GeoCoordBounds {
  LatLngBounds toLatLngBounds() => LatLngBounds(
        northeast: this.northeast.toLatLng(),
        southwest: this.southwest.toLatLng(),
      );

  GeoCoord get center => GeoCoord(
        (this.northeast.latitude + this.southwest.latitude) / 2,
        (this.northeast.longitude + this.southwest.longitude) / 2,
      );
}

extension MobileLatLngBoundsExtensions on LatLngBounds {
  GeoCoordBounds toGeoCoordBounds() => GeoCoordBounds(
        northeast: this.northeast.toGeoCoord(),
        southwest: this.southwest.toGeoCoord(),
      );
}
