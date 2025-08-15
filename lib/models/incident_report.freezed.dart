// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'incident_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

IncidentReport _$IncidentReportFromJson(Map<String, dynamic> json) {
  return _IncidentReport.fromJson(json);
}

/// @nodoc
mixin _$IncidentReport {
  String get id => throw _privateConstructorUsedError;
  String get reporterId => throw _privateConstructorUsedError;
  String get reporterName => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  IncidentType get type => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  DateTime get reportedAt => throw _privateConstructorUsedError;
  ReportStatus get status => throw _privateConstructorUsedError;
  List<String>? get imageUrls => throw _privateConstructorUsedError;
  List<String>? get videoUrls => throw _privateConstructorUsedError;
  String? get audioUrl => throw _privateConstructorUsedError;
  int? get severity => throw _privateConstructorUsedError; // 1-5 scale
  String? get assignedVolunteerId => throw _privateConstructorUsedError;
  String? get authorityNotes => throw _privateConstructorUsedError;
  DateTime? get resolvedAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this IncidentReport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IncidentReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IncidentReportCopyWith<IncidentReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IncidentReportCopyWith<$Res> {
  factory $IncidentReportCopyWith(
          IncidentReport value, $Res Function(IncidentReport) then) =
      _$IncidentReportCopyWithImpl<$Res, IncidentReport>;
  @useResult
  $Res call(
      {String id,
      String reporterId,
      String reporterName,
      String title,
      String description,
      IncidentType type,
      double latitude,
      double longitude,
      String address,
      DateTime reportedAt,
      ReportStatus status,
      List<String>? imageUrls,
      List<String>? videoUrls,
      String? audioUrl,
      int? severity,
      String? assignedVolunteerId,
      String? authorityNotes,
      DateTime? resolvedAt,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$IncidentReportCopyWithImpl<$Res, $Val extends IncidentReport>
    implements $IncidentReportCopyWith<$Res> {
  _$IncidentReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IncidentReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reporterId = null,
    Object? reporterName = null,
    Object? title = null,
    Object? description = null,
    Object? type = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? address = null,
    Object? reportedAt = null,
    Object? status = null,
    Object? imageUrls = freezed,
    Object? videoUrls = freezed,
    Object? audioUrl = freezed,
    Object? severity = freezed,
    Object? assignedVolunteerId = freezed,
    Object? authorityNotes = freezed,
    Object? resolvedAt = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      reporterId: null == reporterId
          ? _value.reporterId
          : reporterId // ignore: cast_nullable_to_non_nullable
              as String,
      reporterName: null == reporterName
          ? _value.reporterName
          : reporterName // ignore: cast_nullable_to_non_nullable
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
              as IncidentType,
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
      reportedAt: null == reportedAt
          ? _value.reportedAt
          : reportedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ReportStatus,
      imageUrls: freezed == imageUrls
          ? _value.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      videoUrls: freezed == videoUrls
          ? _value.videoUrls
          : videoUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      audioUrl: freezed == audioUrl
          ? _value.audioUrl
          : audioUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      severity: freezed == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as int?,
      assignedVolunteerId: freezed == assignedVolunteerId
          ? _value.assignedVolunteerId
          : assignedVolunteerId // ignore: cast_nullable_to_non_nullable
              as String?,
      authorityNotes: freezed == authorityNotes
          ? _value.authorityNotes
          : authorityNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      resolvedAt: freezed == resolvedAt
          ? _value.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IncidentReportImplCopyWith<$Res>
    implements $IncidentReportCopyWith<$Res> {
  factory _$$IncidentReportImplCopyWith(_$IncidentReportImpl value,
          $Res Function(_$IncidentReportImpl) then) =
      __$$IncidentReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String reporterId,
      String reporterName,
      String title,
      String description,
      IncidentType type,
      double latitude,
      double longitude,
      String address,
      DateTime reportedAt,
      ReportStatus status,
      List<String>? imageUrls,
      List<String>? videoUrls,
      String? audioUrl,
      int? severity,
      String? assignedVolunteerId,
      String? authorityNotes,
      DateTime? resolvedAt,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$IncidentReportImplCopyWithImpl<$Res>
    extends _$IncidentReportCopyWithImpl<$Res, _$IncidentReportImpl>
    implements _$$IncidentReportImplCopyWith<$Res> {
  __$$IncidentReportImplCopyWithImpl(
      _$IncidentReportImpl _value, $Res Function(_$IncidentReportImpl) _then)
      : super(_value, _then);

  /// Create a copy of IncidentReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reporterId = null,
    Object? reporterName = null,
    Object? title = null,
    Object? description = null,
    Object? type = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? address = null,
    Object? reportedAt = null,
    Object? status = null,
    Object? imageUrls = freezed,
    Object? videoUrls = freezed,
    Object? audioUrl = freezed,
    Object? severity = freezed,
    Object? assignedVolunteerId = freezed,
    Object? authorityNotes = freezed,
    Object? resolvedAt = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$IncidentReportImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      reporterId: null == reporterId
          ? _value.reporterId
          : reporterId // ignore: cast_nullable_to_non_nullable
              as String,
      reporterName: null == reporterName
          ? _value.reporterName
          : reporterName // ignore: cast_nullable_to_non_nullable
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
              as IncidentType,
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
      reportedAt: null == reportedAt
          ? _value.reportedAt
          : reportedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ReportStatus,
      imageUrls: freezed == imageUrls
          ? _value._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      videoUrls: freezed == videoUrls
          ? _value._videoUrls
          : videoUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      audioUrl: freezed == audioUrl
          ? _value.audioUrl
          : audioUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      severity: freezed == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as int?,
      assignedVolunteerId: freezed == assignedVolunteerId
          ? _value.assignedVolunteerId
          : assignedVolunteerId // ignore: cast_nullable_to_non_nullable
              as String?,
      authorityNotes: freezed == authorityNotes
          ? _value.authorityNotes
          : authorityNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      resolvedAt: freezed == resolvedAt
          ? _value.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IncidentReportImpl implements _IncidentReport {
  const _$IncidentReportImpl(
      {required this.id,
      required this.reporterId,
      required this.reporterName,
      required this.title,
      required this.description,
      required this.type,
      required this.latitude,
      required this.longitude,
      required this.address,
      required this.reportedAt,
      required this.status,
      final List<String>? imageUrls,
      final List<String>? videoUrls,
      this.audioUrl,
      this.severity,
      this.assignedVolunteerId,
      this.authorityNotes,
      this.resolvedAt,
      final Map<String, dynamic>? metadata})
      : _imageUrls = imageUrls,
        _videoUrls = videoUrls,
        _metadata = metadata;

  factory _$IncidentReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$IncidentReportImplFromJson(json);

  @override
  final String id;
  @override
  final String reporterId;
  @override
  final String reporterName;
  @override
  final String title;
  @override
  final String description;
  @override
  final IncidentType type;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String address;
  @override
  final DateTime reportedAt;
  @override
  final ReportStatus status;
  final List<String>? _imageUrls;
  @override
  List<String>? get imageUrls {
    final value = _imageUrls;
    if (value == null) return null;
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _videoUrls;
  @override
  List<String>? get videoUrls {
    final value = _videoUrls;
    if (value == null) return null;
    if (_videoUrls is EqualUnmodifiableListView) return _videoUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? audioUrl;
  @override
  final int? severity;
// 1-5 scale
  @override
  final String? assignedVolunteerId;
  @override
  final String? authorityNotes;
  @override
  final DateTime? resolvedAt;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'IncidentReport(id: $id, reporterId: $reporterId, reporterName: $reporterName, title: $title, description: $description, type: $type, latitude: $latitude, longitude: $longitude, address: $address, reportedAt: $reportedAt, status: $status, imageUrls: $imageUrls, videoUrls: $videoUrls, audioUrl: $audioUrl, severity: $severity, assignedVolunteerId: $assignedVolunteerId, authorityNotes: $authorityNotes, resolvedAt: $resolvedAt, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncidentReportImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reporterId, reporterId) ||
                other.reporterId == reporterId) &&
            (identical(other.reporterName, reporterName) ||
                other.reporterName == reporterName) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.reportedAt, reportedAt) ||
                other.reportedAt == reportedAt) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls) &&
            const DeepCollectionEquality()
                .equals(other._videoUrls, _videoUrls) &&
            (identical(other.audioUrl, audioUrl) ||
                other.audioUrl == audioUrl) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.assignedVolunteerId, assignedVolunteerId) ||
                other.assignedVolunteerId == assignedVolunteerId) &&
            (identical(other.authorityNotes, authorityNotes) ||
                other.authorityNotes == authorityNotes) &&
            (identical(other.resolvedAt, resolvedAt) ||
                other.resolvedAt == resolvedAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        reporterId,
        reporterName,
        title,
        description,
        type,
        latitude,
        longitude,
        address,
        reportedAt,
        status,
        const DeepCollectionEquality().hash(_imageUrls),
        const DeepCollectionEquality().hash(_videoUrls),
        audioUrl,
        severity,
        assignedVolunteerId,
        authorityNotes,
        resolvedAt,
        const DeepCollectionEquality().hash(_metadata)
      ]);

  /// Create a copy of IncidentReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IncidentReportImplCopyWith<_$IncidentReportImpl> get copyWith =>
      __$$IncidentReportImplCopyWithImpl<_$IncidentReportImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IncidentReportImplToJson(
      this,
    );
  }
}

abstract class _IncidentReport implements IncidentReport {
  const factory _IncidentReport(
      {required final String id,
      required final String reporterId,
      required final String reporterName,
      required final String title,
      required final String description,
      required final IncidentType type,
      required final double latitude,
      required final double longitude,
      required final String address,
      required final DateTime reportedAt,
      required final ReportStatus status,
      final List<String>? imageUrls,
      final List<String>? videoUrls,
      final String? audioUrl,
      final int? severity,
      final String? assignedVolunteerId,
      final String? authorityNotes,
      final DateTime? resolvedAt,
      final Map<String, dynamic>? metadata}) = _$IncidentReportImpl;

  factory _IncidentReport.fromJson(Map<String, dynamic> json) =
      _$IncidentReportImpl.fromJson;

  @override
  String get id;
  @override
  String get reporterId;
  @override
  String get reporterName;
  @override
  String get title;
  @override
  String get description;
  @override
  IncidentType get type;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String get address;
  @override
  DateTime get reportedAt;
  @override
  ReportStatus get status;
  @override
  List<String>? get imageUrls;
  @override
  List<String>? get videoUrls;
  @override
  String? get audioUrl;
  @override
  int? get severity; // 1-5 scale
  @override
  String? get assignedVolunteerId;
  @override
  String? get authorityNotes;
  @override
  DateTime? get resolvedAt;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of IncidentReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IncidentReportImplCopyWith<_$IncidentReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
