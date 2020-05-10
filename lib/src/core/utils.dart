// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert' show base64;
import 'dart:typed_data' show Uint8List;

/// Exception when a map style is invalid or was unable to be set.
///
/// See also: `mapStyle` on [GoogleMap] and `changeMapStyle` on
/// [MapOperations] for why this exception might be thrown.
class MapStyleException implements Exception {
  /// Default constructor for [MapStyleException].
  const MapStyleException(this.cause);

  /// The reason `GoogleMap.mapStyle` or `MapOperations.changeMapStyle`
  /// would throw this exception.
  final String cause;
}

/// Wrapper for byte array image representation.
class ByteString {
  /// Constructor an instance of [ByteString].
  const ByteString(this.byteData);

  /// Byte representation of an image.
  final Uint8List byteData;

  static const String _prefix = 'bytes://';

  /// Checks whether provided [String] is a string representation of byte array.
  static bool isByteString(String byteString) => byteString.startsWith(_prefix);

  /// Converts [String] to byte array.
  static Uint8List fromString(String byteString) =>
      base64.decode(byteString.replaceFirst(_prefix, ''));

  @override
  String toString() => _prefix + base64.encode(byteData);
}
