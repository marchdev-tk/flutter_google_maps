// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library flutter_google_maps;

export 'src/core/map_items.dart';
export 'src/core/map_operations.dart';
export 'src/core/map_preferences.dart';

export 'src/core/utils.dart';

export 'src/core/google_map.dart';
export 'src/core/google_map.state.dart'
    if (dart.library.html) 'src/web/google_map.state.dart'
    if (dart.library.io) 'src/mobile/google_map.state.dart';

export 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
export 'package:google_directions_api/google_directions_api.dart'
    show GeoCoord, GeoCoordBounds;
