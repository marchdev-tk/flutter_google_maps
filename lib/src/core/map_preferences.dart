// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';

/// Type of map tiles to display.
enum MapType {
  /// Do not display map tiles.
  none,

  /// Normal tiles (traffic and labels, subtle terrain information).
  roadmap,

  /// Satellite imaging tiles (aerial photos)
  satellite,

  /// Terrain tiles (indicates type and height of terrain)
  terrain,

  /// Hybrid tiles (satellite images with some labels/overlays)
  hybrid,
}

/// Set of mobile map preferences
class MobileMapPreferences {
  const MobileMapPreferences({
    this.compassEnabled = true,
    this.mapToolbarEnabled = true,
    this.myLocationEnabled = false,
    this.myLocationButtonEnabled = true,
    this.indoorViewEnabled = false,
    this.trafficEnabled = false,
    this.buildingsEnabled = true,
    this.padding = const EdgeInsets.all(0),
  });

  /// True if the map should show a compass when rotated.
  final bool compassEnabled;

  /// True if the map should show a toolbar when you interact with the map. Android only.
  final bool mapToolbarEnabled;

  /// True if a "My Location" layer should be shown on the map.
  ///
  /// This layer includes a location indicator at the current device location,
  /// as well as a My Location button.
  /// * The indicator is a small blue dot if the device is stationary, or a
  /// chevron if the device is moving.
  /// * The My Location button animates to focus on the user's current location
  /// if the user's location is currently known.
  ///
  /// Enabling this feature requires adding location permissions to both native
  /// platforms of your app.
  /// * On Android add either
  /// `<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />`
  /// or `<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />`
  /// to your `AndroidManifest.xml` file. `ACCESS_COARSE_LOCATION` returns a
  /// location with an accuracy approximately equivalent to a city block, while
  /// `ACCESS_FINE_LOCATION` returns as precise a location as possible, although
  /// it consumes more battery power. You will also need to request these
  /// permissions during run-time. If they are not granted, the My Location
  /// feature will fail silently.
  /// * On iOS add a `NSLocationWhenInUseUsageDescription` key to your
  /// `Info.plist` file. This will automatically prompt the user for permissions
  /// when the map tries to turn on the My Location layer.
  final bool myLocationEnabled;

  /// Enables or disables the my-location button.
  ///
  /// The my-location button causes the camera to move such that the user's
  /// location is in the center of the map. If the button is enabled, it is
  /// only shown when the my-location layer is enabled.
  ///
  /// By default, the my-location button is enabled (and hence shown when the
  /// my-location layer is enabled).
  ///
  /// See also:
  ///   * [myLocationEnabled] parameter.
  final bool myLocationButtonEnabled;

  /// Enables or disables the indoor view from the map.
  final bool indoorViewEnabled;

  /// Enables or disables the traffic layer of the map.
  final bool trafficEnabled;

  /// Enables or disables showing 3D buildings where available.
  final bool buildingsEnabled;

  /// Padding to be set on map. See https://developers.google.com/maps/documentation/android-sdk/map#map_padding for more details.
  final EdgeInsets padding;
}

/// Set of web map preferences
class WebMapPreferences {
  const WebMapPreferences({
    this.streetViewControl = false,
    this.fullscreenControl = false,
    this.mapTypeControl = false,
    this.scrollwheel = true,
    this.panControl = false,
    this.overviewMapControl = false,
    this.rotateControl = false,
    this.scaleControl = false,
    this.zoomControl = false,
    this.gestures = true,
  });

  /// Enables or disables streetViewControl.
  final bool streetViewControl;

  /// Enables or disables fullscreenControl.
  final bool fullscreenControl;

  /// Enables or disables mapTypeControl.
  final bool mapTypeControl;

  /// Enables or disables scrollwheel.
  final bool scrollwheel;

  /// Enables or disables panControl.
  final bool panControl;

  /// Enables or disables overviewMapControl.
  final bool overviewMapControl;

  /// Enables or disables rotateControl.
  final bool rotateControl;

  /// Enables or disables scaleControl.
  final bool scaleControl;

  /// Enables or disables zoomControl.
  final bool zoomControl;

  /// Enables or disables gestures.
  final bool gestures;
}
