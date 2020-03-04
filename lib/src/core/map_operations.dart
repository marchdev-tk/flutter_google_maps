// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ui' show Color;

import 'package:google_directions_api/google_directions_api.dart'
    show GeoCoord, GeoCoordBounds;

abstract class MapOperations
    implements MapMarkers, MapDirections, MapPolygones {
  /// Moves camera to the new bounds.
  void moveCamera(
    GeoCoordBounds newBounds, {
    double padding = 0,
    bool animated = true,
  });
}

abstract class MapMarkers {
  /// Adds a marker to map by given [position].
  ///
  /// [label] can be set only for `web`.
  ///
  /// If [icon] is set, must be a path to an image from project root
  /// as follows: `assets/images/image.png`.
  ///
  /// If [info] is set and click event will be fired, will be shown popup with [info] within.
  ///  * For `web` [info] could be a [String] or `HTML String`
  ///  * For `mobile` [info] could be only a [String]
  ///
  /// If marker with same [position] have been already added, addition of a new marker will be ignored.
  void addMarker(
    GeoCoord position, {
    String label,
    String icon,
    String info,
  });

  /// Removes a marker from map by given [position].
  void removeMarker(GeoCoord position);

  /// Removes all markers from map.
  void clearMarkers();
}

abstract class MapDirections {
  /// Adds a direction to map by given [origin] and [destination] coordinates.
  ///
  /// [origin] and [destination] are `dynamic` due to following variations:
  ///  * [LatLng], better use [Point], it will be converted into [LatLng]
  ///  * [Place]
  ///  * [String]
  ///
  /// If direction with same [origin] and [destination] have been already added,
  /// addition of a new polygon will be ignored.
  void addDirection(
    dynamic origin,
    dynamic destination, {
    String startLabel,
    String startIcon,
    String startInfo,
    String endLabel,
    String endIcon,
    String endInfo,
  });

  /// Removes a direction from map by given [origin] and [destination] coordinates.
  ///
  /// [origin] and [destination] are `dynamic` due to following variations:
  ///  * [LatLng], better use [GeoCoord], it will be converted into [LatLng]
  ///  * [Place]
  ///  * [String]
  void removeDirection(dynamic origin, dynamic destination);

  /// Removes all directions from map.
  void clearDirections();
}

abstract class MapPolygones {
  /// Adds a polygon to map by given [id] and [points].
  ///
  /// Where [id] must be **unique**.
  ///
  /// If [id] have been already added, addition of a new polygon will be ignored.
  void addPolygon(
    String id,
    Iterable<GeoCoord> points, {
    Color strokeColor = const Color(0x000000),
    double strokeOpacity = 0.8,
    double strokeWidth = 1,
    Color fillColor = const Color(0x000000),
    double fillOpacity = 0.35,
  });

  /// Removes and then adds a polygon to map by given [id] and [points].
  ///
  /// Where [id] must be **unique**.
  ///
  /// If [id] have been already added, addition of a new polygon will be ignored.
  void editPolygon(
    String id,
    Iterable<GeoCoord> points, {
    Color strokeColor = const Color(0x000000),
    double strokeOpacity = 0.8,
    double strokeWeight = 1,
    Color fillColor = const Color(0x000000),
    double fillOpacity = 0.35,
  });

  /// Removes a polygon from map by given [id].
  void removePolygon(String id);

  /// Removes all polygones from map.
  void clearPolygons();
}
