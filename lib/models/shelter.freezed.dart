// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shelter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Shelter _$ShelterFromJson(Map<String, dynamic> json) {
  return _Shelter.fromJson(json);
}

/// @nodoc
mixin _$Shelter {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  ShelterType get type => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  ShelterStatus get status => throw _privateConstructorUsedError;
  int get capacity => throw _privateConstructorUsedError;
  int get currentOccupancy => throw _privateConstructorUsedError;
  String? get contactNumber => throw _privateConstructorUsedError;
  String? get contactPerson => throw _privateConstructorUsedError;
  List<String>? get amenities => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  DateTime? get lastUpdated => throw _privateConstructorUsedError;
  Map<String, dynamic>? get additionalInfo =>
      throw _privateConstructorUsedError;

  /// Serializes this Shelter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Shelter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShelterCopyWith<Shelter> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShelterCopyWith<$Res> {
  factory $ShelterCopyWith(Shelter value, $Res Function(Shelter) then) =
      _$ShelterCopyWithImpl<$Res, Shelter>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      ShelterType type,
      double latitude,
      double longitude,
      String address,
      ShelterStatus status,
      int capacity,
      int currentOccupancy,
      String? contactNumber,
      String? contactPerson,
      List<String>? amenities,
      String? imageUrl,
      DateTime? lastUpdated,
      Map<String, dynamic>? additionalInfo});
}

/// @nodoc
class _$ShelterCopyWithImpl<$Res, $Val extends Shelter>
    implements $ShelterCopyWith<$Res> {
  _$ShelterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Shelter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? type = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? address = null,
    Object? status = null,
    Object? capacity = null,
    Object? currentOccupancy = null,
    Object? contactNumber = freezed,
    Object? contactPerson = freezed,
    Object? amenities = freezed,
    Object? imageUrl = freezed,
    Object? lastUpdated = freezed,
    Object? additionalInfo = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ShelterType,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ShelterStatus,
      capacity: null == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int,
      currentOccupancy: null == currentOccupancy
          ? _value.currentOccupancy
          : currentOccupancy // ignore: cast_nullable_to_non_nullable
              as int,
      contactNumber: freezed == contactNumber
          ? _value.contactNumber
          : contactNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      contactPerson: freezed == contactPerson
          ? _value.contactPerson
          : contactPerson // ignore: cast_nullable_to_non_nullable
              as String?,
      amenities: freezed == amenities
          ? _value.amenities
          : amenities // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      additionalInfo: freezed == additionalInfo
          ? _value.additionalInfo
          : additionalInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShelterImplCopyWith<$Res> implements $ShelterCopyWith<$Res> {
  factory _$$ShelterImplCopyWith(
          _$ShelterImpl value, $Res Function(_$ShelterImpl) then) =
      __$$ShelterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      ShelterType type,
      double latitude,
      double longitude,
      String address,
      ShelterStatus status,
      int capacity,
      int currentOccupancy,
      String? contactNumber,
      String? contactPerson,
      List<String>? amenities,
      String? imageUrl,
      DateTime? lastUpdated,
      Map<String, dynamic>? additionalInfo});
}

/// @nodoc
class __$$ShelterImplCopyWithImpl<$Res>
    extends _$ShelterCopyWithImpl<$Res, _$ShelterImpl>
    implements _$$ShelterImplCopyWith<$Res> {
  __$$ShelterImplCopyWithImpl(
      _$ShelterImpl _value, $Res Function(_$ShelterImpl) _then)
      : super(_value, _then);

  /// Create a copy of Shelter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? type = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? address = null,
    Object? status = null,
    Object? capacity = null,
    Object? currentOccupancy = null,
    Object? contactNumber = freezed,
    Object? contactPerson = freezed,
    Object? amenities = freezed,
    Object? imageUrl = freezed,
    Object? lastUpdated = freezed,
    Object? additionalInfo = freezed,
  }) {
    return _then(_$ShelterImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ShelterType,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ShelterStatus,
      capacity: null == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int,
      currentOccupancy: null == currentOccupancy
          ? _value.currentOccupancy
          : currentOccupancy // ignore: cast_nullable_to_non_nullable
              as int,
      contactNumber: freezed == contactNumber
          ? _value.contactNumber
          : contactNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      contactPerson: freezed == contactPerson
          ? _value.contactPerson
          : contactPerson // ignore: cast_nullable_to_non_nullable
              as String?,
      amenities: freezed == amenities
          ? _value._amenities
          : amenities // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      additionalInfo: freezed == additionalInfo
          ? _value._additionalInfo
          : additionalInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShelterImpl implements _Shelter {
  const _$ShelterImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.type,
      required this.latitude,
      required this.longitude,
      required this.address,
      required this.status,
      required this.capacity,
      required this.currentOccupancy,
      this.contactNumber,
      this.contactPerson,
      final List<String>? amenities,
      this.imageUrl,
      this.lastUpdated,
      final Map<String, dynamic>? additionalInfo})
      : _amenities = amenities,
        _additionalInfo = additionalInfo;

  factory _$ShelterImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShelterImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final ShelterType type;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String address;
  @override
  final ShelterStatus status;
  @override
  final int capacity;
  @override
  final int currentOccupancy;
  @override
  final String? contactNumber;
  @override
  final String? contactPerson;
  final List<String>? _amenities;
  @override
  List<String>? get amenities {
    final value = _amenities;
    if (value == null) return null;
    if (_amenities is EqualUnmodifiableListView) return _amenities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? imageUrl;
  @override
  final DateTime? lastUpdated;
  final Map<String, dynamic>? _additionalInfo;
  @override
  Map<String, dynamic>? get additionalInfo {
    final value = _additionalInfo;
    if (value == null) return null;
    if (_additionalInfo is EqualUnmodifiableMapView) return _additionalInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Shelter(id: $id, name: $name, description: $description, type: $type, latitude: $latitude, longitude: $longitude, address: $address, status: $status, capacity: $capacity, currentOccupancy: $currentOccupancy, contactNumber: $contactNumber, contactPerson: $contactPerson, amenities: $amenities, imageUrl: $imageUrl, lastUpdated: $lastUpdated, additionalInfo: $additionalInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShelterImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            (identical(other.currentOccupancy, currentOccupancy) ||
                other.currentOccupancy == currentOccupancy) &&
            (identical(other.contactNumber, contactNumber) ||
                other.contactNumber == contactNumber) &&
            (identical(other.contactPerson, contactPerson) ||
                other.contactPerson == contactPerson) &&
            const DeepCollectionEquality()
                .equals(other._amenities, _amenities) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            const DeepCollectionEquality()
                .equals(other._additionalInfo, _additionalInfo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      type,
      latitude,
      longitude,
      address,
      status,
      capacity,
      currentOccupancy,
      contactNumber,
      contactPerson,
      const DeepCollectionEquality().hash(_amenities),
      imageUrl,
      lastUpdated,
      const DeepCollectionEquality().hash(_additionalInfo));

  /// Create a copy of Shelter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShelterImplCopyWith<_$ShelterImpl> get copyWith =>
      __$$ShelterImplCopyWithImpl<_$ShelterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShelterImplToJson(
      this,
    );
  }
}

abstract class _Shelter implements Shelter {
  const factory _Shelter(
      {required final String id,
      required final String name,
      required final String description,
      required final ShelterType type,
      required final double latitude,
      required final double longitude,
      required final String address,
      required final ShelterStatus status,
      required final int capacity,
      required final int currentOccupancy,
      final String? contactNumber,
      final String? contactPerson,
      final List<String>? amenities,
      final String? imageUrl,
      final DateTime? lastUpdated,
      final Map<String, dynamic>? additionalInfo}) = _$ShelterImpl;

  factory _Shelter.fromJson(Map<String, dynamic> json) = _$ShelterImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  ShelterType get type;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String get address;
  @override
  ShelterStatus get status;
  @override
  int get capacity;
  @override
  int get currentOccupancy;
  @override
  String? get contactNumber;
  @override
  String? get contactPerson;
  @override
  List<String>? get amenities;
  @override
  String? get imageUrl;
  @override
  DateTime? get lastUpdated;
  @override
  Map<String, dynamic>? get additionalInfo;

  /// Create a copy of Shelter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShelterImplCopyWith<_$ShelterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
