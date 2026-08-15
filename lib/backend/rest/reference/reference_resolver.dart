import 'reference_models.dart';
import 'reference_remote_data_source.dart';

/// Resolves the app's human-readable reference strings (Arabic wilaya name,
/// "O+" blood label) to the integer ids the REST backend's foreign keys expect.
///
/// Each list is fetched once and cached for the process lifetime — reference
/// data is effectively static. Lookups are normalised (trimmed, case-folded) so
/// stray whitespace or casing never misses a match.
class ReferenceResolver {
  ReferenceResolver(this._source);

  final ReferenceRemoteDataSource _source;

  Map<String, int>? _wilayaByName;
  Map<String, int>? _bloodTypeByLabel;

  Future<int?> wilayaIdForName(String name) async {
    final map = _wilayaByName ??= _indexWilayas(await _source.listWilayas());
    return map[_norm(name)];
  }

  Future<int?> bloodTypeIdForLabel(String label) async {
    final map =
        _bloodTypeByLabel ??= _indexBloodTypes(await _source.listBloodTypes());
    return map[_norm(label)];
  }

  Map<String, int> _indexWilayas(List<WilayaRef> list) => {
    for (final w in list) _norm(w.nameAr): w.id,
  };

  Map<String, int> _indexBloodTypes(List<BloodTypeRef> list) => {
    for (final b in list) _norm(b.label): b.id,
  };

  String _norm(String value) => value.trim().toLowerCase();
}
