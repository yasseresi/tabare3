import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabare3/backend/supabase/supabase_error_mapper.dart';

void main() {
  const mapper = SupabaseErrorMapper();

  test('maps redeem QR domain codes to localized donor messages', () {
    expect(
      mapper.map(PostgrestException(message: 'qr_already_used', code: 'P0001'))
          ?.message,
      'تم استخدام هذا الرمز من قبل.',
    );
    expect(
      mapper.map(PostgrestException(message: 'qr_expired', code: 'P0001'))
          ?.message,
      'انتهت صلاحية الرمز.',
    );
    expect(
      mapper
          .map(PostgrestException(message: 'appointment_required', code: 'P0001'))
          ?.message,
      'لا يوجد موعد مؤكد لهذا الطلب.',
    );
    expect(
      mapper.map(PostgrestException(message: 'qr_invalid', code: 'P0001'))
          ?.message,
      'رمز غير صالح.',
    );
  });

  test('unknown database errors still fall back to the generic message', () {
    expect(
      mapper.map(PostgrestException(message: 'something else', code: 'P0001'))
          ?.message,
      'خطأ في قاعدة البيانات',
    );
  });
}
