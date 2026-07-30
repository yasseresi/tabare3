// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HospitalModel {

 String get id;@JsonKey(name: 'wilaya_id') int get wilayaId;@JsonKey(name: 'name_ar') String get nameAr;@JsonKey(name: 'name_fr') String? get nameFr; String? get address;@JsonKey(name: 'is_active') bool get isActive;
/// Create a copy of HospitalModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HospitalModelCopyWith<HospitalModel> get copyWith => _$HospitalModelCopyWithImpl<HospitalModel>(this as HospitalModel, _$identity);

  /// Serializes this HospitalModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HospitalModel&&(identical(other.id, id) || other.id == id)&&(identical(other.wilayaId, wilayaId) || other.wilayaId == wilayaId)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.nameFr, nameFr) || other.nameFr == nameFr)&&(identical(other.address, address) || other.address == address)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,wilayaId,nameAr,nameFr,address,isActive);

@override
String toString() {
  return 'HospitalModel(id: $id, wilayaId: $wilayaId, nameAr: $nameAr, nameFr: $nameFr, address: $address, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $HospitalModelCopyWith<$Res>  {
  factory $HospitalModelCopyWith(HospitalModel value, $Res Function(HospitalModel) _then) = _$HospitalModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'wilaya_id') int wilayaId,@JsonKey(name: 'name_ar') String nameAr,@JsonKey(name: 'name_fr') String? nameFr, String? address,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class _$HospitalModelCopyWithImpl<$Res>
    implements $HospitalModelCopyWith<$Res> {
  _$HospitalModelCopyWithImpl(this._self, this._then);

  final HospitalModel _self;
  final $Res Function(HospitalModel) _then;

/// Create a copy of HospitalModel
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


/// Adds pattern-matching-related methods to [HospitalModel].
extension HospitalModelPatterns on HospitalModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HospitalModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HospitalModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HospitalModel value)  $default,){
final _that = this;
switch (_that) {
case _HospitalModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HospitalModel value)?  $default,){
final _that = this;
switch (_that) {
case _HospitalModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'wilaya_id')  int wilayaId, @JsonKey(name: 'name_ar')  String nameAr, @JsonKey(name: 'name_fr')  String? nameFr,  String? address, @JsonKey(name: 'is_active')  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HospitalModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'wilaya_id')  int wilayaId, @JsonKey(name: 'name_ar')  String nameAr, @JsonKey(name: 'name_fr')  String? nameFr,  String? address, @JsonKey(name: 'is_active')  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _HospitalModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'wilaya_id')  int wilayaId, @JsonKey(name: 'name_ar')  String nameAr, @JsonKey(name: 'name_fr')  String? nameFr,  String? address, @JsonKey(name: 'is_active')  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _HospitalModel() when $default != null:
return $default(_that.id,_that.wilayaId,_that.nameAr,_that.nameFr,_that.address,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HospitalModel extends HospitalModel {
  const _HospitalModel({required this.id, @JsonKey(name: 'wilaya_id') required this.wilayaId, @JsonKey(name: 'name_ar') required this.nameAr, @JsonKey(name: 'name_fr') this.nameFr, this.address, @JsonKey(name: 'is_active') required this.isActive}): super._();
  factory _HospitalModel.fromJson(Map<String, dynamic> json) => _$HospitalModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'wilaya_id') final  int wilayaId;
@override@JsonKey(name: 'name_ar') final  String nameAr;
@override@JsonKey(name: 'name_fr') final  String? nameFr;
@override final  String? address;
@override@JsonKey(name: 'is_active') final  bool isActive;

/// Create a copy of HospitalModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HospitalModelCopyWith<_HospitalModel> get copyWith => __$HospitalModelCopyWithImpl<_HospitalModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HospitalModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HospitalModel&&(identical(other.id, id) || other.id == id)&&(identical(other.wilayaId, wilayaId) || other.wilayaId == wilayaId)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.nameFr, nameFr) || other.nameFr == nameFr)&&(identical(other.address, address) || other.address == address)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,wilayaId,nameAr,nameFr,address,isActive);

@override
String toString() {
  return 'HospitalModel(id: $id, wilayaId: $wilayaId, nameAr: $nameAr, nameFr: $nameFr, address: $address, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$HospitalModelCopyWith<$Res> implements $HospitalModelCopyWith<$Res> {
  factory _$HospitalModelCopyWith(_HospitalModel value, $Res Function(_HospitalModel) _then) = __$HospitalModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'wilaya_id') int wilayaId,@JsonKey(name: 'name_ar') String nameAr,@JsonKey(name: 'name_fr') String? nameFr, String? address,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class __$HospitalModelCopyWithImpl<$Res>
    implements _$HospitalModelCopyWith<$Res> {
  __$HospitalModelCopyWithImpl(this._self, this._then);

  final _HospitalModel _self;
  final $Res Function(_HospitalModel) _then;

/// Create a copy of HospitalModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? wilayaId = null,Object? nameAr = null,Object? nameFr = freezed,Object? address = freezed,Object? isActive = null,}) {
  return _then(_HospitalModel(
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
mixin _$BloodRequestModel {

 String get id;@JsonKey(name: 'requested_by') String get requestedBy; HospitalModel get hospital;@JsonKey(name: 'blood_type') String get bloodType; String get urgency;@JsonKey(name: 'units_needed') int get unitsNeeded;@JsonKey(name: 'units_fulfilled') int get unitsFulfilled; String get status;@JsonKey(name: 'needed_by') DateTime? get neededBy;@JsonKey(name: 'expires_at') DateTime? get expiresAt; String? get notes;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of BloodRequestModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BloodRequestModelCopyWith<BloodRequestModel> get copyWith => _$BloodRequestModelCopyWithImpl<BloodRequestModel>(this as BloodRequestModel, _$identity);

  /// Serializes this BloodRequestModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BloodRequestModel&&(identical(other.id, id) || other.id == id)&&(identical(other.requestedBy, requestedBy) || other.requestedBy == requestedBy)&&(identical(other.hospital, hospital) || other.hospital == hospital)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.urgency, urgency) || other.urgency == urgency)&&(identical(other.unitsNeeded, unitsNeeded) || other.unitsNeeded == unitsNeeded)&&(identical(other.unitsFulfilled, unitsFulfilled) || other.unitsFulfilled == unitsFulfilled)&&(identical(other.status, status) || other.status == status)&&(identical(other.neededBy, neededBy) || other.neededBy == neededBy)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,requestedBy,hospital,bloodType,urgency,unitsNeeded,unitsFulfilled,status,neededBy,expiresAt,notes,createdAt);

@override
String toString() {
  return 'BloodRequestModel(id: $id, requestedBy: $requestedBy, hospital: $hospital, bloodType: $bloodType, urgency: $urgency, unitsNeeded: $unitsNeeded, unitsFulfilled: $unitsFulfilled, status: $status, neededBy: $neededBy, expiresAt: $expiresAt, notes: $notes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $BloodRequestModelCopyWith<$Res>  {
  factory $BloodRequestModelCopyWith(BloodRequestModel value, $Res Function(BloodRequestModel) _then) = _$BloodRequestModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'requested_by') String requestedBy, HospitalModel hospital,@JsonKey(name: 'blood_type') String bloodType, String urgency,@JsonKey(name: 'units_needed') int unitsNeeded,@JsonKey(name: 'units_fulfilled') int unitsFulfilled, String status,@JsonKey(name: 'needed_by') DateTime? neededBy,@JsonKey(name: 'expires_at') DateTime? expiresAt, String? notes,@JsonKey(name: 'created_at') DateTime createdAt
});


$HospitalModelCopyWith<$Res> get hospital;

}
/// @nodoc
class _$BloodRequestModelCopyWithImpl<$Res>
    implements $BloodRequestModelCopyWith<$Res> {
  _$BloodRequestModelCopyWithImpl(this._self, this._then);

  final BloodRequestModel _self;
  final $Res Function(BloodRequestModel) _then;

/// Create a copy of BloodRequestModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? requestedBy = null,Object? hospital = null,Object? bloodType = null,Object? urgency = null,Object? unitsNeeded = null,Object? unitsFulfilled = null,Object? status = null,Object? neededBy = freezed,Object? expiresAt = freezed,Object? notes = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,requestedBy: null == requestedBy ? _self.requestedBy : requestedBy // ignore: cast_nullable_to_non_nullable
as String,hospital: null == hospital ? _self.hospital : hospital // ignore: cast_nullable_to_non_nullable
as HospitalModel,bloodType: null == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as String,urgency: null == urgency ? _self.urgency : urgency // ignore: cast_nullable_to_non_nullable
as String,unitsNeeded: null == unitsNeeded ? _self.unitsNeeded : unitsNeeded // ignore: cast_nullable_to_non_nullable
as int,unitsFulfilled: null == unitsFulfilled ? _self.unitsFulfilled : unitsFulfilled // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,neededBy: freezed == neededBy ? _self.neededBy : neededBy // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of BloodRequestModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HospitalModelCopyWith<$Res> get hospital {
  
  return $HospitalModelCopyWith<$Res>(_self.hospital, (value) {
    return _then(_self.copyWith(hospital: value));
  });
}
}


/// Adds pattern-matching-related methods to [BloodRequestModel].
extension BloodRequestModelPatterns on BloodRequestModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BloodRequestModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BloodRequestModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BloodRequestModel value)  $default,){
final _that = this;
switch (_that) {
case _BloodRequestModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BloodRequestModel value)?  $default,){
final _that = this;
switch (_that) {
case _BloodRequestModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'requested_by')  String requestedBy,  HospitalModel hospital, @JsonKey(name: 'blood_type')  String bloodType,  String urgency, @JsonKey(name: 'units_needed')  int unitsNeeded, @JsonKey(name: 'units_fulfilled')  int unitsFulfilled,  String status, @JsonKey(name: 'needed_by')  DateTime? neededBy, @JsonKey(name: 'expires_at')  DateTime? expiresAt,  String? notes, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BloodRequestModel() when $default != null:
return $default(_that.id,_that.requestedBy,_that.hospital,_that.bloodType,_that.urgency,_that.unitsNeeded,_that.unitsFulfilled,_that.status,_that.neededBy,_that.expiresAt,_that.notes,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'requested_by')  String requestedBy,  HospitalModel hospital, @JsonKey(name: 'blood_type')  String bloodType,  String urgency, @JsonKey(name: 'units_needed')  int unitsNeeded, @JsonKey(name: 'units_fulfilled')  int unitsFulfilled,  String status, @JsonKey(name: 'needed_by')  DateTime? neededBy, @JsonKey(name: 'expires_at')  DateTime? expiresAt,  String? notes, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _BloodRequestModel():
return $default(_that.id,_that.requestedBy,_that.hospital,_that.bloodType,_that.urgency,_that.unitsNeeded,_that.unitsFulfilled,_that.status,_that.neededBy,_that.expiresAt,_that.notes,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'requested_by')  String requestedBy,  HospitalModel hospital, @JsonKey(name: 'blood_type')  String bloodType,  String urgency, @JsonKey(name: 'units_needed')  int unitsNeeded, @JsonKey(name: 'units_fulfilled')  int unitsFulfilled,  String status, @JsonKey(name: 'needed_by')  DateTime? neededBy, @JsonKey(name: 'expires_at')  DateTime? expiresAt,  String? notes, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _BloodRequestModel() when $default != null:
return $default(_that.id,_that.requestedBy,_that.hospital,_that.bloodType,_that.urgency,_that.unitsNeeded,_that.unitsFulfilled,_that.status,_that.neededBy,_that.expiresAt,_that.notes,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BloodRequestModel extends BloodRequestModel {
  const _BloodRequestModel({required this.id, @JsonKey(name: 'requested_by') required this.requestedBy, required this.hospital, @JsonKey(name: 'blood_type') required this.bloodType, required this.urgency, @JsonKey(name: 'units_needed') required this.unitsNeeded, @JsonKey(name: 'units_fulfilled') required this.unitsFulfilled, required this.status, @JsonKey(name: 'needed_by') this.neededBy, @JsonKey(name: 'expires_at') this.expiresAt, this.notes, @JsonKey(name: 'created_at') required this.createdAt}): super._();
  factory _BloodRequestModel.fromJson(Map<String, dynamic> json) => _$BloodRequestModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'requested_by') final  String requestedBy;
@override final  HospitalModel hospital;
@override@JsonKey(name: 'blood_type') final  String bloodType;
@override final  String urgency;
@override@JsonKey(name: 'units_needed') final  int unitsNeeded;
@override@JsonKey(name: 'units_fulfilled') final  int unitsFulfilled;
@override final  String status;
@override@JsonKey(name: 'needed_by') final  DateTime? neededBy;
@override@JsonKey(name: 'expires_at') final  DateTime? expiresAt;
@override final  String? notes;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of BloodRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BloodRequestModelCopyWith<_BloodRequestModel> get copyWith => __$BloodRequestModelCopyWithImpl<_BloodRequestModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BloodRequestModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BloodRequestModel&&(identical(other.id, id) || other.id == id)&&(identical(other.requestedBy, requestedBy) || other.requestedBy == requestedBy)&&(identical(other.hospital, hospital) || other.hospital == hospital)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.urgency, urgency) || other.urgency == urgency)&&(identical(other.unitsNeeded, unitsNeeded) || other.unitsNeeded == unitsNeeded)&&(identical(other.unitsFulfilled, unitsFulfilled) || other.unitsFulfilled == unitsFulfilled)&&(identical(other.status, status) || other.status == status)&&(identical(other.neededBy, neededBy) || other.neededBy == neededBy)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,requestedBy,hospital,bloodType,urgency,unitsNeeded,unitsFulfilled,status,neededBy,expiresAt,notes,createdAt);

@override
String toString() {
  return 'BloodRequestModel(id: $id, requestedBy: $requestedBy, hospital: $hospital, bloodType: $bloodType, urgency: $urgency, unitsNeeded: $unitsNeeded, unitsFulfilled: $unitsFulfilled, status: $status, neededBy: $neededBy, expiresAt: $expiresAt, notes: $notes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BloodRequestModelCopyWith<$Res> implements $BloodRequestModelCopyWith<$Res> {
  factory _$BloodRequestModelCopyWith(_BloodRequestModel value, $Res Function(_BloodRequestModel) _then) = __$BloodRequestModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'requested_by') String requestedBy, HospitalModel hospital,@JsonKey(name: 'blood_type') String bloodType, String urgency,@JsonKey(name: 'units_needed') int unitsNeeded,@JsonKey(name: 'units_fulfilled') int unitsFulfilled, String status,@JsonKey(name: 'needed_by') DateTime? neededBy,@JsonKey(name: 'expires_at') DateTime? expiresAt, String? notes,@JsonKey(name: 'created_at') DateTime createdAt
});


@override $HospitalModelCopyWith<$Res> get hospital;

}
/// @nodoc
class __$BloodRequestModelCopyWithImpl<$Res>
    implements _$BloodRequestModelCopyWith<$Res> {
  __$BloodRequestModelCopyWithImpl(this._self, this._then);

  final _BloodRequestModel _self;
  final $Res Function(_BloodRequestModel) _then;

/// Create a copy of BloodRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? requestedBy = null,Object? hospital = null,Object? bloodType = null,Object? urgency = null,Object? unitsNeeded = null,Object? unitsFulfilled = null,Object? status = null,Object? neededBy = freezed,Object? expiresAt = freezed,Object? notes = freezed,Object? createdAt = null,}) {
  return _then(_BloodRequestModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,requestedBy: null == requestedBy ? _self.requestedBy : requestedBy // ignore: cast_nullable_to_non_nullable
as String,hospital: null == hospital ? _self.hospital : hospital // ignore: cast_nullable_to_non_nullable
as HospitalModel,bloodType: null == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as String,urgency: null == urgency ? _self.urgency : urgency // ignore: cast_nullable_to_non_nullable
as String,unitsNeeded: null == unitsNeeded ? _self.unitsNeeded : unitsNeeded // ignore: cast_nullable_to_non_nullable
as int,unitsFulfilled: null == unitsFulfilled ? _self.unitsFulfilled : unitsFulfilled // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,neededBy: freezed == neededBy ? _self.neededBy : neededBy // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of BloodRequestModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HospitalModelCopyWith<$Res> get hospital {
  
  return $HospitalModelCopyWith<$Res>(_self.hospital, (value) {
    return _then(_self.copyWith(hospital: value));
  });
}
}


/// @nodoc
mixin _$RequestDonorModel {

@JsonKey(name: 'donor_id') String get donorId;@JsonKey(name: 'full_name') String get fullName;@JsonKey(name: 'blood_type') String get bloodType;@JsonKey(name: 'appointment_id') String get appointmentId; String get status;@JsonKey(name: 'scheduled_at') DateTime get scheduledAt;@JsonKey(name: 'completed_at') DateTime? get completedAt;
/// Create a copy of RequestDonorModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestDonorModelCopyWith<RequestDonorModel> get copyWith => _$RequestDonorModelCopyWithImpl<RequestDonorModel>(this as RequestDonorModel, _$identity);

  /// Serializes this RequestDonorModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestDonorModel&&(identical(other.donorId, donorId) || other.donorId == donorId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.status, status) || other.status == status)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,donorId,fullName,bloodType,appointmentId,status,scheduledAt,completedAt);

@override
String toString() {
  return 'RequestDonorModel(donorId: $donorId, fullName: $fullName, bloodType: $bloodType, appointmentId: $appointmentId, status: $status, scheduledAt: $scheduledAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $RequestDonorModelCopyWith<$Res>  {
  factory $RequestDonorModelCopyWith(RequestDonorModel value, $Res Function(RequestDonorModel) _then) = _$RequestDonorModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'donor_id') String donorId,@JsonKey(name: 'full_name') String fullName,@JsonKey(name: 'blood_type') String bloodType,@JsonKey(name: 'appointment_id') String appointmentId, String status,@JsonKey(name: 'scheduled_at') DateTime scheduledAt,@JsonKey(name: 'completed_at') DateTime? completedAt
});




}
/// @nodoc
class _$RequestDonorModelCopyWithImpl<$Res>
    implements $RequestDonorModelCopyWith<$Res> {
  _$RequestDonorModelCopyWithImpl(this._self, this._then);

  final RequestDonorModel _self;
  final $Res Function(RequestDonorModel) _then;

/// Create a copy of RequestDonorModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? donorId = null,Object? fullName = null,Object? bloodType = null,Object? appointmentId = null,Object? status = null,Object? scheduledAt = null,Object? completedAt = freezed,}) {
  return _then(_self.copyWith(
donorId: null == donorId ? _self.donorId : donorId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,bloodType: null == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as String,appointmentId: null == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RequestDonorModel].
extension RequestDonorModelPatterns on RequestDonorModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RequestDonorModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RequestDonorModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RequestDonorModel value)  $default,){
final _that = this;
switch (_that) {
case _RequestDonorModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RequestDonorModel value)?  $default,){
final _that = this;
switch (_that) {
case _RequestDonorModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'donor_id')  String donorId, @JsonKey(name: 'full_name')  String fullName, @JsonKey(name: 'blood_type')  String bloodType, @JsonKey(name: 'appointment_id')  String appointmentId,  String status, @JsonKey(name: 'scheduled_at')  DateTime scheduledAt, @JsonKey(name: 'completed_at')  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RequestDonorModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'donor_id')  String donorId, @JsonKey(name: 'full_name')  String fullName, @JsonKey(name: 'blood_type')  String bloodType, @JsonKey(name: 'appointment_id')  String appointmentId,  String status, @JsonKey(name: 'scheduled_at')  DateTime scheduledAt, @JsonKey(name: 'completed_at')  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _RequestDonorModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'donor_id')  String donorId, @JsonKey(name: 'full_name')  String fullName, @JsonKey(name: 'blood_type')  String bloodType, @JsonKey(name: 'appointment_id')  String appointmentId,  String status, @JsonKey(name: 'scheduled_at')  DateTime scheduledAt, @JsonKey(name: 'completed_at')  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _RequestDonorModel() when $default != null:
return $default(_that.donorId,_that.fullName,_that.bloodType,_that.appointmentId,_that.status,_that.scheduledAt,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RequestDonorModel extends RequestDonorModel {
  const _RequestDonorModel({@JsonKey(name: 'donor_id') required this.donorId, @JsonKey(name: 'full_name') required this.fullName, @JsonKey(name: 'blood_type') required this.bloodType, @JsonKey(name: 'appointment_id') required this.appointmentId, required this.status, @JsonKey(name: 'scheduled_at') required this.scheduledAt, @JsonKey(name: 'completed_at') this.completedAt}): super._();
  factory _RequestDonorModel.fromJson(Map<String, dynamic> json) => _$RequestDonorModelFromJson(json);

@override@JsonKey(name: 'donor_id') final  String donorId;
@override@JsonKey(name: 'full_name') final  String fullName;
@override@JsonKey(name: 'blood_type') final  String bloodType;
@override@JsonKey(name: 'appointment_id') final  String appointmentId;
@override final  String status;
@override@JsonKey(name: 'scheduled_at') final  DateTime scheduledAt;
@override@JsonKey(name: 'completed_at') final  DateTime? completedAt;

/// Create a copy of RequestDonorModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequestDonorModelCopyWith<_RequestDonorModel> get copyWith => __$RequestDonorModelCopyWithImpl<_RequestDonorModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RequestDonorModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestDonorModel&&(identical(other.donorId, donorId) || other.donorId == donorId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.status, status) || other.status == status)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,donorId,fullName,bloodType,appointmentId,status,scheduledAt,completedAt);

@override
String toString() {
  return 'RequestDonorModel(donorId: $donorId, fullName: $fullName, bloodType: $bloodType, appointmentId: $appointmentId, status: $status, scheduledAt: $scheduledAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$RequestDonorModelCopyWith<$Res> implements $RequestDonorModelCopyWith<$Res> {
  factory _$RequestDonorModelCopyWith(_RequestDonorModel value, $Res Function(_RequestDonorModel) _then) = __$RequestDonorModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'donor_id') String donorId,@JsonKey(name: 'full_name') String fullName,@JsonKey(name: 'blood_type') String bloodType,@JsonKey(name: 'appointment_id') String appointmentId, String status,@JsonKey(name: 'scheduled_at') DateTime scheduledAt,@JsonKey(name: 'completed_at') DateTime? completedAt
});




}
/// @nodoc
class __$RequestDonorModelCopyWithImpl<$Res>
    implements _$RequestDonorModelCopyWith<$Res> {
  __$RequestDonorModelCopyWithImpl(this._self, this._then);

  final _RequestDonorModel _self;
  final $Res Function(_RequestDonorModel) _then;

/// Create a copy of RequestDonorModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? donorId = null,Object? fullName = null,Object? bloodType = null,Object? appointmentId = null,Object? status = null,Object? scheduledAt = null,Object? completedAt = freezed,}) {
  return _then(_RequestDonorModel(
donorId: null == donorId ? _self.donorId : donorId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,bloodType: null == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as String,appointmentId: null == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$CompatibleDonorModel {

@JsonKey(name: 'donor_id') String get donorId;@JsonKey(name: 'full_name') String get fullName;@JsonKey(name: 'blood_type') String get bloodType;@JsonKey(name: 'wilaya_id') int get wilayaId;@JsonKey(name: 'cooldown_until') DateTime? get cooldownUntil;
/// Create a copy of CompatibleDonorModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompatibleDonorModelCopyWith<CompatibleDonorModel> get copyWith => _$CompatibleDonorModelCopyWithImpl<CompatibleDonorModel>(this as CompatibleDonorModel, _$identity);

  /// Serializes this CompatibleDonorModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompatibleDonorModel&&(identical(other.donorId, donorId) || other.donorId == donorId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.wilayaId, wilayaId) || other.wilayaId == wilayaId)&&(identical(other.cooldownUntil, cooldownUntil) || other.cooldownUntil == cooldownUntil));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,donorId,fullName,bloodType,wilayaId,cooldownUntil);

@override
String toString() {
  return 'CompatibleDonorModel(donorId: $donorId, fullName: $fullName, bloodType: $bloodType, wilayaId: $wilayaId, cooldownUntil: $cooldownUntil)';
}


}

/// @nodoc
abstract mixin class $CompatibleDonorModelCopyWith<$Res>  {
  factory $CompatibleDonorModelCopyWith(CompatibleDonorModel value, $Res Function(CompatibleDonorModel) _then) = _$CompatibleDonorModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'donor_id') String donorId,@JsonKey(name: 'full_name') String fullName,@JsonKey(name: 'blood_type') String bloodType,@JsonKey(name: 'wilaya_id') int wilayaId,@JsonKey(name: 'cooldown_until') DateTime? cooldownUntil
});




}
/// @nodoc
class _$CompatibleDonorModelCopyWithImpl<$Res>
    implements $CompatibleDonorModelCopyWith<$Res> {
  _$CompatibleDonorModelCopyWithImpl(this._self, this._then);

  final CompatibleDonorModel _self;
  final $Res Function(CompatibleDonorModel) _then;

/// Create a copy of CompatibleDonorModel
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


/// Adds pattern-matching-related methods to [CompatibleDonorModel].
extension CompatibleDonorModelPatterns on CompatibleDonorModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CompatibleDonorModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CompatibleDonorModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CompatibleDonorModel value)  $default,){
final _that = this;
switch (_that) {
case _CompatibleDonorModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CompatibleDonorModel value)?  $default,){
final _that = this;
switch (_that) {
case _CompatibleDonorModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'donor_id')  String donorId, @JsonKey(name: 'full_name')  String fullName, @JsonKey(name: 'blood_type')  String bloodType, @JsonKey(name: 'wilaya_id')  int wilayaId, @JsonKey(name: 'cooldown_until')  DateTime? cooldownUntil)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CompatibleDonorModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'donor_id')  String donorId, @JsonKey(name: 'full_name')  String fullName, @JsonKey(name: 'blood_type')  String bloodType, @JsonKey(name: 'wilaya_id')  int wilayaId, @JsonKey(name: 'cooldown_until')  DateTime? cooldownUntil)  $default,) {final _that = this;
switch (_that) {
case _CompatibleDonorModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'donor_id')  String donorId, @JsonKey(name: 'full_name')  String fullName, @JsonKey(name: 'blood_type')  String bloodType, @JsonKey(name: 'wilaya_id')  int wilayaId, @JsonKey(name: 'cooldown_until')  DateTime? cooldownUntil)?  $default,) {final _that = this;
switch (_that) {
case _CompatibleDonorModel() when $default != null:
return $default(_that.donorId,_that.fullName,_that.bloodType,_that.wilayaId,_that.cooldownUntil);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CompatibleDonorModel extends CompatibleDonorModel {
  const _CompatibleDonorModel({@JsonKey(name: 'donor_id') required this.donorId, @JsonKey(name: 'full_name') required this.fullName, @JsonKey(name: 'blood_type') required this.bloodType, @JsonKey(name: 'wilaya_id') required this.wilayaId, @JsonKey(name: 'cooldown_until') this.cooldownUntil}): super._();
  factory _CompatibleDonorModel.fromJson(Map<String, dynamic> json) => _$CompatibleDonorModelFromJson(json);

@override@JsonKey(name: 'donor_id') final  String donorId;
@override@JsonKey(name: 'full_name') final  String fullName;
@override@JsonKey(name: 'blood_type') final  String bloodType;
@override@JsonKey(name: 'wilaya_id') final  int wilayaId;
@override@JsonKey(name: 'cooldown_until') final  DateTime? cooldownUntil;

/// Create a copy of CompatibleDonorModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompatibleDonorModelCopyWith<_CompatibleDonorModel> get copyWith => __$CompatibleDonorModelCopyWithImpl<_CompatibleDonorModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CompatibleDonorModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompatibleDonorModel&&(identical(other.donorId, donorId) || other.donorId == donorId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.wilayaId, wilayaId) || other.wilayaId == wilayaId)&&(identical(other.cooldownUntil, cooldownUntil) || other.cooldownUntil == cooldownUntil));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,donorId,fullName,bloodType,wilayaId,cooldownUntil);

@override
String toString() {
  return 'CompatibleDonorModel(donorId: $donorId, fullName: $fullName, bloodType: $bloodType, wilayaId: $wilayaId, cooldownUntil: $cooldownUntil)';
}


}

/// @nodoc
abstract mixin class _$CompatibleDonorModelCopyWith<$Res> implements $CompatibleDonorModelCopyWith<$Res> {
  factory _$CompatibleDonorModelCopyWith(_CompatibleDonorModel value, $Res Function(_CompatibleDonorModel) _then) = __$CompatibleDonorModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'donor_id') String donorId,@JsonKey(name: 'full_name') String fullName,@JsonKey(name: 'blood_type') String bloodType,@JsonKey(name: 'wilaya_id') int wilayaId,@JsonKey(name: 'cooldown_until') DateTime? cooldownUntil
});




}
/// @nodoc
class __$CompatibleDonorModelCopyWithImpl<$Res>
    implements _$CompatibleDonorModelCopyWith<$Res> {
  __$CompatibleDonorModelCopyWithImpl(this._self, this._then);

  final _CompatibleDonorModel _self;
  final $Res Function(_CompatibleDonorModel) _then;

/// Create a copy of CompatibleDonorModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? donorId = null,Object? fullName = null,Object? bloodType = null,Object? wilayaId = null,Object? cooldownUntil = freezed,}) {
  return _then(_CompatibleDonorModel(
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
mixin _$IssuedRequestQrModel {

 String get token;@JsonKey(name: 'expires_at') DateTime get expiresAt;
/// Create a copy of IssuedRequestQrModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IssuedRequestQrModelCopyWith<IssuedRequestQrModel> get copyWith => _$IssuedRequestQrModelCopyWithImpl<IssuedRequestQrModel>(this as IssuedRequestQrModel, _$identity);

  /// Serializes this IssuedRequestQrModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IssuedRequestQrModel&&(identical(other.token, token) || other.token == token)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,expiresAt);

@override
String toString() {
  return 'IssuedRequestQrModel(token: $token, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $IssuedRequestQrModelCopyWith<$Res>  {
  factory $IssuedRequestQrModelCopyWith(IssuedRequestQrModel value, $Res Function(IssuedRequestQrModel) _then) = _$IssuedRequestQrModelCopyWithImpl;
@useResult
$Res call({
 String token,@JsonKey(name: 'expires_at') DateTime expiresAt
});




}
/// @nodoc
class _$IssuedRequestQrModelCopyWithImpl<$Res>
    implements $IssuedRequestQrModelCopyWith<$Res> {
  _$IssuedRequestQrModelCopyWithImpl(this._self, this._then);

  final IssuedRequestQrModel _self;
  final $Res Function(IssuedRequestQrModel) _then;

/// Create a copy of IssuedRequestQrModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = null,Object? expiresAt = null,}) {
  return _then(_self.copyWith(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [IssuedRequestQrModel].
extension IssuedRequestQrModelPatterns on IssuedRequestQrModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IssuedRequestQrModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IssuedRequestQrModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IssuedRequestQrModel value)  $default,){
final _that = this;
switch (_that) {
case _IssuedRequestQrModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IssuedRequestQrModel value)?  $default,){
final _that = this;
switch (_that) {
case _IssuedRequestQrModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String token, @JsonKey(name: 'expires_at')  DateTime expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IssuedRequestQrModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String token, @JsonKey(name: 'expires_at')  DateTime expiresAt)  $default,) {final _that = this;
switch (_that) {
case _IssuedRequestQrModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String token, @JsonKey(name: 'expires_at')  DateTime expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _IssuedRequestQrModel() when $default != null:
return $default(_that.token,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IssuedRequestQrModel extends IssuedRequestQrModel {
  const _IssuedRequestQrModel({required this.token, @JsonKey(name: 'expires_at') required this.expiresAt}): super._();
  factory _IssuedRequestQrModel.fromJson(Map<String, dynamic> json) => _$IssuedRequestQrModelFromJson(json);

@override final  String token;
@override@JsonKey(name: 'expires_at') final  DateTime expiresAt;

/// Create a copy of IssuedRequestQrModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IssuedRequestQrModelCopyWith<_IssuedRequestQrModel> get copyWith => __$IssuedRequestQrModelCopyWithImpl<_IssuedRequestQrModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IssuedRequestQrModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IssuedRequestQrModel&&(identical(other.token, token) || other.token == token)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,expiresAt);

@override
String toString() {
  return 'IssuedRequestQrModel(token: $token, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$IssuedRequestQrModelCopyWith<$Res> implements $IssuedRequestQrModelCopyWith<$Res> {
  factory _$IssuedRequestQrModelCopyWith(_IssuedRequestQrModel value, $Res Function(_IssuedRequestQrModel) _then) = __$IssuedRequestQrModelCopyWithImpl;
@override @useResult
$Res call({
 String token,@JsonKey(name: 'expires_at') DateTime expiresAt
});




}
/// @nodoc
class __$IssuedRequestQrModelCopyWithImpl<$Res>
    implements _$IssuedRequestQrModelCopyWith<$Res> {
  __$IssuedRequestQrModelCopyWithImpl(this._self, this._then);

  final _IssuedRequestQrModel _self;
  final $Res Function(_IssuedRequestQrModel) _then;

/// Create a copy of IssuedRequestQrModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = null,Object? expiresAt = null,}) {
  return _then(_IssuedRequestQrModel(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$DirectInvitationModel {

@JsonKey(name: 'invitation_id') String get invitationId;@JsonKey(name: 'donor_id') String get donorId;@JsonKey(name: 'full_name') String get fullName;@JsonKey(name: 'blood_type') String get bloodType; String get status;@JsonKey(name: 'appointment_id') String? get appointmentId;@JsonKey(name: 'expires_at') DateTime get expiresAt;@JsonKey(name: 'responded_at') DateTime? get respondedAt;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of DirectInvitationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DirectInvitationModelCopyWith<DirectInvitationModel> get copyWith => _$DirectInvitationModelCopyWithImpl<DirectInvitationModel>(this as DirectInvitationModel, _$identity);

  /// Serializes this DirectInvitationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DirectInvitationModel&&(identical(other.invitationId, invitationId) || other.invitationId == invitationId)&&(identical(other.donorId, donorId) || other.donorId == donorId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.status, status) || other.status == status)&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.respondedAt, respondedAt) || other.respondedAt == respondedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,invitationId,donorId,fullName,bloodType,status,appointmentId,expiresAt,respondedAt,createdAt);

@override
String toString() {
  return 'DirectInvitationModel(invitationId: $invitationId, donorId: $donorId, fullName: $fullName, bloodType: $bloodType, status: $status, appointmentId: $appointmentId, expiresAt: $expiresAt, respondedAt: $respondedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $DirectInvitationModelCopyWith<$Res>  {
  factory $DirectInvitationModelCopyWith(DirectInvitationModel value, $Res Function(DirectInvitationModel) _then) = _$DirectInvitationModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'invitation_id') String invitationId,@JsonKey(name: 'donor_id') String donorId,@JsonKey(name: 'full_name') String fullName,@JsonKey(name: 'blood_type') String bloodType, String status,@JsonKey(name: 'appointment_id') String? appointmentId,@JsonKey(name: 'expires_at') DateTime expiresAt,@JsonKey(name: 'responded_at') DateTime? respondedAt,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$DirectInvitationModelCopyWithImpl<$Res>
    implements $DirectInvitationModelCopyWith<$Res> {
  _$DirectInvitationModelCopyWithImpl(this._self, this._then);

  final DirectInvitationModel _self;
  final $Res Function(DirectInvitationModel) _then;

/// Create a copy of DirectInvitationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? invitationId = null,Object? donorId = null,Object? fullName = null,Object? bloodType = null,Object? status = null,Object? appointmentId = freezed,Object? expiresAt = null,Object? respondedAt = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
invitationId: null == invitationId ? _self.invitationId : invitationId // ignore: cast_nullable_to_non_nullable
as String,donorId: null == donorId ? _self.donorId : donorId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,bloodType: null == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,appointmentId: freezed == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,respondedAt: freezed == respondedAt ? _self.respondedAt : respondedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DirectInvitationModel].
extension DirectInvitationModelPatterns on DirectInvitationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DirectInvitationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DirectInvitationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DirectInvitationModel value)  $default,){
final _that = this;
switch (_that) {
case _DirectInvitationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DirectInvitationModel value)?  $default,){
final _that = this;
switch (_that) {
case _DirectInvitationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'invitation_id')  String invitationId, @JsonKey(name: 'donor_id')  String donorId, @JsonKey(name: 'full_name')  String fullName, @JsonKey(name: 'blood_type')  String bloodType,  String status, @JsonKey(name: 'appointment_id')  String? appointmentId, @JsonKey(name: 'expires_at')  DateTime expiresAt, @JsonKey(name: 'responded_at')  DateTime? respondedAt, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DirectInvitationModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'invitation_id')  String invitationId, @JsonKey(name: 'donor_id')  String donorId, @JsonKey(name: 'full_name')  String fullName, @JsonKey(name: 'blood_type')  String bloodType,  String status, @JsonKey(name: 'appointment_id')  String? appointmentId, @JsonKey(name: 'expires_at')  DateTime expiresAt, @JsonKey(name: 'responded_at')  DateTime? respondedAt, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _DirectInvitationModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'invitation_id')  String invitationId, @JsonKey(name: 'donor_id')  String donorId, @JsonKey(name: 'full_name')  String fullName, @JsonKey(name: 'blood_type')  String bloodType,  String status, @JsonKey(name: 'appointment_id')  String? appointmentId, @JsonKey(name: 'expires_at')  DateTime expiresAt, @JsonKey(name: 'responded_at')  DateTime? respondedAt, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _DirectInvitationModel() when $default != null:
return $default(_that.invitationId,_that.donorId,_that.fullName,_that.bloodType,_that.status,_that.appointmentId,_that.expiresAt,_that.respondedAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DirectInvitationModel extends DirectInvitationModel {
  const _DirectInvitationModel({@JsonKey(name: 'invitation_id') required this.invitationId, @JsonKey(name: 'donor_id') required this.donorId, @JsonKey(name: 'full_name') required this.fullName, @JsonKey(name: 'blood_type') required this.bloodType, required this.status, @JsonKey(name: 'appointment_id') this.appointmentId, @JsonKey(name: 'expires_at') required this.expiresAt, @JsonKey(name: 'responded_at') this.respondedAt, @JsonKey(name: 'created_at') required this.createdAt}): super._();
  factory _DirectInvitationModel.fromJson(Map<String, dynamic> json) => _$DirectInvitationModelFromJson(json);

@override@JsonKey(name: 'invitation_id') final  String invitationId;
@override@JsonKey(name: 'donor_id') final  String donorId;
@override@JsonKey(name: 'full_name') final  String fullName;
@override@JsonKey(name: 'blood_type') final  String bloodType;
@override final  String status;
@override@JsonKey(name: 'appointment_id') final  String? appointmentId;
@override@JsonKey(name: 'expires_at') final  DateTime expiresAt;
@override@JsonKey(name: 'responded_at') final  DateTime? respondedAt;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of DirectInvitationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DirectInvitationModelCopyWith<_DirectInvitationModel> get copyWith => __$DirectInvitationModelCopyWithImpl<_DirectInvitationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DirectInvitationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DirectInvitationModel&&(identical(other.invitationId, invitationId) || other.invitationId == invitationId)&&(identical(other.donorId, donorId) || other.donorId == donorId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.status, status) || other.status == status)&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.respondedAt, respondedAt) || other.respondedAt == respondedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,invitationId,donorId,fullName,bloodType,status,appointmentId,expiresAt,respondedAt,createdAt);

@override
String toString() {
  return 'DirectInvitationModel(invitationId: $invitationId, donorId: $donorId, fullName: $fullName, bloodType: $bloodType, status: $status, appointmentId: $appointmentId, expiresAt: $expiresAt, respondedAt: $respondedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$DirectInvitationModelCopyWith<$Res> implements $DirectInvitationModelCopyWith<$Res> {
  factory _$DirectInvitationModelCopyWith(_DirectInvitationModel value, $Res Function(_DirectInvitationModel) _then) = __$DirectInvitationModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'invitation_id') String invitationId,@JsonKey(name: 'donor_id') String donorId,@JsonKey(name: 'full_name') String fullName,@JsonKey(name: 'blood_type') String bloodType, String status,@JsonKey(name: 'appointment_id') String? appointmentId,@JsonKey(name: 'expires_at') DateTime expiresAt,@JsonKey(name: 'responded_at') DateTime? respondedAt,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$DirectInvitationModelCopyWithImpl<$Res>
    implements _$DirectInvitationModelCopyWith<$Res> {
  __$DirectInvitationModelCopyWithImpl(this._self, this._then);

  final _DirectInvitationModel _self;
  final $Res Function(_DirectInvitationModel) _then;

/// Create a copy of DirectInvitationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? invitationId = null,Object? donorId = null,Object? fullName = null,Object? bloodType = null,Object? status = null,Object? appointmentId = freezed,Object? expiresAt = null,Object? respondedAt = freezed,Object? createdAt = null,}) {
  return _then(_DirectInvitationModel(
invitationId: null == invitationId ? _self.invitationId : invitationId // ignore: cast_nullable_to_non_nullable
as String,donorId: null == donorId ? _self.donorId : donorId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,bloodType: null == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,appointmentId: freezed == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,respondedAt: freezed == respondedAt ? _self.respondedAt : respondedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
