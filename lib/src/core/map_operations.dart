// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async' show FutureOr;
import 'dart:ui' show Color, VoidCallback;

import 'package:flutter/foundation.dart' show ValueChanged;
import 'package:google_directions_api/google_directions_api.dart'
    show GeoCoord, GeoCoordBounds;

import 'map_items.dart';

/// Interface of setting up map operations including:
///
///  * Markers
///  * Directions
///  * Polygons
///  * Camera position
///  * Map Style
abstract class MapOperations
    implements MapMarkers, MapDirections, MapPolygons, MapCircles {
  /// Moves camera to the new bounds.
  ///
  /// If `padding` not set, it defaults to `0`.
  ///
  /// if `animated` not set, it defaults to `true`.
  ///
  /// For safe execution of [moveCameraBounds] some actions must be performed, and if
  /// `waitUntilReady` is set to `true` (by default it's true), so this method
  /// will await of completion of all actions, and executes [moveCameraBounds] as soon
  /// as it possible. This argument only affects on **mobile** devices.
  void moveCameraBounds(
    GeoCoordBounds newBounds, {
    double padding = 0,
    bool animated = true,
    bool waitUntilReady = true,
  });

  /// Moves camera to the new coordinates.
  ///
  /// if `animated` not set, it defaults to `true`.
  ///
  /// For safe execution of [moveCamera] some actions must be performed, and if
  /// `waitUntilReady` is set to `true` (by default it's true), so this method
  /// will await of completion of all actions, and executes [moveCamera] as soon
  /// as it possible. This argument only affects on **mobile** devices.
  void moveCamera(
    GeoCoord latLng, {
    bool animated = true,
    bool waitUntilReady = true,
    double zoom,
  });

  /// Sets new camera zoom.
  ///
  /// if `animated` not set, it defaults to `true`.
  /// This argument only affects on **mobile** devices.
  ///
  /// For safe execution of [zoomCamera] some actions must be performed, and if
  /// `waitUntilReady` is set to `true` (by default it's true), so this method
  /// will await of completion of all actions, and executes [zoomCamera] as soon
  /// as it possible. This argument only affects on **mobile** devices.
  void zoomCamera(
    double zoom, {
    bool animated = true,
    bool waitUntilReady = true,
  });

  /// Gets center coordinates of the map.
  FutureOr<GeoCoord> get center;

  /// Sets the styling of the base map.
  ///
  /// Set to `null` to clear any previous custom styling.
  ///
  /// For safe execution of [changeMapStyle] some actions must be performed, and if
  /// `waitUntilReady` is set to `true` (by default it's true), so this method
  /// will await of completion of all actions, and executes [changeMapStyle] as soon
  /// as it possible. This argument only affects on **mobile** devices.
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
  ///
  /// Please note, if widget rebuilds new map style will be ommited due to map style
  /// provided from the `widget`. So, if map will be scrolled out, make sure that
  /// new map style will be set to widgets [GoogleMap.mapStyle].
  void changeMapStyle(
    String mapStyle, {
    bool waitUntilReady = true,
  });
}

/// Interface of setting up markers
abstract class MapMarkers {
  /// Adds a marker to the map by given [position].
  ///
  /// [label] can be set only for `web`.
  ///
  /// If [icon] is set, must be a path to an image from project root
  /// as follows: `assets/images/image.png`. Or it must be an instance
  /// of [ByteString].
  ///
  /// If [info] is set and click event will be fired, will be shown popup with [info] within.
  ///  * For `web` [info] could be a [String] or `HTML String`
  ///  * For `mobile` [info] could be only a [String]
  ///
  /// [infoSnippet] sets snippet text for `InfoWindow`.
  ///
  /// If [onTap] is not null, [info] popup will not be shown.
  ///
  /// if [onInfoWindowTap] is set, it will be called once InfoWindow will be tapped.
  ///
  /// If marker with same [position] have been already added, addition of a new marker will be ignored.
  void addMarkerRaw(
    GeoCoord position, {
    String label,
    String icon,
    String info,
    String infoSnippet,
    ValueChanged<String> onTap,
    VoidCallback onInfoWindowTap,
  });

  /// Adds a marker to the map by given [position].
  ///
  /// If marker with same [position] have been already added, addition of a new marker will be ignored.
  void addMarker(Marker marker);

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
    ValueChanged<String> onTap,
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
    ValueChanged<String> onTap,
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

/// Interface of setting up circles
abstract class MapCircles {
  /// Adds a circle to the map by given [id], [center] and [radius].
  ///
  /// Where [id] must be **unique**.
  ///
  /// If [id] have been already added, addition of a new circle will be ignored.
  void addCircle(
    String id,
    GeoCoord center,
    double radius, {
    ValueChanged<String> onTap,
    Color strokeColor = const Color(0x000000),
    double strokeOpacity = 0.8,
    double strokeWidth = 1,
    Color fillColor = const Color(0x000000),
    double fillOpacity = 0.35,
  });

  /// Removes and then adds a circles to the map by given [id], [center] and [radius].
  ///
  /// Where [id] must be **unique**.
  ///
  /// If [id] have been already added, addition of a new circle will be ignored.
  void editCircle(
    String id,
    GeoCoord center,
    double radius, {
    ValueChanged<String> onTap,
    Color strokeColor = const Color(0x000000),
    double strokeOpacity = 0.8,
    double strokeWidth = 1,
    Color fillColor = const Color(0x000000),
    double fillOpacity = 0.35,
  });

  /// Removes a circle from the map by given [id].
  void removeCircle(String id);

  /// Removes all circles from the map.
  void clearCircles();
}
