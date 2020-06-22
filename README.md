# flutter_google_maps

![Build](https://github.com/marchdev-tk/flutter_google_maps/workflows/build/badge.svg)
[![Pub](https://img.shields.io/pub/v/flutter_google_maps.svg)](https://pub.dartlang.org/packages/flutter_google_maps)
![GitHub](https://img.shields.io/github/license/marchdev-tk/flutter_google_maps)
![GitHub stars](https://img.shields.io/github/stars/marchdev-tk/flutter_google_maps?style=social)

A Flutter plugin for integrating Google Maps in iOS, Android and Web applications. It is a wrapper of google_maps_flutter for Mobile and google_maps for Web.

## Getting Started

* Get an API key at <https://cloud.google.com/maps-platform/>.

* Enable Google Map SDK for each platform.
  * Go to [Google Developers Console](https://console.cloud.google.com/).
  * Choose the project that you want to enable Google Maps on.
  * Select the navigation menu and then select "Google Maps".
  * Select "APIs" under the Google Maps menu.
  * To enable Google Maps for Android, select "Maps SDK for Android" in the "Additional APIs" section, then select "ENABLE".
  * To enable Google Maps for iOS, select "Maps SDK for iOS" in the "Additional APIs" section, then select "ENABLE".
  * Make sure the APIs you enabled are under the "Enabled APIs" section.

* You can also find detailed steps to get start with Google Maps Platform [here](https://developers.google.com/maps/gmp-get-started).

### Web

```html
<body>
  <script src="https://maps.googleapis.com/maps/api/js?key=API_KEY"></script>
  <script src="main.dart.js" type="application/javascript"></script>
</body>
```

### Android

Specify your API key in the application manifest `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest ...
  <application ...
    <meta-data android:name="com.google.android.geo.API_KEY"
               android:value="YOUR KEY HERE"/>
```

### iOS

Specify your API key in the application delegate `ios/Runner/AppDelegate.m`:

```objectivec
#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GMSServices provideAPIKey:@"YOUR KEY HERE"];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}
@end
```

Or in your swift code, specify your API key in the application delegate `ios/Runner/AppDelegate.swift`:

```swift
import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR KEY HERE")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```
Opt-in to the embedded views preview by adding a boolean property to the app's `Info.plist` file
with the key `io.flutter.embedded_views_preview` and the value `YES`.

#### Android/iOS Directions API

Add in your `main.dart` within `main` function `GoogleMap.init('API_KEY');` before running the app.

```dart
void main() {
  GoogleMap.init('API_KEY');
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}
```

For more info about **mobile** map setup, view [google_maps_flutter](https://pub.dev/packages/google_maps_flutter) plugin.

### Add GoogleMap Widget

```dart
import 'package:flutter/material.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';

...
GlobalKey<GoogleMapStateBase> _key = GlobalKey<GoogleMapStateBase>();

@override
Widget build(BuildContext context) => GoogleMap(
  key: _key,
),
...
```

And now you're ready to go.

## Examples

### GoogleMap widget can be configured with:

| Property          | Type                   | Description                                                                      |
| :---------------: | :--------------------: | :------------------------------------------------------------------------------: |
| initialPosition   | GeoCoord               | The initial position of the map's camera                                         |
| initialZoom       | double                 | The initial zoom of the map's camera                                             |
| mapType           | MapType                | Type of map tiles to be rendered                                                 |
| minZoom           | double                 | The preferred minimum zoom level or null, if unbounded from below                |
| maxZoom           | double                 | The preferred maximum zoom level or null, if unbounded from above                |
| mapStyle          | String                 | Sets the styling of the base map                                                 |
| mobilePreferences | MobileMapPreferences   | Set of mobile map preferences                                                    |
| webPreferences    | WebMapPreferences      | Set of web map preferences                                                       |
| interactive       | bool                   | Defines whether map is interactive or not                                        |
| onTap             | ValueChanged<GeoCoord> | Called every time a GoogleMap is tapped                                          |
| onLongPress       | ValueChanged<GeoCoord> | Called every time a GoogleMap is long pressed (for web when right mouse clicked) |
| markers           | Set<Marker>            | Markers to be placed on the map                                                  |

**`MapType` is one of following variants:**

  * `none` -> do not display map tiles
  * `roadmap` -> normal tiles (traffic and labels, subtle terrain information)
  * `satellite` -> satellite imaging tiles (aerial photos)
  * `terrain` -> terrain tiles (indicates type and height of terrain)
  * `hybrid` -> hybrid tiles (satellite images with some labels/overlays)

**`MobileMapPreferences` can be configured with:**

| Property                 | Type       | Description                                                                        |
| :----------------------: | :--------: | :--------------------------------------------------------------------------------: |
| compassEnabled           | bool       | True if the map should show a compass when rotated                                 |
| mapToolbarEnabled        | bool       | True if the map should show a toolbar when you interact with the map. Android only |
| myLocationEnabled        | bool       | True if a "My Location" layer should be shown on the map                           |
| myLocationButtonEnabled  | bool       | Enables or disables the my-location button                                         |
| indoorViewEnabled        | bool       | Enables or disables the indoor view from the map                                   |
| trafficEnabled           | bool       | Enables or disables the traffic layer of the map                                   |
| buildingsEnabled         | bool       | Enables or disables showing 3D buildings where available                           |
| padding                  | EdgeInsets | Padding to be set on mapdetails                                                    |
| rotateGesturesEnabled    | bool       | True if the map view should respond to rotate gestures                             |
| scrollGesturesEnabled    | bool       | True if the map view should respond to scroll gestures                             |
| zoomGesturesEnabled      | bool       | True if the map view should respond to zoom gestures                               |
| tiltGesturesEnabled      | bool       | True if the map view should respond to tilt gestures                               |

**`WebMapPreferences` can be configured with:**

| Property           | Type | Description                               |
| :----------------: | :--: | :---------------------------------------: |
| streetViewControl  | bool | Enables or disables streetViewControl     |
| fullscreenControl  | bool | Enables or disables fullscreenControl     |
| mapTypeControl     | bool | Enables or disables mapTypeControl        |
| scrollwheel        | bool | Enables or disables scrollwheel           |
| panControl         | bool | Enables or disables panControl            |
| overviewMapControl | bool | Enables or disables overviewMapControl    |
| rotateControl      | bool | Enables or disables rotateControl         |
| scaleControl       | bool | Enables or disables scaleControl          |
| zoomControl        | bool | Enables or disables zoomControl           |
| dragGestures       | bool | Enables or disables flutter drag gestures |

### To prepare for interacting with GoogleMap you will need to:

Create a `key` and assign it to the `GoogleMap` widget.

### GoogleMap widget has 2 static methods, they are:
  
* MapOperations of(GlobalKey<GoogleMapStateBase> key);
  
  Gets [MapOperations] interface via provided `key` of [GoogleMapStateBase] state.


* void init(String apiKey);
  
  Initializer of [GoogleMap]. `Required` if `Directions API` will be needed. For other cases, could be ignored.


### To interact with GoogleMap you'll need to:

**Use static `of` method**

Here's list of interactions:

* Move camera to the new bounds
  ```dart
  void moveCameraBounds(
    GeoCoordBounds newBounds, {
    double padding = 0,
    bool animated = true,
    bool waitUntilReady = true,
  });
  ```

* Move camera to the new coordinates
  ```dart
  void moveCamera(
    GeoCoord latLng, {
    bool animated = true,
    bool waitUntilReady = true,
    double zoom,
  });
  ```

* Zoom camera
  ```dart
  void zoomCamera(
    double zoom, {
    bool animated = true,
    bool waitUntilReady = true,
  });
  ```

* Get center coordinates of the map
  ```dart
  FutureOr<GeoCoord> get center;
  ```

* Change Map Style.

  The style string can be generated using [map style tool](https://mapstyle.withgoogle.com/).
  Also, refer [iOS](https://developers.google.com/maps/documentation/ios-sdk/style-reference)
  and [Android](https://developers.google.com/maps/documentation/android-sdk/style-reference)
  style reference for more information regarding the supported styles.

  ```dart
  void changeMapStyle(String mapStyle);
  ```

* Add marker to the map by given [position]
  ```dart
  void addMarkerRaw(
    GeoCoord position, {
    String label,
    String icon,
    String info,
    ValueChanged<String> onTap,
    VOidCallback onInfoWindowTap,
  });
  ```
**Please note:** [icon] could be a *path to an image asset* or it could be an instance of *ByteString*.

* Add marker to the map by given [marker] object
  ```dart
  void addMarker(Marker marker);
  ```

* Remove marker from the map by given [position]
  ```dart
  void removeMarker(GeoCoord position);
  ```

* Remove all markers from the map
  ```dart
  void clearMarkers();
  ```

* Add direction to the map by given [origin] and [destination] coordinates
  ```dart
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
  ```

* Remove direction from the map by given [origin] and [destination] coordinates
  ```dart
  void removeDirection(dynamic origin, dynamic destination);
  ```

* Remove all directions from the map
  ```dart
  void clearDirections();
  ```

* Add polygon to the map by given [id] and [points]
  ```dart
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
  ```

* Edit polygon on the map by given [id] and [points]
  ```dart
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
  ```

* Remove polygon from the map by given [id].
  ```dart
  void removePolygon(String id);
  ```

* Remove all polygones from the map.
  ```dart
  void clearPolygons();
  ```

## Feature requests and Bug reports

Feel free to post a feature requests or report a bug [here](https://github.com/marchdev-tk/flutter_google_maps/issues).

## TODO

* Add circles support
* Add polyline support
