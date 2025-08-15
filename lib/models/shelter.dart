import 'package:freezed_annotation/freezed_annotation.dart';

part 'shelter.freezed.dart';
part 'shelter.g.dart';

enum ShelterType { emergency, relief, medical, food, temporary }

enum ShelterStatus { open, full, closed, maintenance }

@freezed
class Shelter with _$Shelter {
  const factory Shelter({
    required String id,
    required String name,
    required String description,
    required ShelterType type,
    required double latitude,
    required double longitude,
    required String address,
    required ShelterStatus status,
    required int capacity,
    required int currentOccupancy,
    String? contactNumber,
    String? contactPerson,
    List<String>? amenities,
    String? imageUrl,
    DateTime? lastUpdated,
    Map<String, dynamic>? additionalInfo,
  }) = _Shelter;

  factory Shelter.fromJson(Map<String, dynamic> json) =>
      _$ShelterFromJson(json);
} 