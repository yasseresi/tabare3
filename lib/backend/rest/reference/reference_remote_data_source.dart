import 'package:dio/dio.dart';

import '../constants/rest_paths.dart';
import 'reference_models.dart';

/// Fetches the REST backend's reference tables.
///
/// Both endpoints return a plain JSON array (no pagination wrapper).
abstract class ReferenceRemoteDataSource {
  Future<List<WilayaRef>> listWilayas();
  Future<List<BloodTypeRef>> listBloodTypes();
}

class ReferenceRestDataSource implements ReferenceRemoteDataSource {
  ReferenceRestDataSource(this.dio);

  final Dio dio;

  @override
  Future<List<WilayaRef>> listWilayas() async {
    final response = await dio.get<List<dynamic>>(RestPaths.refWilayas);
    return _mapList(response.data, WilayaRef.fromJson);
  }

  @override
  Future<List<BloodTypeRef>> listBloodTypes() async {
    final response = await dio.get<List<dynamic>>(RestPaths.refBloodTypes);
    return _mapList(response.data, BloodTypeRef.fromJson);
  }

  List<T> _mapList<T>(
    List<dynamic>? data,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (data == null) return const [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(fromJson)
        .toList(growable: false);
  }
}
