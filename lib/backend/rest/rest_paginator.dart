import 'package:dio/dio.dart';

/// Hard cap on pages followed — fail safe if a backend bug returns a stable
/// `next`, so pagination can never loop forever.
const int _maxPages = 1000;

/// Follows DRF pagination: fetches [path], then every `next` page, accumulating
/// each page's `results`. [query] is applied to the first request only — the
/// `next` URL already carries it.
///
/// `next` arrives as an absolute URL derived from the request Host. To stop a
/// forged/misconfigured `next` from leaking the bearer to a foreign host, a
/// `next` whose origin differs from the API base is not followed.
///
/// Shared by every REST data source that reads a paginated list endpoint.
Future<List<Map<String, dynamic>>> fetchAllPages(
  Dio dio,
  String path, {
  Map<String, dynamic>? query,
}) async {
  final apiBase = Uri.tryParse(dio.options.baseUrl);
  final all = <Map<String, dynamic>>[];
  String? url = path;
  var params = query;
  var pages = 0;
  while (url != null && pages < _maxPages) {
    final response = await dio.get<Map<String, dynamic>>(
      url,
      queryParameters: params,
    );
    final data = response.data ?? const {};
    final results = data['results'];
    if (results is List) {
      all.addAll(results.whereType<Map<String, dynamic>>());
    }
    final next = data['next'] as String?;
    url = (next != null && _sameOrigin(apiBase, next)) ? next : null;
    params = null;
    pages++;
  }
  return all;
}

/// Whether an absolute [next] URL targets the same origin as the API base. A
/// relative `next` (no host) is same-origin by definition.
bool _sameOrigin(Uri? apiBase, String next) {
  final target = Uri.tryParse(next);
  if (target == null) return false;
  if (!target.hasAuthority) return true;
  if (apiBase == null) return false;
  return target.scheme == apiBase.scheme &&
      target.host == apiBase.host &&
      target.port == apiBase.port;
}
