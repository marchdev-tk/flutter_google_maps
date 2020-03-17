// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import 'package:uuid/uuid.dart';
import 'package:flinq/flinq.dart';
import 'package:google_maps/google_maps.dart';
import 'package:google_directions_api/google_directions_api.dart'
    show GeoCoord, GeoCoordBounds;

import 'utils.dart';
import '../core/google_map.dart';
import '../core/utils.dart' as exception;

class GoogleMapState extends GoogleMapStateBase {
  final htmlId = Uuid().v1();
  final directionsService = DirectionsService();

  final _markers = <String, Marker>{};
  final _infoState = <String, bool>{};
  final _infos = <String, InfoWindow>{};
  final _polygons = <String, Polygon>{};
  final _directions = <String, DirectionsRenderer>{};

  GMap _map;
  MapOptions _mapOptions;

  @override
  void moveCamera(
    GeoCoordBounds newBounds, {
    double padding = 0,
    bool animated = true,
  }) {
    assert(() {
      if (newBounds == null) {
        throw ArgumentError.notNull('newBounds');
      }

      return true;
    }());

    _map.center = newBounds.center.toLatLng();

    final zoom = _map.zoom;
    if (animated == true) {
      _map.panToBounds(newBounds.toLatLngBounds());
    } else {
      _map.fitBounds(newBounds.toLatLngBounds());
    }
    _map.zoom = zoom;
  }

  @override
  void changeMapStyle(String mapStyle) {
    try {
      _mapOptions.styles = mapStyle?.parseMapStyle();
      _map.options = _mapOptions;
    } catch (e) {
      throw exception.MapStyleException(e.toString());
    }
  }

  @override
  void addMarker(
    GeoCoord position, {
    String label,
    String icon,
    String info,
    ui.VoidCallback onTap,
  }) {
    assert(() {
      if (position == null) {
        throw ArgumentError.notNull('position');
      }

      if (position.latitude == null || position.longitude == null) {
        throw ArgumentError.notNull('position.latitude && position.longitude');
      }

      return true;
    }());

    _markers.putIfAbsent(
      position.toString(),
      () {
        final marker = Marker()
          ..map = _map
          ..label = label
          ..icon = icon != null ? '${fixAssetPath(icon)}assets/$icon' : null
          ..position = position.toLatLng();

        if (info != null || onTap != null) {
          // potential leak
          marker.onClick.listen((_) {
            if (onTap != null) {
              onTap();
              return;
            }

            final key = position.toString();

            if (_infos[key] == null) {
              _infos[key] = InfoWindow(InfoWindowOptions()..content = info);
              // potential leak
              _infos[key].onCloseclick.listen((_) => _infoState[key] = false);
            }

            if (!(_infoState[key] ?? false)) {
              _infos[key].open(_map, marker);
              _infoState[key] = true;
            } else {
              _infos[key].close();

              _infoState[key] = false;
            }
          });
        }

        return marker;
      },
    );
  }

  @override
  void removeMarker(GeoCoord position) {
    assert(() {
      if (position == null) {
        throw ArgumentError.notNull('position');
      }

      if (position.latitude == null || position.longitude == null) {
        throw ArgumentError.notNull('position.latitude && position.longitude');
      }

      return true;
    }());

    final key = position.toString();

    var marker = _markers.remove(key);
    marker?.map = null;
    marker = null;

    var info = _infos.remove(key);
    info?.close();
    info = null;

    _infoState.remove(key);
  }

  @override
  void clearMarkers() {
    for (var marker in _markers.values) {
      marker?.map = null;
      marker = null;
    }
    _markers.clear();

    for (var info in _infos.values) {
      info?.close();
      info = null;
    }
    _infos.clear();

    _infoState.clear();
  }

  @override
  void addDirection(
    dynamic origin,
    dynamic destination, {
    String startLabel,
    String startIcon,
    String startInfo,
    String endLabel,
    String endIcon,
    String endInfo,
  }) {
    assert(() {
      if (origin == null) {
        throw ArgumentError.notNull('origin');
      }

      if (destination == null) {
        throw ArgumentError.notNull('destination');
      }

      return true;
    }());

    _directions.putIfAbsent(
      '${origin}_$destination',
      () {
        DirectionsRenderer direction = DirectionsRenderer(
            DirectionsRendererOptions()..suppressMarkers = true);
        direction.map = _map;

        final request = DirectionsRequest()
          ..origin = origin is GeoCoord
              ? LatLng(origin.latitude, origin.longitude)
              : origin
          ..destination =
              destination is GeoCoord ? destination.toLatLng() : destination
          ..travelMode = TravelMode.DRIVING;
        directionsService.route(
          request,
          (response, status) {
            if (status == DirectionsStatus.OK) {
              direction.directions = response;

              final leg = response?.routes?.firstOrNull?.legs?.firstOrNull;

              final startLatLng = leg?.startLocation;
              if (startLatLng != null) {
                if (startIcon != null ||
                    startInfo != null ||
                    startLabel != null) {
                  addMarker(
                    startLatLng.toGeoCoord(),
                    icon: startIcon,
                    info: startInfo ?? leg.startAddress,
                    label: startLabel,
                  );
                } else {
                  addMarker(
                    startLatLng.toGeoCoord(),
                    icon: 'assets/images/marker_a.png',
                    info: leg.startAddress,
                  );
                }
              }

              final endLatLng = leg?.endLocation;
              if (endLatLng != null) {
                if (endIcon != null || endInfo != null || endLabel != null) {
                  addMarker(
                    endLatLng.toGeoCoord(),
                    icon: endIcon,
                    info: endInfo ?? leg.endAddress,
                    label: endLabel,
                  );
                } else {
                  addMarker(
                    endLatLng.toGeoCoord(),
                    icon: 'assets/images/marker_b.png',
                    info: leg.endAddress,
                  );
                }
              }
            }
          },
        );

        return direction;
      },
    );
  }

  @override
  void removeDirection(dynamic origin, dynamic destination) {
    assert(() {
      if (origin == null) {
        throw ArgumentError.notNull('origin');
      }

      if (destination == null) {
        throw ArgumentError.notNull('destination');
      }

      return true;
    }());

    var value = _directions.remove('${origin}_$destination');
    value?.map = null;
    final start = value
        ?.directions?.routes?.firstOrNull?.legs?.firstOrNull?.startLocation
        ?.toGeoCoord();
    if (start != null) {
      removeMarker(start);
    }
    final end = value
        ?.directions?.routes?.firstOrNull?.legs?.lastOrNull?.endLocation
        ?.toGeoCoord();
    if (end != null) {
      removeMarker(end);
    }
    value = null;
  }

  @override
  void clearDirections() {
    for (var direction in _directions.values) {
      direction?.map = null;
      final start = direction
          ?.directions?.routes?.firstOrNull?.legs?.firstOrNull?.startLocation
          ?.toGeoCoord();
      if (start != null) {
        removeMarker(start);
      }
      final end = direction
          ?.directions?.routes?.firstOrNull?.legs?.lastOrNull?.endLocation
          ?.toGeoCoord();
      if (end != null) {
        removeMarker(end);
      }
      direction = null;
    }
    _directions.clear();
  }

  @override
  void addPolygon(
    String id,
    Iterable<GeoCoord> points, {
    Color strokeColor = const Color(0x000000),
    double strokeOpacity = 0.8,
    double strokeWidth = 1,
    Color fillColor = const Color(0x000000),
    double fillOpacity = 0.35,
  }) {
    assert(() {
      if (id == null) {
        throw ArgumentError.notNull('id');
      }

      if (points == null) {
        throw ArgumentError.notNull('position');
      }

      if (points.isEmpty) {
        throw ArgumentError.value(<GeoCoord>[], 'points');
      }

      if (points.length < 3) {
        throw ArgumentError('Polygon must have at least 3 coordinates');
      }

      return true;
    }());

    _polygons.putIfAbsent(
      id,
      () {
        final options = PolygonOptions()
          ..paths = points.mapList((_) => _.toLatLng())
          ..strokeColor = strokeColor?.toHashString() ?? '#000000'
          ..strokeOpacity = strokeOpacity ?? 0.8
          ..strokeWeight = strokeWidth ?? 1
          ..fillColor = strokeColor?.toHashString() ?? '#000000'
          ..fillOpacity = fillOpacity ?? 0.35;

        return Polygon(options)..map = _map;
      },
    );
  }

  @override
  void editPolygon(
    String id,
    Iterable<GeoCoord> points, {
    Color strokeColor = const Color(0x000000),
    double strokeOpacity = 0.8,
    double strokeWeight = 1,
    Color fillColor = const Color(0x000000),
    double fillOpacity = 0.35,
  }) {
    removePolygon(id);
    addPolygon(
      id,
      points,
      strokeColor: strokeColor,
      strokeOpacity: strokeOpacity,
      strokeWidth: strokeWeight,
      fillColor: fillColor,
      fillOpacity: fillOpacity,
    );
  }

  @override
  void removePolygon(String id) {
    assert(() {
      if (id == null) {
        throw ArgumentError.notNull('id');
      }

      return true;
    }());

    var value = _polygons.remove(id);
    value?.map = null;
    value = null;
  }

  @override
  void clearPolygons() {
    for (var polygon in _polygons.values) {
      polygon?.map = null;
      polygon = null;
    }
    _polygons.clear();
  }

  @override
  Widget build(BuildContext context) {
    _mapOptions = MapOptions()
      ..zoom = widget.initialZoom
      ..center = widget.initialPosition.toLatLng()
      ..streetViewControl = widget.webPreferences.streetViewControl
      ..fullscreenControl = widget.webPreferences.fullscreenControl
      ..mapTypeControl = widget.webPreferences.mapTypeControl
      ..scrollwheel = widget.webPreferences.scrollwheel
      ..panControl = widget.webPreferences.panControl
      ..overviewMapControl = widget.webPreferences.overviewMapControl
      ..rotateControl = widget.webPreferences.rotateControl
      ..scaleControl = widget.webPreferences.scaleControl
      ..zoomControl = widget.webPreferences.zoomControl
      ..minZoom = widget.minZoom
      ..maxZoom = widget.maxZoom
      ..styles = widget.mapStyle?.parseMapStyle()
      ..mapTypeId = widget.mapType.toString().split('.')[1];

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
      final elem = DivElement()
        ..id = htmlId
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.border = 'none';

      _map = GMap(elem, _mapOptions);

      return elem;
    });

    return LayoutBuilder(
      builder: (context, constraints) => GestureDetector(
        onPanUpdate: widget.webPreferences.gestures ? null : (_) {},
        onScaleUpdate: widget.webPreferences.gestures ? null : (_) {},
        onVerticalDragUpdate: widget.webPreferences.gestures ? null : (_) {},
        onHorizontalDragUpdate: widget.webPreferences.gestures ? null : (_) {},
        child: Container(
          constraints: BoxConstraints(maxHeight: constraints.maxHeight),
          child: HtmlElementView(viewType: htmlId),
        ),
      ),
    );
  }
}
