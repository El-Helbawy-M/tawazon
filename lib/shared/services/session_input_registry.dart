import 'dart:collection';

/// Registry to capture session input values for content items during UI interaction.
/// Keys are content item IDs, values are the current user inputs.
class SessionInputRegistry {
  SessionInputRegistry._();

  static final SessionInputRegistry instance = SessionInputRegistry._();

  final Map<String, dynamic> _values = <String, dynamic>{};

  /// Sets current value for a content item.
  void setValue(String contentItemId, dynamic value) {
    _values[contentItemId] = value;
  }

  /// Reads a value for content item ID.
  dynamic getValue(String contentItemId) => _values[contentItemId];

  /// Returns an unmodifiable snapshot of all values.
  Map<String, dynamic> get all => UnmodifiableMapView(_values);

  /// Returns a map filtered by provided IDs.
  Map<String, dynamic> byIds(Iterable<String> ids) {
    final Map<String, dynamic> out = {};
    for (final id in ids) {
      if (_values.containsKey(id)) {
        out[id] = _values[id];
      }
    }
    return out;
  }

  /// Clears captured values (optional use by caller when needed).
  void clear() => _values.clear();
}
