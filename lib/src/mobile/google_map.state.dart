// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' as math show Point, Rectangle;

import 'package:flutter/widgets.dart';

import 'package:flinq/flinq.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_directions_api/google_directions_api.dart' as gda;

import 'utils.dart';
import '../core/google_map.dart' as gmap;

class GoogleMapState extends gmap.GoogleMapStateBase {
  final directionsService = gda.DirectionsService();

  final _markers = <String, Marker>{};
  final _polygons = <String, Polygon>{};
  final _polylines = <String, Polyline>{};
  final _directionMarkerCoords = <math.Point<double>, dynamic>{};

  GoogleMapController _controller;

  void _setState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    } else {
      fn();
    }
  }

  Future<BitmapDescriptor> _getBmpDescFromAsset(String asset) async {
    if (asset == null) return null;

    return await BitmapDescriptor.fromAssetImage(
      createLocalImageConfiguration(context),
      asset,
    );
  }

  @override
  void moveCamera(
    math.Rectangle<double> newBounds, {
    double padding = 0,
    bool animated = true,
  }) {
    assert(() {
      if (newBounds == null) {
        throw ArgumentError.notNull('newBounds');
      }

      return true;
    }());

    if (animated == true) {
      _controller.animateCamera(CameraUpdate.newLatLngBounds(
        newBounds.toLatLngBounds(),
        padding ?? 0,
      ));
    } else {
      _controller.moveCamera(CameraUpdate.newLatLngBounds(
        newBounds.toLatLngBounds(),
        padding ?? 0,
      ));
    }
  }

  @override
  void addMarker(
    math.Point<double> position, {
    String label,
    String icon,
    String info,
    int zIndex,
  }) async {
    assert(() {
      if (position == null) {
        throw ArgumentError.notNull('position');
      }

      if (position.x == null || position.y == null) {
        throw ArgumentError.notNull('position.x && position.y');
      }

      return true;
    }());

    final key = position.toString();

    if (_markers.containsKey(key)) return;

    final markerId = MarkerId(key);
    final marker = Marker(
      markerId: markerId,
      position: position.toLatLng(),
      icon: await _getBmpDescFromAsset(icon),
      infoWindow: info != null ? InfoWindow(title: info) : null,
      zIndex: zIndex?.toDouble(),
    );

    _setState(() => _markers[key] = marker);
  }

  @override
  void removeMarker(math.Point<double> position) {
    assert(() {
      if (position == null) {
        throw ArgumentError.notNull('position');
      }

      if (position.x == null || position.y == null) {
        throw ArgumentError.notNull('position.x && position.y');
      }

      return true;
    }());

    final key = position.toString();

    if (!_markers.containsKey(key)) return;

    _setState(() => _markers.remove(key));
  }

  @override
  void clearMarkers() => _setState(() => _markers.clear());

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

    final request = gda.DirectionsRequest(
      origin: origin is math.Point ? LatLng(origin.x, origin.y) : origin,
      destination: destination is math.Point<double>
          ? destination.toLatLng()
          : destination,
      travelMode: gda.TravelMode.driving,
    );
    directionsService.route(
      request,
      (response, status) {
        if (status == gda.DirectionsStatus.ok) {
          final key = '${origin}_$destination';

          if (_polylines.containsKey(key)) return;

          _controller.animateCamera(CameraUpdate.newLatLngBounds(
            response?.routes?.firstOrNull?.bounds?.toLatLng(),
            80,
          ));

          final leg = response?.routes?.firstOrNull?.legs?.firstOrNull;

          final startLatLng = leg?.startLocation?.toLatLng();
          if (startLatLng != null) {
            _directionMarkerCoords[startLatLng.toPoint()] = origin;
            if (startIcon != null || startInfo != null || startLabel != null) {
              addMarker(
                startLatLng.toPoint(),
                icon: startIcon ?? 'assets/images/marker_a.png',
                info: startInfo ?? leg.startAddress,
                label: startLabel,
              );
            } else {
              addMarker(
                startLatLng.toPoint(),
                icon: 'assets/images/marker_a.png',
                info: leg.startAddress,
              );
            }
          }

          final endLatLng = leg?.endLocation?.toLatLng();
          if (endLatLng != null) {
            _directionMarkerCoords[endLatLng.toPoint()] = destination;
            if (endIcon != null || endInfo != null || endLabel != null) {
              addMarker(
                endLatLng.toPoint(),
                icon: endIcon ?? 'assets/images/marker_b.png',
                info: endInfo ?? leg.endAddress,
                label: endLabel,
              );
            } else {
              addMarker(
                endLatLng.toPoint(),
                icon: 'assets/images/marker_b.png',
                info: leg.endAddress,
              );
            }
          }

          final polylineId = PolylineId(key);
          final polyline = Polyline(
            polylineId: polylineId,
            points: response?.routes?.firstOrNull?.overviewPath ??
                [startLatLng, endLatLng],
            color: const Color(0xcc2196F3),
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
            width: 8,
          );

          _setState(() => _polylines[key] = polyline);
        }
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

    var value = _polylines.remove('${origin}_$destination');
    final start = value?.points?.firstOrNull?.toPoint();
    if (start != null) {
      removeMarker(start);
      _directionMarkerCoords.remove(start);
    }
    final end = value?.points?.lastOrNull?.toPoint();
    if (end != null) {
      removeMarker(end);
      _directionMarkerCoords.remove(end);
    }
    value = null;
  }

  @override
  void clearDirections() {
    for (var polyline in _polylines.values) {
      final start = polyline?.points?.firstOrNull?.toPoint();
      if (start != null) {
        removeMarker(start);
        _directionMarkerCoords.remove(start);
      }
      final end = polyline?.points?.lastOrNull?.toPoint();
      if (end != null) {
        removeMarker(end);
        _directionMarkerCoords.remove(end);
      }
      polyline = null;
    }
    _polylines.clear();
  }

  @override
  void addPolygon(
    String id,
    Iterable<math.Point<double>> points, {
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
        throw ArgumentError.value(<math.Point<double>>[], 'points');
      }

      if (points.length < 3) {
        throw ArgumentError('Polygon must have at least 3 coordinates');
      }

      return true;
    }());

    _polygons.putIfAbsent(
      id,
      () => Polygon(
        polygonId: PolygonId(id),
        points: points.mapList((_) => _.toLatLng()),
        strokeWidth: strokeWidth?.toInt() ?? 1,
        strokeColor: (strokeColor ?? const Color(0x000000))
            .withOpacity(strokeOpacity ?? 0.8),
        fillColor: (fillColor ?? const Color(0x000000))
            .withOpacity(fillOpacity ?? 0.35),
      ),
    );
  }

  @override
  void editPolygon(
    String id,
    Iterable<math.Point<double>> points, {
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

    if (!_polygons.containsKey(id)) return;

    _setState(() => _polygons.remove(id));
  }

  @override
  void clearPolygons() => _setState(() => _polygons.clear());

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => Container(
          constraints: BoxConstraints(maxHeight: constraints.maxHeight),
          child: GoogleMap(
            markers: Set<Marker>.of(_markers.values),
            polygons: Set<Polygon>.of(_polygons.values),
            polylines: Set<Polyline>.of(_polylines.values),
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.lat, widget.lng),
              zoom: gmap.GoogleMap.zoom.toDouble(),
            ),
            onMapCreated: (GoogleMapController controller) =>
                _controller = controller,
          ),
        ),
      );
}
