// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'donor_feed_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DonorHospitalEntity {

 String get id; int get wilayaId; String get nameAr; String? get nameFr; String? get address; bool get isActive;
/// Create a copy of DonorHospitalEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DonorHospitalEntityCopyWith<DonorHospitalEntity> get copyWith => _$DonorHospitalEntityCopyWithImpl<DonorHospitalEntity>(this as DonorHospitalEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DonorHospitalEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.wilayaId, wilayaId) || other.wilayaId == wilayaId)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.nameFr, nameFr) || other.nameFr == nameFr)&&(identical(other.address, address) || other.address == address)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,id,wilayaId,nameAr,nameFr,address,isActive);

@override
String toString() {
  return 'DonorHospitalEntity(id: $id, wilayaId: $wilayaId, nameAr: $nameAr, nameFr: $nameFr, address: $address, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $DonorHospitalEntityCopyWith<$Res>  {
  factory $DonorHospitalEntityCopyWith(DonorHospitalEntity value, $Res Function(DonorHospitalEntity) _then) = _$DonorHospitalEntityCopyWithImpl;
@useResult
$Res call({
 String id, int wilayaId, String nameAr, String? nameFr, String? address, bool isActive
});




}
/// @nodoc
class _$DonorHospitalEntityCopyWithImpl<$Res>
    implements $DonorHospitalEntityCopyWith<$Res> {
  _$DonorHospitalEntityCopyWithImpl(this._self, this._then);

  final DonorHospitalEntity _self;
  final $Res Function(DonorHospitalEntity) _then;

/// Create a copy of DonorHospitalEntity
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


/// Adds pattern-matching-related methods to [DonorHospitalEntity].
extension DonorHospitalEntityPatterns on DonorHospitalEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DonorHospitalEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DonorHospitalEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DonorHospitalEntity value)  $default,){
final _that = this;
switch (_that) {
case _DonorHospitalEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DonorHospitalEntity value)?  $default,){
final _that = this;
switch (_that) {
case _DonorHospitalEntity() when $default != null:
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
case _DonorHospitalEntity() when $default != null:
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
case _DonorHospitalEntity():
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
case _DonorHospitalEntity() when $default != null:
return $default(_that.id,_that.wilayaId,_that.nameAr,_that.nameFr,_that.address,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc


class _DonorHospitalEntity implements DonorHospitalEntity {
  const _DonorHospitalEntity({required this.id, required this.wilayaId, required this.nameAr, this.nameFr, this.address, required this.isActive});
  

@override final  String id;
@override final  int wilayaId;
@override final  String nameAr;
@override final  String? nameFr;
@override final  String? address;
@override final  bool isActive;

/// Create a copy of DonorHospitalEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DonorHospitalEntityCopyWith<_DonorHospitalEntity> get copyWith => __$DonorHospitalEntityCopyWithImpl<_DonorHospitalEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DonorHospitalEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.wilayaId, wilayaId) || other.wilayaId == wilayaId)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.nameFr, nameFr) || other.nameFr == nameFr)&&(identical(other.address, address) || other.address == address)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,id,wilayaId,nameAr,nameFr,address,isActive);

@override
String toString() {
  return 'DonorHospitalEntity(id: $id, wilayaId: $wilayaId, nameAr: $nameAr, nameFr: $nameFr, address: $address, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$DonorHospitalEntityCopyWith<$Res> implements $DonorHospitalEntityCopyWith<$Res> {
  factory _$DonorHospitalEntityCopyWith(_DonorHospitalEntity value, $Res Function(_DonorHospitalEntity) _then) = __$DonorHospitalEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, int wilayaId, String nameAr, String? nameFr, String? address, bool isActive
});




}
/// @nodoc
class __$DonorHospitalEntityCopyWithImpl<$Res>
    implements _$DonorHospitalEntityCopyWith<$Res> {
  __$DonorHospitalEntityCopyWithImpl(this._self, this._then);

  final _DonorHospitalEntity _self;
  final $Res Function(_DonorHospitalEntity) _then;

/// Create a copy of DonorHospitalEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? wilayaId = null,Object? nameAr = null,Object? nameFr = freezed,Object? address = freezed,Object? isActive = null,}) {
  return _then(_DonorHospitalEntity(
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
mixin _$DonorAvailabilityEntity {

 String get userId; bool get isAccountActive; bool get isAvailableForDonation; bool get isDonor; String get bloodType; int get wilayaId; DateTime? get cooldownUntil; DateTime? get lastDonationDate; int get totalDonationsCount;
/// Create a copy of DonorAvailabilityEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DonorAvailabilityEntityCopyWith<DonorAvailabilityEntity> get copyWith => _$DonorAvailabilityEntityCopyWithImpl<DonorAvailabilityEntity>(this as DonorAvailabilityEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DonorAvailabilityEntity&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.isAccountActive, isAccountActive) || other.isAccountActive == isAccountActive)&&(identical(other.isAvailableForDonation, isAvailableForDonation) || other.isAvailableForDonation == isAvailableForDonation)&&(identical(other.isDonor, isDonor) || other.isDonor == isDonor)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.wilayaId, wilayaId) || other.wilayaId == wilayaId)&&(identical(other.cooldownUntil, cooldownUntil) || other.cooldownUntil == cooldownUntil)&&(identical(other.lastDonationDate, lastDonationDate) || other.lastDonationDate == lastDonationDate)&&(identical(other.totalDonationsCount, totalDonationsCount) || other.totalDonationsCount == totalDonationsCount));
}


@override
int get hashCode => Object.hash(runtimeType,userId,isAccountActive,isAvailableForDonation,isDonor,bloodType,wilayaId,cooldownUntil,lastDonationDate,totalDonationsCount);

@override
String toString() {
  return 'DonorAvailabilityEntity(userId: $userId, isAccountActive: $isAccountActive, isAvailableForDonation: $isAvailableForDonation, isDonor: $isDonor, bloodType: $bloodType, wilayaId: $wilayaId, cooldownUntil: $cooldownUntil, lastDonationDate: $lastDonationDate, totalDonationsCount: $totalDonationsCount)';
}


}

/// @nodoc
abstract mixin class $DonorAvailabilityEntityCopyWith<$Res>  {
  factory $DonorAvailabilityEntityCopyWith(DonorAvailabilityEntity value, $Res Function(DonorAvailabilityEntity) _then) = _$DonorAvailabilityEntityCopyWithImpl;
@useResult
$Res call({
 String userId, bool isAccountActive, bool isAvailableForDonation, bool isDonor, String bloodType, int wilayaId, DateTime? cooldownUntil, DateTime? lastDonationDate, int totalDonationsCount
});




}
/// @nodoc
class _$DonorAvailabilityEntityCopyWithImpl<$Res>
    implements $DonorAvailabilityEntityCopyWith<$Res> {
  _$DonorAvailabilityEntityCopyWithImpl(this._self, this._then);

  final DonorAvailabilityEntity _self;
  final $Res Function(DonorAvailabilityEntity) _then;

/// Create a copy of DonorAvailabilityEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? isAccountActive = null,Object? isAvailableForDonation = null,Object? isDonor = null,Object? bloodType = null,Object? wilayaId = null,Object? cooldownUntil = freezed,Object? lastDonationDate = freezed,Object? totalDonationsCount = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,isAccountActive: null == isAccountActive ? _self.isAccountActive : isAccountActive // ignore: cast_nullable_to_non_nullable
as bool,isAvailableForDonation: null == isAvailableForDonation ? _self.isAvailableForDonation : isAvailableForDonation // ignore: cast_nullable_to_non_nullable
as bool,isDonor: null == isDonor ? _self.isDonor : isDonor // ignore: cast_nullable_to_non_nullable
as bool,bloodType: null == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as String,wilayaId: null == wilayaId ? _self.wilayaId : wilayaId // ignore: cast_nullable_to_non_nullable
as int,cooldownUntil: freezed == cooldownUntil ? _self.cooldownUntil : cooldownUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,lastDonationDate: freezed == lastDonationDate ? _self.lastDonationDate : lastDonationDate // ignore: cast_nullable_to_non_nullable
as DateTime?,totalDonationsCount: null == totalDonationsCount ? _self.totalDonationsCount : totalDonationsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DonorAvailabilityEntity].
extension DonorAvailabilityEntityPatterns on DonorAvailabilityEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DonorAvailabilityEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DonorAvailabilityEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DonorAvailabilityEntity value)  $default,){
final _that = this;
switch (_that) {
case _DonorAvailabilityEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DonorAvailabilityEntity value)?  $default,){
final _that = this;
switch (_that) {
case _DonorAvailabilityEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  bool isAccountActive,  bool isAvailableForDonation,  bool isDonor,  String bloodType,  int wilayaId,  DateTime? cooldownUntil,  DateTime? lastDonationDate,  int totalDonationsCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DonorAvailabilityEntity() when $default != null:
return $default(_that.userId,_that.isAccountActive,_that.isAvailableForDonation,_that.isDonor,_that.bloodType,_that.wilayaId,_that.cooldownUntil,_that.lastDonationDate,_that.totalDonationsCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  bool isAccountActive,  bool isAvailableForDonation,  bool isDonor,  String bloodType,  int wilayaId,  DateTime? cooldownUntil,  DateTime? lastDonationDate,  int totalDonationsCount)  $default,) {final _that = this;
switch (_that) {
case _DonorAvailabilityEntity():
return $default(_that.userId,_that.isAccountActive,_that.isAvailableForDonation,_that.isDonor,_that.bloodType,_that.wilayaId,_that.cooldownUntil,_that.lastDonationDate,_that.totalDonationsCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  bool isAccountActive,  bool isAvailableForDonation,  bool isDonor,  String bloodType,  int wilayaId,  DateTime? cooldownUntil,  DateTime? lastDonationDate,  int totalDonationsCount)?  $default,) {final _that = this;
switch (_that) {
case _DonorAvailabilityEntity() when $default != null:
return $default(_that.userId,_that.isAccountActive,_that.isAvailableForDonation,_that.isDonor,_that.bloodType,_that.wilayaId,_that.cooldownUntil,_that.lastDonationDate,_that.totalDonationsCount);case _:
  return null;

}
}

}

/// @nodoc


class _DonorAvailabilityEntity extends DonorAvailabilityEntity {
  const _DonorAvailabilityEntity({required this.userId, required this.isAccountActive, required this.isAvailableForDonation, required this.isDonor, required this.bloodType, required this.wilayaId, this.cooldownUntil, this.lastDonationDate, required this.totalDonationsCount}): super._();
  

@override final  String userId;
@override final  bool isAccountActive;
@override final  bool isAvailableForDonation;
@override final  bool isDonor;
@override final  String bloodType;
@override final  int wilayaId;
@override final  DateTime? cooldownUntil;
@override final  DateTime? lastDonationDate;
@override final  int totalDonationsCount;

/// Create a copy of DonorAvailabilityEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DonorAvailabilityEntityCopyWith<_DonorAvailabilityEntity> get copyWith => __$DonorAvailabilityEntityCopyWithImpl<_DonorAvailabilityEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DonorAvailabilityEntity&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.isAccountActive, isAccountActive) || other.isAccountActive == isAccountActive)&&(identical(other.isAvailableForDonation, isAvailableForDonation) || other.isAvailableForDonation == isAvailableForDonation)&&(identical(other.isDonor, isDonor) || other.isDonor == isDonor)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.wilayaId, wilayaId) || other.wilayaId == wilayaId)&&(identical(other.cooldownUntil, cooldownUntil) || other.cooldownUntil == cooldownUntil)&&(identical(other.lastDonationDate, lastDonationDate) || other.lastDonationDate == lastDonationDate)&&(identical(other.totalDonationsCount, totalDonationsCount) || other.totalDonationsCount == totalDonationsCount));
}


@override
int get hashCode => Object.hash(runtimeType,userId,isAccountActive,isAvailableForDonation,isDonor,bloodType,wilayaId,cooldownUntil,lastDonationDate,totalDonationsCount);

@override
String toString() {
  return 'DonorAvailabilityEntity(userId: $userId, isAccountActive: $isAccountActive, isAvailableForDonation: $isAvailableForDonation, isDonor: $isDonor, bloodType: $bloodType, wilayaId: $wilayaId, cooldownUntil: $cooldownUntil, lastDonationDate: $lastDonationDate, totalDonationsCount: $totalDonationsCount)';
}


}

/// @nodoc
abstract mixin class _$DonorAvailabilityEntityCopyWith<$Res> implements $DonorAvailabilityEntityCopyWith<$Res> {
  factory _$DonorAvailabilityEntityCopyWith(_DonorAvailabilityEntity value, $Res Function(_DonorAvailabilityEntity) _then) = __$DonorAvailabilityEntityCopyWithImpl;
@override @useResult
$Res call({
 String userId, bool isAccountActive, bool isAvailableForDonation, bool isDonor, String bloodType, int wilayaId, DateTime? cooldownUntil, DateTime? lastDonationDate, int totalDonationsCount
});




}
/// @nodoc
class __$DonorAvailabilityEntityCopyWithImpl<$Res>
    implements _$DonorAvailabilityEntityCopyWith<$Res> {
  __$DonorAvailabilityEntityCopyWithImpl(this._self, this._then);

  final _DonorAvailabilityEntity _self;
  final $Res Function(_DonorAvailabilityEntity) _then;

/// Create a copy of DonorAvailabilityEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? isAccountActive = null,Object? isAvailableForDonation = null,Object? isDonor = null,Object? bloodType = null,Object? wilayaId = null,Object? cooldownUntil = freezed,Object? lastDonationDate = freezed,Object? totalDonationsCount = null,}) {
  return _then(_DonorAvailabilityEntity(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,isAccountActive: null == isAccountActive ? _self.isAccountActive : isAccountActive // ignore: cast_nullable_to_non_nullable
as bool,isAvailableForDonation: null == isAvailableForDonation ? _self.isAvailableForDonation : isAvailableForDonation // ignore: cast_nullable_to_non_nullable
as bool,isDonor: null == isDonor ? _self.isDonor : isDonor // ignore: cast_nullable_to_non_nullable
as bool,bloodType: null == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as String,wilayaId: null == wilayaId ? _self.wilayaId : wilayaId // ignore: cast_nullable_to_non_nullable
as int,cooldownUntil: freezed == cooldownUntil ? _self.cooldownUntil : cooldownUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,lastDonationDate: freezed == lastDonationDate ? _self.lastDonationDate : lastDonationDate // ignore: cast_nullable_to_non_nullable
as DateTime?,totalDonationsCount: null == totalDonationsCount ? _self.totalDonationsCount : totalDonationsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$DonorBloodRequestEntity {

 String get id; String get requestedBy; String? get patientName; DonorHospitalEntity get hospital; String get bloodType; DonorRequestPriority get priority; int get unitsNeeded; int get unitsFulfilled; DonorBloodRequestStatus get status; DateTime? get neededBy; DateTime? get expiresAt; String? get notes; DateTime get createdAt;
/// Create a copy of DonorBloodRequestEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DonorBloodRequestEntityCopyWith<DonorBloodRequestEntity> get copyWith => _$DonorBloodRequestEntityCopyWithImpl<DonorBloodRequestEntity>(this as DonorBloodRequestEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DonorBloodRequestEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.requestedBy, requestedBy) || other.requestedBy == requestedBy)&&(identical(other.patientName, patientName) || other.patientName == patientName)&&(identical(other.hospital, hospital) || other.hospital == hospital)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.unitsNeeded, unitsNeeded) || other.unitsNeeded == unitsNeeded)&&(identical(other.unitsFulfilled, unitsFulfilled) || other.unitsFulfilled == unitsFulfilled)&&(identical(other.status, status) || other.status == status)&&(identical(other.neededBy, neededBy) || other.neededBy == neededBy)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,requestedBy,patientName,hospital,bloodType,priority,unitsNeeded,unitsFulfilled,status,neededBy,expiresAt,notes,createdAt);

@override
String toString() {
  return 'DonorBloodRequestEntity(id: $id, requestedBy: $requestedBy, patientName: $patientName, hospital: $hospital, bloodType: $bloodType, priority: $priority, unitsNeeded: $unitsNeeded, unitsFulfilled: $unitsFulfilled, status: $status, neededBy: $neededBy, expiresAt: $expiresAt, notes: $notes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $DonorBloodRequestEntityCopyWith<$Res>  {
  factory $DonorBloodRequestEntityCopyWith(DonorBloodRequestEntity value, $Res Function(DonorBloodRequestEntity) _then) = _$DonorBloodRequestEntityCopyWithImpl;
@useResult
$Res call({
 String id, String requestedBy, String? patientName, DonorHospitalEntity hospital, String bloodType, DonorRequestPriority priority, int unitsNeeded, int unitsFulfilled, DonorBloodRequestStatus status, DateTime? neededBy, DateTime? expiresAt, String? notes, DateTime createdAt
});


$DonorHospitalEntityCopyWith<$Res> get hospital;

}
/// @nodoc
class _$DonorBloodRequestEntityCopyWithImpl<$Res>
    implements $DonorBloodRequestEntityCopyWith<$Res> {
  _$DonorBloodRequestEntityCopyWithImpl(this._self, this._then);

  final DonorBloodRequestEntity _self;
  final $Res Function(DonorBloodRequestEntity) _then;

/// Create a copy of DonorBloodRequestEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? requestedBy = null,Object? patientName = freezed,Object? hospital = null,Object? bloodType = null,Object? priority = null,Object? unitsNeeded = null,Object? unitsFulfilled = null,Object? status = null,Object? neededBy = freezed,Object? expiresAt = freezed,Object? notes = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,requestedBy: null == requestedBy ? _self.requestedBy : requestedBy // ignore: cast_nullable_to_non_nullable
as String,patientName: freezed == patientName ? _self.patientName : patientName // ignore: cast_nullable_to_non_nullable
as String?,hospital: null == hospital ? _self.hospital : hospital // ignore: cast_nullable_to_non_nullable
as DonorHospitalEntity,bloodType: null == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as DonorRequestPriority,unitsNeeded: null == unitsNeeded ? _self.unitsNeeded : unitsNeeded // ignore: cast_nullable_to_non_nullable
as int,unitsFulfilled: null == unitsFulfilled ? _self.unitsFulfilled : unitsFulfilled // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DonorBloodRequestStatus,neededBy: freezed == neededBy ? _self.neededBy : neededBy // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of DonorBloodRequestEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonorHospitalEntityCopyWith<$Res> get hospital {
  
  return $DonorHospitalEntityCopyWith<$Res>(_self.hospital, (value) {
    return _then(_self.copyWith(hospital: value));
  });
}
}


/// Adds pattern-matching-related methods to [DonorBloodRequestEntity].
extension DonorBloodRequestEntityPatterns on DonorBloodRequestEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DonorBloodRequestEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DonorBloodRequestEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DonorBloodRequestEntity value)  $default,){
final _that = this;
switch (_that) {
case _DonorBloodRequestEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DonorBloodRequestEntity value)?  $default,){
final _that = this;
switch (_that) {
case _DonorBloodRequestEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String requestedBy,  String? patientName,  DonorHospitalEntity hospital,  String bloodType,  DonorRequestPriority priority,  int unitsNeeded,  int unitsFulfilled,  DonorBloodRequestStatus status,  DateTime? neededBy,  DateTime? expiresAt,  String? notes,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DonorBloodRequestEntity() when $default != null:
return $default(_that.id,_that.requestedBy,_that.patientName,_that.hospital,_that.bloodType,_that.priority,_that.unitsNeeded,_that.unitsFulfilled,_that.status,_that.neededBy,_that.expiresAt,_that.notes,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String requestedBy,  String? patientName,  DonorHospitalEntity hospital,  String bloodType,  DonorRequestPriority priority,  int unitsNeeded,  int unitsFulfilled,  DonorBloodRequestStatus status,  DateTime? neededBy,  DateTime? expiresAt,  String? notes,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _DonorBloodRequestEntity():
return $default(_that.id,_that.requestedBy,_that.patientName,_that.hospital,_that.bloodType,_that.priority,_that.unitsNeeded,_that.unitsFulfilled,_that.status,_that.neededBy,_that.expiresAt,_that.notes,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String requestedBy,  String? patientName,  DonorHospitalEntity hospital,  String bloodType,  DonorRequestPriority priority,  int unitsNeeded,  int unitsFulfilled,  DonorBloodRequestStatus status,  DateTime? neededBy,  DateTime? expiresAt,  String? notes,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _DonorBloodRequestEntity() when $default != null:
return $default(_that.id,_that.requestedBy,_that.patientName,_that.hospital,_that.bloodType,_that.priority,_that.unitsNeeded,_that.unitsFulfilled,_that.status,_that.neededBy,_that.expiresAt,_that.notes,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _DonorBloodRequestEntity extends DonorBloodRequestEntity {
  const _DonorBloodRequestEntity({required this.id, required this.requestedBy, this.patientName, required this.hospital, required this.bloodType, required this.priority, required this.unitsNeeded, required this.unitsFulfilled, required this.status, this.neededBy, this.expiresAt, this.notes, required this.createdAt}): super._();
  

@override final  String id;
@override final  String requestedBy;
@override final  String? patientName;
@override final  DonorHospitalEntity hospital;
@override final  String bloodType;
@override final  DonorRequestPriority priority;
@override final  int unitsNeeded;
@override final  int unitsFulfilled;
@override final  DonorBloodRequestStatus status;
@override final  DateTime? neededBy;
@override final  DateTime? expiresAt;
@override final  String? notes;
@override final  DateTime createdAt;

/// Create a copy of DonorBloodRequestEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DonorBloodRequestEntityCopyWith<_DonorBloodRequestEntity> get copyWith => __$DonorBloodRequestEntityCopyWithImpl<_DonorBloodRequestEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DonorBloodRequestEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.requestedBy, requestedBy) || other.requestedBy == requestedBy)&&(identical(other.patientName, patientName) || other.patientName == patientName)&&(identical(other.hospital, hospital) || other.hospital == hospital)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.unitsNeeded, unitsNeeded) || other.unitsNeeded == unitsNeeded)&&(identical(other.unitsFulfilled, unitsFulfilled) || other.unitsFulfilled == unitsFulfilled)&&(identical(other.status, status) || other.status == status)&&(identical(other.neededBy, neededBy) || other.neededBy == neededBy)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,requestedBy,patientName,hospital,bloodType,priority,unitsNeeded,unitsFulfilled,status,neededBy,expiresAt,notes,createdAt);

@override
String toString() {
  return 'DonorBloodRequestEntity(id: $id, requestedBy: $requestedBy, patientName: $patientName, hospital: $hospital, bloodType: $bloodType, priority: $priority, unitsNeeded: $unitsNeeded, unitsFulfilled: $unitsFulfilled, status: $status, neededBy: $neededBy, expiresAt: $expiresAt, notes: $notes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$DonorBloodRequestEntityCopyWith<$Res> implements $DonorBloodRequestEntityCopyWith<$Res> {
  factory _$DonorBloodRequestEntityCopyWith(_DonorBloodRequestEntity value, $Res Function(_DonorBloodRequestEntity) _then) = __$DonorBloodRequestEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String requestedBy, String? patientName, DonorHospitalEntity hospital, String bloodType, DonorRequestPriority priority, int unitsNeeded, int unitsFulfilled, DonorBloodRequestStatus status, DateTime? neededBy, DateTime? expiresAt, String? notes, DateTime createdAt
});


@override $DonorHospitalEntityCopyWith<$Res> get hospital;

}
/// @nodoc
class __$DonorBloodRequestEntityCopyWithImpl<$Res>
    implements _$DonorBloodRequestEntityCopyWith<$Res> {
  __$DonorBloodRequestEntityCopyWithImpl(this._self, this._then);

  final _DonorBloodRequestEntity _self;
  final $Res Function(_DonorBloodRequestEntity) _then;

/// Create a copy of DonorBloodRequestEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? requestedBy = null,Object? patientName = freezed,Object? hospital = null,Object? bloodType = null,Object? priority = null,Object? unitsNeeded = null,Object? unitsFulfilled = null,Object? status = null,Object? neededBy = freezed,Object? expiresAt = freezed,Object? notes = freezed,Object? createdAt = null,}) {
  return _then(_DonorBloodRequestEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,requestedBy: null == requestedBy ? _self.requestedBy : requestedBy // ignore: cast_nullable_to_non_nullable
as String,patientName: freezed == patientName ? _self.patientName : patientName // ignore: cast_nullable_to_non_nullable
as String?,hospital: null == hospital ? _self.hospital : hospital // ignore: cast_nullable_to_non_nullable
as DonorHospitalEntity,bloodType: null == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as DonorRequestPriority,unitsNeeded: null == unitsNeeded ? _self.unitsNeeded : unitsNeeded // ignore: cast_nullable_to_non_nullable
as int,unitsFulfilled: null == unitsFulfilled ? _self.unitsFulfilled : unitsFulfilled // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DonorBloodRequestStatus,neededBy: freezed == neededBy ? _self.neededBy : neededBy // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of DonorBloodRequestEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonorHospitalEntityCopyWith<$Res> get hospital {
  
  return $DonorHospitalEntityCopyWith<$Res>(_self.hospital, (value) {
    return _then(_self.copyWith(hospital: value));
  });
}
}

/// @nodoc
mixin _$DonorCampaignEntity {

 String get id; String? get createdBy; String get organizerName; String get title; String? get description; String get venueName; String get city; int get wilayaId; String? get hospitalId; List<String>? get bloodTypesNeeded; DonorCampaignStatus get status; DateTime get startsAt; DateTime get endsAt; DateTime? get publishedAt; DateTime get createdAt;
/// Create a copy of DonorCampaignEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DonorCampaignEntityCopyWith<DonorCampaignEntity> get copyWith => _$DonorCampaignEntityCopyWithImpl<DonorCampaignEntity>(this as DonorCampaignEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DonorCampaignEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.organizerName, organizerName) || other.organizerName == organizerName)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.venueName, venueName) || other.venueName == venueName)&&(identical(other.city, city) || other.city == city)&&(identical(other.wilayaId, wilayaId) || other.wilayaId == wilayaId)&&(identical(other.hospitalId, hospitalId) || other.hospitalId == hospitalId)&&const DeepCollectionEquality().equals(other.bloodTypesNeeded, bloodTypesNeeded)&&(identical(other.status, status) || other.status == status)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,createdBy,organizerName,title,description,venueName,city,wilayaId,hospitalId,const DeepCollectionEquality().hash(bloodTypesNeeded),status,startsAt,endsAt,publishedAt,createdAt);

@override
String toString() {
  return 'DonorCampaignEntity(id: $id, createdBy: $createdBy, organizerName: $organizerName, title: $title, description: $description, venueName: $venueName, city: $city, wilayaId: $wilayaId, hospitalId: $hospitalId, bloodTypesNeeded: $bloodTypesNeeded, status: $status, startsAt: $startsAt, endsAt: $endsAt, publishedAt: $publishedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $DonorCampaignEntityCopyWith<$Res>  {
  factory $DonorCampaignEntityCopyWith(DonorCampaignEntity value, $Res Function(DonorCampaignEntity) _then) = _$DonorCampaignEntityCopyWithImpl;
@useResult
$Res call({
 String id, String? createdBy, String organizerName, String title, String? description, String venueName, String city, int wilayaId, String? hospitalId, List<String>? bloodTypesNeeded, DonorCampaignStatus status, DateTime startsAt, DateTime endsAt, DateTime? publishedAt, DateTime createdAt
});




}
/// @nodoc
class _$DonorCampaignEntityCopyWithImpl<$Res>
    implements $DonorCampaignEntityCopyWith<$Res> {
  _$DonorCampaignEntityCopyWithImpl(this._self, this._then);

  final DonorCampaignEntity _self;
  final $Res Function(DonorCampaignEntity) _then;

/// Create a copy of DonorCampaignEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdBy = freezed,Object? organizerName = null,Object? title = null,Object? description = freezed,Object? venueName = null,Object? city = null,Object? wilayaId = null,Object? hospitalId = freezed,Object? bloodTypesNeeded = freezed,Object? status = null,Object? startsAt = null,Object? endsAt = null,Object? publishedAt = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,organizerName: null == organizerName ? _self.organizerName : organizerName // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,venueName: null == venueName ? _self.venueName : venueName // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,wilayaId: null == wilayaId ? _self.wilayaId : wilayaId // ignore: cast_nullable_to_non_nullable
as int,hospitalId: freezed == hospitalId ? _self.hospitalId : hospitalId // ignore: cast_nullable_to_non_nullable
as String?,bloodTypesNeeded: freezed == bloodTypesNeeded ? _self.bloodTypesNeeded : bloodTypesNeeded // ignore: cast_nullable_to_non_nullable
as List<String>?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DonorCampaignStatus,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DonorCampaignEntity].
extension DonorCampaignEntityPatterns on DonorCampaignEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DonorCampaignEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DonorCampaignEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DonorCampaignEntity value)  $default,){
final _that = this;
switch (_that) {
case _DonorCampaignEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DonorCampaignEntity value)?  $default,){
final _that = this;
switch (_that) {
case _DonorCampaignEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? createdBy,  String organizerName,  String title,  String? description,  String venueName,  String city,  int wilayaId,  String? hospitalId,  List<String>? bloodTypesNeeded,  DonorCampaignStatus status,  DateTime startsAt,  DateTime endsAt,  DateTime? publishedAt,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DonorCampaignEntity() when $default != null:
return $default(_that.id,_that.createdBy,_that.organizerName,_that.title,_that.description,_that.venueName,_that.city,_that.wilayaId,_that.hospitalId,_that.bloodTypesNeeded,_that.status,_that.startsAt,_that.endsAt,_that.publishedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? createdBy,  String organizerName,  String title,  String? description,  String venueName,  String city,  int wilayaId,  String? hospitalId,  List<String>? bloodTypesNeeded,  DonorCampaignStatus status,  DateTime startsAt,  DateTime endsAt,  DateTime? publishedAt,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _DonorCampaignEntity():
return $default(_that.id,_that.createdBy,_that.organizerName,_that.title,_that.description,_that.venueName,_that.city,_that.wilayaId,_that.hospitalId,_that.bloodTypesNeeded,_that.status,_that.startsAt,_that.endsAt,_that.publishedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? createdBy,  String organizerName,  String title,  String? description,  String venueName,  String city,  int wilayaId,  String? hospitalId,  List<String>? bloodTypesNeeded,  DonorCampaignStatus status,  DateTime startsAt,  DateTime endsAt,  DateTime? publishedAt,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _DonorCampaignEntity() when $default != null:
return $default(_that.id,_that.createdBy,_that.organizerName,_that.title,_that.description,_that.venueName,_that.city,_that.wilayaId,_that.hospitalId,_that.bloodTypesNeeded,_that.status,_that.startsAt,_that.endsAt,_that.publishedAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _DonorCampaignEntity extends DonorCampaignEntity {
  const _DonorCampaignEntity({required this.id, this.createdBy, required this.organizerName, required this.title, this.description, required this.venueName, required this.city, required this.wilayaId, this.hospitalId, final  List<String>? bloodTypesNeeded, required this.status, required this.startsAt, required this.endsAt, this.publishedAt, required this.createdAt}): _bloodTypesNeeded = bloodTypesNeeded,super._();
  

@override final  String id;
@override final  String? createdBy;
@override final  String organizerName;
@override final  String title;
@override final  String? description;
@override final  String venueName;
@override final  String city;
@override final  int wilayaId;
@override final  String? hospitalId;
 final  List<String>? _bloodTypesNeeded;
@override List<String>? get bloodTypesNeeded {
  final value = _bloodTypesNeeded;
  if (value == null) return null;
  if (_bloodTypesNeeded is EqualUnmodifiableListView) return _bloodTypesNeeded;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  DonorCampaignStatus status;
@override final  DateTime startsAt;
@override final  DateTime endsAt;
@override final  DateTime? publishedAt;
@override final  DateTime createdAt;

/// Create a copy of DonorCampaignEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DonorCampaignEntityCopyWith<_DonorCampaignEntity> get copyWith => __$DonorCampaignEntityCopyWithImpl<_DonorCampaignEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DonorCampaignEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.organizerName, organizerName) || other.organizerName == organizerName)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.venueName, venueName) || other.venueName == venueName)&&(identical(other.city, city) || other.city == city)&&(identical(other.wilayaId, wilayaId) || other.wilayaId == wilayaId)&&(identical(other.hospitalId, hospitalId) || other.hospitalId == hospitalId)&&const DeepCollectionEquality().equals(other._bloodTypesNeeded, _bloodTypesNeeded)&&(identical(other.status, status) || other.status == status)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,createdBy,organizerName,title,description,venueName,city,wilayaId,hospitalId,const DeepCollectionEquality().hash(_bloodTypesNeeded),status,startsAt,endsAt,publishedAt,createdAt);

@override
String toString() {
  return 'DonorCampaignEntity(id: $id, createdBy: $createdBy, organizerName: $organizerName, title: $title, description: $description, venueName: $venueName, city: $city, wilayaId: $wilayaId, hospitalId: $hospitalId, bloodTypesNeeded: $bloodTypesNeeded, status: $status, startsAt: $startsAt, endsAt: $endsAt, publishedAt: $publishedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$DonorCampaignEntityCopyWith<$Res> implements $DonorCampaignEntityCopyWith<$Res> {
  factory _$DonorCampaignEntityCopyWith(_DonorCampaignEntity value, $Res Function(_DonorCampaignEntity) _then) = __$DonorCampaignEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String? createdBy, String organizerName, String title, String? description, String venueName, String city, int wilayaId, String? hospitalId, List<String>? bloodTypesNeeded, DonorCampaignStatus status, DateTime startsAt, DateTime endsAt, DateTime? publishedAt, DateTime createdAt
});




}
/// @nodoc
class __$DonorCampaignEntityCopyWithImpl<$Res>
    implements _$DonorCampaignEntityCopyWith<$Res> {
  __$DonorCampaignEntityCopyWithImpl(this._self, this._then);

  final _DonorCampaignEntity _self;
  final $Res Function(_DonorCampaignEntity) _then;

/// Create a copy of DonorCampaignEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdBy = freezed,Object? organizerName = null,Object? title = null,Object? description = freezed,Object? venueName = null,Object? city = null,Object? wilayaId = null,Object? hospitalId = freezed,Object? bloodTypesNeeded = freezed,Object? status = null,Object? startsAt = null,Object? endsAt = null,Object? publishedAt = freezed,Object? createdAt = null,}) {
  return _then(_DonorCampaignEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,organizerName: null == organizerName ? _self.organizerName : organizerName // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,venueName: null == venueName ? _self.venueName : venueName // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,wilayaId: null == wilayaId ? _self.wilayaId : wilayaId // ignore: cast_nullable_to_non_nullable
as int,hospitalId: freezed == hospitalId ? _self.hospitalId : hospitalId // ignore: cast_nullable_to_non_nullable
as String?,bloodTypesNeeded: freezed == bloodTypesNeeded ? _self._bloodTypesNeeded : bloodTypesNeeded // ignore: cast_nullable_to_non_nullable
as List<String>?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DonorCampaignStatus,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$DonorAppointmentRequestRef {

 String get id; DonorHospitalEntity get hospital; String get bloodType; DonorRequestPriority get priority; DateTime? get neededBy;
/// Create a copy of DonorAppointmentRequestRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DonorAppointmentRequestRefCopyWith<DonorAppointmentRequestRef> get copyWith => _$DonorAppointmentRequestRefCopyWithImpl<DonorAppointmentRequestRef>(this as DonorAppointmentRequestRef, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DonorAppointmentRequestRef&&(identical(other.id, id) || other.id == id)&&(identical(other.hospital, hospital) || other.hospital == hospital)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.neededBy, neededBy) || other.neededBy == neededBy));
}


@override
int get hashCode => Object.hash(runtimeType,id,hospital,bloodType,priority,neededBy);

@override
String toString() {
  return 'DonorAppointmentRequestRef(id: $id, hospital: $hospital, bloodType: $bloodType, priority: $priority, neededBy: $neededBy)';
}


}

/// @nodoc
abstract mixin class $DonorAppointmentRequestRefCopyWith<$Res>  {
  factory $DonorAppointmentRequestRefCopyWith(DonorAppointmentRequestRef value, $Res Function(DonorAppointmentRequestRef) _then) = _$DonorAppointmentRequestRefCopyWithImpl;
@useResult
$Res call({
 String id, DonorHospitalEntity hospital, String bloodType, DonorRequestPriority priority, DateTime? neededBy
});


$DonorHospitalEntityCopyWith<$Res> get hospital;

}
/// @nodoc
class _$DonorAppointmentRequestRefCopyWithImpl<$Res>
    implements $DonorAppointmentRequestRefCopyWith<$Res> {
  _$DonorAppointmentRequestRefCopyWithImpl(this._self, this._then);

  final DonorAppointmentRequestRef _self;
  final $Res Function(DonorAppointmentRequestRef) _then;

/// Create a copy of DonorAppointmentRequestRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? hospital = null,Object? bloodType = null,Object? priority = null,Object? neededBy = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hospital: null == hospital ? _self.hospital : hospital // ignore: cast_nullable_to_non_nullable
as DonorHospitalEntity,bloodType: null == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as DonorRequestPriority,neededBy: freezed == neededBy ? _self.neededBy : neededBy // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of DonorAppointmentRequestRef
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonorHospitalEntityCopyWith<$Res> get hospital {
  
  return $DonorHospitalEntityCopyWith<$Res>(_self.hospital, (value) {
    return _then(_self.copyWith(hospital: value));
  });
}
}


/// Adds pattern-matching-related methods to [DonorAppointmentRequestRef].
extension DonorAppointmentRequestRefPatterns on DonorAppointmentRequestRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DonorAppointmentRequestRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DonorAppointmentRequestRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DonorAppointmentRequestRef value)  $default,){
final _that = this;
switch (_that) {
case _DonorAppointmentRequestRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DonorAppointmentRequestRef value)?  $default,){
final _that = this;
switch (_that) {
case _DonorAppointmentRequestRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DonorHospitalEntity hospital,  String bloodType,  DonorRequestPriority priority,  DateTime? neededBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DonorAppointmentRequestRef() when $default != null:
return $default(_that.id,_that.hospital,_that.bloodType,_that.priority,_that.neededBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DonorHospitalEntity hospital,  String bloodType,  DonorRequestPriority priority,  DateTime? neededBy)  $default,) {final _that = this;
switch (_that) {
case _DonorAppointmentRequestRef():
return $default(_that.id,_that.hospital,_that.bloodType,_that.priority,_that.neededBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DonorHospitalEntity hospital,  String bloodType,  DonorRequestPriority priority,  DateTime? neededBy)?  $default,) {final _that = this;
switch (_that) {
case _DonorAppointmentRequestRef() when $default != null:
return $default(_that.id,_that.hospital,_that.bloodType,_that.priority,_that.neededBy);case _:
  return null;

}
}

}

/// @nodoc


class _DonorAppointmentRequestRef implements DonorAppointmentRequestRef {
  const _DonorAppointmentRequestRef({required this.id, required this.hospital, required this.bloodType, required this.priority, this.neededBy});
  

@override final  String id;
@override final  DonorHospitalEntity hospital;
@override final  String bloodType;
@override final  DonorRequestPriority priority;
@override final  DateTime? neededBy;

/// Create a copy of DonorAppointmentRequestRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DonorAppointmentRequestRefCopyWith<_DonorAppointmentRequestRef> get copyWith => __$DonorAppointmentRequestRefCopyWithImpl<_DonorAppointmentRequestRef>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DonorAppointmentRequestRef&&(identical(other.id, id) || other.id == id)&&(identical(other.hospital, hospital) || other.hospital == hospital)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.neededBy, neededBy) || other.neededBy == neededBy));
}


@override
int get hashCode => Object.hash(runtimeType,id,hospital,bloodType,priority,neededBy);

@override
String toString() {
  return 'DonorAppointmentRequestRef(id: $id, hospital: $hospital, bloodType: $bloodType, priority: $priority, neededBy: $neededBy)';
}


}

/// @nodoc
abstract mixin class _$DonorAppointmentRequestRefCopyWith<$Res> implements $DonorAppointmentRequestRefCopyWith<$Res> {
  factory _$DonorAppointmentRequestRefCopyWith(_DonorAppointmentRequestRef value, $Res Function(_DonorAppointmentRequestRef) _then) = __$DonorAppointmentRequestRefCopyWithImpl;
@override @useResult
$Res call({
 String id, DonorHospitalEntity hospital, String bloodType, DonorRequestPriority priority, DateTime? neededBy
});


@override $DonorHospitalEntityCopyWith<$Res> get hospital;

}
/// @nodoc
class __$DonorAppointmentRequestRefCopyWithImpl<$Res>
    implements _$DonorAppointmentRequestRefCopyWith<$Res> {
  __$DonorAppointmentRequestRefCopyWithImpl(this._self, this._then);

  final _DonorAppointmentRequestRef _self;
  final $Res Function(_DonorAppointmentRequestRef) _then;

/// Create a copy of DonorAppointmentRequestRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? hospital = null,Object? bloodType = null,Object? priority = null,Object? neededBy = freezed,}) {
  return _then(_DonorAppointmentRequestRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hospital: null == hospital ? _self.hospital : hospital // ignore: cast_nullable_to_non_nullable
as DonorHospitalEntity,bloodType: null == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as DonorRequestPriority,neededBy: freezed == neededBy ? _self.neededBy : neededBy // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of DonorAppointmentRequestRef
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonorHospitalEntityCopyWith<$Res> get hospital {
  
  return $DonorHospitalEntityCopyWith<$Res>(_self.hospital, (value) {
    return _then(_self.copyWith(hospital: value));
  });
}
}

/// @nodoc
mixin _$DonorAppointmentCampaignRef {

 String get id; String get title; String get organizerName; DateTime get startsAt; DateTime get endsAt;
/// Create a copy of DonorAppointmentCampaignRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DonorAppointmentCampaignRefCopyWith<DonorAppointmentCampaignRef> get copyWith => _$DonorAppointmentCampaignRefCopyWithImpl<DonorAppointmentCampaignRef>(this as DonorAppointmentCampaignRef, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DonorAppointmentCampaignRef&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.organizerName, organizerName) || other.organizerName == organizerName)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,organizerName,startsAt,endsAt);

@override
String toString() {
  return 'DonorAppointmentCampaignRef(id: $id, title: $title, organizerName: $organizerName, startsAt: $startsAt, endsAt: $endsAt)';
}


}

/// @nodoc
abstract mixin class $DonorAppointmentCampaignRefCopyWith<$Res>  {
  factory $DonorAppointmentCampaignRefCopyWith(DonorAppointmentCampaignRef value, $Res Function(DonorAppointmentCampaignRef) _then) = _$DonorAppointmentCampaignRefCopyWithImpl;
@useResult
$Res call({
 String id, String title, String organizerName, DateTime startsAt, DateTime endsAt
});




}
/// @nodoc
class _$DonorAppointmentCampaignRefCopyWithImpl<$Res>
    implements $DonorAppointmentCampaignRefCopyWith<$Res> {
  _$DonorAppointmentCampaignRefCopyWithImpl(this._self, this._then);

  final DonorAppointmentCampaignRef _self;
  final $Res Function(DonorAppointmentCampaignRef) _then;

/// Create a copy of DonorAppointmentCampaignRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? organizerName = null,Object? startsAt = null,Object? endsAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,organizerName: null == organizerName ? _self.organizerName : organizerName // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DonorAppointmentCampaignRef].
extension DonorAppointmentCampaignRefPatterns on DonorAppointmentCampaignRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DonorAppointmentCampaignRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DonorAppointmentCampaignRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DonorAppointmentCampaignRef value)  $default,){
final _that = this;
switch (_that) {
case _DonorAppointmentCampaignRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DonorAppointmentCampaignRef value)?  $default,){
final _that = this;
switch (_that) {
case _DonorAppointmentCampaignRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String organizerName,  DateTime startsAt,  DateTime endsAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DonorAppointmentCampaignRef() when $default != null:
return $default(_that.id,_that.title,_that.organizerName,_that.startsAt,_that.endsAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String organizerName,  DateTime startsAt,  DateTime endsAt)  $default,) {final _that = this;
switch (_that) {
case _DonorAppointmentCampaignRef():
return $default(_that.id,_that.title,_that.organizerName,_that.startsAt,_that.endsAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String organizerName,  DateTime startsAt,  DateTime endsAt)?  $default,) {final _that = this;
switch (_that) {
case _DonorAppointmentCampaignRef() when $default != null:
return $default(_that.id,_that.title,_that.organizerName,_that.startsAt,_that.endsAt);case _:
  return null;

}
}

}

/// @nodoc


class _DonorAppointmentCampaignRef implements DonorAppointmentCampaignRef {
  const _DonorAppointmentCampaignRef({required this.id, required this.title, required this.organizerName, required this.startsAt, required this.endsAt});
  

@override final  String id;
@override final  String title;
@override final  String organizerName;
@override final  DateTime startsAt;
@override final  DateTime endsAt;

/// Create a copy of DonorAppointmentCampaignRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DonorAppointmentCampaignRefCopyWith<_DonorAppointmentCampaignRef> get copyWith => __$DonorAppointmentCampaignRefCopyWithImpl<_DonorAppointmentCampaignRef>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DonorAppointmentCampaignRef&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.organizerName, organizerName) || other.organizerName == organizerName)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,organizerName,startsAt,endsAt);

@override
String toString() {
  return 'DonorAppointmentCampaignRef(id: $id, title: $title, organizerName: $organizerName, startsAt: $startsAt, endsAt: $endsAt)';
}


}

/// @nodoc
abstract mixin class _$DonorAppointmentCampaignRefCopyWith<$Res> implements $DonorAppointmentCampaignRefCopyWith<$Res> {
  factory _$DonorAppointmentCampaignRefCopyWith(_DonorAppointmentCampaignRef value, $Res Function(_DonorAppointmentCampaignRef) _then) = __$DonorAppointmentCampaignRefCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String organizerName, DateTime startsAt, DateTime endsAt
});




}
/// @nodoc
class __$DonorAppointmentCampaignRefCopyWithImpl<$Res>
    implements _$DonorAppointmentCampaignRefCopyWith<$Res> {
  __$DonorAppointmentCampaignRefCopyWithImpl(this._self, this._then);

  final _DonorAppointmentCampaignRef _self;
  final $Res Function(_DonorAppointmentCampaignRef) _then;

/// Create a copy of DonorAppointmentCampaignRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? organizerName = null,Object? startsAt = null,Object? endsAt = null,}) {
  return _then(_DonorAppointmentCampaignRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,organizerName: null == organizerName ? _self.organizerName : organizerName // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$DonorAppointmentEntity {

 String get id; String get donorId; DateTime get scheduledAt; DonationAppointmentStatus get status; DateTime? get completedAt; DateTime? get cancelledAt; String? get cancelReason; DateTime get createdAt; DonorAppointmentRequestRef? get bloodRequest; DonorAppointmentCampaignRef? get campaign;
/// Create a copy of DonorAppointmentEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DonorAppointmentEntityCopyWith<DonorAppointmentEntity> get copyWith => _$DonorAppointmentEntityCopyWithImpl<DonorAppointmentEntity>(this as DonorAppointmentEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DonorAppointmentEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.donorId, donorId) || other.donorId == donorId)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.cancelReason, cancelReason) || other.cancelReason == cancelReason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.bloodRequest, bloodRequest) || other.bloodRequest == bloodRequest)&&(identical(other.campaign, campaign) || other.campaign == campaign));
}


@override
int get hashCode => Object.hash(runtimeType,id,donorId,scheduledAt,status,completedAt,cancelledAt,cancelReason,createdAt,bloodRequest,campaign);

@override
String toString() {
  return 'DonorAppointmentEntity(id: $id, donorId: $donorId, scheduledAt: $scheduledAt, status: $status, completedAt: $completedAt, cancelledAt: $cancelledAt, cancelReason: $cancelReason, createdAt: $createdAt, bloodRequest: $bloodRequest, campaign: $campaign)';
}


}

/// @nodoc
abstract mixin class $DonorAppointmentEntityCopyWith<$Res>  {
  factory $DonorAppointmentEntityCopyWith(DonorAppointmentEntity value, $Res Function(DonorAppointmentEntity) _then) = _$DonorAppointmentEntityCopyWithImpl;
@useResult
$Res call({
 String id, String donorId, DateTime scheduledAt, DonationAppointmentStatus status, DateTime? completedAt, DateTime? cancelledAt, String? cancelReason, DateTime createdAt, DonorAppointmentRequestRef? bloodRequest, DonorAppointmentCampaignRef? campaign
});


$DonorAppointmentRequestRefCopyWith<$Res>? get bloodRequest;$DonorAppointmentCampaignRefCopyWith<$Res>? get campaign;

}
/// @nodoc
class _$DonorAppointmentEntityCopyWithImpl<$Res>
    implements $DonorAppointmentEntityCopyWith<$Res> {
  _$DonorAppointmentEntityCopyWithImpl(this._self, this._then);

  final DonorAppointmentEntity _self;
  final $Res Function(DonorAppointmentEntity) _then;

/// Create a copy of DonorAppointmentEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? donorId = null,Object? scheduledAt = null,Object? status = null,Object? completedAt = freezed,Object? cancelledAt = freezed,Object? cancelReason = freezed,Object? createdAt = null,Object? bloodRequest = freezed,Object? campaign = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,donorId: null == donorId ? _self.donorId : donorId // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DonationAppointmentStatus,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelReason: freezed == cancelReason ? _self.cancelReason : cancelReason // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,bloodRequest: freezed == bloodRequest ? _self.bloodRequest : bloodRequest // ignore: cast_nullable_to_non_nullable
as DonorAppointmentRequestRef?,campaign: freezed == campaign ? _self.campaign : campaign // ignore: cast_nullable_to_non_nullable
as DonorAppointmentCampaignRef?,
  ));
}
/// Create a copy of DonorAppointmentEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonorAppointmentRequestRefCopyWith<$Res>? get bloodRequest {
    if (_self.bloodRequest == null) {
    return null;
  }

  return $DonorAppointmentRequestRefCopyWith<$Res>(_self.bloodRequest!, (value) {
    return _then(_self.copyWith(bloodRequest: value));
  });
}/// Create a copy of DonorAppointmentEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonorAppointmentCampaignRefCopyWith<$Res>? get campaign {
    if (_self.campaign == null) {
    return null;
  }

  return $DonorAppointmentCampaignRefCopyWith<$Res>(_self.campaign!, (value) {
    return _then(_self.copyWith(campaign: value));
  });
}
}


/// Adds pattern-matching-related methods to [DonorAppointmentEntity].
extension DonorAppointmentEntityPatterns on DonorAppointmentEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DonorAppointmentEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DonorAppointmentEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DonorAppointmentEntity value)  $default,){
final _that = this;
switch (_that) {
case _DonorAppointmentEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DonorAppointmentEntity value)?  $default,){
final _that = this;
switch (_that) {
case _DonorAppointmentEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String donorId,  DateTime scheduledAt,  DonationAppointmentStatus status,  DateTime? completedAt,  DateTime? cancelledAt,  String? cancelReason,  DateTime createdAt,  DonorAppointmentRequestRef? bloodRequest,  DonorAppointmentCampaignRef? campaign)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DonorAppointmentEntity() when $default != null:
return $default(_that.id,_that.donorId,_that.scheduledAt,_that.status,_that.completedAt,_that.cancelledAt,_that.cancelReason,_that.createdAt,_that.bloodRequest,_that.campaign);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String donorId,  DateTime scheduledAt,  DonationAppointmentStatus status,  DateTime? completedAt,  DateTime? cancelledAt,  String? cancelReason,  DateTime createdAt,  DonorAppointmentRequestRef? bloodRequest,  DonorAppointmentCampaignRef? campaign)  $default,) {final _that = this;
switch (_that) {
case _DonorAppointmentEntity():
return $default(_that.id,_that.donorId,_that.scheduledAt,_that.status,_that.completedAt,_that.cancelledAt,_that.cancelReason,_that.createdAt,_that.bloodRequest,_that.campaign);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String donorId,  DateTime scheduledAt,  DonationAppointmentStatus status,  DateTime? completedAt,  DateTime? cancelledAt,  String? cancelReason,  DateTime createdAt,  DonorAppointmentRequestRef? bloodRequest,  DonorAppointmentCampaignRef? campaign)?  $default,) {final _that = this;
switch (_that) {
case _DonorAppointmentEntity() when $default != null:
return $default(_that.id,_that.donorId,_that.scheduledAt,_that.status,_that.completedAt,_that.cancelledAt,_that.cancelReason,_that.createdAt,_that.bloodRequest,_that.campaign);case _:
  return null;

}
}

}

/// @nodoc


class _DonorAppointmentEntity implements DonorAppointmentEntity {
  const _DonorAppointmentEntity({required this.id, required this.donorId, required this.scheduledAt, required this.status, this.completedAt, this.cancelledAt, this.cancelReason, required this.createdAt, this.bloodRequest, this.campaign});
  

@override final  String id;
@override final  String donorId;
@override final  DateTime scheduledAt;
@override final  DonationAppointmentStatus status;
@override final  DateTime? completedAt;
@override final  DateTime? cancelledAt;
@override final  String? cancelReason;
@override final  DateTime createdAt;
@override final  DonorAppointmentRequestRef? bloodRequest;
@override final  DonorAppointmentCampaignRef? campaign;

/// Create a copy of DonorAppointmentEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DonorAppointmentEntityCopyWith<_DonorAppointmentEntity> get copyWith => __$DonorAppointmentEntityCopyWithImpl<_DonorAppointmentEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DonorAppointmentEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.donorId, donorId) || other.donorId == donorId)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.cancelReason, cancelReason) || other.cancelReason == cancelReason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.bloodRequest, bloodRequest) || other.bloodRequest == bloodRequest)&&(identical(other.campaign, campaign) || other.campaign == campaign));
}


@override
int get hashCode => Object.hash(runtimeType,id,donorId,scheduledAt,status,completedAt,cancelledAt,cancelReason,createdAt,bloodRequest,campaign);

@override
String toString() {
  return 'DonorAppointmentEntity(id: $id, donorId: $donorId, scheduledAt: $scheduledAt, status: $status, completedAt: $completedAt, cancelledAt: $cancelledAt, cancelReason: $cancelReason, createdAt: $createdAt, bloodRequest: $bloodRequest, campaign: $campaign)';
}


}

/// @nodoc
abstract mixin class _$DonorAppointmentEntityCopyWith<$Res> implements $DonorAppointmentEntityCopyWith<$Res> {
  factory _$DonorAppointmentEntityCopyWith(_DonorAppointmentEntity value, $Res Function(_DonorAppointmentEntity) _then) = __$DonorAppointmentEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String donorId, DateTime scheduledAt, DonationAppointmentStatus status, DateTime? completedAt, DateTime? cancelledAt, String? cancelReason, DateTime createdAt, DonorAppointmentRequestRef? bloodRequest, DonorAppointmentCampaignRef? campaign
});


@override $DonorAppointmentRequestRefCopyWith<$Res>? get bloodRequest;@override $DonorAppointmentCampaignRefCopyWith<$Res>? get campaign;

}
/// @nodoc
class __$DonorAppointmentEntityCopyWithImpl<$Res>
    implements _$DonorAppointmentEntityCopyWith<$Res> {
  __$DonorAppointmentEntityCopyWithImpl(this._self, this._then);

  final _DonorAppointmentEntity _self;
  final $Res Function(_DonorAppointmentEntity) _then;

/// Create a copy of DonorAppointmentEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? donorId = null,Object? scheduledAt = null,Object? status = null,Object? completedAt = freezed,Object? cancelledAt = freezed,Object? cancelReason = freezed,Object? createdAt = null,Object? bloodRequest = freezed,Object? campaign = freezed,}) {
  return _then(_DonorAppointmentEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,donorId: null == donorId ? _self.donorId : donorId // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DonationAppointmentStatus,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelReason: freezed == cancelReason ? _self.cancelReason : cancelReason // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,bloodRequest: freezed == bloodRequest ? _self.bloodRequest : bloodRequest // ignore: cast_nullable_to_non_nullable
as DonorAppointmentRequestRef?,campaign: freezed == campaign ? _self.campaign : campaign // ignore: cast_nullable_to_non_nullable
as DonorAppointmentCampaignRef?,
  ));
}

/// Create a copy of DonorAppointmentEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonorAppointmentRequestRefCopyWith<$Res>? get bloodRequest {
    if (_self.bloodRequest == null) {
    return null;
  }

  return $DonorAppointmentRequestRefCopyWith<$Res>(_self.bloodRequest!, (value) {
    return _then(_self.copyWith(bloodRequest: value));
  });
}/// Create a copy of DonorAppointmentEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonorAppointmentCampaignRefCopyWith<$Res>? get campaign {
    if (_self.campaign == null) {
    return null;
  }

  return $DonorAppointmentCampaignRefCopyWith<$Res>(_self.campaign!, (value) {
    return _then(_self.copyWith(campaign: value));
  });
}
}

/// @nodoc
mixin _$DonationRecordRequestRef {

 String get id; String get recipientName; DonorHospitalEntity get hospital;
/// Create a copy of DonationRecordRequestRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DonationRecordRequestRefCopyWith<DonationRecordRequestRef> get copyWith => _$DonationRecordRequestRefCopyWithImpl<DonationRecordRequestRef>(this as DonationRecordRequestRef, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DonationRecordRequestRef&&(identical(other.id, id) || other.id == id)&&(identical(other.recipientName, recipientName) || other.recipientName == recipientName)&&(identical(other.hospital, hospital) || other.hospital == hospital));
}


@override
int get hashCode => Object.hash(runtimeType,id,recipientName,hospital);

@override
String toString() {
  return 'DonationRecordRequestRef(id: $id, recipientName: $recipientName, hospital: $hospital)';
}


}

/// @nodoc
abstract mixin class $DonationRecordRequestRefCopyWith<$Res>  {
  factory $DonationRecordRequestRefCopyWith(DonationRecordRequestRef value, $Res Function(DonationRecordRequestRef) _then) = _$DonationRecordRequestRefCopyWithImpl;
@useResult
$Res call({
 String id, String recipientName, DonorHospitalEntity hospital
});


$DonorHospitalEntityCopyWith<$Res> get hospital;

}
/// @nodoc
class _$DonationRecordRequestRefCopyWithImpl<$Res>
    implements $DonationRecordRequestRefCopyWith<$Res> {
  _$DonationRecordRequestRefCopyWithImpl(this._self, this._then);

  final DonationRecordRequestRef _self;
  final $Res Function(DonationRecordRequestRef) _then;

/// Create a copy of DonationRecordRequestRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? recipientName = null,Object? hospital = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,recipientName: null == recipientName ? _self.recipientName : recipientName // ignore: cast_nullable_to_non_nullable
as String,hospital: null == hospital ? _self.hospital : hospital // ignore: cast_nullable_to_non_nullable
as DonorHospitalEntity,
  ));
}
/// Create a copy of DonationRecordRequestRef
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonorHospitalEntityCopyWith<$Res> get hospital {
  
  return $DonorHospitalEntityCopyWith<$Res>(_self.hospital, (value) {
    return _then(_self.copyWith(hospital: value));
  });
}
}


/// Adds pattern-matching-related methods to [DonationRecordRequestRef].
extension DonationRecordRequestRefPatterns on DonationRecordRequestRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DonationRecordRequestRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DonationRecordRequestRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DonationRecordRequestRef value)  $default,){
final _that = this;
switch (_that) {
case _DonationRecordRequestRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DonationRecordRequestRef value)?  $default,){
final _that = this;
switch (_that) {
case _DonationRecordRequestRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String recipientName,  DonorHospitalEntity hospital)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DonationRecordRequestRef() when $default != null:
return $default(_that.id,_that.recipientName,_that.hospital);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String recipientName,  DonorHospitalEntity hospital)  $default,) {final _that = this;
switch (_that) {
case _DonationRecordRequestRef():
return $default(_that.id,_that.recipientName,_that.hospital);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String recipientName,  DonorHospitalEntity hospital)?  $default,) {final _that = this;
switch (_that) {
case _DonationRecordRequestRef() when $default != null:
return $default(_that.id,_that.recipientName,_that.hospital);case _:
  return null;

}
}

}

/// @nodoc


class _DonationRecordRequestRef implements DonationRecordRequestRef {
  const _DonationRecordRequestRef({required this.id, required this.recipientName, required this.hospital});
  

@override final  String id;
@override final  String recipientName;
@override final  DonorHospitalEntity hospital;

/// Create a copy of DonationRecordRequestRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DonationRecordRequestRefCopyWith<_DonationRecordRequestRef> get copyWith => __$DonationRecordRequestRefCopyWithImpl<_DonationRecordRequestRef>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DonationRecordRequestRef&&(identical(other.id, id) || other.id == id)&&(identical(other.recipientName, recipientName) || other.recipientName == recipientName)&&(identical(other.hospital, hospital) || other.hospital == hospital));
}


@override
int get hashCode => Object.hash(runtimeType,id,recipientName,hospital);

@override
String toString() {
  return 'DonationRecordRequestRef(id: $id, recipientName: $recipientName, hospital: $hospital)';
}


}

/// @nodoc
abstract mixin class _$DonationRecordRequestRefCopyWith<$Res> implements $DonationRecordRequestRefCopyWith<$Res> {
  factory _$DonationRecordRequestRefCopyWith(_DonationRecordRequestRef value, $Res Function(_DonationRecordRequestRef) _then) = __$DonationRecordRequestRefCopyWithImpl;
@override @useResult
$Res call({
 String id, String recipientName, DonorHospitalEntity hospital
});


@override $DonorHospitalEntityCopyWith<$Res> get hospital;

}
/// @nodoc
class __$DonationRecordRequestRefCopyWithImpl<$Res>
    implements _$DonationRecordRequestRefCopyWith<$Res> {
  __$DonationRecordRequestRefCopyWithImpl(this._self, this._then);

  final _DonationRecordRequestRef _self;
  final $Res Function(_DonationRecordRequestRef) _then;

/// Create a copy of DonationRecordRequestRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? recipientName = null,Object? hospital = null,}) {
  return _then(_DonationRecordRequestRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,recipientName: null == recipientName ? _self.recipientName : recipientName // ignore: cast_nullable_to_non_nullable
as String,hospital: null == hospital ? _self.hospital : hospital // ignore: cast_nullable_to_non_nullable
as DonorHospitalEntity,
  ));
}

/// Create a copy of DonationRecordRequestRef
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonorHospitalEntityCopyWith<$Res> get hospital {
  
  return $DonorHospitalEntityCopyWith<$Res>(_self.hospital, (value) {
    return _then(_self.copyWith(hospital: value));
  });
}
}

/// @nodoc
mixin _$DonationRecordCampaignRef {

 String get id; String get title; String get venueName; String get city;
/// Create a copy of DonationRecordCampaignRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DonationRecordCampaignRefCopyWith<DonationRecordCampaignRef> get copyWith => _$DonationRecordCampaignRefCopyWithImpl<DonationRecordCampaignRef>(this as DonationRecordCampaignRef, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DonationRecordCampaignRef&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.venueName, venueName) || other.venueName == venueName)&&(identical(other.city, city) || other.city == city));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,venueName,city);

@override
String toString() {
  return 'DonationRecordCampaignRef(id: $id, title: $title, venueName: $venueName, city: $city)';
}


}

/// @nodoc
abstract mixin class $DonationRecordCampaignRefCopyWith<$Res>  {
  factory $DonationRecordCampaignRefCopyWith(DonationRecordCampaignRef value, $Res Function(DonationRecordCampaignRef) _then) = _$DonationRecordCampaignRefCopyWithImpl;
@useResult
$Res call({
 String id, String title, String venueName, String city
});




}
/// @nodoc
class _$DonationRecordCampaignRefCopyWithImpl<$Res>
    implements $DonationRecordCampaignRefCopyWith<$Res> {
  _$DonationRecordCampaignRefCopyWithImpl(this._self, this._then);

  final DonationRecordCampaignRef _self;
  final $Res Function(DonationRecordCampaignRef) _then;

/// Create a copy of DonationRecordCampaignRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? venueName = null,Object? city = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,venueName: null == venueName ? _self.venueName : venueName // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DonationRecordCampaignRef].
extension DonationRecordCampaignRefPatterns on DonationRecordCampaignRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DonationRecordCampaignRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DonationRecordCampaignRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DonationRecordCampaignRef value)  $default,){
final _that = this;
switch (_that) {
case _DonationRecordCampaignRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DonationRecordCampaignRef value)?  $default,){
final _that = this;
switch (_that) {
case _DonationRecordCampaignRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String venueName,  String city)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DonationRecordCampaignRef() when $default != null:
return $default(_that.id,_that.title,_that.venueName,_that.city);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String venueName,  String city)  $default,) {final _that = this;
switch (_that) {
case _DonationRecordCampaignRef():
return $default(_that.id,_that.title,_that.venueName,_that.city);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String venueName,  String city)?  $default,) {final _that = this;
switch (_that) {
case _DonationRecordCampaignRef() when $default != null:
return $default(_that.id,_that.title,_that.venueName,_that.city);case _:
  return null;

}
}

}

/// @nodoc


class _DonationRecordCampaignRef implements DonationRecordCampaignRef {
  const _DonationRecordCampaignRef({required this.id, required this.title, required this.venueName, required this.city});
  

@override final  String id;
@override final  String title;
@override final  String venueName;
@override final  String city;

/// Create a copy of DonationRecordCampaignRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DonationRecordCampaignRefCopyWith<_DonationRecordCampaignRef> get copyWith => __$DonationRecordCampaignRefCopyWithImpl<_DonationRecordCampaignRef>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DonationRecordCampaignRef&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.venueName, venueName) || other.venueName == venueName)&&(identical(other.city, city) || other.city == city));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,venueName,city);

@override
String toString() {
  return 'DonationRecordCampaignRef(id: $id, title: $title, venueName: $venueName, city: $city)';
}


}

/// @nodoc
abstract mixin class _$DonationRecordCampaignRefCopyWith<$Res> implements $DonationRecordCampaignRefCopyWith<$Res> {
  factory _$DonationRecordCampaignRefCopyWith(_DonationRecordCampaignRef value, $Res Function(_DonationRecordCampaignRef) _then) = __$DonationRecordCampaignRefCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String venueName, String city
});




}
/// @nodoc
class __$DonationRecordCampaignRefCopyWithImpl<$Res>
    implements _$DonationRecordCampaignRefCopyWith<$Res> {
  __$DonationRecordCampaignRefCopyWithImpl(this._self, this._then);

  final _DonationRecordCampaignRef _self;
  final $Res Function(_DonationRecordCampaignRef) _then;

/// Create a copy of DonationRecordCampaignRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? venueName = null,Object? city = null,}) {
  return _then(_DonationRecordCampaignRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,venueName: null == venueName ? _self.venueName : venueName // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$DonationRecordEntity {

 String get id; String get donorId; DonationSource get source; String? get requestId; String? get campaignId; String? get appointmentId; String? get hospitalId; DateTime get donatedAt; int get units; DonationRecordRequestRef? get bloodRequest; DonationRecordCampaignRef? get campaign;
/// Create a copy of DonationRecordEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DonationRecordEntityCopyWith<DonationRecordEntity> get copyWith => _$DonationRecordEntityCopyWithImpl<DonationRecordEntity>(this as DonationRecordEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DonationRecordEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.donorId, donorId) || other.donorId == donorId)&&(identical(other.source, source) || other.source == source)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.campaignId, campaignId) || other.campaignId == campaignId)&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.hospitalId, hospitalId) || other.hospitalId == hospitalId)&&(identical(other.donatedAt, donatedAt) || other.donatedAt == donatedAt)&&(identical(other.units, units) || other.units == units)&&(identical(other.bloodRequest, bloodRequest) || other.bloodRequest == bloodRequest)&&(identical(other.campaign, campaign) || other.campaign == campaign));
}


@override
int get hashCode => Object.hash(runtimeType,id,donorId,source,requestId,campaignId,appointmentId,hospitalId,donatedAt,units,bloodRequest,campaign);

@override
String toString() {
  return 'DonationRecordEntity(id: $id, donorId: $donorId, source: $source, requestId: $requestId, campaignId: $campaignId, appointmentId: $appointmentId, hospitalId: $hospitalId, donatedAt: $donatedAt, units: $units, bloodRequest: $bloodRequest, campaign: $campaign)';
}


}

/// @nodoc
abstract mixin class $DonationRecordEntityCopyWith<$Res>  {
  factory $DonationRecordEntityCopyWith(DonationRecordEntity value, $Res Function(DonationRecordEntity) _then) = _$DonationRecordEntityCopyWithImpl;
@useResult
$Res call({
 String id, String donorId, DonationSource source, String? requestId, String? campaignId, String? appointmentId, String? hospitalId, DateTime donatedAt, int units, DonationRecordRequestRef? bloodRequest, DonationRecordCampaignRef? campaign
});


$DonationRecordRequestRefCopyWith<$Res>? get bloodRequest;$DonationRecordCampaignRefCopyWith<$Res>? get campaign;

}
/// @nodoc
class _$DonationRecordEntityCopyWithImpl<$Res>
    implements $DonationRecordEntityCopyWith<$Res> {
  _$DonationRecordEntityCopyWithImpl(this._self, this._then);

  final DonationRecordEntity _self;
  final $Res Function(DonationRecordEntity) _then;

/// Create a copy of DonationRecordEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? donorId = null,Object? source = null,Object? requestId = freezed,Object? campaignId = freezed,Object? appointmentId = freezed,Object? hospitalId = freezed,Object? donatedAt = null,Object? units = null,Object? bloodRequest = freezed,Object? campaign = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,donorId: null == donorId ? _self.donorId : donorId // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as DonationSource,requestId: freezed == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String?,campaignId: freezed == campaignId ? _self.campaignId : campaignId // ignore: cast_nullable_to_non_nullable
as String?,appointmentId: freezed == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String?,hospitalId: freezed == hospitalId ? _self.hospitalId : hospitalId // ignore: cast_nullable_to_non_nullable
as String?,donatedAt: null == donatedAt ? _self.donatedAt : donatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as int,bloodRequest: freezed == bloodRequest ? _self.bloodRequest : bloodRequest // ignore: cast_nullable_to_non_nullable
as DonationRecordRequestRef?,campaign: freezed == campaign ? _self.campaign : campaign // ignore: cast_nullable_to_non_nullable
as DonationRecordCampaignRef?,
  ));
}
/// Create a copy of DonationRecordEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonationRecordRequestRefCopyWith<$Res>? get bloodRequest {
    if (_self.bloodRequest == null) {
    return null;
  }

  return $DonationRecordRequestRefCopyWith<$Res>(_self.bloodRequest!, (value) {
    return _then(_self.copyWith(bloodRequest: value));
  });
}/// Create a copy of DonationRecordEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonationRecordCampaignRefCopyWith<$Res>? get campaign {
    if (_self.campaign == null) {
    return null;
  }

  return $DonationRecordCampaignRefCopyWith<$Res>(_self.campaign!, (value) {
    return _then(_self.copyWith(campaign: value));
  });
}
}


/// Adds pattern-matching-related methods to [DonationRecordEntity].
extension DonationRecordEntityPatterns on DonationRecordEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DonationRecordEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DonationRecordEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DonationRecordEntity value)  $default,){
final _that = this;
switch (_that) {
case _DonationRecordEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DonationRecordEntity value)?  $default,){
final _that = this;
switch (_that) {
case _DonationRecordEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String donorId,  DonationSource source,  String? requestId,  String? campaignId,  String? appointmentId,  String? hospitalId,  DateTime donatedAt,  int units,  DonationRecordRequestRef? bloodRequest,  DonationRecordCampaignRef? campaign)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DonationRecordEntity() when $default != null:
return $default(_that.id,_that.donorId,_that.source,_that.requestId,_that.campaignId,_that.appointmentId,_that.hospitalId,_that.donatedAt,_that.units,_that.bloodRequest,_that.campaign);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String donorId,  DonationSource source,  String? requestId,  String? campaignId,  String? appointmentId,  String? hospitalId,  DateTime donatedAt,  int units,  DonationRecordRequestRef? bloodRequest,  DonationRecordCampaignRef? campaign)  $default,) {final _that = this;
switch (_that) {
case _DonationRecordEntity():
return $default(_that.id,_that.donorId,_that.source,_that.requestId,_that.campaignId,_that.appointmentId,_that.hospitalId,_that.donatedAt,_that.units,_that.bloodRequest,_that.campaign);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String donorId,  DonationSource source,  String? requestId,  String? campaignId,  String? appointmentId,  String? hospitalId,  DateTime donatedAt,  int units,  DonationRecordRequestRef? bloodRequest,  DonationRecordCampaignRef? campaign)?  $default,) {final _that = this;
switch (_that) {
case _DonationRecordEntity() when $default != null:
return $default(_that.id,_that.donorId,_that.source,_that.requestId,_that.campaignId,_that.appointmentId,_that.hospitalId,_that.donatedAt,_that.units,_that.bloodRequest,_that.campaign);case _:
  return null;

}
}

}

/// @nodoc


class _DonationRecordEntity implements DonationRecordEntity {
  const _DonationRecordEntity({required this.id, required this.donorId, required this.source, this.requestId, this.campaignId, this.appointmentId, this.hospitalId, required this.donatedAt, required this.units, this.bloodRequest, this.campaign});
  

@override final  String id;
@override final  String donorId;
@override final  DonationSource source;
@override final  String? requestId;
@override final  String? campaignId;
@override final  String? appointmentId;
@override final  String? hospitalId;
@override final  DateTime donatedAt;
@override final  int units;
@override final  DonationRecordRequestRef? bloodRequest;
@override final  DonationRecordCampaignRef? campaign;

/// Create a copy of DonationRecordEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DonationRecordEntityCopyWith<_DonationRecordEntity> get copyWith => __$DonationRecordEntityCopyWithImpl<_DonationRecordEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DonationRecordEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.donorId, donorId) || other.donorId == donorId)&&(identical(other.source, source) || other.source == source)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.campaignId, campaignId) || other.campaignId == campaignId)&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.hospitalId, hospitalId) || other.hospitalId == hospitalId)&&(identical(other.donatedAt, donatedAt) || other.donatedAt == donatedAt)&&(identical(other.units, units) || other.units == units)&&(identical(other.bloodRequest, bloodRequest) || other.bloodRequest == bloodRequest)&&(identical(other.campaign, campaign) || other.campaign == campaign));
}


@override
int get hashCode => Object.hash(runtimeType,id,donorId,source,requestId,campaignId,appointmentId,hospitalId,donatedAt,units,bloodRequest,campaign);

@override
String toString() {
  return 'DonationRecordEntity(id: $id, donorId: $donorId, source: $source, requestId: $requestId, campaignId: $campaignId, appointmentId: $appointmentId, hospitalId: $hospitalId, donatedAt: $donatedAt, units: $units, bloodRequest: $bloodRequest, campaign: $campaign)';
}


}

/// @nodoc
abstract mixin class _$DonationRecordEntityCopyWith<$Res> implements $DonationRecordEntityCopyWith<$Res> {
  factory _$DonationRecordEntityCopyWith(_DonationRecordEntity value, $Res Function(_DonationRecordEntity) _then) = __$DonationRecordEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String donorId, DonationSource source, String? requestId, String? campaignId, String? appointmentId, String? hospitalId, DateTime donatedAt, int units, DonationRecordRequestRef? bloodRequest, DonationRecordCampaignRef? campaign
});


@override $DonationRecordRequestRefCopyWith<$Res>? get bloodRequest;@override $DonationRecordCampaignRefCopyWith<$Res>? get campaign;

}
/// @nodoc
class __$DonationRecordEntityCopyWithImpl<$Res>
    implements _$DonationRecordEntityCopyWith<$Res> {
  __$DonationRecordEntityCopyWithImpl(this._self, this._then);

  final _DonationRecordEntity _self;
  final $Res Function(_DonationRecordEntity) _then;

/// Create a copy of DonationRecordEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? donorId = null,Object? source = null,Object? requestId = freezed,Object? campaignId = freezed,Object? appointmentId = freezed,Object? hospitalId = freezed,Object? donatedAt = null,Object? units = null,Object? bloodRequest = freezed,Object? campaign = freezed,}) {
  return _then(_DonationRecordEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,donorId: null == donorId ? _self.donorId : donorId // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as DonationSource,requestId: freezed == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String?,campaignId: freezed == campaignId ? _self.campaignId : campaignId // ignore: cast_nullable_to_non_nullable
as String?,appointmentId: freezed == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String?,hospitalId: freezed == hospitalId ? _self.hospitalId : hospitalId // ignore: cast_nullable_to_non_nullable
as String?,donatedAt: null == donatedAt ? _self.donatedAt : donatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as int,bloodRequest: freezed == bloodRequest ? _self.bloodRequest : bloodRequest // ignore: cast_nullable_to_non_nullable
as DonationRecordRequestRef?,campaign: freezed == campaign ? _self.campaign : campaign // ignore: cast_nullable_to_non_nullable
as DonationRecordCampaignRef?,
  ));
}

/// Create a copy of DonationRecordEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonationRecordRequestRefCopyWith<$Res>? get bloodRequest {
    if (_self.bloodRequest == null) {
    return null;
  }

  return $DonationRecordRequestRefCopyWith<$Res>(_self.bloodRequest!, (value) {
    return _then(_self.copyWith(bloodRequest: value));
  });
}/// Create a copy of DonationRecordEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonationRecordCampaignRefCopyWith<$Res>? get campaign {
    if (_self.campaign == null) {
    return null;
  }

  return $DonationRecordCampaignRefCopyWith<$Res>(_self.campaign!, (value) {
    return _then(_self.copyWith(campaign: value));
  });
}
}

/// @nodoc
mixin _$DonorFeedEntity {

 DonorAvailabilityEntity get availability; List<DonorBloodRequestEntity> get compatibleRequests; List<DonorCampaignEntity> get availableCampaigns; List<DonorAppointmentEntity> get appointments;
/// Create a copy of DonorFeedEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DonorFeedEntityCopyWith<DonorFeedEntity> get copyWith => _$DonorFeedEntityCopyWithImpl<DonorFeedEntity>(this as DonorFeedEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DonorFeedEntity&&(identical(other.availability, availability) || other.availability == availability)&&const DeepCollectionEquality().equals(other.compatibleRequests, compatibleRequests)&&const DeepCollectionEquality().equals(other.availableCampaigns, availableCampaigns)&&const DeepCollectionEquality().equals(other.appointments, appointments));
}


@override
int get hashCode => Object.hash(runtimeType,availability,const DeepCollectionEquality().hash(compatibleRequests),const DeepCollectionEquality().hash(availableCampaigns),const DeepCollectionEquality().hash(appointments));

@override
String toString() {
  return 'DonorFeedEntity(availability: $availability, compatibleRequests: $compatibleRequests, availableCampaigns: $availableCampaigns, appointments: $appointments)';
}


}

/// @nodoc
abstract mixin class $DonorFeedEntityCopyWith<$Res>  {
  factory $DonorFeedEntityCopyWith(DonorFeedEntity value, $Res Function(DonorFeedEntity) _then) = _$DonorFeedEntityCopyWithImpl;
@useResult
$Res call({
 DonorAvailabilityEntity availability, List<DonorBloodRequestEntity> compatibleRequests, List<DonorCampaignEntity> availableCampaigns, List<DonorAppointmentEntity> appointments
});


$DonorAvailabilityEntityCopyWith<$Res> get availability;

}
/// @nodoc
class _$DonorFeedEntityCopyWithImpl<$Res>
    implements $DonorFeedEntityCopyWith<$Res> {
  _$DonorFeedEntityCopyWithImpl(this._self, this._then);

  final DonorFeedEntity _self;
  final $Res Function(DonorFeedEntity) _then;

/// Create a copy of DonorFeedEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? availability = null,Object? compatibleRequests = null,Object? availableCampaigns = null,Object? appointments = null,}) {
  return _then(_self.copyWith(
availability: null == availability ? _self.availability : availability // ignore: cast_nullable_to_non_nullable
as DonorAvailabilityEntity,compatibleRequests: null == compatibleRequests ? _self.compatibleRequests : compatibleRequests // ignore: cast_nullable_to_non_nullable
as List<DonorBloodRequestEntity>,availableCampaigns: null == availableCampaigns ? _self.availableCampaigns : availableCampaigns // ignore: cast_nullable_to_non_nullable
as List<DonorCampaignEntity>,appointments: null == appointments ? _self.appointments : appointments // ignore: cast_nullable_to_non_nullable
as List<DonorAppointmentEntity>,
  ));
}
/// Create a copy of DonorFeedEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonorAvailabilityEntityCopyWith<$Res> get availability {
  
  return $DonorAvailabilityEntityCopyWith<$Res>(_self.availability, (value) {
    return _then(_self.copyWith(availability: value));
  });
}
}


/// Adds pattern-matching-related methods to [DonorFeedEntity].
extension DonorFeedEntityPatterns on DonorFeedEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DonorFeedEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DonorFeedEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DonorFeedEntity value)  $default,){
final _that = this;
switch (_that) {
case _DonorFeedEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DonorFeedEntity value)?  $default,){
final _that = this;
switch (_that) {
case _DonorFeedEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DonorAvailabilityEntity availability,  List<DonorBloodRequestEntity> compatibleRequests,  List<DonorCampaignEntity> availableCampaigns,  List<DonorAppointmentEntity> appointments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DonorFeedEntity() when $default != null:
return $default(_that.availability,_that.compatibleRequests,_that.availableCampaigns,_that.appointments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DonorAvailabilityEntity availability,  List<DonorBloodRequestEntity> compatibleRequests,  List<DonorCampaignEntity> availableCampaigns,  List<DonorAppointmentEntity> appointments)  $default,) {final _that = this;
switch (_that) {
case _DonorFeedEntity():
return $default(_that.availability,_that.compatibleRequests,_that.availableCampaigns,_that.appointments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DonorAvailabilityEntity availability,  List<DonorBloodRequestEntity> compatibleRequests,  List<DonorCampaignEntity> availableCampaigns,  List<DonorAppointmentEntity> appointments)?  $default,) {final _that = this;
switch (_that) {
case _DonorFeedEntity() when $default != null:
return $default(_that.availability,_that.compatibleRequests,_that.availableCampaigns,_that.appointments);case _:
  return null;

}
}

}

/// @nodoc


class _DonorFeedEntity extends DonorFeedEntity {
  const _DonorFeedEntity({required this.availability, required final  List<DonorBloodRequestEntity> compatibleRequests, required final  List<DonorCampaignEntity> availableCampaigns, required final  List<DonorAppointmentEntity> appointments}): _compatibleRequests = compatibleRequests,_availableCampaigns = availableCampaigns,_appointments = appointments,super._();
  

@override final  DonorAvailabilityEntity availability;
 final  List<DonorBloodRequestEntity> _compatibleRequests;
@override List<DonorBloodRequestEntity> get compatibleRequests {
  if (_compatibleRequests is EqualUnmodifiableListView) return _compatibleRequests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_compatibleRequests);
}

 final  List<DonorCampaignEntity> _availableCampaigns;
@override List<DonorCampaignEntity> get availableCampaigns {
  if (_availableCampaigns is EqualUnmodifiableListView) return _availableCampaigns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableCampaigns);
}

 final  List<DonorAppointmentEntity> _appointments;
@override List<DonorAppointmentEntity> get appointments {
  if (_appointments is EqualUnmodifiableListView) return _appointments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_appointments);
}


/// Create a copy of DonorFeedEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DonorFeedEntityCopyWith<_DonorFeedEntity> get copyWith => __$DonorFeedEntityCopyWithImpl<_DonorFeedEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DonorFeedEntity&&(identical(other.availability, availability) || other.availability == availability)&&const DeepCollectionEquality().equals(other._compatibleRequests, _compatibleRequests)&&const DeepCollectionEquality().equals(other._availableCampaigns, _availableCampaigns)&&const DeepCollectionEquality().equals(other._appointments, _appointments));
}


@override
int get hashCode => Object.hash(runtimeType,availability,const DeepCollectionEquality().hash(_compatibleRequests),const DeepCollectionEquality().hash(_availableCampaigns),const DeepCollectionEquality().hash(_appointments));

@override
String toString() {
  return 'DonorFeedEntity(availability: $availability, compatibleRequests: $compatibleRequests, availableCampaigns: $availableCampaigns, appointments: $appointments)';
}


}

/// @nodoc
abstract mixin class _$DonorFeedEntityCopyWith<$Res> implements $DonorFeedEntityCopyWith<$Res> {
  factory _$DonorFeedEntityCopyWith(_DonorFeedEntity value, $Res Function(_DonorFeedEntity) _then) = __$DonorFeedEntityCopyWithImpl;
@override @useResult
$Res call({
 DonorAvailabilityEntity availability, List<DonorBloodRequestEntity> compatibleRequests, List<DonorCampaignEntity> availableCampaigns, List<DonorAppointmentEntity> appointments
});


@override $DonorAvailabilityEntityCopyWith<$Res> get availability;

}
/// @nodoc
class __$DonorFeedEntityCopyWithImpl<$Res>
    implements _$DonorFeedEntityCopyWith<$Res> {
  __$DonorFeedEntityCopyWithImpl(this._self, this._then);

  final _DonorFeedEntity _self;
  final $Res Function(_DonorFeedEntity) _then;

/// Create a copy of DonorFeedEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? availability = null,Object? compatibleRequests = null,Object? availableCampaigns = null,Object? appointments = null,}) {
  return _then(_DonorFeedEntity(
availability: null == availability ? _self.availability : availability // ignore: cast_nullable_to_non_nullable
as DonorAvailabilityEntity,compatibleRequests: null == compatibleRequests ? _self._compatibleRequests : compatibleRequests // ignore: cast_nullable_to_non_nullable
as List<DonorBloodRequestEntity>,availableCampaigns: null == availableCampaigns ? _self._availableCampaigns : availableCampaigns // ignore: cast_nullable_to_non_nullable
as List<DonorCampaignEntity>,appointments: null == appointments ? _self._appointments : appointments // ignore: cast_nullable_to_non_nullable
as List<DonorAppointmentEntity>,
  ));
}

/// Create a copy of DonorFeedEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonorAvailabilityEntityCopyWith<$Res> get availability {
  
  return $DonorAvailabilityEntityCopyWith<$Res>(_self.availability, (value) {
    return _then(_self.copyWith(availability: value));
  });
}
}

// dart format on
