import 'package:freezed_annotation/freezed_annotation.dart';
part 'alert.freezed.dart';
part 'alert.g.dart';

@freezed
class Alert with _$Alert {
  const factory Alert({
    required String id,
    required String title,
    required String description,
    required DateTime issuedAt,
    required String severity,      // “advisory”, “watch”, “warning”
    required String type,          // “flood”, “cyclone”, …
    required double lat,
    required double lng,
  }) = _Alert;

  factory Alert.fromJson(Map<String, dynamic> json) =>
      _$AlertFromJson(json);
}
