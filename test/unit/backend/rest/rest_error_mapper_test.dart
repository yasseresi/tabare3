import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tabare3/backend/rest/rest_error_mapper.dart';
import 'package:tabare3/core/backend/backend_error_mapper.dart';
import 'package:tabare3/core/error/failures.dart';

DioException _badResponse(int status, Object? data) {
  final requestOptions = RequestOptions(path: '/auth/register/');
  return DioException(
    requestOptions: requestOptions,
    type: DioExceptionType.badResponse,
    response: Response(
      requestOptions: requestOptions,
      statusCode: status,
      data: data,
    ),
  );
}

void main() {
  const mapper = RestErrorMapper();

  group('RestErrorMapper — DRF field errors', () {
    test('surfaces per-field messages and carries the field keys', () {
      final failure = mapper.map(
        _badResponse(400, {
          'phone': ['رقم الهاتف موجود مسبقاً.'],
          'first_name': ['الاسم قصير جدًا.'],
        }),
      );

      expect(failure, isA<ValidationFailure>());
      failure as ValidationFailure;
      expect(failure.message, contains('رقم الهاتف موجود مسبقاً.'));
      expect(failure.message, contains('الاسم قصير جدًا.'));
      expect(failure.fields, containsAll(<String>['phone', 'first_name']));
    });

    test('handles a form-level {detail: ...} body without a field key', () {
      final failure = mapper.map(_badResponse(400, {'detail': 'رمز غير صالح.'}));

      expect(failure, isA<ValidationFailure>());
      failure as ValidationFailure;
      expect(failure.message, 'رمز غير صالح.');
      expect(failure.fields, isEmpty);
    });

    test('422 is treated the same as 400', () {
      final failure = mapper.map(
        _badResponse(422, {
          'weight_kg': ['تأكد من أن هذه القيمة أقل من أو تساوي 3 أرقام.'],
        }),
      );

      expect(failure, isA<ValidationFailure>());
      expect((failure! as ValidationFailure).fields, contains('weight_kg'));
    });

    test('falls back to the generic message when the body has no text', () {
      final failure = mapper.map(_badResponse(400, null));

      expect(failure, isA<ValidationFailure>());
      expect((failure! as ValidationFailure).fields, isEmpty);
      expect(failure.message, isNotEmpty);
    });

    test('sign-in path stays masked and never leaks field errors', () {
      final failure = mapper.map(
        _badResponse(400, {
          'email': ['هذا الحقل مطلوب.'],
        }),
        operation: BackendOperation.signIn,
      );

      expect(failure, isA<AuthFailure>());
      expect(failure!.message, isNot(contains('email')));
    });
  });
}
