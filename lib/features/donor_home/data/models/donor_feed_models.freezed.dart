// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'donor_feed_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DonorHospitalModel {

 String get id;@JsonKey(name: 'wilaya_id') int get wilayaId;@JsonKey(name: 'name_ar') String get nameAr;@JsonKey(name: 'name_fr') String? get nameFr; String? get address;@JsonKey(name: 'is_active') bool get isActive;
/// Create a copy of DonorHospitalModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DonorHospitalModelCopyWith<DonorHospitalModel> get copyWith => _$DonorHospitalModelCopyWithImpl<DonorHospitalModel>(this as DonorHospitalModel, _$identity);

  /// Serializes this DonorHospitalModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DonorHospitalModel&&(identical(other.id, id) || other.id == id)&&(identical(other.wilayaId, wilayaId) || other.wilayaId == wilayaId)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.nameFr, nameFr) || other.nameFr == nameFr)&&(identical(other.address, address) || other.address == address)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,wilayaId,nameAr,nameFr,address,isActive);

@override
String toString() {
  return 'DonorHospitalModel(id: $id, wilayaId: $wilayaId, nameAr: $nameAr, nameFr: $nameFr, address: $address, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $DonorHospitalModelCopyWith<$Res>  {
  factory $DonorHospitalModelCopyWith(DonorHospitalModel value, $Res Function(DonorHospitalModel) _then) = _$DonorHospitalModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'wilaya_id') int wilayaId,@JsonKey(name: 'name_ar') String nameAr,@JsonKey(name: 'name_fr') String? nameFr, String? address,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class _$DonorHospitalModelCopyWithImpl<$Res>
    implements $DonorHospitalModelCopyWith<$Res> {
  _$DonorHospitalModelCopyWithImpl(this._self, this._then);

  final DonorHospitalModel _self;
  final $Res Function(DonorHospitalModel) _then;

/// Create a copy of DonorHospitalModel
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


/// Adds pattern-matching-related methods to [DonorHospitalModel].
extension DonorHospitalModelPatterns on DonorHospitalModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DonorHospitalModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DonorHospitalModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DonorHospitalModel value)  $default,){
final _that = this;
switch (_that) {
case _DonorHospitalModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DonorHospitalModel value)?  $default,){
final _that = this;
switch (_that) {
case _DonorHospitalModel() when $default != null:
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
case _DonorHospitalModel() when $default != null:
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
case _DonorHospitalModel():
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
case _DonorHospitalModel() when $default != null:
return $default(_that.id,_that.wilayaId,_that.nameAr,_that.nameFr,_that.address,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DonorHospitalModel extends DonorHospitalModel {
  const _DonorHospitalModel({required this.id, @JsonKey(name: 'wilaya_id') required this.wilayaId, @JsonKey(name: 'name_ar') required this.nameAr, @JsonKey(name: 'name_fr') this.nameFr, this.address, @JsonKey(name: 'is_active') required this.isActive}): super._();
  factory _DonorHospitalModel.fromJson(Map<String, dynamic> json) => _$DonorHospitalModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'wilaya_id') final  int wilayaId;
@override@JsonKey(name: 'name_ar') final  String nameAr;
@override@JsonKey(name: 'name_fr') final  String? nameFr;
@override final  String? address;
@override@JsonKey(name: 'is_active') final  bool isActive;

/// Create a copy of DonorHospitalModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DonorHospitalModelCopyWith<_DonorHospitalModel> get copyWith => __$DonorHospitalModelCopyWithImpl<_DonorHospitalModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DonorHospitalModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DonorHospitalModel&&(identical(other.id, id) || other.id == id)&&(identical(other.wilayaId, wilayaId) || other.wilayaId == wilayaId)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.nameFr, nameFr) || other.nameFr == nameFr)&&(identical(other.address, address) || other.address == address)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,wilayaId,nameAr,nameFr,address,isActive);

@override
String toString() {
  return 'DonorHospitalModel(id: $id, wilayaId: $wilayaId, nameAr: $nameAr, nameFr: $nameFr, address: $address, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$DonorHospitalModelCopyWith<$Res> implements $DonorHospitalModelCopyWith<$Res> {
  factory _$DonorHospitalModelCopyWith(_DonorHospitalModel value, $Res Function(_DonorHospitalModel) _then) = __$DonorHospitalModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'wilaya_id') int wilayaId,@JsonKey(name: 'name_ar') String nameAr,@JsonKey(name: 'name_fr') String? nameFr, String? address,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class __$DonorHospitalModelCopyWithImpl<$Res>
    implements _$DonorHospitalModelCopyWith<$Res> {
  __$DonorHospitalModelCopyWithImpl(this._self, this._then);

  final _DonorHospitalModel _self;
  final $Res Function(_DonorHospitalModel) _then;

/// Create a copy of DonorHospitalModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? wilayaId = null,Object? nameAr = null,Object? nameFr = freezed,Object? address = freezed,Object? isActive = null,}) {
  return _then(_DonorHospitalModel(
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
mixin _$DonorAvailabilityModel {

@JsonKey(name: 'id') String get userId;@JsonKey(name: 'is_active') bool get isAccountActive;@JsonKey(name: 'is_available_for_donation') bool get isAvailableForDonation;@JsonKey(name: 'is_donor') bool get isDonor;@JsonKey(name: 'blood_type') String get bloodType;// `users.wilaya_id` is nullable — a donor who signed up before the wilaya
// rollout (or skipped it) has none. Keep it optional so the feed still loads.
@JsonKey(name: 'wilaya_id') int? get wilayaId;@JsonKey(name: 'cooldown_until') DateTime? get cooldownUntil;@JsonKey(name: 'last_donation_date') DateTime? get lastDonationDate;@JsonKey(name: 'total_donations_count') int get totalDonationsCount;
/// Create a copy of DonorAvailabilityModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DonorAvailabilityModelCopyWith<DonorAvailabilityModel> get copyWith => _$DonorAvailabilityModelCopyWithImpl<DonorAvailabilityModel>(this as DonorAvailabilityModel, _$identity);

  /// Serializes this DonorAvailabilityModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DonorAvailabilityModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.isAccountActive, isAccountActive) || other.isAccountActive == isAccountActive)&&(identical(other.isAvailableForDonation, isAvailableForDonation) || other.isAvailableForDonation == isAvailableForDonation)&&(identical(other.isDonor, isDonor) || other.isDonor == isDonor)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.wilayaId, wilayaId) || other.wilayaId == wilayaId)&&(identical(other.cooldownUntil, cooldownUntil) || other.cooldownUntil == cooldownUntil)&&(identical(other.lastDonationDate, lastDonationDate) || other.lastDonationDate == lastDonationDate)&&(identical(other.totalDonationsCount, totalDonationsCount) || other.totalDonationsCount == totalDonationsCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,isAccountActive,isAvailableForDonation,isDonor,bloodType,wilayaId,cooldownUntil,lastDonationDate,totalDonationsCount);

@override
String toString() {
  return 'DonorAvailabilityModel(userId: $userId, isAccountActive: $isAccountActive, isAvailableForDonation: $isAvailableForDonation, isDonor: $isDonor, bloodType: $bloodType, wilayaId: $wilayaId, cooldownUntil: $cooldownUntil, lastDonationDate: $lastDonationDate, totalDonationsCount: $totalDonationsCount)';
}


}

/// @nodoc
abstract mixin class $DonorAvailabilityModelCopyWith<$Res>  {
  factory $DonorAvailabilityModelCopyWith(DonorAvailabilityModel value, $Res Function(DonorAvailabilityModel) _then) = _$DonorAvailabilityModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String userId,@JsonKey(name: 'is_active') bool isAccountActive,@JsonKey(name: 'is_available_for_donation') bool isAvailableForDonation,@JsonKey(name: 'is_donor') bool isDonor,@JsonKey(name: 'blood_type') String bloodType,@JsonKey(name: 'wilaya_id') int? wilayaId,@JsonKey(name: 'cooldown_until') DateTime? cooldownUntil,@JsonKey(name: 'last_donation_date') DateTime? lastDonationDate,@JsonKey(name: 'total_donations_count') int totalDonationsCount
});




}
/// @nodoc
class _$DonorAvailabilityModelCopyWithImpl<$Res>
    implements $DonorAvailabilityModelCopyWith<$Res> {
  _$DonorAvailabilityModelCopyWithImpl(this._self, this._then);

  final DonorAvailabilityModel _self;
  final $Res Function(DonorAvailabilityModel) _then;

/// Create a copy of DonorAvailabilityModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? isAccountActive = null,Object? isAvailableForDonation = null,Object? isDonor = null,Object? bloodType = null,Object? wilayaId = freezed,Object? cooldownUntil = freezed,Object? lastDonationDate = freezed,Object? totalDonationsCount = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,isAccountActive: null == isAccountActive ? _self.isAccountActive : isAccountActive // ignore: cast_nullable_to_non_nullable
as bool,isAvailableForDonation: null == isAvailableForDonation ? _self.isAvailableForDonation : isAvailableForDonation // ignore: cast_nullable_to_non_nullable
as bool,isDonor: null == isDonor ? _self.isDonor : isDonor // ignore: cast_nullable_to_non_nullable
as bool,bloodType: null == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as String,wilayaId: freezed == wilayaId ? _self.wilayaId : wilayaId // ignore: cast_nullable_to_non_nullable
as int?,cooldownUntil: freezed == cooldownUntil ? _self.cooldownUntil : cooldownUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,lastDonationDate: freezed == lastDonationDate ? _self.lastDonationDate : lastDonationDate // ignore: cast_nullable_to_non_nullable
as DateTime?,totalDonationsCount: null == totalDonationsCount ? _self.totalDonationsCount : totalDonationsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DonorAvailabilityModel].
extension DonorAvailabilityModelPatterns on DonorAvailabilityModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DonorAvailabilityModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DonorAvailabilityModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DonorAvailabilityModel value)  $default,){
final _that = this;
switch (_that) {
case _DonorAvailabilityModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DonorAvailabilityModel value)?  $default,){
final _that = this;
switch (_that) {
case _DonorAvailabilityModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String userId, @JsonKey(name: 'is_active')  bool isAccountActive, @JsonKey(name: 'is_available_for_donation')  bool isAvailableForDonation, @JsonKey(name: 'is_donor')  bool isDonor, @JsonKey(name: 'blood_type')  String bloodType, @JsonKey(name: 'wilaya_id')  int? wilayaId, @JsonKey(name: 'cooldown_until')  DateTime? cooldownUntil, @JsonKey(name: 'last_donation_date')  DateTime? lastDonationDate, @JsonKey(name: 'total_donations_count')  int totalDonationsCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DonorAvailabilityModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String userId, @JsonKey(name: 'is_active')  bool isAccountActive, @JsonKey(name: 'is_available_for_donation')  bool isAvailableForDonation, @JsonKey(name: 'is_donor')  bool isDonor, @JsonKey(name: 'blood_type')  String bloodType, @JsonKey(name: 'wilaya_id')  int? wilayaId, @JsonKey(name: 'cooldown_until')  DateTime? cooldownUntil, @JsonKey(name: 'last_donation_date')  DateTime? lastDonationDate, @JsonKey(name: 'total_donations_count')  int totalDonationsCount)  $default,) {final _that = this;
switch (_that) {
case _DonorAvailabilityModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String userId, @JsonKey(name: 'is_active')  bool isAccountActive, @JsonKey(name: 'is_available_for_donation')  bool isAvailableForDonation, @JsonKey(name: 'is_donor')  bool isDonor, @JsonKey(name: 'blood_type')  String bloodType, @JsonKey(name: 'wilaya_id')  int? wilayaId, @JsonKey(name: 'cooldown_until')  DateTime? cooldownUntil, @JsonKey(name: 'last_donation_date')  DateTime? lastDonationDate, @JsonKey(name: 'total_donations_count')  int totalDonationsCount)?  $default,) {final _that = this;
switch (_that) {
case _DonorAvailabilityModel() when $default != null:
return $default(_that.userId,_that.isAccountActive,_that.isAvailableForDonation,_that.isDonor,_that.bloodType,_that.wilayaId,_that.cooldownUntil,_that.lastDonationDate,_that.totalDonationsCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DonorAvailabilityModel extends DonorAvailabilityModel {
  const _DonorAvailabilityModel({@JsonKey(name: 'id') required this.userId, @JsonKey(name: 'is_active') required this.isAccountActive, @JsonKey(name: 'is_available_for_donation') required this.isAvailableForDonation, @JsonKey(name: 'is_donor') required this.isDonor, @JsonKey(name: 'blood_type') required this.bloodType, @JsonKey(name: 'wilaya_id') this.wilayaId, @JsonKey(name: 'cooldown_until') this.cooldownUntil, @JsonKey(name: 'last_donation_date') this.lastDonationDate, @JsonKey(name: 'total_donations_count') required this.totalDonationsCount}): super._();
  factory _DonorAvailabilityModel.fromJson(Map<String, dynamic> json) => _$DonorAvailabilityModelFromJson(json);

@override@JsonKey(name: 'id') final  String userId;
@override@JsonKey(name: 'is_active') final  bool isAccountActive;
@override@JsonKey(name: 'is_available_for_donation') final  bool isAvailableForDonation;
@override@JsonKey(name: 'is_donor') final  bool isDonor;
@override@JsonKey(name: 'blood_type') final  String bloodType;
// `users.wilaya_id` is nullable — a donor who signed up before the wilaya
// rollout (or skipped it) has none. Keep it optional so the feed still loads.
@override@JsonKey(name: 'wilaya_id') final  int? wilayaId;
@override@JsonKey(name: 'cooldown_until') final  DateTime? cooldownUntil;
@override@JsonKey(name: 'last_donation_date') final  DateTime? lastDonationDate;
@override@JsonKey(name: 'total_donations_count') final  int totalDonationsCount;

/// Create a copy of DonorAvailabilityModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DonorAvailabilityModelCopyWith<_DonorAvailabilityModel> get copyWith => __$DonorAvailabilityModelCopyWithImpl<_DonorAvailabilityModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DonorAvailabilityModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DonorAvailabilityModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.isAccountActive, isAccountActive) || other.isAccountActive == isAccountActive)&&(identical(other.isAvailableForDonation, isAvailableForDonation) || other.isAvailableForDonation == isAvailableForDonation)&&(identical(other.isDonor, isDonor) || other.isDonor == isDonor)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.wilayaId, wilayaId) || other.wilayaId == wilayaId)&&(identical(other.cooldownUntil, cooldownUntil) || other.cooldownUntil == cooldownUntil)&&(identical(other.lastDonationDate, lastDonationDate) || other.lastDonationDate == lastDonationDate)&&(identical(other.totalDonationsCount, totalDonationsCount) || other.totalDonationsCount == totalDonationsCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,isAccountActive,isAvailableForDonation,isDonor,bloodType,wilayaId,cooldownUntil,lastDonationDate,totalDonationsCount);

@override
String toString() {
  return 'DonorAvailabilityModel(userId: $userId, isAccountActive: $isAccountActive, isAvailableForDonation: $isAvailableForDonation, isDonor: $isDonor, bloodType: $bloodType, wilayaId: $wilayaId, cooldownUntil: $cooldownUntil, lastDonationDate: $lastDonationDate, totalDonationsCount: $totalDonationsCount)';
}


}

/// @nodoc
abstract mixin class _$DonorAvailabilityModelCopyWith<$Res> implements $DonorAvailabilityModelCopyWith<$Res> {
  factory _$DonorAvailabilityModelCopyWith(_DonorAvailabilityModel value, $Res Function(_DonorAvailabilityModel) _then) = __$DonorAvailabilityModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String userId,@JsonKey(name: 'is_active') bool isAccountActive,@JsonKey(name: 'is_available_for_donation') bool isAvailableForDonation,@JsonKey(name: 'is_donor') bool isDonor,@JsonKey(name: 'blood_type') String bloodType,@JsonKey(name: 'wilaya_id') int? wilayaId,@JsonKey(name: 'cooldown_until') DateTime? cooldownUntil,@JsonKey(name: 'last_donation_date') DateTime? lastDonationDate,@JsonKey(name: 'total_donations_count') int totalDonationsCount
});




}
/// @nodoc
class __$DonorAvailabilityModelCopyWithImpl<$Res>
    implements _$DonorAvailabilityModelCopyWith<$Res> {
  __$DonorAvailabilityModelCopyWithImpl(this._self, this._then);

  final _DonorAvailabilityModel _self;
  final $Res Function(_DonorAvailabilityModel) _then;

/// Create a copy of DonorAvailabilityModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? isAccountActive = null,Object? isAvailableForDonation = null,Object? isDonor = null,Object? bloodType = null,Object? wilayaId = freezed,Object? cooldownUntil = freezed,Object? lastDonationDate = freezed,Object? totalDonationsCount = null,}) {
  return _then(_DonorAvailabilityModel(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,isAccountActive: null == isAccountActive ? _self.isAccountActive : isAccountActive // ignore: cast_nullable_to_non_nullable
as bool,isAvailableForDonation: null == isAvailableForDonation ? _self.isAvailableForDonation : isAvailableForDonation // ignore: cast_nullable_to_non_nullable
as bool,isDonor: null == isDonor ? _self.isDonor : isDonor // ignore: cast_nullable_to_non_nullable
as bool,bloodType: null == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as String,wilayaId: freezed == wilayaId ? _self.wilayaId : wilayaId // ignore: cast_nullable_to_non_nullable
as int?,cooldownUntil: freezed == cooldownUntil ? _self.cooldownUntil : cooldownUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,lastDonationDate: freezed == lastDonationDate ? _self.lastDonationDate : lastDonationDate // ignore: cast_nullable_to_non_nullable
as DateTime?,totalDonationsCount: null == totalDonationsCount ? _self.totalDonationsCount : totalDonationsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$DonorBloodRequestModel {

 String get id;@JsonKey(name: 'requested_by') String get requestedBy;@JsonKey(name: 'patient_name') String? get patientName; DonorHospitalModel get hospital;@JsonKey(name: 'blood_type') String get bloodType; String get urgency;@JsonKey(name: 'units_needed') int get unitsNeeded;@JsonKey(name: 'units_fulfilled') int get unitsFulfilled; String get status;@JsonKey(name: 'needed_by') DateTime? get neededBy;@JsonKey(name: 'expires_at') DateTime? get expiresAt; String? get notes;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of DonorBloodRequestModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DonorBloodRequestModelCopyWith<DonorBloodRequestModel> get copyWith => _$DonorBloodRequestModelCopyWithImpl<DonorBloodRequestModel>(this as DonorBloodRequestModel, _$identity);

  /// Serializes this DonorBloodRequestModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DonorBloodRequestModel&&(identical(other.id, id) || other.id == id)&&(identical(other.requestedBy, requestedBy) || other.requestedBy == requestedBy)&&(identical(other.patientName, patientName) || other.patientName == patientName)&&(identical(other.hospital, hospital) || other.hospital == hospital)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.urgency, urgency) || other.urgency == urgency)&&(identical(other.unitsNeeded, unitsNeeded) || other.unitsNeeded == unitsNeeded)&&(identical(other.unitsFulfilled, unitsFulfilled) || other.unitsFulfilled == unitsFulfilled)&&(identical(other.status, status) || other.status == status)&&(identical(other.neededBy, neededBy) || other.neededBy == neededBy)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,requestedBy,patientName,hospital,bloodType,urgency,unitsNeeded,unitsFulfilled,status,neededBy,expiresAt,notes,createdAt);

@override
String toString() {
  return 'DonorBloodRequestModel(id: $id, requestedBy: $requestedBy, patientName: $patientName, hospital: $hospital, bloodType: $bloodType, urgency: $urgency, unitsNeeded: $unitsNeeded, unitsFulfilled: $unitsFulfilled, status: $status, neededBy: $neededBy, expiresAt: $expiresAt, notes: $notes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $DonorBloodRequestModelCopyWith<$Res>  {
  factory $DonorBloodRequestModelCopyWith(DonorBloodRequestModel value, $Res Function(DonorBloodRequestModel) _then) = _$DonorBloodRequestModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'requested_by') String requestedBy,@JsonKey(name: 'patient_name') String? patientName, DonorHospitalModel hospital,@JsonKey(name: 'blood_type') String bloodType, String urgency,@JsonKey(name: 'units_needed') int unitsNeeded,@JsonKey(name: 'units_fulfilled') int unitsFulfilled, String status,@JsonKey(name: 'needed_by') DateTime? neededBy,@JsonKey(name: 'expires_at') DateTime? expiresAt, String? notes,@JsonKey(name: 'created_at') DateTime createdAt
});


$DonorHospitalModelCopyWith<$Res> get hospital;

}
/// @nodoc
class _$DonorBloodRequestModelCopyWithImpl<$Res>
    implements $DonorBloodRequestModelCopyWith<$Res> {
  _$DonorBloodRequestModelCopyWithImpl(this._self, this._then);

  final DonorBloodRequestModel _self;
  final $Res Function(DonorBloodRequestModel) _then;

/// Create a copy of DonorBloodRequestModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? requestedBy = null,Object? patientName = freezed,Object? hospital = null,Object? bloodType = null,Object? urgency = null,Object? unitsNeeded = null,Object? unitsFulfilled = null,Object? status = null,Object? neededBy = freezed,Object? expiresAt = freezed,Object? notes = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,requestedBy: null == requestedBy ? _self.requestedBy : requestedBy // ignore: cast_nullable_to_non_nullable
as String,patientName: freezed == patientName ? _self.patientName : patientName // ignore: cast_nullable_to_non_nullable
as String?,hospital: null == hospital ? _self.hospital : hospital // ignore: cast_nullable_to_non_nullable
as DonorHospitalModel,bloodType: null == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
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
/// Create a copy of DonorBloodRequestModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonorHospitalModelCopyWith<$Res> get hospital {
  
  return $DonorHospitalModelCopyWith<$Res>(_self.hospital, (value) {
    return _then(_self.copyWith(hospital: value));
  });
}
}


/// Adds pattern-matching-related methods to [DonorBloodRequestModel].
extension DonorBloodRequestModelPatterns on DonorBloodRequestModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DonorBloodRequestModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DonorBloodRequestModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DonorBloodRequestModel value)  $default,){
final _that = this;
switch (_that) {
case _DonorBloodRequestModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DonorBloodRequestModel value)?  $default,){
final _that = this;
switch (_that) {
case _DonorBloodRequestModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'requested_by')  String requestedBy, @JsonKey(name: 'patient_name')  String? patientName,  DonorHospitalModel hospital, @JsonKey(name: 'blood_type')  String bloodType,  String urgency, @JsonKey(name: 'units_needed')  int unitsNeeded, @JsonKey(name: 'units_fulfilled')  int unitsFulfilled,  String status, @JsonKey(name: 'needed_by')  DateTime? neededBy, @JsonKey(name: 'expires_at')  DateTime? expiresAt,  String? notes, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DonorBloodRequestModel() when $default != null:
return $default(_that.id,_that.requestedBy,_that.patientName,_that.hospital,_that.bloodType,_that.urgency,_that.unitsNeeded,_that.unitsFulfilled,_that.status,_that.neededBy,_that.expiresAt,_that.notes,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'requested_by')  String requestedBy, @JsonKey(name: 'patient_name')  String? patientName,  DonorHospitalModel hospital, @JsonKey(name: 'blood_type')  String bloodType,  String urgency, @JsonKey(name: 'units_needed')  int unitsNeeded, @JsonKey(name: 'units_fulfilled')  int unitsFulfilled,  String status, @JsonKey(name: 'needed_by')  DateTime? neededBy, @JsonKey(name: 'expires_at')  DateTime? expiresAt,  String? notes, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _DonorBloodRequestModel():
return $default(_that.id,_that.requestedBy,_that.patientName,_that.hospital,_that.bloodType,_that.urgency,_that.unitsNeeded,_that.unitsFulfilled,_that.status,_that.neededBy,_that.expiresAt,_that.notes,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'requested_by')  String requestedBy, @JsonKey(name: 'patient_name')  String? patientName,  DonorHospitalModel hospital, @JsonKey(name: 'blood_type')  String bloodType,  String urgency, @JsonKey(name: 'units_needed')  int unitsNeeded, @JsonKey(name: 'units_fulfilled')  int unitsFulfilled,  String status, @JsonKey(name: 'needed_by')  DateTime? neededBy, @JsonKey(name: 'expires_at')  DateTime? expiresAt,  String? notes, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _DonorBloodRequestModel() when $default != null:
return $default(_that.id,_that.requestedBy,_that.patientName,_that.hospital,_that.bloodType,_that.urgency,_that.unitsNeeded,_that.unitsFulfilled,_that.status,_that.neededBy,_that.expiresAt,_that.notes,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DonorBloodRequestModel extends DonorBloodRequestModel {
  const _DonorBloodRequestModel({required this.id, @JsonKey(name: 'requested_by') required this.requestedBy, @JsonKey(name: 'patient_name') this.patientName, required this.hospital, @JsonKey(name: 'blood_type') required this.bloodType, required this.urgency, @JsonKey(name: 'units_needed') required this.unitsNeeded, @JsonKey(name: 'units_fulfilled') required this.unitsFulfilled, required this.status, @JsonKey(name: 'needed_by') this.neededBy, @JsonKey(name: 'expires_at') this.expiresAt, this.notes, @JsonKey(name: 'created_at') required this.createdAt}): super._();
  factory _DonorBloodRequestModel.fromJson(Map<String, dynamic> json) => _$DonorBloodRequestModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'requested_by') final  String requestedBy;
@override@JsonKey(name: 'patient_name') final  String? patientName;
@override final  DonorHospitalModel hospital;
@override@JsonKey(name: 'blood_type') final  String bloodType;
@override final  String urgency;
@override@JsonKey(name: 'units_needed') final  int unitsNeeded;
@override@JsonKey(name: 'units_fulfilled') final  int unitsFulfilled;
@override final  String status;
@override@JsonKey(name: 'needed_by') final  DateTime? neededBy;
@override@JsonKey(name: 'expires_at') final  DateTime? expiresAt;
@override final  String? notes;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of DonorBloodRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DonorBloodRequestModelCopyWith<_DonorBloodRequestModel> get copyWith => __$DonorBloodRequestModelCopyWithImpl<_DonorBloodRequestModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DonorBloodRequestModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DonorBloodRequestModel&&(identical(other.id, id) || other.id == id)&&(identical(other.requestedBy, requestedBy) || other.requestedBy == requestedBy)&&(identical(other.patientName, patientName) || other.patientName == patientName)&&(identical(other.hospital, hospital) || other.hospital == hospital)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.urgency, urgency) || other.urgency == urgency)&&(identical(other.unitsNeeded, unitsNeeded) || other.unitsNeeded == unitsNeeded)&&(identical(other.unitsFulfilled, unitsFulfilled) || other.unitsFulfilled == unitsFulfilled)&&(identical(other.status, status) || other.status == status)&&(identical(other.neededBy, neededBy) || other.neededBy == neededBy)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,requestedBy,patientName,hospital,bloodType,urgency,unitsNeeded,unitsFulfilled,status,neededBy,expiresAt,notes,createdAt);

@override
String toString() {
  return 'DonorBloodRequestModel(id: $id, requestedBy: $requestedBy, patientName: $patientName, hospital: $hospital, bloodType: $bloodType, urgency: $urgency, unitsNeeded: $unitsNeeded, unitsFulfilled: $unitsFulfilled, status: $status, neededBy: $neededBy, expiresAt: $expiresAt, notes: $notes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$DonorBloodRequestModelCopyWith<$Res> implements $DonorBloodRequestModelCopyWith<$Res> {
  factory _$DonorBloodRequestModelCopyWith(_DonorBloodRequestModel value, $Res Function(_DonorBloodRequestModel) _then) = __$DonorBloodRequestModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'requested_by') String requestedBy,@JsonKey(name: 'patient_name') String? patientName, DonorHospitalModel hospital,@JsonKey(name: 'blood_type') String bloodType, String urgency,@JsonKey(name: 'units_needed') int unitsNeeded,@JsonKey(name: 'units_fulfilled') int unitsFulfilled, String status,@JsonKey(name: 'needed_by') DateTime? neededBy,@JsonKey(name: 'expires_at') DateTime? expiresAt, String? notes,@JsonKey(name: 'created_at') DateTime createdAt
});


@override $DonorHospitalModelCopyWith<$Res> get hospital;

}
/// @nodoc
class __$DonorBloodRequestModelCopyWithImpl<$Res>
    implements _$DonorBloodRequestModelCopyWith<$Res> {
  __$DonorBloodRequestModelCopyWithImpl(this._self, this._then);

  final _DonorBloodRequestModel _self;
  final $Res Function(_DonorBloodRequestModel) _then;

/// Create a copy of DonorBloodRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? requestedBy = null,Object? patientName = freezed,Object? hospital = null,Object? bloodType = null,Object? urgency = null,Object? unitsNeeded = null,Object? unitsFulfilled = null,Object? status = null,Object? neededBy = freezed,Object? expiresAt = freezed,Object? notes = freezed,Object? createdAt = null,}) {
  return _then(_DonorBloodRequestModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,requestedBy: null == requestedBy ? _self.requestedBy : requestedBy // ignore: cast_nullable_to_non_nullable
as String,patientName: freezed == patientName ? _self.patientName : patientName // ignore: cast_nullable_to_non_nullable
as String?,hospital: null == hospital ? _self.hospital : hospital // ignore: cast_nullable_to_non_nullable
as DonorHospitalModel,bloodType: null == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
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

/// Create a copy of DonorBloodRequestModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonorHospitalModelCopyWith<$Res> get hospital {
  
  return $DonorHospitalModelCopyWith<$Res>(_self.hospital, (value) {
    return _then(_self.copyWith(hospital: value));
  });
}
}


/// @nodoc
mixin _$DonorCampaignModel {

 String get id;@JsonKey(name: 'created_by') String? get createdBy;@JsonKey(name: 'organizer_name') String get organizerName; String get title; String? get description;// `campaigns.venue_name` is nullable in the schema.
@JsonKey(name: 'venue_name') String? get venueName; String get city;@JsonKey(name: 'wilaya_id') int get wilayaId;@JsonKey(name: 'hospital_id') String? get hospitalId;@JsonKey(name: 'blood_types_needed') List<String>? get bloodTypesNeeded; String get status;@JsonKey(name: 'starts_at') DateTime get startsAt;@JsonKey(name: 'ends_at') DateTime get endsAt;@JsonKey(name: 'published_at') DateTime? get publishedAt;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of DonorCampaignModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DonorCampaignModelCopyWith<DonorCampaignModel> get copyWith => _$DonorCampaignModelCopyWithImpl<DonorCampaignModel>(this as DonorCampaignModel, _$identity);

  /// Serializes this DonorCampaignModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DonorCampaignModel&&(identical(other.id, id) || other.id == id)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.organizerName, organizerName) || other.organizerName == organizerName)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.venueName, venueName) || other.venueName == venueName)&&(identical(other.city, city) || other.city == city)&&(identical(other.wilayaId, wilayaId) || other.wilayaId == wilayaId)&&(identical(other.hospitalId, hospitalId) || other.hospitalId == hospitalId)&&const DeepCollectionEquality().equals(other.bloodTypesNeeded, bloodTypesNeeded)&&(identical(other.status, status) || other.status == status)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdBy,organizerName,title,description,venueName,city,wilayaId,hospitalId,const DeepCollectionEquality().hash(bloodTypesNeeded),status,startsAt,endsAt,publishedAt,createdAt);

@override
String toString() {
  return 'DonorCampaignModel(id: $id, createdBy: $createdBy, organizerName: $organizerName, title: $title, description: $description, venueName: $venueName, city: $city, wilayaId: $wilayaId, hospitalId: $hospitalId, bloodTypesNeeded: $bloodTypesNeeded, status: $status, startsAt: $startsAt, endsAt: $endsAt, publishedAt: $publishedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $DonorCampaignModelCopyWith<$Res>  {
  factory $DonorCampaignModelCopyWith(DonorCampaignModel value, $Res Function(DonorCampaignModel) _then) = _$DonorCampaignModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'created_by') String? createdBy,@JsonKey(name: 'organizer_name') String organizerName, String title, String? description,@JsonKey(name: 'venue_name') String? venueName, String city,@JsonKey(name: 'wilaya_id') int wilayaId,@JsonKey(name: 'hospital_id') String? hospitalId,@JsonKey(name: 'blood_types_needed') List<String>? bloodTypesNeeded, String status,@JsonKey(name: 'starts_at') DateTime startsAt,@JsonKey(name: 'ends_at') DateTime endsAt,@JsonKey(name: 'published_at') DateTime? publishedAt,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$DonorCampaignModelCopyWithImpl<$Res>
    implements $DonorCampaignModelCopyWith<$Res> {
  _$DonorCampaignModelCopyWithImpl(this._self, this._then);

  final DonorCampaignModel _self;
  final $Res Function(DonorCampaignModel) _then;

/// Create a copy of DonorCampaignModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdBy = freezed,Object? organizerName = null,Object? title = null,Object? description = freezed,Object? venueName = freezed,Object? city = null,Object? wilayaId = null,Object? hospitalId = freezed,Object? bloodTypesNeeded = freezed,Object? status = null,Object? startsAt = null,Object? endsAt = null,Object? publishedAt = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,organizerName: null == organizerName ? _self.organizerName : organizerName // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,venueName: freezed == venueName ? _self.venueName : venueName // ignore: cast_nullable_to_non_nullable
as String?,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,wilayaId: null == wilayaId ? _self.wilayaId : wilayaId // ignore: cast_nullable_to_non_nullable
as int,hospitalId: freezed == hospitalId ? _self.hospitalId : hospitalId // ignore: cast_nullable_to_non_nullable
as String?,bloodTypesNeeded: freezed == bloodTypesNeeded ? _self.bloodTypesNeeded : bloodTypesNeeded // ignore: cast_nullable_to_non_nullable
as List<String>?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DonorCampaignModel].
extension DonorCampaignModelPatterns on DonorCampaignModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DonorCampaignModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DonorCampaignModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DonorCampaignModel value)  $default,){
final _that = this;
switch (_that) {
case _DonorCampaignModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DonorCampaignModel value)?  $default,){
final _that = this;
switch (_that) {
case _DonorCampaignModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'created_by')  String? createdBy, @JsonKey(name: 'organizer_name')  String organizerName,  String title,  String? description, @JsonKey(name: 'venue_name')  String? venueName,  String city, @JsonKey(name: 'wilaya_id')  int wilayaId, @JsonKey(name: 'hospital_id')  String? hospitalId, @JsonKey(name: 'blood_types_needed')  List<String>? bloodTypesNeeded,  String status, @JsonKey(name: 'starts_at')  DateTime startsAt, @JsonKey(name: 'ends_at')  DateTime endsAt, @JsonKey(name: 'published_at')  DateTime? publishedAt, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DonorCampaignModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'created_by')  String? createdBy, @JsonKey(name: 'organizer_name')  String organizerName,  String title,  String? description, @JsonKey(name: 'venue_name')  String? venueName,  String city, @JsonKey(name: 'wilaya_id')  int wilayaId, @JsonKey(name: 'hospital_id')  String? hospitalId, @JsonKey(name: 'blood_types_needed')  List<String>? bloodTypesNeeded,  String status, @JsonKey(name: 'starts_at')  DateTime startsAt, @JsonKey(name: 'ends_at')  DateTime endsAt, @JsonKey(name: 'published_at')  DateTime? publishedAt, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _DonorCampaignModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'created_by')  String? createdBy, @JsonKey(name: 'organizer_name')  String organizerName,  String title,  String? description, @JsonKey(name: 'venue_name')  String? venueName,  String city, @JsonKey(name: 'wilaya_id')  int wilayaId, @JsonKey(name: 'hospital_id')  String? hospitalId, @JsonKey(name: 'blood_types_needed')  List<String>? bloodTypesNeeded,  String status, @JsonKey(name: 'starts_at')  DateTime startsAt, @JsonKey(name: 'ends_at')  DateTime endsAt, @JsonKey(name: 'published_at')  DateTime? publishedAt, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _DonorCampaignModel() when $default != null:
return $default(_that.id,_that.createdBy,_that.organizerName,_that.title,_that.description,_that.venueName,_that.city,_that.wilayaId,_that.hospitalId,_that.bloodTypesNeeded,_that.status,_that.startsAt,_that.endsAt,_that.publishedAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DonorCampaignModel extends DonorCampaignModel {
  const _DonorCampaignModel({required this.id, @JsonKey(name: 'created_by') this.createdBy, @JsonKey(name: 'organizer_name') required this.organizerName, required this.title, this.description, @JsonKey(name: 'venue_name') this.venueName, required this.city, @JsonKey(name: 'wilaya_id') required this.wilayaId, @JsonKey(name: 'hospital_id') this.hospitalId, @JsonKey(name: 'blood_types_needed') final  List<String>? bloodTypesNeeded, required this.status, @JsonKey(name: 'starts_at') required this.startsAt, @JsonKey(name: 'ends_at') required this.endsAt, @JsonKey(name: 'published_at') this.publishedAt, @JsonKey(name: 'created_at') required this.createdAt}): _bloodTypesNeeded = bloodTypesNeeded,super._();
  factory _DonorCampaignModel.fromJson(Map<String, dynamic> json) => _$DonorCampaignModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'created_by') final  String? createdBy;
@override@JsonKey(name: 'organizer_name') final  String organizerName;
@override final  String title;
@override final  String? description;
// `campaigns.venue_name` is nullable in the schema.
@override@JsonKey(name: 'venue_name') final  String? venueName;
@override final  String city;
@override@JsonKey(name: 'wilaya_id') final  int wilayaId;
@override@JsonKey(name: 'hospital_id') final  String? hospitalId;
 final  List<String>? _bloodTypesNeeded;
@override@JsonKey(name: 'blood_types_needed') List<String>? get bloodTypesNeeded {
  final value = _bloodTypesNeeded;
  if (value == null) return null;
  if (_bloodTypesNeeded is EqualUnmodifiableListView) return _bloodTypesNeeded;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String status;
@override@JsonKey(name: 'starts_at') final  DateTime startsAt;
@override@JsonKey(name: 'ends_at') final  DateTime endsAt;
@override@JsonKey(name: 'published_at') final  DateTime? publishedAt;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of DonorCampaignModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DonorCampaignModelCopyWith<_DonorCampaignModel> get copyWith => __$DonorCampaignModelCopyWithImpl<_DonorCampaignModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DonorCampaignModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DonorCampaignModel&&(identical(other.id, id) || other.id == id)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.organizerName, organizerName) || other.organizerName == organizerName)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.venueName, venueName) || other.venueName == venueName)&&(identical(other.city, city) || other.city == city)&&(identical(other.wilayaId, wilayaId) || other.wilayaId == wilayaId)&&(identical(other.hospitalId, hospitalId) || other.hospitalId == hospitalId)&&const DeepCollectionEquality().equals(other._bloodTypesNeeded, _bloodTypesNeeded)&&(identical(other.status, status) || other.status == status)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdBy,organizerName,title,description,venueName,city,wilayaId,hospitalId,const DeepCollectionEquality().hash(_bloodTypesNeeded),status,startsAt,endsAt,publishedAt,createdAt);

@override
String toString() {
  return 'DonorCampaignModel(id: $id, createdBy: $createdBy, organizerName: $organizerName, title: $title, description: $description, venueName: $venueName, city: $city, wilayaId: $wilayaId, hospitalId: $hospitalId, bloodTypesNeeded: $bloodTypesNeeded, status: $status, startsAt: $startsAt, endsAt: $endsAt, publishedAt: $publishedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$DonorCampaignModelCopyWith<$Res> implements $DonorCampaignModelCopyWith<$Res> {
  factory _$DonorCampaignModelCopyWith(_DonorCampaignModel value, $Res Function(_DonorCampaignModel) _then) = __$DonorCampaignModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'created_by') String? createdBy,@JsonKey(name: 'organizer_name') String organizerName, String title, String? description,@JsonKey(name: 'venue_name') String? venueName, String city,@JsonKey(name: 'wilaya_id') int wilayaId,@JsonKey(name: 'hospital_id') String? hospitalId,@JsonKey(name: 'blood_types_needed') List<String>? bloodTypesNeeded, String status,@JsonKey(name: 'starts_at') DateTime startsAt,@JsonKey(name: 'ends_at') DateTime endsAt,@JsonKey(name: 'published_at') DateTime? publishedAt,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$DonorCampaignModelCopyWithImpl<$Res>
    implements _$DonorCampaignModelCopyWith<$Res> {
  __$DonorCampaignModelCopyWithImpl(this._self, this._then);

  final _DonorCampaignModel _self;
  final $Res Function(_DonorCampaignModel) _then;

/// Create a copy of DonorCampaignModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdBy = freezed,Object? organizerName = null,Object? title = null,Object? description = freezed,Object? venueName = freezed,Object? city = null,Object? wilayaId = null,Object? hospitalId = freezed,Object? bloodTypesNeeded = freezed,Object? status = null,Object? startsAt = null,Object? endsAt = null,Object? publishedAt = freezed,Object? createdAt = null,}) {
  return _then(_DonorCampaignModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,organizerName: null == organizerName ? _self.organizerName : organizerName // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,venueName: freezed == venueName ? _self.venueName : venueName // ignore: cast_nullable_to_non_nullable
as String?,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,wilayaId: null == wilayaId ? _self.wilayaId : wilayaId // ignore: cast_nullable_to_non_nullable
as int,hospitalId: freezed == hospitalId ? _self.hospitalId : hospitalId // ignore: cast_nullable_to_non_nullable
as String?,bloodTypesNeeded: freezed == bloodTypesNeeded ? _self._bloodTypesNeeded : bloodTypesNeeded // ignore: cast_nullable_to_non_nullable
as List<String>?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$DonorAppointmentRequestRefModel {

 String get id;// `blood_requests.hospital_id` is nullable, so PostgREST returns a null
// hospital embed for requests that have no hospital attached.
 DonorHospitalModel? get hospital;@JsonKey(name: 'blood_type') String get bloodType; String get urgency;@JsonKey(name: 'needed_by') DateTime? get neededBy;
/// Create a copy of DonorAppointmentRequestRefModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DonorAppointmentRequestRefModelCopyWith<DonorAppointmentRequestRefModel> get copyWith => _$DonorAppointmentRequestRefModelCopyWithImpl<DonorAppointmentRequestRefModel>(this as DonorAppointmentRequestRefModel, _$identity);

  /// Serializes this DonorAppointmentRequestRefModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DonorAppointmentRequestRefModel&&(identical(other.id, id) || other.id == id)&&(identical(other.hospital, hospital) || other.hospital == hospital)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.urgency, urgency) || other.urgency == urgency)&&(identical(other.neededBy, neededBy) || other.neededBy == neededBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,hospital,bloodType,urgency,neededBy);

@override
String toString() {
  return 'DonorAppointmentRequestRefModel(id: $id, hospital: $hospital, bloodType: $bloodType, urgency: $urgency, neededBy: $neededBy)';
}


}

/// @nodoc
abstract mixin class $DonorAppointmentRequestRefModelCopyWith<$Res>  {
  factory $DonorAppointmentRequestRefModelCopyWith(DonorAppointmentRequestRefModel value, $Res Function(DonorAppointmentRequestRefModel) _then) = _$DonorAppointmentRequestRefModelCopyWithImpl;
@useResult
$Res call({
 String id, DonorHospitalModel? hospital,@JsonKey(name: 'blood_type') String bloodType, String urgency,@JsonKey(name: 'needed_by') DateTime? neededBy
});


$DonorHospitalModelCopyWith<$Res>? get hospital;

}
/// @nodoc
class _$DonorAppointmentRequestRefModelCopyWithImpl<$Res>
    implements $DonorAppointmentRequestRefModelCopyWith<$Res> {
  _$DonorAppointmentRequestRefModelCopyWithImpl(this._self, this._then);

  final DonorAppointmentRequestRefModel _self;
  final $Res Function(DonorAppointmentRequestRefModel) _then;

/// Create a copy of DonorAppointmentRequestRefModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? hospital = freezed,Object? bloodType = null,Object? urgency = null,Object? neededBy = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hospital: freezed == hospital ? _self.hospital : hospital // ignore: cast_nullable_to_non_nullable
as DonorHospitalModel?,bloodType: null == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as String,urgency: null == urgency ? _self.urgency : urgency // ignore: cast_nullable_to_non_nullable
as String,neededBy: freezed == neededBy ? _self.neededBy : neededBy // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of DonorAppointmentRequestRefModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonorHospitalModelCopyWith<$Res>? get hospital {
    if (_self.hospital == null) {
    return null;
  }

  return $DonorHospitalModelCopyWith<$Res>(_self.hospital!, (value) {
    return _then(_self.copyWith(hospital: value));
  });
}
}


/// Adds pattern-matching-related methods to [DonorAppointmentRequestRefModel].
extension DonorAppointmentRequestRefModelPatterns on DonorAppointmentRequestRefModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DonorAppointmentRequestRefModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DonorAppointmentRequestRefModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DonorAppointmentRequestRefModel value)  $default,){
final _that = this;
switch (_that) {
case _DonorAppointmentRequestRefModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DonorAppointmentRequestRefModel value)?  $default,){
final _that = this;
switch (_that) {
case _DonorAppointmentRequestRefModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DonorHospitalModel? hospital, @JsonKey(name: 'blood_type')  String bloodType,  String urgency, @JsonKey(name: 'needed_by')  DateTime? neededBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DonorAppointmentRequestRefModel() when $default != null:
return $default(_that.id,_that.hospital,_that.bloodType,_that.urgency,_that.neededBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DonorHospitalModel? hospital, @JsonKey(name: 'blood_type')  String bloodType,  String urgency, @JsonKey(name: 'needed_by')  DateTime? neededBy)  $default,) {final _that = this;
switch (_that) {
case _DonorAppointmentRequestRefModel():
return $default(_that.id,_that.hospital,_that.bloodType,_that.urgency,_that.neededBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DonorHospitalModel? hospital, @JsonKey(name: 'blood_type')  String bloodType,  String urgency, @JsonKey(name: 'needed_by')  DateTime? neededBy)?  $default,) {final _that = this;
switch (_that) {
case _DonorAppointmentRequestRefModel() when $default != null:
return $default(_that.id,_that.hospital,_that.bloodType,_that.urgency,_that.neededBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DonorAppointmentRequestRefModel extends DonorAppointmentRequestRefModel {
  const _DonorAppointmentRequestRefModel({required this.id, this.hospital, @JsonKey(name: 'blood_type') required this.bloodType, required this.urgency, @JsonKey(name: 'needed_by') this.neededBy}): super._();
  factory _DonorAppointmentRequestRefModel.fromJson(Map<String, dynamic> json) => _$DonorAppointmentRequestRefModelFromJson(json);

@override final  String id;
// `blood_requests.hospital_id` is nullable, so PostgREST returns a null
// hospital embed for requests that have no hospital attached.
@override final  DonorHospitalModel? hospital;
@override@JsonKey(name: 'blood_type') final  String bloodType;
@override final  String urgency;
@override@JsonKey(name: 'needed_by') final  DateTime? neededBy;

/// Create a copy of DonorAppointmentRequestRefModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DonorAppointmentRequestRefModelCopyWith<_DonorAppointmentRequestRefModel> get copyWith => __$DonorAppointmentRequestRefModelCopyWithImpl<_DonorAppointmentRequestRefModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DonorAppointmentRequestRefModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DonorAppointmentRequestRefModel&&(identical(other.id, id) || other.id == id)&&(identical(other.hospital, hospital) || other.hospital == hospital)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.urgency, urgency) || other.urgency == urgency)&&(identical(other.neededBy, neededBy) || other.neededBy == neededBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,hospital,bloodType,urgency,neededBy);

@override
String toString() {
  return 'DonorAppointmentRequestRefModel(id: $id, hospital: $hospital, bloodType: $bloodType, urgency: $urgency, neededBy: $neededBy)';
}


}

/// @nodoc
abstract mixin class _$DonorAppointmentRequestRefModelCopyWith<$Res> implements $DonorAppointmentRequestRefModelCopyWith<$Res> {
  factory _$DonorAppointmentRequestRefModelCopyWith(_DonorAppointmentRequestRefModel value, $Res Function(_DonorAppointmentRequestRefModel) _then) = __$DonorAppointmentRequestRefModelCopyWithImpl;
@override @useResult
$Res call({
 String id, DonorHospitalModel? hospital,@JsonKey(name: 'blood_type') String bloodType, String urgency,@JsonKey(name: 'needed_by') DateTime? neededBy
});


@override $DonorHospitalModelCopyWith<$Res>? get hospital;

}
/// @nodoc
class __$DonorAppointmentRequestRefModelCopyWithImpl<$Res>
    implements _$DonorAppointmentRequestRefModelCopyWith<$Res> {
  __$DonorAppointmentRequestRefModelCopyWithImpl(this._self, this._then);

  final _DonorAppointmentRequestRefModel _self;
  final $Res Function(_DonorAppointmentRequestRefModel) _then;

/// Create a copy of DonorAppointmentRequestRefModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? hospital = freezed,Object? bloodType = null,Object? urgency = null,Object? neededBy = freezed,}) {
  return _then(_DonorAppointmentRequestRefModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hospital: freezed == hospital ? _self.hospital : hospital // ignore: cast_nullable_to_non_nullable
as DonorHospitalModel?,bloodType: null == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as String,urgency: null == urgency ? _self.urgency : urgency // ignore: cast_nullable_to_non_nullable
as String,neededBy: freezed == neededBy ? _self.neededBy : neededBy // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of DonorAppointmentRequestRefModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonorHospitalModelCopyWith<$Res>? get hospital {
    if (_self.hospital == null) {
    return null;
  }

  return $DonorHospitalModelCopyWith<$Res>(_self.hospital!, (value) {
    return _then(_self.copyWith(hospital: value));
  });
}
}


/// @nodoc
mixin _$DonorAppointmentCampaignRefModel {

 String get id; String get title;@JsonKey(name: 'organizer_name') String get organizerName;@JsonKey(name: 'starts_at') DateTime get startsAt;@JsonKey(name: 'ends_at') DateTime get endsAt;
/// Create a copy of DonorAppointmentCampaignRefModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DonorAppointmentCampaignRefModelCopyWith<DonorAppointmentCampaignRefModel> get copyWith => _$DonorAppointmentCampaignRefModelCopyWithImpl<DonorAppointmentCampaignRefModel>(this as DonorAppointmentCampaignRefModel, _$identity);

  /// Serializes this DonorAppointmentCampaignRefModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DonorAppointmentCampaignRefModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.organizerName, organizerName) || other.organizerName == organizerName)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,organizerName,startsAt,endsAt);

@override
String toString() {
  return 'DonorAppointmentCampaignRefModel(id: $id, title: $title, organizerName: $organizerName, startsAt: $startsAt, endsAt: $endsAt)';
}


}

/// @nodoc
abstract mixin class $DonorAppointmentCampaignRefModelCopyWith<$Res>  {
  factory $DonorAppointmentCampaignRefModelCopyWith(DonorAppointmentCampaignRefModel value, $Res Function(DonorAppointmentCampaignRefModel) _then) = _$DonorAppointmentCampaignRefModelCopyWithImpl;
@useResult
$Res call({
 String id, String title,@JsonKey(name: 'organizer_name') String organizerName,@JsonKey(name: 'starts_at') DateTime startsAt,@JsonKey(name: 'ends_at') DateTime endsAt
});




}
/// @nodoc
class _$DonorAppointmentCampaignRefModelCopyWithImpl<$Res>
    implements $DonorAppointmentCampaignRefModelCopyWith<$Res> {
  _$DonorAppointmentCampaignRefModelCopyWithImpl(this._self, this._then);

  final DonorAppointmentCampaignRefModel _self;
  final $Res Function(DonorAppointmentCampaignRefModel) _then;

/// Create a copy of DonorAppointmentCampaignRefModel
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


/// Adds pattern-matching-related methods to [DonorAppointmentCampaignRefModel].
extension DonorAppointmentCampaignRefModelPatterns on DonorAppointmentCampaignRefModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DonorAppointmentCampaignRefModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DonorAppointmentCampaignRefModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DonorAppointmentCampaignRefModel value)  $default,){
final _that = this;
switch (_that) {
case _DonorAppointmentCampaignRefModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DonorAppointmentCampaignRefModel value)?  $default,){
final _that = this;
switch (_that) {
case _DonorAppointmentCampaignRefModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title, @JsonKey(name: 'organizer_name')  String organizerName, @JsonKey(name: 'starts_at')  DateTime startsAt, @JsonKey(name: 'ends_at')  DateTime endsAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DonorAppointmentCampaignRefModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title, @JsonKey(name: 'organizer_name')  String organizerName, @JsonKey(name: 'starts_at')  DateTime startsAt, @JsonKey(name: 'ends_at')  DateTime endsAt)  $default,) {final _that = this;
switch (_that) {
case _DonorAppointmentCampaignRefModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title, @JsonKey(name: 'organizer_name')  String organizerName, @JsonKey(name: 'starts_at')  DateTime startsAt, @JsonKey(name: 'ends_at')  DateTime endsAt)?  $default,) {final _that = this;
switch (_that) {
case _DonorAppointmentCampaignRefModel() when $default != null:
return $default(_that.id,_that.title,_that.organizerName,_that.startsAt,_that.endsAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DonorAppointmentCampaignRefModel extends DonorAppointmentCampaignRefModel {
  const _DonorAppointmentCampaignRefModel({required this.id, required this.title, @JsonKey(name: 'organizer_name') required this.organizerName, @JsonKey(name: 'starts_at') required this.startsAt, @JsonKey(name: 'ends_at') required this.endsAt}): super._();
  factory _DonorAppointmentCampaignRefModel.fromJson(Map<String, dynamic> json) => _$DonorAppointmentCampaignRefModelFromJson(json);

@override final  String id;
@override final  String title;
@override@JsonKey(name: 'organizer_name') final  String organizerName;
@override@JsonKey(name: 'starts_at') final  DateTime startsAt;
@override@JsonKey(name: 'ends_at') final  DateTime endsAt;

/// Create a copy of DonorAppointmentCampaignRefModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DonorAppointmentCampaignRefModelCopyWith<_DonorAppointmentCampaignRefModel> get copyWith => __$DonorAppointmentCampaignRefModelCopyWithImpl<_DonorAppointmentCampaignRefModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DonorAppointmentCampaignRefModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DonorAppointmentCampaignRefModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.organizerName, organizerName) || other.organizerName == organizerName)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,organizerName,startsAt,endsAt);

@override
String toString() {
  return 'DonorAppointmentCampaignRefModel(id: $id, title: $title, organizerName: $organizerName, startsAt: $startsAt, endsAt: $endsAt)';
}


}

/// @nodoc
abstract mixin class _$DonorAppointmentCampaignRefModelCopyWith<$Res> implements $DonorAppointmentCampaignRefModelCopyWith<$Res> {
  factory _$DonorAppointmentCampaignRefModelCopyWith(_DonorAppointmentCampaignRefModel value, $Res Function(_DonorAppointmentCampaignRefModel) _then) = __$DonorAppointmentCampaignRefModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title,@JsonKey(name: 'organizer_name') String organizerName,@JsonKey(name: 'starts_at') DateTime startsAt,@JsonKey(name: 'ends_at') DateTime endsAt
});




}
/// @nodoc
class __$DonorAppointmentCampaignRefModelCopyWithImpl<$Res>
    implements _$DonorAppointmentCampaignRefModelCopyWith<$Res> {
  __$DonorAppointmentCampaignRefModelCopyWithImpl(this._self, this._then);

  final _DonorAppointmentCampaignRefModel _self;
  final $Res Function(_DonorAppointmentCampaignRefModel) _then;

/// Create a copy of DonorAppointmentCampaignRefModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? organizerName = null,Object? startsAt = null,Object? endsAt = null,}) {
  return _then(_DonorAppointmentCampaignRefModel(
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
mixin _$DonorAppointmentModel {

 String get id;@JsonKey(name: 'donor_id') String get donorId;@JsonKey(name: 'scheduled_at') DateTime get scheduledAt; String get status;@JsonKey(name: 'completed_at') DateTime? get completedAt;@JsonKey(name: 'cancelled_at') DateTime? get cancelledAt;@JsonKey(name: 'cancel_reason') String? get cancelReason;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'blood_request') DonorAppointmentRequestRefModel? get bloodRequest; DonorAppointmentCampaignRefModel? get campaign;
/// Create a copy of DonorAppointmentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DonorAppointmentModelCopyWith<DonorAppointmentModel> get copyWith => _$DonorAppointmentModelCopyWithImpl<DonorAppointmentModel>(this as DonorAppointmentModel, _$identity);

  /// Serializes this DonorAppointmentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DonorAppointmentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.donorId, donorId) || other.donorId == donorId)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.cancelReason, cancelReason) || other.cancelReason == cancelReason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.bloodRequest, bloodRequest) || other.bloodRequest == bloodRequest)&&(identical(other.campaign, campaign) || other.campaign == campaign));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,donorId,scheduledAt,status,completedAt,cancelledAt,cancelReason,createdAt,bloodRequest,campaign);

@override
String toString() {
  return 'DonorAppointmentModel(id: $id, donorId: $donorId, scheduledAt: $scheduledAt, status: $status, completedAt: $completedAt, cancelledAt: $cancelledAt, cancelReason: $cancelReason, createdAt: $createdAt, bloodRequest: $bloodRequest, campaign: $campaign)';
}


}

/// @nodoc
abstract mixin class $DonorAppointmentModelCopyWith<$Res>  {
  factory $DonorAppointmentModelCopyWith(DonorAppointmentModel value, $Res Function(DonorAppointmentModel) _then) = _$DonorAppointmentModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'donor_id') String donorId,@JsonKey(name: 'scheduled_at') DateTime scheduledAt, String status,@JsonKey(name: 'completed_at') DateTime? completedAt,@JsonKey(name: 'cancelled_at') DateTime? cancelledAt,@JsonKey(name: 'cancel_reason') String? cancelReason,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'blood_request') DonorAppointmentRequestRefModel? bloodRequest, DonorAppointmentCampaignRefModel? campaign
});


$DonorAppointmentRequestRefModelCopyWith<$Res>? get bloodRequest;$DonorAppointmentCampaignRefModelCopyWith<$Res>? get campaign;

}
/// @nodoc
class _$DonorAppointmentModelCopyWithImpl<$Res>
    implements $DonorAppointmentModelCopyWith<$Res> {
  _$DonorAppointmentModelCopyWithImpl(this._self, this._then);

  final DonorAppointmentModel _self;
  final $Res Function(DonorAppointmentModel) _then;

/// Create a copy of DonorAppointmentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? donorId = null,Object? scheduledAt = null,Object? status = null,Object? completedAt = freezed,Object? cancelledAt = freezed,Object? cancelReason = freezed,Object? createdAt = null,Object? bloodRequest = freezed,Object? campaign = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,donorId: null == donorId ? _self.donorId : donorId // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelReason: freezed == cancelReason ? _self.cancelReason : cancelReason // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,bloodRequest: freezed == bloodRequest ? _self.bloodRequest : bloodRequest // ignore: cast_nullable_to_non_nullable
as DonorAppointmentRequestRefModel?,campaign: freezed == campaign ? _self.campaign : campaign // ignore: cast_nullable_to_non_nullable
as DonorAppointmentCampaignRefModel?,
  ));
}
/// Create a copy of DonorAppointmentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonorAppointmentRequestRefModelCopyWith<$Res>? get bloodRequest {
    if (_self.bloodRequest == null) {
    return null;
  }

  return $DonorAppointmentRequestRefModelCopyWith<$Res>(_self.bloodRequest!, (value) {
    return _then(_self.copyWith(bloodRequest: value));
  });
}/// Create a copy of DonorAppointmentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonorAppointmentCampaignRefModelCopyWith<$Res>? get campaign {
    if (_self.campaign == null) {
    return null;
  }

  return $DonorAppointmentCampaignRefModelCopyWith<$Res>(_self.campaign!, (value) {
    return _then(_self.copyWith(campaign: value));
  });
}
}


/// Adds pattern-matching-related methods to [DonorAppointmentModel].
extension DonorAppointmentModelPatterns on DonorAppointmentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DonorAppointmentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DonorAppointmentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DonorAppointmentModel value)  $default,){
final _that = this;
switch (_that) {
case _DonorAppointmentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DonorAppointmentModel value)?  $default,){
final _that = this;
switch (_that) {
case _DonorAppointmentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'donor_id')  String donorId, @JsonKey(name: 'scheduled_at')  DateTime scheduledAt,  String status, @JsonKey(name: 'completed_at')  DateTime? completedAt, @JsonKey(name: 'cancelled_at')  DateTime? cancelledAt, @JsonKey(name: 'cancel_reason')  String? cancelReason, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'blood_request')  DonorAppointmentRequestRefModel? bloodRequest,  DonorAppointmentCampaignRefModel? campaign)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DonorAppointmentModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'donor_id')  String donorId, @JsonKey(name: 'scheduled_at')  DateTime scheduledAt,  String status, @JsonKey(name: 'completed_at')  DateTime? completedAt, @JsonKey(name: 'cancelled_at')  DateTime? cancelledAt, @JsonKey(name: 'cancel_reason')  String? cancelReason, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'blood_request')  DonorAppointmentRequestRefModel? bloodRequest,  DonorAppointmentCampaignRefModel? campaign)  $default,) {final _that = this;
switch (_that) {
case _DonorAppointmentModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'donor_id')  String donorId, @JsonKey(name: 'scheduled_at')  DateTime scheduledAt,  String status, @JsonKey(name: 'completed_at')  DateTime? completedAt, @JsonKey(name: 'cancelled_at')  DateTime? cancelledAt, @JsonKey(name: 'cancel_reason')  String? cancelReason, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'blood_request')  DonorAppointmentRequestRefModel? bloodRequest,  DonorAppointmentCampaignRefModel? campaign)?  $default,) {final _that = this;
switch (_that) {
case _DonorAppointmentModel() when $default != null:
return $default(_that.id,_that.donorId,_that.scheduledAt,_that.status,_that.completedAt,_that.cancelledAt,_that.cancelReason,_that.createdAt,_that.bloodRequest,_that.campaign);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DonorAppointmentModel extends DonorAppointmentModel {
  const _DonorAppointmentModel({required this.id, @JsonKey(name: 'donor_id') required this.donorId, @JsonKey(name: 'scheduled_at') required this.scheduledAt, required this.status, @JsonKey(name: 'completed_at') this.completedAt, @JsonKey(name: 'cancelled_at') this.cancelledAt, @JsonKey(name: 'cancel_reason') this.cancelReason, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'blood_request') this.bloodRequest, this.campaign}): super._();
  factory _DonorAppointmentModel.fromJson(Map<String, dynamic> json) => _$DonorAppointmentModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'donor_id') final  String donorId;
@override@JsonKey(name: 'scheduled_at') final  DateTime scheduledAt;
@override final  String status;
@override@JsonKey(name: 'completed_at') final  DateTime? completedAt;
@override@JsonKey(name: 'cancelled_at') final  DateTime? cancelledAt;
@override@JsonKey(name: 'cancel_reason') final  String? cancelReason;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'blood_request') final  DonorAppointmentRequestRefModel? bloodRequest;
@override final  DonorAppointmentCampaignRefModel? campaign;

/// Create a copy of DonorAppointmentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DonorAppointmentModelCopyWith<_DonorAppointmentModel> get copyWith => __$DonorAppointmentModelCopyWithImpl<_DonorAppointmentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DonorAppointmentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DonorAppointmentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.donorId, donorId) || other.donorId == donorId)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.cancelReason, cancelReason) || other.cancelReason == cancelReason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.bloodRequest, bloodRequest) || other.bloodRequest == bloodRequest)&&(identical(other.campaign, campaign) || other.campaign == campaign));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,donorId,scheduledAt,status,completedAt,cancelledAt,cancelReason,createdAt,bloodRequest,campaign);

@override
String toString() {
  return 'DonorAppointmentModel(id: $id, donorId: $donorId, scheduledAt: $scheduledAt, status: $status, completedAt: $completedAt, cancelledAt: $cancelledAt, cancelReason: $cancelReason, createdAt: $createdAt, bloodRequest: $bloodRequest, campaign: $campaign)';
}


}

/// @nodoc
abstract mixin class _$DonorAppointmentModelCopyWith<$Res> implements $DonorAppointmentModelCopyWith<$Res> {
  factory _$DonorAppointmentModelCopyWith(_DonorAppointmentModel value, $Res Function(_DonorAppointmentModel) _then) = __$DonorAppointmentModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'donor_id') String donorId,@JsonKey(name: 'scheduled_at') DateTime scheduledAt, String status,@JsonKey(name: 'completed_at') DateTime? completedAt,@JsonKey(name: 'cancelled_at') DateTime? cancelledAt,@JsonKey(name: 'cancel_reason') String? cancelReason,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'blood_request') DonorAppointmentRequestRefModel? bloodRequest, DonorAppointmentCampaignRefModel? campaign
});


@override $DonorAppointmentRequestRefModelCopyWith<$Res>? get bloodRequest;@override $DonorAppointmentCampaignRefModelCopyWith<$Res>? get campaign;

}
/// @nodoc
class __$DonorAppointmentModelCopyWithImpl<$Res>
    implements _$DonorAppointmentModelCopyWith<$Res> {
  __$DonorAppointmentModelCopyWithImpl(this._self, this._then);

  final _DonorAppointmentModel _self;
  final $Res Function(_DonorAppointmentModel) _then;

/// Create a copy of DonorAppointmentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? donorId = null,Object? scheduledAt = null,Object? status = null,Object? completedAt = freezed,Object? cancelledAt = freezed,Object? cancelReason = freezed,Object? createdAt = null,Object? bloodRequest = freezed,Object? campaign = freezed,}) {
  return _then(_DonorAppointmentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,donorId: null == donorId ? _self.donorId : donorId // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelReason: freezed == cancelReason ? _self.cancelReason : cancelReason // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,bloodRequest: freezed == bloodRequest ? _self.bloodRequest : bloodRequest // ignore: cast_nullable_to_non_nullable
as DonorAppointmentRequestRefModel?,campaign: freezed == campaign ? _self.campaign : campaign // ignore: cast_nullable_to_non_nullable
as DonorAppointmentCampaignRefModel?,
  ));
}

/// Create a copy of DonorAppointmentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonorAppointmentRequestRefModelCopyWith<$Res>? get bloodRequest {
    if (_self.bloodRequest == null) {
    return null;
  }

  return $DonorAppointmentRequestRefModelCopyWith<$Res>(_self.bloodRequest!, (value) {
    return _then(_self.copyWith(bloodRequest: value));
  });
}/// Create a copy of DonorAppointmentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonorAppointmentCampaignRefModelCopyWith<$Res>? get campaign {
    if (_self.campaign == null) {
    return null;
  }

  return $DonorAppointmentCampaignRefModelCopyWith<$Res>(_self.campaign!, (value) {
    return _then(_self.copyWith(campaign: value));
  });
}
}


/// @nodoc
mixin _$DonationRecordRecipientModel {

@JsonKey(name: 'full_name') String get fullName;
/// Create a copy of DonationRecordRecipientModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DonationRecordRecipientModelCopyWith<DonationRecordRecipientModel> get copyWith => _$DonationRecordRecipientModelCopyWithImpl<DonationRecordRecipientModel>(this as DonationRecordRecipientModel, _$identity);

  /// Serializes this DonationRecordRecipientModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DonationRecordRecipientModel&&(identical(other.fullName, fullName) || other.fullName == fullName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fullName);

@override
String toString() {
  return 'DonationRecordRecipientModel(fullName: $fullName)';
}


}

/// @nodoc
abstract mixin class $DonationRecordRecipientModelCopyWith<$Res>  {
  factory $DonationRecordRecipientModelCopyWith(DonationRecordRecipientModel value, $Res Function(DonationRecordRecipientModel) _then) = _$DonationRecordRecipientModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'full_name') String fullName
});




}
/// @nodoc
class _$DonationRecordRecipientModelCopyWithImpl<$Res>
    implements $DonationRecordRecipientModelCopyWith<$Res> {
  _$DonationRecordRecipientModelCopyWithImpl(this._self, this._then);

  final DonationRecordRecipientModel _self;
  final $Res Function(DonationRecordRecipientModel) _then;

/// Create a copy of DonationRecordRecipientModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fullName = null,}) {
  return _then(_self.copyWith(
fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DonationRecordRecipientModel].
extension DonationRecordRecipientModelPatterns on DonationRecordRecipientModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DonationRecordRecipientModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DonationRecordRecipientModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DonationRecordRecipientModel value)  $default,){
final _that = this;
switch (_that) {
case _DonationRecordRecipientModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DonationRecordRecipientModel value)?  $default,){
final _that = this;
switch (_that) {
case _DonationRecordRecipientModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'full_name')  String fullName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DonationRecordRecipientModel() when $default != null:
return $default(_that.fullName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'full_name')  String fullName)  $default,) {final _that = this;
switch (_that) {
case _DonationRecordRecipientModel():
return $default(_that.fullName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'full_name')  String fullName)?  $default,) {final _that = this;
switch (_that) {
case _DonationRecordRecipientModel() when $default != null:
return $default(_that.fullName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DonationRecordRecipientModel implements DonationRecordRecipientModel {
  const _DonationRecordRecipientModel({@JsonKey(name: 'full_name') required this.fullName});
  factory _DonationRecordRecipientModel.fromJson(Map<String, dynamic> json) => _$DonationRecordRecipientModelFromJson(json);

@override@JsonKey(name: 'full_name') final  String fullName;

/// Create a copy of DonationRecordRecipientModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DonationRecordRecipientModelCopyWith<_DonationRecordRecipientModel> get copyWith => __$DonationRecordRecipientModelCopyWithImpl<_DonationRecordRecipientModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DonationRecordRecipientModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DonationRecordRecipientModel&&(identical(other.fullName, fullName) || other.fullName == fullName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fullName);

@override
String toString() {
  return 'DonationRecordRecipientModel(fullName: $fullName)';
}


}

/// @nodoc
abstract mixin class _$DonationRecordRecipientModelCopyWith<$Res> implements $DonationRecordRecipientModelCopyWith<$Res> {
  factory _$DonationRecordRecipientModelCopyWith(_DonationRecordRecipientModel value, $Res Function(_DonationRecordRecipientModel) _then) = __$DonationRecordRecipientModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'full_name') String fullName
});




}
/// @nodoc
class __$DonationRecordRecipientModelCopyWithImpl<$Res>
    implements _$DonationRecordRecipientModelCopyWith<$Res> {
  __$DonationRecordRecipientModelCopyWithImpl(this._self, this._then);

  final _DonationRecordRecipientModel _self;
  final $Res Function(_DonationRecordRecipientModel) _then;

/// Create a copy of DonationRecordRecipientModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fullName = null,}) {
  return _then(_DonationRecordRecipientModel(
fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$DonationRecordRequestRefModel {

 String get id;// RLS limits donors to their own `users` row, so PostgREST returns a null
// recipient embed for someone else's request. Keep it optional.
 DonationRecordRecipientModel? get recipient;// `blood_requests.hospital_id` is nullable — same null-embed exposure as
// the appointment request ref above.
 DonorHospitalModel? get hospital;
/// Create a copy of DonationRecordRequestRefModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DonationRecordRequestRefModelCopyWith<DonationRecordRequestRefModel> get copyWith => _$DonationRecordRequestRefModelCopyWithImpl<DonationRecordRequestRefModel>(this as DonationRecordRequestRefModel, _$identity);

  /// Serializes this DonationRecordRequestRefModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DonationRecordRequestRefModel&&(identical(other.id, id) || other.id == id)&&(identical(other.recipient, recipient) || other.recipient == recipient)&&(identical(other.hospital, hospital) || other.hospital == hospital));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,recipient,hospital);

@override
String toString() {
  return 'DonationRecordRequestRefModel(id: $id, recipient: $recipient, hospital: $hospital)';
}


}

/// @nodoc
abstract mixin class $DonationRecordRequestRefModelCopyWith<$Res>  {
  factory $DonationRecordRequestRefModelCopyWith(DonationRecordRequestRefModel value, $Res Function(DonationRecordRequestRefModel) _then) = _$DonationRecordRequestRefModelCopyWithImpl;
@useResult
$Res call({
 String id, DonationRecordRecipientModel? recipient, DonorHospitalModel? hospital
});


$DonationRecordRecipientModelCopyWith<$Res>? get recipient;$DonorHospitalModelCopyWith<$Res>? get hospital;

}
/// @nodoc
class _$DonationRecordRequestRefModelCopyWithImpl<$Res>
    implements $DonationRecordRequestRefModelCopyWith<$Res> {
  _$DonationRecordRequestRefModelCopyWithImpl(this._self, this._then);

  final DonationRecordRequestRefModel _self;
  final $Res Function(DonationRecordRequestRefModel) _then;

/// Create a copy of DonationRecordRequestRefModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? recipient = freezed,Object? hospital = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,recipient: freezed == recipient ? _self.recipient : recipient // ignore: cast_nullable_to_non_nullable
as DonationRecordRecipientModel?,hospital: freezed == hospital ? _self.hospital : hospital // ignore: cast_nullable_to_non_nullable
as DonorHospitalModel?,
  ));
}
/// Create a copy of DonationRecordRequestRefModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonationRecordRecipientModelCopyWith<$Res>? get recipient {
    if (_self.recipient == null) {
    return null;
  }

  return $DonationRecordRecipientModelCopyWith<$Res>(_self.recipient!, (value) {
    return _then(_self.copyWith(recipient: value));
  });
}/// Create a copy of DonationRecordRequestRefModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonorHospitalModelCopyWith<$Res>? get hospital {
    if (_self.hospital == null) {
    return null;
  }

  return $DonorHospitalModelCopyWith<$Res>(_self.hospital!, (value) {
    return _then(_self.copyWith(hospital: value));
  });
}
}


/// Adds pattern-matching-related methods to [DonationRecordRequestRefModel].
extension DonationRecordRequestRefModelPatterns on DonationRecordRequestRefModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DonationRecordRequestRefModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DonationRecordRequestRefModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DonationRecordRequestRefModel value)  $default,){
final _that = this;
switch (_that) {
case _DonationRecordRequestRefModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DonationRecordRequestRefModel value)?  $default,){
final _that = this;
switch (_that) {
case _DonationRecordRequestRefModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DonationRecordRecipientModel? recipient,  DonorHospitalModel? hospital)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DonationRecordRequestRefModel() when $default != null:
return $default(_that.id,_that.recipient,_that.hospital);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DonationRecordRecipientModel? recipient,  DonorHospitalModel? hospital)  $default,) {final _that = this;
switch (_that) {
case _DonationRecordRequestRefModel():
return $default(_that.id,_that.recipient,_that.hospital);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DonationRecordRecipientModel? recipient,  DonorHospitalModel? hospital)?  $default,) {final _that = this;
switch (_that) {
case _DonationRecordRequestRefModel() when $default != null:
return $default(_that.id,_that.recipient,_that.hospital);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DonationRecordRequestRefModel extends DonationRecordRequestRefModel {
  const _DonationRecordRequestRefModel({required this.id, this.recipient, this.hospital}): super._();
  factory _DonationRecordRequestRefModel.fromJson(Map<String, dynamic> json) => _$DonationRecordRequestRefModelFromJson(json);

@override final  String id;
// RLS limits donors to their own `users` row, so PostgREST returns a null
// recipient embed for someone else's request. Keep it optional.
@override final  DonationRecordRecipientModel? recipient;
// `blood_requests.hospital_id` is nullable — same null-embed exposure as
// the appointment request ref above.
@override final  DonorHospitalModel? hospital;

/// Create a copy of DonationRecordRequestRefModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DonationRecordRequestRefModelCopyWith<_DonationRecordRequestRefModel> get copyWith => __$DonationRecordRequestRefModelCopyWithImpl<_DonationRecordRequestRefModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DonationRecordRequestRefModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DonationRecordRequestRefModel&&(identical(other.id, id) || other.id == id)&&(identical(other.recipient, recipient) || other.recipient == recipient)&&(identical(other.hospital, hospital) || other.hospital == hospital));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,recipient,hospital);

@override
String toString() {
  return 'DonationRecordRequestRefModel(id: $id, recipient: $recipient, hospital: $hospital)';
}


}

/// @nodoc
abstract mixin class _$DonationRecordRequestRefModelCopyWith<$Res> implements $DonationRecordRequestRefModelCopyWith<$Res> {
  factory _$DonationRecordRequestRefModelCopyWith(_DonationRecordRequestRefModel value, $Res Function(_DonationRecordRequestRefModel) _then) = __$DonationRecordRequestRefModelCopyWithImpl;
@override @useResult
$Res call({
 String id, DonationRecordRecipientModel? recipient, DonorHospitalModel? hospital
});


@override $DonationRecordRecipientModelCopyWith<$Res>? get recipient;@override $DonorHospitalModelCopyWith<$Res>? get hospital;

}
/// @nodoc
class __$DonationRecordRequestRefModelCopyWithImpl<$Res>
    implements _$DonationRecordRequestRefModelCopyWith<$Res> {
  __$DonationRecordRequestRefModelCopyWithImpl(this._self, this._then);

  final _DonationRecordRequestRefModel _self;
  final $Res Function(_DonationRecordRequestRefModel) _then;

/// Create a copy of DonationRecordRequestRefModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? recipient = freezed,Object? hospital = freezed,}) {
  return _then(_DonationRecordRequestRefModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,recipient: freezed == recipient ? _self.recipient : recipient // ignore: cast_nullable_to_non_nullable
as DonationRecordRecipientModel?,hospital: freezed == hospital ? _self.hospital : hospital // ignore: cast_nullable_to_non_nullable
as DonorHospitalModel?,
  ));
}

/// Create a copy of DonationRecordRequestRefModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonationRecordRecipientModelCopyWith<$Res>? get recipient {
    if (_self.recipient == null) {
    return null;
  }

  return $DonationRecordRecipientModelCopyWith<$Res>(_self.recipient!, (value) {
    return _then(_self.copyWith(recipient: value));
  });
}/// Create a copy of DonationRecordRequestRefModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonorHospitalModelCopyWith<$Res>? get hospital {
    if (_self.hospital == null) {
    return null;
  }

  return $DonorHospitalModelCopyWith<$Res>(_self.hospital!, (value) {
    return _then(_self.copyWith(hospital: value));
  });
}
}


/// @nodoc
mixin _$DonationRecordCampaignRefModel {

 String get id; String get title;// `campaigns.venue_name` is nullable in the schema.
@JsonKey(name: 'venue_name') String? get venueName; String get city;
/// Create a copy of DonationRecordCampaignRefModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DonationRecordCampaignRefModelCopyWith<DonationRecordCampaignRefModel> get copyWith => _$DonationRecordCampaignRefModelCopyWithImpl<DonationRecordCampaignRefModel>(this as DonationRecordCampaignRefModel, _$identity);

  /// Serializes this DonationRecordCampaignRefModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DonationRecordCampaignRefModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.venueName, venueName) || other.venueName == venueName)&&(identical(other.city, city) || other.city == city));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,venueName,city);

@override
String toString() {
  return 'DonationRecordCampaignRefModel(id: $id, title: $title, venueName: $venueName, city: $city)';
}


}

/// @nodoc
abstract mixin class $DonationRecordCampaignRefModelCopyWith<$Res>  {
  factory $DonationRecordCampaignRefModelCopyWith(DonationRecordCampaignRefModel value, $Res Function(DonationRecordCampaignRefModel) _then) = _$DonationRecordCampaignRefModelCopyWithImpl;
@useResult
$Res call({
 String id, String title,@JsonKey(name: 'venue_name') String? venueName, String city
});




}
/// @nodoc
class _$DonationRecordCampaignRefModelCopyWithImpl<$Res>
    implements $DonationRecordCampaignRefModelCopyWith<$Res> {
  _$DonationRecordCampaignRefModelCopyWithImpl(this._self, this._then);

  final DonationRecordCampaignRefModel _self;
  final $Res Function(DonationRecordCampaignRefModel) _then;

/// Create a copy of DonationRecordCampaignRefModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? venueName = freezed,Object? city = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,venueName: freezed == venueName ? _self.venueName : venueName // ignore: cast_nullable_to_non_nullable
as String?,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DonationRecordCampaignRefModel].
extension DonationRecordCampaignRefModelPatterns on DonationRecordCampaignRefModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DonationRecordCampaignRefModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DonationRecordCampaignRefModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DonationRecordCampaignRefModel value)  $default,){
final _that = this;
switch (_that) {
case _DonationRecordCampaignRefModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DonationRecordCampaignRefModel value)?  $default,){
final _that = this;
switch (_that) {
case _DonationRecordCampaignRefModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title, @JsonKey(name: 'venue_name')  String? venueName,  String city)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DonationRecordCampaignRefModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title, @JsonKey(name: 'venue_name')  String? venueName,  String city)  $default,) {final _that = this;
switch (_that) {
case _DonationRecordCampaignRefModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title, @JsonKey(name: 'venue_name')  String? venueName,  String city)?  $default,) {final _that = this;
switch (_that) {
case _DonationRecordCampaignRefModel() when $default != null:
return $default(_that.id,_that.title,_that.venueName,_that.city);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DonationRecordCampaignRefModel extends DonationRecordCampaignRefModel {
  const _DonationRecordCampaignRefModel({required this.id, required this.title, @JsonKey(name: 'venue_name') this.venueName, required this.city}): super._();
  factory _DonationRecordCampaignRefModel.fromJson(Map<String, dynamic> json) => _$DonationRecordCampaignRefModelFromJson(json);

@override final  String id;
@override final  String title;
// `campaigns.venue_name` is nullable in the schema.
@override@JsonKey(name: 'venue_name') final  String? venueName;
@override final  String city;

/// Create a copy of DonationRecordCampaignRefModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DonationRecordCampaignRefModelCopyWith<_DonationRecordCampaignRefModel> get copyWith => __$DonationRecordCampaignRefModelCopyWithImpl<_DonationRecordCampaignRefModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DonationRecordCampaignRefModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DonationRecordCampaignRefModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.venueName, venueName) || other.venueName == venueName)&&(identical(other.city, city) || other.city == city));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,venueName,city);

@override
String toString() {
  return 'DonationRecordCampaignRefModel(id: $id, title: $title, venueName: $venueName, city: $city)';
}


}

/// @nodoc
abstract mixin class _$DonationRecordCampaignRefModelCopyWith<$Res> implements $DonationRecordCampaignRefModelCopyWith<$Res> {
  factory _$DonationRecordCampaignRefModelCopyWith(_DonationRecordCampaignRefModel value, $Res Function(_DonationRecordCampaignRefModel) _then) = __$DonationRecordCampaignRefModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title,@JsonKey(name: 'venue_name') String? venueName, String city
});




}
/// @nodoc
class __$DonationRecordCampaignRefModelCopyWithImpl<$Res>
    implements _$DonationRecordCampaignRefModelCopyWith<$Res> {
  __$DonationRecordCampaignRefModelCopyWithImpl(this._self, this._then);

  final _DonationRecordCampaignRefModel _self;
  final $Res Function(_DonationRecordCampaignRefModel) _then;

/// Create a copy of DonationRecordCampaignRefModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? venueName = freezed,Object? city = null,}) {
  return _then(_DonationRecordCampaignRefModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,venueName: freezed == venueName ? _self.venueName : venueName // ignore: cast_nullable_to_non_nullable
as String?,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$DonationRecordModel {

 String get id;@JsonKey(name: 'donor_id') String get donorId; String get source;@JsonKey(name: 'request_id') String? get requestId;@JsonKey(name: 'campaign_id') String? get campaignId;@JsonKey(name: 'appointment_id') String? get appointmentId;@JsonKey(name: 'hospital_id') String? get hospitalId;@JsonKey(name: 'donated_at') DateTime get donatedAt; int get units;@JsonKey(name: 'blood_request') DonationRecordRequestRefModel? get bloodRequest; DonationRecordCampaignRefModel? get campaign;
/// Create a copy of DonationRecordModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DonationRecordModelCopyWith<DonationRecordModel> get copyWith => _$DonationRecordModelCopyWithImpl<DonationRecordModel>(this as DonationRecordModel, _$identity);

  /// Serializes this DonationRecordModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DonationRecordModel&&(identical(other.id, id) || other.id == id)&&(identical(other.donorId, donorId) || other.donorId == donorId)&&(identical(other.source, source) || other.source == source)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.campaignId, campaignId) || other.campaignId == campaignId)&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.hospitalId, hospitalId) || other.hospitalId == hospitalId)&&(identical(other.donatedAt, donatedAt) || other.donatedAt == donatedAt)&&(identical(other.units, units) || other.units == units)&&(identical(other.bloodRequest, bloodRequest) || other.bloodRequest == bloodRequest)&&(identical(other.campaign, campaign) || other.campaign == campaign));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,donorId,source,requestId,campaignId,appointmentId,hospitalId,donatedAt,units,bloodRequest,campaign);

@override
String toString() {
  return 'DonationRecordModel(id: $id, donorId: $donorId, source: $source, requestId: $requestId, campaignId: $campaignId, appointmentId: $appointmentId, hospitalId: $hospitalId, donatedAt: $donatedAt, units: $units, bloodRequest: $bloodRequest, campaign: $campaign)';
}


}

/// @nodoc
abstract mixin class $DonationRecordModelCopyWith<$Res>  {
  factory $DonationRecordModelCopyWith(DonationRecordModel value, $Res Function(DonationRecordModel) _then) = _$DonationRecordModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'donor_id') String donorId, String source,@JsonKey(name: 'request_id') String? requestId,@JsonKey(name: 'campaign_id') String? campaignId,@JsonKey(name: 'appointment_id') String? appointmentId,@JsonKey(name: 'hospital_id') String? hospitalId,@JsonKey(name: 'donated_at') DateTime donatedAt, int units,@JsonKey(name: 'blood_request') DonationRecordRequestRefModel? bloodRequest, DonationRecordCampaignRefModel? campaign
});


$DonationRecordRequestRefModelCopyWith<$Res>? get bloodRequest;$DonationRecordCampaignRefModelCopyWith<$Res>? get campaign;

}
/// @nodoc
class _$DonationRecordModelCopyWithImpl<$Res>
    implements $DonationRecordModelCopyWith<$Res> {
  _$DonationRecordModelCopyWithImpl(this._self, this._then);

  final DonationRecordModel _self;
  final $Res Function(DonationRecordModel) _then;

/// Create a copy of DonationRecordModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? donorId = null,Object? source = null,Object? requestId = freezed,Object? campaignId = freezed,Object? appointmentId = freezed,Object? hospitalId = freezed,Object? donatedAt = null,Object? units = null,Object? bloodRequest = freezed,Object? campaign = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,donorId: null == donorId ? _self.donorId : donorId // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,requestId: freezed == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String?,campaignId: freezed == campaignId ? _self.campaignId : campaignId // ignore: cast_nullable_to_non_nullable
as String?,appointmentId: freezed == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String?,hospitalId: freezed == hospitalId ? _self.hospitalId : hospitalId // ignore: cast_nullable_to_non_nullable
as String?,donatedAt: null == donatedAt ? _self.donatedAt : donatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as int,bloodRequest: freezed == bloodRequest ? _self.bloodRequest : bloodRequest // ignore: cast_nullable_to_non_nullable
as DonationRecordRequestRefModel?,campaign: freezed == campaign ? _self.campaign : campaign // ignore: cast_nullable_to_non_nullable
as DonationRecordCampaignRefModel?,
  ));
}
/// Create a copy of DonationRecordModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonationRecordRequestRefModelCopyWith<$Res>? get bloodRequest {
    if (_self.bloodRequest == null) {
    return null;
  }

  return $DonationRecordRequestRefModelCopyWith<$Res>(_self.bloodRequest!, (value) {
    return _then(_self.copyWith(bloodRequest: value));
  });
}/// Create a copy of DonationRecordModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonationRecordCampaignRefModelCopyWith<$Res>? get campaign {
    if (_self.campaign == null) {
    return null;
  }

  return $DonationRecordCampaignRefModelCopyWith<$Res>(_self.campaign!, (value) {
    return _then(_self.copyWith(campaign: value));
  });
}
}


/// Adds pattern-matching-related methods to [DonationRecordModel].
extension DonationRecordModelPatterns on DonationRecordModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DonationRecordModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DonationRecordModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DonationRecordModel value)  $default,){
final _that = this;
switch (_that) {
case _DonationRecordModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DonationRecordModel value)?  $default,){
final _that = this;
switch (_that) {
case _DonationRecordModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'donor_id')  String donorId,  String source, @JsonKey(name: 'request_id')  String? requestId, @JsonKey(name: 'campaign_id')  String? campaignId, @JsonKey(name: 'appointment_id')  String? appointmentId, @JsonKey(name: 'hospital_id')  String? hospitalId, @JsonKey(name: 'donated_at')  DateTime donatedAt,  int units, @JsonKey(name: 'blood_request')  DonationRecordRequestRefModel? bloodRequest,  DonationRecordCampaignRefModel? campaign)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DonationRecordModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'donor_id')  String donorId,  String source, @JsonKey(name: 'request_id')  String? requestId, @JsonKey(name: 'campaign_id')  String? campaignId, @JsonKey(name: 'appointment_id')  String? appointmentId, @JsonKey(name: 'hospital_id')  String? hospitalId, @JsonKey(name: 'donated_at')  DateTime donatedAt,  int units, @JsonKey(name: 'blood_request')  DonationRecordRequestRefModel? bloodRequest,  DonationRecordCampaignRefModel? campaign)  $default,) {final _that = this;
switch (_that) {
case _DonationRecordModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'donor_id')  String donorId,  String source, @JsonKey(name: 'request_id')  String? requestId, @JsonKey(name: 'campaign_id')  String? campaignId, @JsonKey(name: 'appointment_id')  String? appointmentId, @JsonKey(name: 'hospital_id')  String? hospitalId, @JsonKey(name: 'donated_at')  DateTime donatedAt,  int units, @JsonKey(name: 'blood_request')  DonationRecordRequestRefModel? bloodRequest,  DonationRecordCampaignRefModel? campaign)?  $default,) {final _that = this;
switch (_that) {
case _DonationRecordModel() when $default != null:
return $default(_that.id,_that.donorId,_that.source,_that.requestId,_that.campaignId,_that.appointmentId,_that.hospitalId,_that.donatedAt,_that.units,_that.bloodRequest,_that.campaign);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DonationRecordModel extends DonationRecordModel {
  const _DonationRecordModel({required this.id, @JsonKey(name: 'donor_id') required this.donorId, required this.source, @JsonKey(name: 'request_id') this.requestId, @JsonKey(name: 'campaign_id') this.campaignId, @JsonKey(name: 'appointment_id') this.appointmentId, @JsonKey(name: 'hospital_id') this.hospitalId, @JsonKey(name: 'donated_at') required this.donatedAt, required this.units, @JsonKey(name: 'blood_request') this.bloodRequest, this.campaign}): super._();
  factory _DonationRecordModel.fromJson(Map<String, dynamic> json) => _$DonationRecordModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'donor_id') final  String donorId;
@override final  String source;
@override@JsonKey(name: 'request_id') final  String? requestId;
@override@JsonKey(name: 'campaign_id') final  String? campaignId;
@override@JsonKey(name: 'appointment_id') final  String? appointmentId;
@override@JsonKey(name: 'hospital_id') final  String? hospitalId;
@override@JsonKey(name: 'donated_at') final  DateTime donatedAt;
@override final  int units;
@override@JsonKey(name: 'blood_request') final  DonationRecordRequestRefModel? bloodRequest;
@override final  DonationRecordCampaignRefModel? campaign;

/// Create a copy of DonationRecordModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DonationRecordModelCopyWith<_DonationRecordModel> get copyWith => __$DonationRecordModelCopyWithImpl<_DonationRecordModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DonationRecordModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DonationRecordModel&&(identical(other.id, id) || other.id == id)&&(identical(other.donorId, donorId) || other.donorId == donorId)&&(identical(other.source, source) || other.source == source)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.campaignId, campaignId) || other.campaignId == campaignId)&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.hospitalId, hospitalId) || other.hospitalId == hospitalId)&&(identical(other.donatedAt, donatedAt) || other.donatedAt == donatedAt)&&(identical(other.units, units) || other.units == units)&&(identical(other.bloodRequest, bloodRequest) || other.bloodRequest == bloodRequest)&&(identical(other.campaign, campaign) || other.campaign == campaign));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,donorId,source,requestId,campaignId,appointmentId,hospitalId,donatedAt,units,bloodRequest,campaign);

@override
String toString() {
  return 'DonationRecordModel(id: $id, donorId: $donorId, source: $source, requestId: $requestId, campaignId: $campaignId, appointmentId: $appointmentId, hospitalId: $hospitalId, donatedAt: $donatedAt, units: $units, bloodRequest: $bloodRequest, campaign: $campaign)';
}


}

/// @nodoc
abstract mixin class _$DonationRecordModelCopyWith<$Res> implements $DonationRecordModelCopyWith<$Res> {
  factory _$DonationRecordModelCopyWith(_DonationRecordModel value, $Res Function(_DonationRecordModel) _then) = __$DonationRecordModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'donor_id') String donorId, String source,@JsonKey(name: 'request_id') String? requestId,@JsonKey(name: 'campaign_id') String? campaignId,@JsonKey(name: 'appointment_id') String? appointmentId,@JsonKey(name: 'hospital_id') String? hospitalId,@JsonKey(name: 'donated_at') DateTime donatedAt, int units,@JsonKey(name: 'blood_request') DonationRecordRequestRefModel? bloodRequest, DonationRecordCampaignRefModel? campaign
});


@override $DonationRecordRequestRefModelCopyWith<$Res>? get bloodRequest;@override $DonationRecordCampaignRefModelCopyWith<$Res>? get campaign;

}
/// @nodoc
class __$DonationRecordModelCopyWithImpl<$Res>
    implements _$DonationRecordModelCopyWith<$Res> {
  __$DonationRecordModelCopyWithImpl(this._self, this._then);

  final _DonationRecordModel _self;
  final $Res Function(_DonationRecordModel) _then;

/// Create a copy of DonationRecordModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? donorId = null,Object? source = null,Object? requestId = freezed,Object? campaignId = freezed,Object? appointmentId = freezed,Object? hospitalId = freezed,Object? donatedAt = null,Object? units = null,Object? bloodRequest = freezed,Object? campaign = freezed,}) {
  return _then(_DonationRecordModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,donorId: null == donorId ? _self.donorId : donorId // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,requestId: freezed == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String?,campaignId: freezed == campaignId ? _self.campaignId : campaignId // ignore: cast_nullable_to_non_nullable
as String?,appointmentId: freezed == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String?,hospitalId: freezed == hospitalId ? _self.hospitalId : hospitalId // ignore: cast_nullable_to_non_nullable
as String?,donatedAt: null == donatedAt ? _self.donatedAt : donatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as int,bloodRequest: freezed == bloodRequest ? _self.bloodRequest : bloodRequest // ignore: cast_nullable_to_non_nullable
as DonationRecordRequestRefModel?,campaign: freezed == campaign ? _self.campaign : campaign // ignore: cast_nullable_to_non_nullable
as DonationRecordCampaignRefModel?,
  ));
}

/// Create a copy of DonationRecordModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonationRecordRequestRefModelCopyWith<$Res>? get bloodRequest {
    if (_self.bloodRequest == null) {
    return null;
  }

  return $DonationRecordRequestRefModelCopyWith<$Res>(_self.bloodRequest!, (value) {
    return _then(_self.copyWith(bloodRequest: value));
  });
}/// Create a copy of DonationRecordModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonationRecordCampaignRefModelCopyWith<$Res>? get campaign {
    if (_self.campaign == null) {
    return null;
  }

  return $DonationRecordCampaignRefModelCopyWith<$Res>(_self.campaign!, (value) {
    return _then(_self.copyWith(campaign: value));
  });
}
}

// dart format on
