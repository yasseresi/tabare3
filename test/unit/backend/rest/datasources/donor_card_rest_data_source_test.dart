import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/backend/rest/constants/rest_paths.dart';
import 'package:tabare3/backend/rest/datasources/donor_card_rest_data_source.dart';

class MockDio extends Mock implements Dio {}

Response<T> _res<T>(String path, T body) => Response<T>(
  requestOptions: RequestOptions(path: path),
  statusCode: 200,
  data: body,
);

const _cardJson = {
  'points_balance': 12,
  'donations_count': 1,
  'level': {'level_number': 2, 'title_ar': 'متبرع نشط', 'min_points': 10},
  'badges': [
    {
      'id': 107,
      'badge': {'id': 2, 'code': 'level_2', 'name_ar': 'متبرع نشط', 'description': 'وصف', 'icon_url': '', 'level': 2},
      'awarded_at': '2026-08-14T23:04:31.805427+01:00',
    },
  ],
};

const _levelsJson = [
  {'id': 1, 'level_number': 1, 'title_ar': 'قطرة أمل', 'min_points': 0, 'icon_url': ''},
  {'id': 2, 'level_number': 2, 'title_ar': 'متبرع نشط', 'min_points': 10, 'icon_url': ''},
];

void main() {
  late MockDio dio;
  late DonorCardRestDataSource source;

  setUp(() {
    dio = MockDio();
    source = DonorCardRestDataSource(dio);
    when(() => dio.get<Map<String, dynamic>>(RestPaths.donorCard))
        .thenAnswer((_) async => _res(RestPaths.donorCard, _cardJson));
    when(() => dio.get<List<dynamic>>(RestPaths.levels))
        .thenAnswer((_) async => _res(RestPaths.levels, _levelsJson));
  });

  test('getDonorCard merges /donor-card/ summary+badges with /levels/', () async {
    final card = await source.getDonorCard();

    expect(card.summary.totalPoints, 12);
    expect(card.summary.totalDonations, 1);
    // full ladder from /levels/
    expect(card.levels, hasLength(2));
    expect(card.levels.first.nameAr, 'قطرة أمل'); // title_ar → name_ar
    // earned badges from the card
    expect(card.badges, hasLength(1));
    expect(card.badges.single.badge.nameAr, 'متبرع نشط');
    expect(card.badges.single.badge.descriptionAr, 'وصف');
  });

  test('empty icon_url maps to null', () async {
    final card = await source.getDonorCard();
    expect(card.levels.first.iconUrl, isNull);
    expect(card.badges.single.badge.iconUrl, isNull);
  });
}
