import 'package:flutter_test/flutter_test.dart';
import 'package:upazila_app/core/utils/phone.dart';

void main() {
  group('normalizeBdPhone', () {
    test('accepts local, 880 and +880 forms', () {
      expect(normalizeBdPhone('01712345678'), '+8801712345678');
      expect(normalizeBdPhone('8801712345678'), '+8801712345678');
      expect(normalizeBdPhone('+8801712345678'), '+8801712345678');
    });

    test('strips spaces, dashes and parentheses', () {
      expect(normalizeBdPhone(' 017-1234 5678 '), '+8801712345678');
      expect(normalizeBdPhone('(+880) 1712-345678'), '+8801712345678');
    });

    test('rejects non-BD and malformed numbers', () {
      expect(normalizeBdPhone('+11234567890'), isNull);
      expect(normalizeBdPhone('0171234567'), isNull); // too short
      expect(normalizeBdPhone('017123456789'), isNull); // too long
      expect(normalizeBdPhone('01212345678'), isNull); // invalid operator prefix
      expect(normalizeBdPhone(''), isNull);
      expect(normalizeBdPhone('abc'), isNull);
    });
  });

  group('maskPhone', () {
    test('keeps country code + operator prefix and last three digits', () {
      expect(maskPhone('+8801712345678'), '+88017****678');
    });

    test('fully masks very short values', () {
      expect(maskPhone('12345'), '*****');
    });
  });
}
