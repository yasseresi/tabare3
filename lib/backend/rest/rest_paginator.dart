import 'package:dio/dio.dart';

/// Follows DRF pagination: fetches [path], then every `next` page, accumulating
/// each page's `results`. [query] is applied to the first request only — the
/// `next` URL already carries it.
///
/// Shared by every REST data source that reads a paginated list endpoint.
Future<List<Map<String, dynamic>>> fetchAllPages(
  Dio dio,
  String path, {
  Map<String, dynamic>? query,
}) async {
  final all = <Map<String, dynamic>>[];
  String? url = path;
  var params = query;
  while (url != null) {
    final response = await dio.get<Map<String, dynamic>>(
      url,
      queryParameters: params,
    );
    final data = response.data ?? const {};
    final results = data['results'];
    if (results is List) {
      all.addAll(results.whereType<Map<String, dynamic>>());
    }
    url = data['next'] as String?;
    params = null;
  }
  return all;
}
