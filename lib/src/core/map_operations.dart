// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ui' show Color;

import 'package:google_directions_api/google_directions_api.dart'
    show GeoCoord, GeoCoordBounds;

/// Interface of setting up map operations including:
/// 
///  * Markers
///  * Directions
///  * Polygons
///  * Camera position
///  * Map Style
abstract class MapOperations
    implements MapMarkers, MapDirections, MapPolygons {
  /// Moves camera to the new bounds.
  void moveCamera(
    GeoCoordBounds newBounds, {
    double padding = 0,
    bool animated = true,
  });

  /// Sets the styling of the base map.
  ///
  /// Set to `null` to clear any previous custom styling.
  ///
  /// If problems were detected with the [mapStyle], including un-parsable
  /// styling JSON, unrecognized feature type, unrecognized element type, or
  /// invalid styler keys: [MapStyleException] is thrown and the current
  /// style is left unchanged.
  ///
  /// The style string can be generated using [map style tool](https://mapstyle.withgoogle.com/).
  /// Also, refer [iOS](https://developers.google.com/maps/documentation/ios-sdk/style-reference)
  /// and [Android](https://developers.google.com/maps/documentation/android-sdk/style-reference)
  /// style reference for more information regarding the supported styles.
  void changeMapStyle(String mapStyle);
}

/// Interface of setting up markers
abstract class MapMarkers {
  /// Adds a marker to the map by given [position].
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

  /// Removes a marker from the map by given [position].
  void removeMarker(GeoCoord position);

  /// Removes all markers from the map.
  void clearMarkers();
}

/// Interface of setting up directions
abstract class MapDirections {
  /// Adds a direction to the map by given [origin] and [destination] coordinates.
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

  /// Removes a direction from the map by given [origin] and [destination] coordinates.
  ///
  /// [origin] and [destination] are `dynamic` due to following variations:
  ///  * [LatLng], better use [GeoCoord], it will be converted into [LatLng]
  ///  * [Place]
  ///  * [String]
  void removeDirection(dynamic origin, dynamic destination);

  /// Removes all directions from the map.
  void clearDirections();
}

/// Interface of setting up polygons
abstract class MapPolygons {
  /// Adds a polygon to the map by given [id] and [points].
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

  /// Removes and then adds a polygon to the map by given [id] and [points].
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

  /// Removes a polygon from the map by given [id].
  void removePolygon(String id);

  /// Removes all polygones from the map.
  void clearPolygons();
}
