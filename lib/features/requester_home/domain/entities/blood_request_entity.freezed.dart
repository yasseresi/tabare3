// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blood_request_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HospitalEntity {

 String get id; int get wilayaId; String get nameAr; String? get nameFr; String? get address; bool get isActive;
/// Create a copy of HospitalEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HospitalEntityCopyWith<HospitalEntity> get copyWith => _$HospitalEntityCopyWithImpl<HospitalEntity>(this as HospitalEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HospitalEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.wilayaId, wilayaId) || other.wilayaId == wilayaId)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.nameFr, nameFr) || other.nameFr == nameFr)&&(identical(other.address, address) || other.address == address)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,id,wilayaId,nameAr,nameFr,address,isActive);

@override
String toString() {
  return 'HospitalEntity(id: $id, wilayaId: $wilayaId, nameAr: $nameAr, nameFr: $nameFr, address: $address, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $HospitalEntityCopyWith<$Res>  {
  factory $HospitalEntityCopyWith(HospitalEntity value, $Res Function(HospitalEntity) _then) = _$HospitalEntityCopyWithImpl;
@useResult
$Res call({
 String id, int wilayaId, String nameAr, String? nameFr, String? address, bool isActive
});




}
/// @nodoc
class _$HospitalEntityCopyWithImpl<$Res>
    implements $HospitalEntityCopyWith<$Res> {
  _$HospitalEntityCopyWithImpl(this._self, this._then);

  final HospitalEntity _self;
  final $Res Function(HospitalEntity) _then;

/// Create a copy of HospitalEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? wilayaId = null,Object? nameAr = null,Object? nameFr = freezed,Object? address = freezed,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,wilayaId: null == wilayaId ? _self.wilayaId : wilayaId // ignore: cast_nullable_to_non_nullable
as int,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,nameFr: freezed == nameFr ? _self.nameFr : nameFr // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [HospitalEntity].
extension HospitalEntityPatterns on HospitalEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HospitalEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HospitalEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HospitalEntity value)  $default,){
final _that = this;
switch (_that) {
case _HospitalEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HospitalEntity value)?  $default,){
final _that = this;
switch (_that) {
case _HospitalEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int wilayaId,  String nameAr,  String? nameFr,  String? address,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HospitalEntity() when $default != null:
return $default(_that.id,_that.wilayaId,_that.nameAr,_that.nameFr,_that.address,_that.isActive);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int wilayaId,  String nameAr,  String? nameFr,  String? address,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _HospitalEntity():
return $default(_that.id,_that.wilayaId,_that.nameAr,_that.nameFr,_that.address,_that.isActive);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int wilayaId,  String nameAr,  String? nameFr,  String? address,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _HospitalEntity() when $default != null:
return $default(_that.id,_that.wilayaId,_that.nameAr,_that.nameFr,_that.address,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc


class _HospitalEntity implements HospitalEntity {
  const _HospitalEntity({required this.id, required this.wilayaId, required this.nameAr, this.nameFr, this.address, required this.isActive});
  

@override final  String id;
@override final  int wilayaId;
@override final  String nameAr;
@override final  String? nameFr;
@override final  String? address;
@override final  bool isActive;

/// Create a copy of HospitalEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HospitalEntityCopyWith<_HospitalEntity> get copyWith => __$HospitalEntityCopyWithImpl<_HospitalEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HospitalEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.wilayaId, wilayaId) || other.wilayaId == wilayaId)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.nameFr, nameFr) || other.nameFr == nameFr)&&(identical(other.address, address) || other.address == address)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,id,wilayaId,nameAr,nameFr,address,isActive);

@override
String toString() {
  return 'HospitalEntity(id: $id, wilayaId: $wilayaId, nameAr: $nameAr, nameFr: $nameFr, address: $address, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$HospitalEntityCopyWith<$Res> implements $HospitalEntityCopyWith<$Res> {
  factory _$HospitalEntityCopyWith(_HospitalEntity value, $Res Function(_HospitalEntity) _then) = __$HospitalEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, int wilayaId, String nameAr, String? nameFr, String? address, bool isActive
});




}
/// @nodoc
class __$HospitalEntityCopyWithImpl<$Res>
    implements _$HospitalEntityCopyWith<$Res> {
  __$HospitalEntityCopyWithImpl(this._self, this._then);

  final _HospitalEntity _self;
  final $Res Function(_HospitalEntity) _then;

/// Create a copy of HospitalEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? wilayaId = null,Object? nameAr = null,Object? nameFr = freezed,Object? address = freezed,Object? isActive = null,}) {
  return _then(_HospitalEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,wilayaId: null == wilayaId ? _self.wilayaId : wilayaId // ignore: cast_nullable_to_non_nullable
as int,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,nameFr: freezed == nameFr ? _self.nameFr : nameFr // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$BloodRequestEntity {

 String get id; String get requestedBy; HospitalEntity get hospital; String get bloodType; RequestPriority get priority; int get unitsNeeded; int get unitsFulfilled; BloodRequestStatus get status; DateTime? get neededBy; DateTime? get expiresAt; String? get notes; DateTime get createdAt;
/// Create a copy of BloodRequestEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BloodRequestEntityCopyWith<BloodRequestEntity> get copyWith => _$BloodRequestEntityCopyWithImpl<BloodRequestEntity>(this as BloodRequestEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BloodRequestEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.requestedBy, requestedBy) || other.requestedBy == requestedBy)&&(identical(other.hospital, hospital) || other.hospital == hospital)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.unitsNeeded, unitsNeeded) || other.unitsNeeded == unitsNeeded)&&(identical(other.unitsFulfilled, unitsFulfilled) || other.unitsFulfilled == unitsFulfilled)&&(identical(other.status, status) || other.status == status)&&(identical(other.neededBy, neededBy) || other.neededBy == neededBy)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,requestedBy,hospital,bloodType,priority,unitsNeeded,unitsFulfilled,status,neededBy,expiresAt,notes,createdAt);

@override
String toString() {
  return 'BloodRequestEntity(id: $id, requestedBy: $requestedBy, hospital: $hospital, bloodType: $bloodType, priority: $priority, unitsNeeded: $unitsNeeded, unitsFulfilled: $unitsFulfilled, status: $status, neededBy: $neededBy, expiresAt: $expiresAt, notes: $notes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $BloodRequestEntityCopyWith<$Res>  {
  factory $BloodRequestEntityCopyWith(BloodRequestEntity value, $Res Function(BloodRequestEntity) _then) = _$BloodRequestEntityCopyWithImpl;
@useResult
$Res call({
 String id, String requestedBy, HospitalEntity hospital, String bloodType, RequestPriority priority, int unitsNeeded, int unitsFulfilled, BloodRequestStatus status, DateTime? neededBy, DateTime? expiresAt, String? notes, DateTime createdAt
});


$HospitalEntityCopyWith<$Res> get hospital;

}
/// @nodoc
class _$BloodRequestEntityCopyWithImpl<$Res>
    implements $BloodRequestEntityCopyWith<$Res> {
  _$BloodRequestEntityCopyWithImpl(this._self, this._then);

  final BloodRequestEntity _self;
  final $Res Function(BloodRequestEntity) _then;

/// Create a copy of BloodRequestEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? requestedBy = null,Object? hospital = null,Object? bloodType = null,Object? priority = null,Object? unitsNeeded = null,Object? unitsFulfilled = null,Object? status = null,Object? neededBy = freezed,Object? expiresAt = freezed,Object? notes = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,requestedBy: null == requestedBy ? _self.requestedBy : requestedBy // ignore: cast_nullable_to_non_nullable
as String,hospital: null == hospital ? _self.hospital : hospital // ignore: cast_nullable_to_non_nullable
as HospitalEntity,bloodType: null == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as RequestPriority,unitsNeeded: null == unitsNeeded ? _self.unitsNeeded : unitsNeeded // ignore: cast_nullable_to_non_nullable
as int,unitsFulfilled: null == unitsFulfilled ? _self.unitsFulfilled : unitsFulfilled // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BloodRequestStatus,neededBy: freezed == neededBy ? _self.neededBy : neededBy // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of BloodRequestEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HospitalEntityCopyWith<$Res> get hospital {
  
  return $HospitalEntityCopyWith<$Res>(_self.hospital, (value) {
    return _then(_self.copyWith(hospital: value));
  });
}
}


/// Adds pattern-matching-related methods to [BloodRequestEntity].
extension BloodRequestEntityPatterns on BloodRequestEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BloodRequestEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BloodRequestEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BloodRequestEntity value)  $default,){
final _that = this;
switch (_that) {
case _BloodRequestEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BloodRequestEntity value)?  $default,){
final _that = this;
switch (_that) {
case _BloodRequestEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String requestedBy,  HospitalEntity hospital,  String bloodType,  RequestPriority priority,  int unitsNeeded,  int unitsFulfilled,  BloodRequestStatus status,  DateTime? neededBy,  DateTime? expiresAt,  String? notes,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BloodRequestEntity() when $default != null:
return $default(_that.id,_that.requestedBy,_that.hospital,_that.bloodType,_that.priority,_that.unitsNeeded,_that.unitsFulfilled,_that.status,_that.neededBy,_that.expiresAt,_that.notes,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String requestedBy,  HospitalEntity hospital,  String bloodType,  RequestPriority priority,  int unitsNeeded,  int unitsFulfilled,  BloodRequestStatus status,  DateTime? neededBy,  DateTime? expiresAt,  String? notes,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _BloodRequestEntity():
return $default(_that.id,_that.requestedBy,_that.hospital,_that.bloodType,_that.priority,_that.unitsNeeded,_that.unitsFulfilled,_that.status,_that.neededBy,_that.expiresAt,_that.notes,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String requestedBy,  HospitalEntity hospital,  String bloodType,  RequestPriority priority,  int unitsNeeded,  int unitsFulfilled,  BloodRequestStatus status,  DateTime? neededBy,  DateTime? expiresAt,  String? notes,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _BloodRequestEntity() when $default != null:
return $default(_that.id,_that.requestedBy,_that.hospital,_that.bloodType,_that.priority,_that.unitsNeeded,_that.unitsFulfilled,_that.status,_that.neededBy,_that.expiresAt,_that.notes,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _BloodRequestEntity extends BloodRequestEntity {
  const _BloodRequestEntity({required this.id, required this.requestedBy, required this.hospital, required this.bloodType, required this.priority, required this.unitsNeeded, required this.unitsFulfilled, required this.status, this.neededBy, this.expiresAt, this.notes, required this.createdAt}): super._();
  

@override final  String id;
@override final  String requestedBy;
@override final  HospitalEntity hospital;
@override final  String bloodType;
@override final  RequestPriority priority;
@override final  int unitsNeeded;
@override final  int unitsFulfilled;
@override final  BloodRequestStatus status;
@override final  DateTime? neededBy;
@override final  DateTime? expiresAt;
@override final  String? notes;
@override final  DateTime createdAt;

/// Create a copy of BloodRequestEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BloodRequestEntityCopyWith<_BloodRequestEntity> get copyWith => __$BloodRequestEntityCopyWithImpl<_BloodRequestEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BloodRequestEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.requestedBy, requestedBy) || other.requestedBy == requestedBy)&&(identical(other.hospital, hospital) || other.hospital == hospital)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.unitsNeeded, unitsNeeded) || other.unitsNeeded == unitsNeeded)&&(identical(other.unitsFulfilled, unitsFulfilled) || other.unitsFulfilled == unitsFulfilled)&&(identical(other.status, status) || other.status == status)&&(identical(other.neededBy, neededBy) || other.neededBy == neededBy)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,requestedBy,hospital,bloodType,priority,unitsNeeded,unitsFulfilled,status,neededBy,expiresAt,notes,createdAt);

@override
String toString() {
  return 'BloodRequestEntity(id: $id, requestedBy: $requestedBy, hospital: $hospital, bloodType: $bloodType, priority: $priority, unitsNeeded: $unitsNeeded, unitsFulfilled: $unitsFulfilled, status: $status, neededBy: $neededBy, expiresAt: $expiresAt, notes: $notes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BloodRequestEntityCopyWith<$Res> implements $BloodRequestEntityCopyWith<$Res> {
  factory _$BloodRequestEntityCopyWith(_BloodRequestEntity value, $Res Function(_BloodRequestEntity) _then) = __$BloodRequestEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String requestedBy, HospitalEntity hospital, String bloodType, RequestPriority priority, int unitsNeeded, int unitsFulfilled, BloodRequestStatus status, DateTime? neededBy, DateTime? expiresAt, String? notes, DateTime createdAt
});


@override $HospitalEntityCopyWith<$Res> get hospital;

}
/// @nodoc
class __$BloodRequestEntityCopyWithImpl<$Res>
    implements _$BloodRequestEntityCopyWith<$Res> {
  __$BloodRequestEntityCopyWithImpl(this._self, this._then);

  final _BloodRequestEntity _self;
  final $Res Function(_BloodRequestEntity) _then;

/// Create a copy of BloodRequestEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? requestedBy = null,Object? hospital = null,Object? bloodType = null,Object? priority = null,Object? unitsNeeded = null,Object? unitsFulfilled = null,Object? status = null,Object? neededBy = freezed,Object? expiresAt = freezed,Object? notes = freezed,Object? createdAt = null,}) {
  return _then(_BloodRequestEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,requestedBy: null == requestedBy ? _self.requestedBy : requestedBy // ignore: cast_nullable_to_non_nullable
as String,hospital: null == hospital ? _self.hospital : hospital // ignore: cast_nullable_to_non_nullable
as HospitalEntity,bloodType: null == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as RequestPriority,unitsNeeded: null == unitsNeeded ? _self.unitsNeeded : unitsNeeded // ignore: cast_nullable_to_non_nullable
as int,unitsFulfilled: null == unitsFulfilled ? _self.unitsFulfilled : unitsFulfilled // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BloodRequestStatus,neededBy: freezed == neededBy ? _self.neededBy : neededBy // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of BloodRequestEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HospitalEntityCopyWith<$Res> get hospital {
  
  return $HospitalEntityCopyWith<$Res>(_self.hospital, (value) {
    return _then(_self.copyWith(hospital: value));
  });
}
}

/// @nodoc
mixin _$RequestDraft {

 String get hospitalId; String get bloodType; RequestPriority get priority; int get unitsNeeded; DateTime? get neededBy; String? get notes;
/// Create a copy of RequestDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestDraftCopyWith<RequestDraft> get copyWith => _$RequestDraftCopyWithImpl<RequestDraft>(this as RequestDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestDraft&&(identical(other.hospitalId, hospitalId) || other.hospitalId == hospitalId)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.unitsNeeded, unitsNeeded) || other.unitsNeeded == unitsNeeded)&&(identical(other.neededBy, neededBy) || other.neededBy == neededBy)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode => Object.hash(runtimeType,hospitalId,bloodType,priority,unitsNeeded,neededBy,notes);

@override
String toString() {
  return 'RequestDraft(hospitalId: $hospitalId, bloodType: $bloodType, priority: $priority, unitsNeeded: $unitsNeeded, neededBy: $neededBy, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $RequestDraftCopyWith<$Res>  {
  factory $RequestDraftCopyWith(RequestDraft value, $Res Function(RequestDraft) _then) = _$RequestDraftCopyWithImpl;
@useResult
$Res call({
 String hospitalId, String bloodType, RequestPriority priority, int unitsNeeded, DateTime? neededBy, String? notes
});




}
/// @nodoc
class _$RequestDraftCopyWithImpl<$Res>
    implements $RequestDraftCopyWith<$Res> {
  _$RequestDraftCopyWithImpl(this._self, this._then);

  final RequestDraft _self;
  final $Res Function(RequestDraft) _then;

/// Create a copy of RequestDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hospitalId = null,Object? bloodType = null,Object? priority = null,Object? unitsNeeded = null,Object? neededBy = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
hospitalId: null == hospitalId ? _self.hospitalId : hospitalId // ignore: cast_nullable_to_non_nullable
as String,bloodType: null == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as RequestPriority,unitsNeeded: null == unitsNeeded ? _self.unitsNeeded : unitsNeeded // ignore: cast_nullable_to_non_nullable
as int,neededBy: freezed == neededBy ? _self.neededBy : neededBy // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RequestDraft].
extension RequestDraftPatterns on RequestDraft {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RequestDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RequestDraft() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RequestDraft value)  $default,){
final _that = this;
switch (_that) {
case _RequestDraft():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RequestDraft value)?  $default,){
final _that = this;
switch (_that) {
case _RequestDraft() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String hospitalId,  String bloodType,  RequestPriority priority,  int unitsNeeded,  DateTime? neededBy,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RequestDraft() when $default != null:
return $default(_that.hospitalId,_that.bloodType,_that.priority,_that.unitsNeeded,_that.neededBy,_that.notes);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String hospitalId,  String bloodType,  RequestPriority priority,  int unitsNeeded,  DateTime? neededBy,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _RequestDraft():
return $default(_that.hospitalId,_that.bloodType,_that.priority,_that.unitsNeeded,_that.neededBy,_that.notes);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String hospitalId,  String bloodType,  RequestPriority priority,  int unitsNeeded,  DateTime? neededBy,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _RequestDraft() when $default != null:
return $default(_that.hospitalId,_that.bloodType,_that.priority,_that.unitsNeeded,_that.neededBy,_that.notes);case _:
  return null;

}
}

}

/// @nodoc


class _RequestDraft implements RequestDraft {
  const _RequestDraft({required this.hospitalId, required this.bloodType, required this.priority, required this.unitsNeeded, this.neededBy, this.notes});
  

@override final  String hospitalId;
@override final  String bloodType;
@override final  RequestPriority priority;
@override final  int unitsNeeded;
@override final  DateTime? neededBy;
@override final  String? notes;

/// Create a copy of RequestDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequestDraftCopyWith<_RequestDraft> get copyWith => __$RequestDraftCopyWithImpl<_RequestDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestDraft&&(identical(other.hospitalId, hospitalId) || other.hospitalId == hospitalId)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.unitsNeeded, unitsNeeded) || other.unitsNeeded == unitsNeeded)&&(identical(other.neededBy, neededBy) || other.neededBy == neededBy)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode => Object.hash(runtimeType,hospitalId,bloodType,priority,unitsNeeded,neededBy,notes);

@override
String toString() {
  return 'RequestDraft(hospitalId: $hospitalId, bloodType: $bloodType, priority: $priority, unitsNeeded: $unitsNeeded, neededBy: $neededBy, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$RequestDraftCopyWith<$Res> implements $RequestDraftCopyWith<$Res> {
  factory _$RequestDraftCopyWith(_RequestDraft value, $Res Function(_RequestDraft) _then) = __$RequestDraftCopyWithImpl;
@override @useResult
$Res call({
 String hospitalId, String bloodType, RequestPriority priority, int unitsNeeded, DateTime? neededBy, String? notes
});




}
/// @nodoc
class __$RequestDraftCopyWithImpl<$Res>
    implements _$RequestDraftCopyWith<$Res> {
  __$RequestDraftCopyWithImpl(this._self, this._then);

  final _RequestDraft _self;
  final $Res Function(_RequestDraft) _then;

/// Create a copy of RequestDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hospitalId = null,Object? bloodType = null,Object? priority = null,Object? unitsNeeded = null,Object? neededBy = freezed,Object? notes = freezed,}) {
  return _then(_RequestDraft(
hospitalId: null == hospitalId ? _self.hospitalId : hospitalId // ignore: cast_nullable_to_non_nullable
as String,bloodType: null == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as RequestPriority,unitsNeeded: null == unitsNeeded ? _self.unitsNeeded : unitsNeeded // ignore: cast_nullable_to_non_nullable
as int,neededBy: freezed == neededBy ? _self.neededBy : neededBy // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$RequestDonorEntity {

 String get donorId; String get fullName; String get bloodType; String get appointmentId; DonationAppointmentStatus get status; DateTime get scheduledAt; DateTime? get completedAt;
/// Create a copy of RequestDonorEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestDonorEntityCopyWith<RequestDonorEntity> get copyWith => _$RequestDonorEntityCopyWithImpl<RequestDonorEntity>(this as RequestDonorEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestDonorEntity&&(identical(other.donorId, donorId) || other.donorId == donorId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.status, status) || other.status == status)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}


@override
int get hashCode => Object.hash(runtimeType,donorId,fullName,bloodType,appointmentId,status,scheduledAt,completedAt);

@override
String toString() {
  return 'RequestDonorEntity(donorId: $donorId, fullName: $fullName, bloodType: $bloodType, appointmentId: $appointmentId, status: $status, scheduledAt: $scheduledAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $RequestDonorEntityCopyWith<$Res>  {
  factory $RequestDonorEntityCopyWith(RequestDonorEntity value, $Res Function(RequestDonorEntity) _then) = _$RequestDonorEntityCopyWithImpl;
@useResult
$Res call({
 String donorId, String fullName, String bloodType, String appointmentId, DonationAppointmentStatus status, DateTime scheduledAt, DateTime? completedAt
});




}
/// @nodoc
class _$RequestDonorEntityCopyWithImpl<$Res>
    implements $RequestDonorEntityCopyWith<$Res> {
  _$RequestDonorEntityCopyWithImpl(this._self, this._then);

  final RequestDonorEntity _self;
  final $Res Function(RequestDonorEntity) _then;

/// Create a copy of RequestDonorEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? donorId = null,Object? fullName = null,Object? bloodType = null,Object? appointmentId = null,Object? status = null,Object? scheduledAt = null,Object? completedAt = freezed,}) {
  return _then(_self.copyWith(
donorId: null == donorId ? _self.donorId : donorId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,bloodType: null == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as String,appointmentId: null == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DonationAppointmentStatus,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RequestDonorEntity].
extension RequestDonorEntityPatterns on RequestDonorEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RequestDonorEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RequestDonorEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RequestDonorEntity value)  $default,){
final _that = this;
switch (_that) {
case _RequestDonorEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RequestDonorEntity value)?  $default,){
final _that = this;
switch (_that) {
case _RequestDonorEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String donorId,  String fullName,  String bloodType,  String appointmentId,  DonationAppointmentStatus status,  DateTime scheduledAt,  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RequestDonorEntity() when $default != null:
return $default(_that.donorId,_that.fullName,_that.bloodType,_that.appointmentId,_that.status,_that.scheduledAt,_that.completedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String donorId,  String fullName,  String bloodType,  String appointmentId,  DonationAppointmentStatus status,  DateTime scheduledAt,  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _RequestDonorEntity():
return $default(_that.donorId,_that.fullName,_that.bloodType,_that.appointmentId,_that.status,_that.scheduledAt,_that.completedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String donorId,  String fullName,  String bloodType,  String appointmentId,  DonationAppointmentStatus status,  DateTime scheduledAt,  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _RequestDonorEntity() when $default != null:
return $default(_that.donorId,_that.fullName,_that.bloodType,_that.appointmentId,_that.status,_that.scheduledAt,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc


class _RequestDonorEntity implements RequestDonorEntity {
  const _RequestDonorEntity({required this.donorId, required this.fullName, required this.bloodType, required this.appointmentId, required this.status, required this.scheduledAt, this.completedAt});
  

@override final  String donorId;
@override final  String fullName;
@override final  String bloodType;
@override final  String appointmentId;
@override final  DonationAppointmentStatus status;
@override final  DateTime scheduledAt;
@override final  DateTime? completedAt;

/// Create a copy of RequestDonorEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequestDonorEntityCopyWith<_RequestDonorEntity> get copyWith => __$RequestDonorEntityCopyWithImpl<_RequestDonorEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestDonorEntity&&(identical(other.donorId, donorId) || other.donorId == donorId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.status, status) || other.status == status)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}


@override
int get hashCode => Object.hash(runtimeType,donorId,fullName,bloodType,appointmentId,status,scheduledAt,completedAt);

@override
String toString() {
  return 'RequestDonorEntity(donorId: $donorId, fullName: $fullName, bloodType: $bloodType, appointmentId: $appointmentId, status: $status, scheduledAt: $scheduledAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$RequestDonorEntityCopyWith<$Res> implements $RequestDonorEntityCopyWith<$Res> {
  factory _$RequestDonorEntityCopyWith(_RequestDonorEntity value, $Res Function(_RequestDonorEntity) _then) = __$RequestDonorEntityCopyWithImpl;
@override @useResult
$Res call({
 String donorId, String fullName, String bloodType, String appointmentId, DonationAppointmentStatus status, DateTime scheduledAt, DateTime? completedAt
});




}
/// @nodoc
class __$RequestDonorEntityCopyWithImpl<$Res>
    implements _$RequestDonorEntityCopyWith<$Res> {
  __$RequestDonorEntityCopyWithImpl(this._self, this._then);

  final _RequestDonorEntity _self;
  final $Res Function(_RequestDonorEntity) _then;

/// Create a copy of RequestDonorEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? donorId = null,Object? fullName = null,Object? bloodType = null,Object? appointmentId = null,Object? status = null,Object? scheduledAt = null,Object? completedAt = freezed,}) {
  return _then(_RequestDonorEntity(
donorId: null == donorId ? _self.donorId : donorId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,bloodType: null == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as String,appointmentId: null == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DonationAppointmentStatus,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$CompatibleDonorEntity {

 String get donorId; String get fullName; String get bloodType; int get wilayaId; DateTime? get cooldownUntil;
/// Create a copy of CompatibleDonorEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompatibleDonorEntityCopyWith<CompatibleDonorEntity> get copyWith => _$CompatibleDonorEntityCopyWithImpl<CompatibleDonorEntity>(this as CompatibleDonorEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompatibleDonorEntity&&(identical(other.donorId, donorId) || other.donorId == donorId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.wilayaId, wilayaId) || other.wilayaId == wilayaId)&&(identical(other.cooldownUntil, cooldownUntil) || other.cooldownUntil == cooldownUntil));
}


@override
int get hashCode => Object.hash(runtimeType,donorId,fullName,bloodType,wilayaId,cooldownUntil);

@override
String toString() {
  return 'CompatibleDonorEntity(donorId: $donorId, fullName: $fullName, bloodType: $bloodType, wilayaId: $wilayaId, cooldownUntil: $cooldownUntil)';
}


}

/// @nodoc
abstract mixin class $CompatibleDonorEntityCopyWith<$Res>  {
  factory $CompatibleDonorEntityCopyWith(CompatibleDonorEntity value, $Res Function(CompatibleDonorEntity) _then) = _$CompatibleDonorEntityCopyWithImpl;
@useResult
$Res call({
 String donorId, String fullName, String bloodType, int wilayaId, DateTime? cooldownUntil
});




}
/// @nodoc
class _$CompatibleDonorEntityCopyWithImpl<$Res>
    implements $CompatibleDonorEntityCopyWith<$Res> {
  _$CompatibleDonorEntityCopyWithImpl(this._self, this._then);

  final CompatibleDonorEntity _self;
  final $Res Function(CompatibleDonorEntity) _then;

/// Create a copy of CompatibleDonorEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? donorId = null,Object? fullName = null,Object? bloodType = null,Object? wilayaId = null,Object? cooldownUntil = freezed,}) {
  return _then(_self.copyWith(
donorId: null == donorId ? _self.donorId : donorId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,bloodType: null == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as String,wilayaId: null == wilayaId ? _self.wilayaId : wilayaId // ignore: cast_nullable_to_non_nullable
as int,cooldownUntil: freezed == cooldownUntil ? _self.cooldownUntil : cooldownUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CompatibleDonorEntity].
extension CompatibleDonorEntityPatterns on CompatibleDonorEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CompatibleDonorEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CompatibleDonorEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CompatibleDonorEntity value)  $default,){
final _that = this;
switch (_that) {
case _CompatibleDonorEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CompatibleDonorEntity value)?  $default,){
final _that = this;
switch (_that) {
case _CompatibleDonorEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String donorId,  String fullName,  String bloodType,  int wilayaId,  DateTime? cooldownUntil)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CompatibleDonorEntity() when $default != null:
return $default(_that.donorId,_that.fullName,_that.bloodType,_that.wilayaId,_that.cooldownUntil);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String donorId,  String fullName,  String bloodType,  int wilayaId,  DateTime? cooldownUntil)  $default,) {final _that = this;
switch (_that) {
case _CompatibleDonorEntity():
return $default(_that.donorId,_that.fullName,_that.bloodType,_that.wilayaId,_that.cooldownUntil);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String donorId,  String fullName,  String bloodType,  int wilayaId,  DateTime? cooldownUntil)?  $default,) {final _that = this;
switch (_that) {
case _CompatibleDonorEntity() when $default != null:
return $default(_that.donorId,_that.fullName,_that.bloodType,_that.wilayaId,_that.cooldownUntil);case _:
  return null;

}
}

}

/// @nodoc


class _CompatibleDonorEntity implements CompatibleDonorEntity {
  const _CompatibleDonorEntity({required this.donorId, required this.fullName, required this.bloodType, required this.wilayaId, this.cooldownUntil});
  

@override final  String donorId;
@override final  String fullName;
@override final  String bloodType;
@override final  int wilayaId;
@override final  DateTime? cooldownUntil;

/// Create a copy of CompatibleDonorEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompatibleDonorEntityCopyWith<_CompatibleDonorEntity> get copyWith => __$CompatibleDonorEntityCopyWithImpl<_CompatibleDonorEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompatibleDonorEntity&&(identical(other.donorId, donorId) || other.donorId == donorId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.wilayaId, wilayaId) || other.wilayaId == wilayaId)&&(identical(other.cooldownUntil, cooldownUntil) || other.cooldownUntil == cooldownUntil));
}


@override
int get hashCode => Object.hash(runtimeType,donorId,fullName,bloodType,wilayaId,cooldownUntil);

@override
String toString() {
  return 'CompatibleDonorEntity(donorId: $donorId, fullName: $fullName, bloodType: $bloodType, wilayaId: $wilayaId, cooldownUntil: $cooldownUntil)';
}


}

/// @nodoc
abstract mixin class _$CompatibleDonorEntityCopyWith<$Res> implements $CompatibleDonorEntityCopyWith<$Res> {
  factory _$CompatibleDonorEntityCopyWith(_CompatibleDonorEntity value, $Res Function(_CompatibleDonorEntity) _then) = __$CompatibleDonorEntityCopyWithImpl;
@override @useResult
$Res call({
 String donorId, String fullName, String bloodType, int wilayaId, DateTime? cooldownUntil
});




}
/// @nodoc
class __$CompatibleDonorEntityCopyWithImpl<$Res>
    implements _$CompatibleDonorEntityCopyWith<$Res> {
  __$CompatibleDonorEntityCopyWithImpl(this._self, this._then);

  final _CompatibleDonorEntity _self;
  final $Res Function(_CompatibleDonorEntity) _then;

/// Create a copy of CompatibleDonorEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? donorId = null,Object? fullName = null,Object? bloodType = null,Object? wilayaId = null,Object? cooldownUntil = freezed,}) {
  return _then(_CompatibleDonorEntity(
donorId: null == donorId ? _self.donorId : donorId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,bloodType: null == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as String,wilayaId: null == wilayaId ? _self.wilayaId : wilayaId // ignore: cast_nullable_to_non_nullable
as int,cooldownUntil: freezed == cooldownUntil ? _self.cooldownUntil : cooldownUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$IssuedRequestQrEntity {

 String get token; DateTime get expiresAt;
/// Create a copy of IssuedRequestQrEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IssuedRequestQrEntityCopyWith<IssuedRequestQrEntity> get copyWith => _$IssuedRequestQrEntityCopyWithImpl<IssuedRequestQrEntity>(this as IssuedRequestQrEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IssuedRequestQrEntity&&(identical(other.token, token) || other.token == token)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}


@override
int get hashCode => Object.hash(runtimeType,token,expiresAt);

@override
String toString() {
  return 'IssuedRequestQrEntity(token: $token, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $IssuedRequestQrEntityCopyWith<$Res>  {
  factory $IssuedRequestQrEntityCopyWith(IssuedRequestQrEntity value, $Res Function(IssuedRequestQrEntity) _then) = _$IssuedRequestQrEntityCopyWithImpl;
@useResult
$Res call({
 String token, DateTime expiresAt
});




}
/// @nodoc
class _$IssuedRequestQrEntityCopyWithImpl<$Res>
    implements $IssuedRequestQrEntityCopyWith<$Res> {
  _$IssuedRequestQrEntityCopyWithImpl(this._self, this._then);

  final IssuedRequestQrEntity _self;
  final $Res Function(IssuedRequestQrEntity) _then;

/// Create a copy of IssuedRequestQrEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = null,Object? expiresAt = null,}) {
  return _then(_self.copyWith(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [IssuedRequestQrEntity].
extension IssuedRequestQrEntityPatterns on IssuedRequestQrEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IssuedRequestQrEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IssuedRequestQrEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IssuedRequestQrEntity value)  $default,){
final _that = this;
switch (_that) {
case _IssuedRequestQrEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IssuedRequestQrEntity value)?  $default,){
final _that = this;
switch (_that) {
case _IssuedRequestQrEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String token,  DateTime expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IssuedRequestQrEntity() when $default != null:
return $default(_that.token,_that.expiresAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String token,  DateTime expiresAt)  $default,) {final _that = this;
switch (_that) {
case _IssuedRequestQrEntity():
return $default(_that.token,_that.expiresAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String token,  DateTime expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _IssuedRequestQrEntity() when $default != null:
return $default(_that.token,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc


class _IssuedRequestQrEntity extends IssuedRequestQrEntity {
  const _IssuedRequestQrEntity({required this.token, required this.expiresAt}): super._();
  

@override final  String token;
@override final  DateTime expiresAt;

/// Create a copy of IssuedRequestQrEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IssuedRequestQrEntityCopyWith<_IssuedRequestQrEntity> get copyWith => __$IssuedRequestQrEntityCopyWithImpl<_IssuedRequestQrEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IssuedRequestQrEntity&&(identical(other.token, token) || other.token == token)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}


@override
int get hashCode => Object.hash(runtimeType,token,expiresAt);

@override
String toString() {
  return 'IssuedRequestQrEntity(token: $token, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$IssuedRequestQrEntityCopyWith<$Res> implements $IssuedRequestQrEntityCopyWith<$Res> {
  factory _$IssuedRequestQrEntityCopyWith(_IssuedRequestQrEntity value, $Res Function(_IssuedRequestQrEntity) _then) = __$IssuedRequestQrEntityCopyWithImpl;
@override @useResult
$Res call({
 String token, DateTime expiresAt
});




}
/// @nodoc
class __$IssuedRequestQrEntityCopyWithImpl<$Res>
    implements _$IssuedRequestQrEntityCopyWith<$Res> {
  __$IssuedRequestQrEntityCopyWithImpl(this._self, this._then);

  final _IssuedRequestQrEntity _self;
  final $Res Function(_IssuedRequestQrEntity) _then;

/// Create a copy of IssuedRequestQrEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = null,Object? expiresAt = null,}) {
  return _then(_IssuedRequestQrEntity(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$DirectInvitationEntity {

 String get invitationId; String get donorId; String get fullName; String get bloodType; DirectInvitationStatus get status; String? get appointmentId; DateTime get expiresAt; DateTime? get respondedAt; DateTime get createdAt;
/// Create a copy of DirectInvitationEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DirectInvitationEntityCopyWith<DirectInvitationEntity> get copyWith => _$DirectInvitationEntityCopyWithImpl<DirectInvitationEntity>(this as DirectInvitationEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DirectInvitationEntity&&(identical(other.invitationId, invitationId) || other.invitationId == invitationId)&&(identical(other.donorId, donorId) || other.donorId == donorId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.status, status) || other.status == status)&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.respondedAt, respondedAt) || other.respondedAt == respondedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,invitationId,donorId,fullName,bloodType,status,appointmentId,expiresAt,respondedAt,createdAt);

@override
String toString() {
  return 'DirectInvitationEntity(invitationId: $invitationId, donorId: $donorId, fullName: $fullName, bloodType: $bloodType, status: $status, appointmentId: $appointmentId, expiresAt: $expiresAt, respondedAt: $respondedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $DirectInvitationEntityCopyWith<$Res>  {
  factory $DirectInvitationEntityCopyWith(DirectInvitationEntity value, $Res Function(DirectInvitationEntity) _then) = _$DirectInvitationEntityCopyWithImpl;
@useResult
$Res call({
 String invitationId, String donorId, String fullName, String bloodType, DirectInvitationStatus status, String? appointmentId, DateTime expiresAt, DateTime? respondedAt, DateTime createdAt
});




}
/// @nodoc
class _$DirectInvitationEntityCopyWithImpl<$Res>
    implements $DirectInvitationEntityCopyWith<$Res> {
  _$DirectInvitationEntityCopyWithImpl(this._self, this._then);

  final DirectInvitationEntity _self;
  final $Res Function(DirectInvitationEntity) _then;

/// Create a copy of DirectInvitationEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? invitationId = null,Object? donorId = null,Object? fullName = null,Object? bloodType = null,Object? status = null,Object? appointmentId = freezed,Object? expiresAt = null,Object? respondedAt = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
invitationId: null == invitationId ? _self.invitationId : invitationId // ignore: cast_nullable_to_non_nullable
as String,donorId: null == donorId ? _self.donorId : donorId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,bloodType: null == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DirectInvitationStatus,appointmentId: freezed == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,respondedAt: freezed == respondedAt ? _self.respondedAt : respondedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DirectInvitationEntity].
extension DirectInvitationEntityPatterns on DirectInvitationEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DirectInvitationEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DirectInvitationEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DirectInvitationEntity value)  $default,){
final _that = this;
switch (_that) {
case _DirectInvitationEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DirectInvitationEntity value)?  $default,){
final _that = this;
switch (_that) {
case _DirectInvitationEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String invitationId,  String donorId,  String fullName,  String bloodType,  DirectInvitationStatus status,  String? appointmentId,  DateTime expiresAt,  DateTime? respondedAt,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DirectInvitationEntity() when $default != null:
return $default(_that.invitationId,_that.donorId,_that.fullName,_that.bloodType,_that.status,_that.appointmentId,_that.expiresAt,_that.respondedAt,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String invitationId,  String donorId,  String fullName,  String bloodType,  DirectInvitationStatus status,  String? appointmentId,  DateTime expiresAt,  DateTime? respondedAt,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _DirectInvitationEntity():
return $default(_that.invitationId,_that.donorId,_that.fullName,_that.bloodType,_that.status,_that.appointmentId,_that.expiresAt,_that.respondedAt,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String invitationId,  String donorId,  String fullName,  String bloodType,  DirectInvitationStatus status,  String? appointmentId,  DateTime expiresAt,  DateTime? respondedAt,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _DirectInvitationEntity() when $default != null:
return $default(_that.invitationId,_that.donorId,_that.fullName,_that.bloodType,_that.status,_that.appointmentId,_that.expiresAt,_that.respondedAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _DirectInvitationEntity implements DirectInvitationEntity {
  const _DirectInvitationEntity({required this.invitationId, required this.donorId, required this.fullName, required this.bloodType, required this.status, this.appointmentId, required this.expiresAt, this.respondedAt, required this.createdAt});
  

@override final  String invitationId;
@override final  String donorId;
@override final  String fullName;
@override final  String bloodType;
@override final  DirectInvitationStatus status;
@override final  String? appointmentId;
@override final  DateTime expiresAt;
@override final  DateTime? respondedAt;
@override final  DateTime createdAt;

/// Create a copy of DirectInvitationEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DirectInvitationEntityCopyWith<_DirectInvitationEntity> get copyWith => __$DirectInvitationEntityCopyWithImpl<_DirectInvitationEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DirectInvitationEntity&&(identical(other.invitationId, invitationId) || other.invitationId == invitationId)&&(identical(other.donorId, donorId) || other.donorId == donorId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.status, status) || other.status == status)&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.respondedAt, respondedAt) || other.respondedAt == respondedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,invitationId,donorId,fullName,bloodType,status,appointmentId,expiresAt,respondedAt,createdAt);

@override
String toString() {
  return 'DirectInvitationEntity(invitationId: $invitationId, donorId: $donorId, fullName: $fullName, bloodType: $bloodType, status: $status, appointmentId: $appointmentId, expiresAt: $expiresAt, respondedAt: $respondedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$DirectInvitationEntityCopyWith<$Res> implements $DirectInvitationEntityCopyWith<$Res> {
  factory _$DirectInvitationEntityCopyWith(_DirectInvitationEntity value, $Res Function(_DirectInvitationEntity) _then) = __$DirectInvitationEntityCopyWithImpl;
@override @useResult
$Res call({
 String invitationId, String donorId, String fullName, String bloodType, DirectInvitationStatus status, String? appointmentId, DateTime expiresAt, DateTime? respondedAt, DateTime createdAt
});




}
/// @nodoc
class __$DirectInvitationEntityCopyWithImpl<$Res>
    implements _$DirectInvitationEntityCopyWith<$Res> {
  __$DirectInvitationEntityCopyWithImpl(this._self, this._then);

  final _DirectInvitationEntity _self;
  final $Res Function(_DirectInvitationEntity) _then;

/// Create a copy of DirectInvitationEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? invitationId = null,Object? donorId = null,Object? fullName = null,Object? bloodType = null,Object? status = null,Object? appointmentId = freezed,Object? expiresAt = null,Object? respondedAt = freezed,Object? createdAt = null,}) {
  return _then(_DirectInvitationEntity(
invitationId: null == invitationId ? _self.invitationId : invitationId // ignore: cast_nullable_to_non_nullable
as String,donorId: null == donorId ? _self.donorId : donorId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,bloodType: null == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DirectInvitationStatus,appointmentId: freezed == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,respondedAt: freezed == respondedAt ? _self.respondedAt : respondedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
