# flutter_google_maps

![Build](https://github.com/marchdev-tk/flutter_google_maps/workflows/build/badge.svg)
[![Pub](https://img.shields.io/pub/v/flutter_google_maps.svg)](https://pub.dartlang.org/packages/flutter_google_maps)
![GitHub](https://img.shields.io/github/license/marchdev-tk/flutter_google_maps)
![GitHub stars](https://img.shields.io/github/stars/marchdev-tk/flutter_google_maps?style=social)

A Flutter plugin for integrating Google Maps in iOS, Android and Web applications. It is a wrapper of google_maps_flutter for Mobile and google_maps for Web.

## Getting Started

For **mobile** map setup view [google_maps_flutter](https://pub.dev/packages/google_maps_flutter) plugin.

For **web** map setup view [google_maps](https://pub.dev/packages/google_maps) package.

### If Directions API will be needed, this package must be initialized like this:

* For **mobile**:

```dart
void main() {
  GoogleMap.init('API_KEY');
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}
```

* For **web**:

```html
...
<body>
  <script src="https://maps.googleapis.com/maps/api/js?key=API_KEY"></script>
  <script src="main.dart.js" type="application/javascript"></script>
</body>
...
```

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

| Property          | Type                 | Description                                                       |
| :---------------: | :------------------: | :---------------------------------------------------------------: |
| initialPosition   | GeoCoord             | The initial position of the map's camera                          |
| initialZoom       | double               | The initial zoom of the map's camera                              |
| mapType           | MapType              | Type of map tiles to be rendered                                  |
| minZoom           | double               | The preferred minimum zoom level or null, if unbounded from below |
| maxZoom           | double               | The preferred maximum zoom level or null, if unbounded from above |
| mobilePreferences | MobileMapPreferences | Set of mobile map preferences                                     |
| webPreferences    | WebMapPreferences    | Set of web map preferences                                        |

**`MapType` is one of following variants:**

  * `none` -> do not display map tiles
  * `normal` -> normal tiles (traffic and labels, subtle terrain information)
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

**`WebMapPreferences` can be configured with:**

| Property           | Type | Description                            |
| :----------------: | :--: | :------------------------------------: |
| streetViewControl  | bool | Enables or disables streetViewControl  |
| fullscreenControl  | bool | Enables or disables fullscreenControl  |
| mapTypeControl     | bool | Enables or disables mapTypeControl     |
| scrollwheel        | bool | Enables or disables scrollwheel        |
| panControl         | bool | Enables or disables panControl         |
| overviewMapControl | bool | Enables or disables overviewMapControl |
| rotateControl      | bool | Enables or disables rotateControl      |
| scaleControl       | bool | Enables or disables scaleControl       |
| zoomControl        | bool | Enables or disables zoomControl        |

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
  void moveCamera(
    GeoCoordBounds newBounds, {
    double padding = 0,
    bool animated = true,
  });
  ```

* Add marker to the map by given [position]
  ```dart
  void addMarker(
    GeoCoord position, {
    String label,
    String icon,
    String info,
  });
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
