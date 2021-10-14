# Changelog

## 5.0.1

* Removed unnecessary null checks
* Fixed markers not displaying on mobile

## 5.0.0

* Updated to null-safety
* [BREAKING CHANGE] Removed `WebMapStyleExtension` as it is no longer supported by the underlying package [google_maps](https://pub.dev/packages/google_maps)

## 4.0.1

* TypeError: this.widget.markers is not iterable (thanks to [slovnicki](https://github.com/slovnicki))

## 4.0.0

* Added Circles support (thanks to [jan-pavlovsky](https://github.com/jan-pavlovsky))

## 3.8.0

* Added moveCameraBounds (old moveCamera), moveCamera (with zooming ability) and zoomCamera (thanks to [travisjayday](https://github.com/travisjayday) for zoomControlsEnabled on mobile)
* Added center getter for center coordinates of the map
* Fixed issue when onTap/onLongPress was not specified

## 3.7.1

* Fixed bug when app crash, when there's no any marker on mobile map (thanks to [Chojecki](https://github.com/Chojecki))

## 3.7.0

* Changed onTap VoidCallback to onTap ValueChanged with marker ID as an argument
* Added onTap for polygon with polygon ID as an argument
* Added option for marker icon to be a path to an asset as well as to be a ByteString

### BREAKING CHANGE
* addMarker now is addMarkerRaw
* addMarker now accepts instance of a Marker object

## 3.6.0

* Added infoSnippet as an argument to addMarker method

## 3.5.0

* Fixed animateCamera issue and possible changeMapStyle issue

## 3.4.0

* Added rotate/scroll/tilt/zoom gestures to mobile map preferences
* Added map callbacks onTap, onLongPress
* Added onInfoWindowTap for addMarker method on web

## 3.3.0

* Added onInfoWindowTap for addMarker method (works only on Android/iOS)
* Added map iteractivity setup

## 3.2.0

* Added onTap VoidCallback for addMarker method

## 3.1.0

* Added gesture boolean to WebMapPreferences, that indicates whether to enable gestures or not

## 3.0.0

* Implemented setting up Map Style

## 2.0.0

* Fixed roadmap/normal Map Type

## 1.1.0

* Update docs

## 1.0.0

* Created wrapper for Mobile map and Web map
* Created common interface
