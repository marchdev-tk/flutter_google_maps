// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart' show ValueChanged, VoidCallback;

import 'package:google_directions_api/google_directions_api.dart' show GeoCoord;

/// Marks a geographical location on the map.
///
/// A marker icon is drawn oriented against the device's screen rather than
/// the map's surface; that is, it will not necessarily change orientation
/// due to map rotations, tilting, or zooming.
class Marker {
  /// Creates an instance of [Marker].
  const Marker(
    this.position, {
    this.label,
    this.icon,
    this.info,
    this.infoSnippet,
    this.onTap,
    this.onInfoWindowTap,
  });

  /// Geographical location on the map.
  final GeoCoord position;

  /// [label] can be set only for `web`.
  final String? label;

  /// If [icon] is set, must be a path to an image from project root
  /// as follows: `assets/images/image.png`. Or it must be an instance
  /// of [ByteString].
  final String? icon;

  /// If [info] is set and click event will be fired, will be shown popup with [info] within.
  ///  * For `web` [info] could be a [String] or `HTML String`
  ///  * For `mobile` [info] could be only a [String]
  final String? info;

  /// [infoSnippet] sets snippet text for `InfoWindow`.
  final String? infoSnippet;

  /// If [onTap] is not null, [info] popup will not be shown.
  final ValueChanged<String>? onTap;

  /// if [onInfoWindowTap] is set, it will be called once InfoWindow will be tapped.
  final VoidCallback? onInfoWindowTap;
}
