# flutter_google_maps

![Build](https://github.com/marchdev-tk/flutter_google_maps/workflows/build/badge.svg)
[![Pub](https://img.shields.io/pub/v/flutter_google_maps.svg)](https://pub.dartlang.org/packages/flutter_google_maps)
![GitHub](https://img.shields.io/github/license/marchdev-tk/flutter_google_maps)
![GitHub stars](https://img.shields.io/github/stars/marchdev-tk/flutter_google_maps?style=social)

A Flutter plugin for integrating Google Maps in iOS, Android and Web applications. It is a wrapper of google_maps_flutter for Mobile and google_maps for Web.

## Getting Started

For **mobile** map setup view [google_maps_flutter](https://pub.dev/packages/google_maps_flutter) plugin.

For **web** map setup view [google_maps](https://pub.dev/packages/google_maps) package.

If Directions API will be needed, this package must be initialized like this:

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

## Examples



## Feature requests and Bug reports

Feel free to post a feature requests or report a bug [here](https://github.com/marchdev-tk/flutter_google_maps/issues).

## TODO

* Add circles support
* Add polyline support
