import 'package:flutter_test/flutter_test.dart';
import 'package:upazila_app/core/utils/semver.dart';

void main() {
  group('SemVer.tryParse', () {
    test('parses plain and prefixed versions', () {
      expect(SemVer.tryParse('1.2.3'), const SemVer(1, 2, 3));
      expect(SemVer.tryParse('v1.2.3'), const SemVer(1, 2, 3));
      expect(SemVer.tryParse(' 0.1.0 '), const SemVer(0, 1, 0));
    });

    test('ignores build metadata and pre-release tags', () {
      expect(SemVer.tryParse('0.1.0+1'), const SemVer(0, 1, 0));
      expect(SemVer.tryParse('1.0.0-beta.2'), const SemVer(1, 0, 0));
    });

    test('pads missing components', () {
      expect(SemVer.tryParse('2'), const SemVer(2, 0, 0));
      expect(SemVer.tryParse('2.5'), const SemVer(2, 5, 0));
    });

    test('rejects garbage', () {
      expect(SemVer.tryParse(''), isNull);
      expect(SemVer.tryParse('a.b.c'), isNull);
      expect(SemVer.tryParse('1.2.3.4'), isNull);
      expect(SemVer.tryParse('-1.0.0'), isNull);
      expect(() => SemVer.parse('nope'), throwsFormatException);
    });
  });

  group('SemVer ordering', () {
    test('compares major, then minor, then patch', () {
      expect(const SemVer(1, 0, 0) < const SemVer(2, 0, 0), isTrue);
      expect(const SemVer(1, 2, 0) < const SemVer(1, 10, 0), isTrue);
      expect(const SemVer(1, 2, 3) > const SemVer(1, 2, 2), isTrue);
      expect(const SemVer(1, 2, 3) >= const SemVer(1, 2, 3), isTrue);
      expect(const SemVer(1, 2, 3) == const SemVer(1, 2, 3), isTrue);
    });
  });

  group('isUpdateRequired', () {
    test('blocks when installed is below the minimum', () {
      expect(isUpdateRequired(installed: '0.1.0', minimumSupported: '0.2.0'), isTrue);
      expect(isUpdateRequired(installed: '1.9.9', minimumSupported: '2.0.0'), isTrue);
    });

    test('allows equal or newer versions', () {
      expect(isUpdateRequired(installed: '0.2.0', minimumSupported: '0.2.0'), isFalse);
      expect(isUpdateRequired(installed: '0.2.1+7', minimumSupported: '0.2.0'), isFalse);
    });

    test('fails open on unparseable input', () {
      expect(isUpdateRequired(installed: '0.1.0', minimumSupported: ''), isFalse);
      expect(isUpdateRequired(installed: 'dev', minimumSupported: '9.9.9'), isFalse);
    });
  });
}
