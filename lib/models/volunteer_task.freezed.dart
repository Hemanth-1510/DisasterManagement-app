// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'volunteer_task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VolunteerTask _$VolunteerTaskFromJson(Map<String, dynamic> json) {
  return _VolunteerTask.fromJson(json);
}

/// @nodoc
mixin _$VolunteerTask {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  TaskType get type => throw _privateConstructorUsedError;
  String get incidentReportId => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  TaskStatus get status => throw _privateConstructorUsedError;
  String? get assignedVolunteerId => throw _privateConstructorUsedError;
  String? get assignedVolunteerName => throw _privateConstructorUsedError;
  DateTime? get assignedAt => throw _privateConstructorUsedError;
  DateTime? get startedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  int? get priority => throw _privateConstructorUsedError; // 1-5 scale
  Map<String, dynamic>? get requirements => throw _privateConstructorUsedError;

  /// Serializes this VolunteerTask to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VolunteerTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VolunteerTaskCopyWith<VolunteerTask> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VolunteerTaskCopyWith<$Res> {
  factory $VolunteerTaskCopyWith(
          VolunteerTask value, $Res Function(VolunteerTask) then) =
      _$VolunteerTaskCopyWithImpl<$Res, VolunteerTask>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      TaskType type,
      String incidentReportId,
      double latitude,
      double longitude,
      String address,
      DateTime createdAt,
      TaskStatus status,
      String? assignedVolunteerId,
      String? assignedVolunteerName,
      DateTime? assignedAt,
      DateTime? startedAt,
      DateTime? completedAt,
      String? notes,
      int? priority,
      Map<String, dynamic>? requirements});
}

/// @nodoc
class _$VolunteerTaskCopyWithImpl<$Res, $Val extends VolunteerTask>
    implements $VolunteerTaskCopyWith<$Res> {
  _$VolunteerTaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VolunteerTask
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? type = null,
    Object? incidentReportId = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? address = null,
    Object? createdAt = null,
    Object? status = null,
    Object? assignedVolunteerId = freezed,
    Object? assignedVolunteerName = freezed,
    Object? assignedAt = freezed,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? notes = freezed,
    Object? priority = freezed,
    Object? requirements = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TaskType,
      incidentReportId: null == incidentReportId
          ? _value.incidentReportId
          : incidentReportId // ignore: cast_nullable_to_non_nullable
              as String,
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
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TaskStatus,
      assignedVolunteerId: freezed == assignedVolunteerId
          ? _value.assignedVolunteerId
          : assignedVolunteerId // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedVolunteerName: freezed == assignedVolunteerName
          ? _value.assignedVolunteerName
          : assignedVolunteerName // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedAt: freezed == assignedAt
          ? _value.assignedAt
          : assignedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int?,
      requirements: freezed == requirements
          ? _value.requirements
          : requirements // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VolunteerTaskImplCopyWith<$Res>
    implements $VolunteerTaskCopyWith<$Res> {
  factory _$$VolunteerTaskImplCopyWith(
          _$VolunteerTaskImpl value, $Res Function(_$VolunteerTaskImpl) then) =
      __$$VolunteerTaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      TaskType type,
      String incidentReportId,
      double latitude,
      double longitude,
      String address,
      DateTime createdAt,
      TaskStatus status,
      String? assignedVolunteerId,
      String? assignedVolunteerName,
      DateTime? assignedAt,
      DateTime? startedAt,
      DateTime? completedAt,
      String? notes,
      int? priority,
      Map<String, dynamic>? requirements});
}

/// @nodoc
class __$$VolunteerTaskImplCopyWithImpl<$Res>
    extends _$VolunteerTaskCopyWithImpl<$Res, _$VolunteerTaskImpl>
    implements _$$VolunteerTaskImplCopyWith<$Res> {
  __$$VolunteerTaskImplCopyWithImpl(
      _$VolunteerTaskImpl _value, $Res Function(_$VolunteerTaskImpl) _then)
      : super(_value, _then);

  /// Create a copy of VolunteerTask
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? type = null,
    Object? incidentReportId = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? address = null,
    Object? createdAt = null,
    Object? status = null,
    Object? assignedVolunteerId = freezed,
    Object? assignedVolunteerName = freezed,
    Object? assignedAt = freezed,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? notes = freezed,
    Object? priority = freezed,
    Object? requirements = freezed,
  }) {
    return _then(_$VolunteerTaskImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TaskType,
      incidentReportId: null == incidentReportId
          ? _value.incidentReportId
          : incidentReportId // ignore: cast_nullable_to_non_nullable
              as String,
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
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TaskStatus,
      assignedVolunteerId: freezed == assignedVolunteerId
          ? _value.assignedVolunteerId
          : assignedVolunteerId // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedVolunteerName: freezed == assignedVolunteerName
          ? _value.assignedVolunteerName
          : assignedVolunteerName // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedAt: freezed == assignedAt
          ? _value.assignedAt
          : assignedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int?,
      requirements: freezed == requirements
          ? _value._requirements
          : requirements // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VolunteerTaskImpl implements _VolunteerTask {
  const _$VolunteerTaskImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.type,
      required this.incidentReportId,
      required this.latitude,
      required this.longitude,
      required this.address,
      required this.createdAt,
      required this.status,
      this.assignedVolunteerId,
      this.assignedVolunteerName,
      this.assignedAt,
      this.startedAt,
      this.completedAt,
      this.notes,
      this.priority,
      final Map<String, dynamic>? requirements})
      : _requirements = requirements;

  factory _$VolunteerTaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$VolunteerTaskImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final TaskType type;
  @override
  final String incidentReportId;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String address;
  @override
  final DateTime createdAt;
  @override
  final TaskStatus status;
  @override
  final String? assignedVolunteerId;
  @override
  final String? assignedVolunteerName;
  @override
  final DateTime? assignedAt;
  @override
  final DateTime? startedAt;
  @override
  final DateTime? completedAt;
  @override
  final String? notes;
  @override
  final int? priority;
// 1-5 scale
  final Map<String, dynamic>? _requirements;
// 1-5 scale
  @override
  Map<String, dynamic>? get requirements {
    final value = _requirements;
    if (value == null) return null;
    if (_requirements is EqualUnmodifiableMapView) return _requirements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'VolunteerTask(id: $id, title: $title, description: $description, type: $type, incidentReportId: $incidentReportId, latitude: $latitude, longitude: $longitude, address: $address, createdAt: $createdAt, status: $status, assignedVolunteerId: $assignedVolunteerId, assignedVolunteerName: $assignedVolunteerName, assignedAt: $assignedAt, startedAt: $startedAt, completedAt: $completedAt, notes: $notes, priority: $priority, requirements: $requirements)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VolunteerTaskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.incidentReportId, incidentReportId) ||
                other.incidentReportId == incidentReportId) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.assignedVolunteerId, assignedVolunteerId) ||
                other.assignedVolunteerId == assignedVolunteerId) &&
            (identical(other.assignedVolunteerName, assignedVolunteerName) ||
                other.assignedVolunteerName == assignedVolunteerName) &&
            (identical(other.assignedAt, assignedAt) ||
                other.assignedAt == assignedAt) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            const DeepCollectionEquality()
                .equals(other._requirements, _requirements));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      type,
      incidentReportId,
      latitude,
      longitude,
      address,
      createdAt,
      status,
      assignedVolunteerId,
      assignedVolunteerName,
      assignedAt,
      startedAt,
      completedAt,
      notes,
      priority,
      const DeepCollectionEquality().hash(_requirements));

  /// Create a copy of VolunteerTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VolunteerTaskImplCopyWith<_$VolunteerTaskImpl> get copyWith =>
      __$$VolunteerTaskImplCopyWithImpl<_$VolunteerTaskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VolunteerTaskImplToJson(
      this,
    );
  }
}

abstract class _VolunteerTask implements VolunteerTask {
  const factory _VolunteerTask(
      {required final String id,
      required final String title,
      required final String description,
      required final TaskType type,
      required final String incidentReportId,
      required final double latitude,
      required final double longitude,
      required final String address,
      required final DateTime createdAt,
      required final TaskStatus status,
      final String? assignedVolunteerId,
      final String? assignedVolunteerName,
      final DateTime? assignedAt,
      final DateTime? startedAt,
      final DateTime? completedAt,
      final String? notes,
      final int? priority,
      final Map<String, dynamic>? requirements}) = _$VolunteerTaskImpl;

  factory _VolunteerTask.fromJson(Map<String, dynamic> json) =
      _$VolunteerTaskImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  TaskType get type;
  @override
  String get incidentReportId;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String get address;
  @override
  DateTime get createdAt;
  @override
  TaskStatus get status;
  @override
  String? get assignedVolunteerId;
  @override
  String? get assignedVolunteerName;
  @override
  DateTime? get assignedAt;
  @override
  DateTime? get startedAt;
  @override
  DateTime? get completedAt;
  @override
  String? get notes;
  @override
  int? get priority; // 1-5 scale
  @override
  Map<String, dynamic>? get requirements;

  /// Create a copy of VolunteerTask
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VolunteerTaskImplCopyWith<_$VolunteerTaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
