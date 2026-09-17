/// Minimal semantic version used by the min-supported-app-version gate
/// (Section 8.7). Build metadata (`+1`) and pre-release tags are ignored for
/// ordering purposes; only `major.minor.patch` matters for compatibility.
class SemVer implements Comparable<SemVer> {
  const SemVer(this.major, this.minor, this.patch);

  final int major;
  final int minor;
  final int patch;

  static SemVer? tryParse(String raw) {
    var text = raw.trim();
    if (text.startsWith('v') || text.startsWith('V')) text = text.substring(1);
    final plus = text.indexOf('+');
    if (plus >= 0) text = text.substring(0, plus);
    final dash = text.indexOf('-');
    if (dash >= 0) text = text.substring(0, dash);
    if (text.isEmpty) return null;

    final parts = text.split('.');
    if (parts.length > 3) return null;
    final numbers = <int>[];
    for (final part in parts) {
      final n = int.tryParse(part);
      if (n == null || n < 0) return null;
      numbers.add(n);
    }
    while (numbers.length < 3) {
      numbers.add(0);
    }
    return SemVer(numbers[0], numbers[1], numbers[2]);
  }

  static SemVer parse(String raw) {
    final parsed = tryParse(raw);
    if (parsed == null) throw FormatException('Invalid semantic version: $raw');
    return parsed;
  }

  @override
  int compareTo(SemVer other) {
    if (major != other.major) return major.compareTo(other.major);
    if (minor != other.minor) return minor.compareTo(other.minor);
    return patch.compareTo(other.patch);
  }

  bool operator <(SemVer other) => compareTo(other) < 0;
  bool operator >(SemVer other) => compareTo(other) > 0;
  bool operator <=(SemVer other) => compareTo(other) <= 0;
  bool operator >=(SemVer other) => compareTo(other) >= 0;

  @override
  bool operator ==(Object other) => other is SemVer && compareTo(other) == 0;

  @override
  int get hashCode => Object.hash(major, minor, patch);

  @override
  String toString() => '$major.$minor.$patch';
}

/// `true` when [installed] is older than [minimumSupported]. Unparseable input
/// fails open (never blocks the user because of a malformed config value).
bool isUpdateRequired({required String installed, required String minimumSupported}) {
  final current = SemVer.tryParse(installed);
  final minimum = SemVer.tryParse(minimumSupported);
  if (current == null || minimum == null) return false;
  return current < minimum;
}
