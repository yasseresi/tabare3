/// Plain DTOs for the REST backend's reference tables.
///
/// Only the REST backend needs these: Django stores `wilaya` / `blood_type` as
/// integer foreign keys, so the app's Arabic name / "O+" label must be resolved
/// to an id before register or request-create. The Supabase backend stored the
/// strings directly and never needed them.
class WilayaRef {
  const WilayaRef({
    required this.id,
    required this.code,
    required this.nameAr,
    required this.nameFr,
    required this.nameEn,
  });

  final int id;
  final String code;
  final String nameAr;
  final String nameFr;
  final String nameEn;

  factory WilayaRef.fromJson(Map<String, dynamic> json) => WilayaRef(
    id: _asInt(json['id']) ?? 0,
    code: json['code']?.toString() ?? '',
    nameAr: json['name_ar']?.toString() ?? '',
    nameFr: json['name_fr']?.toString() ?? '',
    nameEn: json['name_en']?.toString() ?? '',
  );
}

class BloodTypeRef {
  const BloodTypeRef({required this.id, required this.label});

  final int id;
  final String label;

  factory BloodTypeRef.fromJson(Map<String, dynamic> json) => BloodTypeRef(
    id: _asInt(json['id']) ?? 0,
    label: json['label']?.toString() ?? '',
  );
}

/// Backends are loose about int vs string — parse defensively.
int? _asInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString());
}
