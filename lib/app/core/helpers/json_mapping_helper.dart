// json_mapping_helpers.dart
typedef Json = Map<String, dynamic>;

/// Flatten selected keys from a container (default: 'additional_info')
/// into the top-level map.
/// - Does not mutate [src]; returns a new map.
/// - Only copies keys that exist & non-null.
/// - If [removeContainer] = true, removes the container key after flattening.
Json flattenContainerKeys(
  Json src, {
  String containerKey = 'additional_info',
  List<String> keysToLift = const [],
  bool removeContainer = false,
}) {
  final out = Map<String, dynamic>.from(src);
  final container = out[containerKey];

  if (container is Map<String, dynamic>) {
    for (final key in keysToLift) {
      final v = container[key];
      if (v != null) {
        out[key] = v;
      }
    }
    if (removeContainer) {
      out.remove(containerKey);
    }
  }

  return out;
}

/// Preset daftar kunci yang umum diangkat per-model.
/// Tambahkan model lain seiring kebutuhan.
const Map<String, List<String>> _liftKeysRegistry = {
  'user': [
    'user_detail',
    'user_preferences',
    'user_saved',
    'user_settings',
    'user_notification',
  ],
  'place': [
    'place_detail',
    'place_value',
    'food_type',
    'menu_image_url',
    'menu',
    'place_attributes',
  ],
  // contoh: 'review': [], 'checkin': []
};

/// Flatten dengan preset berdasarkan nama model.
/// - [modelKey] contoh: 'user', 'place'
/// - [containerKey] default 'additional_info'
Json flattenByModelPreset(
  Json src, {
  required String modelKey,
  String containerKey = 'additional_info',
  bool removeContainer = false,
}) {
  final keys = _liftKeysRegistry[modelKey] ?? const <String>[];
  return flattenContainerKeys(
    src,
    containerKey: containerKey,
    keysToLift: keys,
    removeContainer: removeContainer,
  );
}

/// Versi yang lebih eksplisit per model (sintaks manis).
Json flattenAdditionalInfoForUser(
  Json src, {
  bool removeContainer = false,
}) {
  return flattenByModelPreset(
    src,
    modelKey: 'user',
    containerKey: 'additional_info',
    removeContainer: removeContainer,
  );
}

Json flattenAdditionalInfoForPlace(
  Json src, {
  bool removeContainer = false,
}) {
  return flattenByModelPreset(
    src,
    modelKey: 'place',
    containerKey: 'additional_info',
    removeContainer: removeContainer,
  );
}
