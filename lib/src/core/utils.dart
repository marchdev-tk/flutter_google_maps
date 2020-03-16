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