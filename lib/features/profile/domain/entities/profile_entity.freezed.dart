// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileEntity {

 String get id; String get email; String get username; String get fullName; String get phone; String get dateOfBirth; String get gender; String? get nationalId; String get bloodType; double? get weight; String get city; String? get chronicDiseases; String? get avatarUrl; bool get isDonor; bool get isRecipient; bool get isActive;
/// Create a copy of ProfileEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileEntityCopyWith<ProfileEntity> get copyWith => _$ProfileEntityCopyWithImpl<ProfileEntity>(this as ProfileEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.username, username) || other.username == username)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.nationalId, nationalId) || other.nationalId == nationalId)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.city, city) || other.city == city)&&(identical(other.chronicDiseases, chronicDiseases) || other.chronicDiseases == chronicDiseases)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isDonor, isDonor) || other.isDonor == isDonor)&&(identical(other.isRecipient, isRecipient) || other.isRecipient == isRecipient)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,id,email,username,fullName,phone,dateOfBirth,gender,nationalId,bloodType,weight,city,chronicDiseases,avatarUrl,isDonor,isRecipient,isActive);

@override
String toString() {
  return 'ProfileEntity(id: $id, email: $email, username: $username, fullName: $fullName, phone: $phone, dateOfBirth: $dateOfBirth, gender: $gender, nationalId: $nationalId, bloodType: $bloodType, weight: $weight, city: $city, chronicDiseases: $chronicDiseases, avatarUrl: $avatarUrl, isDonor: $isDonor, isRecipient: $isRecipient, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $ProfileEntityCopyWith<$Res>  {
  factory $ProfileEntityCopyWith(ProfileEntity value, $Res Function(ProfileEntity) _then) = _$ProfileEntityCopyWithImpl;
@useResult
$Res call({
 String id, String email, String username, String fullName, String phone, String dateOfBirth, String gender, String? nationalId, String bloodType, double? weight, String city, String? chronicDiseases, String? avatarUrl, bool isDonor, bool isRecipient, bool isActive
});




}
/// @nodoc
class _$ProfileEntityCopyWithImpl<$Res>
    implements $ProfileEntityCopyWith<$Res> {
  _$ProfileEntityCopyWithImpl(this._self, this._then);

  final ProfileEntity _self;
  final $Res Function(ProfileEntity) _then;

/// Create a copy of ProfileEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? username = null,Object? fullName = null,Object? phone = null,Object? dateOfBirth = null,Object? gender = null,Object? nationalId = freezed,Object? bloodType = null,Object? weight = freezed,Object? city = null,Object? chronicDiseases = freezed,Object? avatarUrl = freezed,Object? isDonor = null,Object? isRecipient = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,nationalId: freezed == nationalId ? _self.nationalId : nationalId // ignore: cast_nullable_to_non_nullable
as String?,bloodType: null == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as String,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,chronicDiseases: freezed == chronicDiseases ? _self.chronicDiseases : chronicDiseases // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isDonor: null == isDonor ? _self.isDonor : isDonor // ignore: cast_nullable_to_non_nullable
as bool,isRecipient: null == isRecipient ? _self.isRecipient : isRecipient // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileEntity].
extension ProfileEntityPatterns on ProfileEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileEntity value)  $default,){
final _that = this;
switch (_that) {
case _ProfileEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String username,  String fullName,  String phone,  String dateOfBirth,  String gender,  String? nationalId,  String bloodType,  double? weight,  String city,  String? chronicDiseases,  String? avatarUrl,  bool isDonor,  bool isRecipient,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileEntity() when $default != null:
return $default(_that.id,_that.email,_that.username,_that.fullName,_that.phone,_that.dateOfBirth,_that.gender,_that.nationalId,_that.bloodType,_that.weight,_that.city,_that.chronicDiseases,_that.avatarUrl,_that.isDonor,_that.isRecipient,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String username,  String fullName,  String phone,  String dateOfBirth,  String gender,  String? nationalId,  String bloodType,  double? weight,  String city,  String? chronicDiseases,  String? avatarUrl,  bool isDonor,  bool isRecipient,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _ProfileEntity():
return $default(_that.id,_that.email,_that.username,_that.fullName,_that.phone,_that.dateOfBirth,_that.gender,_that.nationalId,_that.bloodType,_that.weight,_that.city,_that.chronicDiseases,_that.avatarUrl,_that.isDonor,_that.isRecipient,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String username,  String fullName,  String phone,  String dateOfBirth,  String gender,  String? nationalId,  String bloodType,  double? weight,  String city,  String? chronicDiseases,  String? avatarUrl,  bool isDonor,  bool isRecipient,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _ProfileEntity() when $default != null:
return $default(_that.id,_that.email,_that.username,_that.fullName,_that.phone,_that.dateOfBirth,_that.gender,_that.nationalId,_that.bloodType,_that.weight,_that.city,_that.chronicDiseases,_that.avatarUrl,_that.isDonor,_that.isRecipient,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileEntity implements ProfileEntity {
  const _ProfileEntity({required this.id, required this.email, required this.username, required this.fullName, required this.phone, required this.dateOfBirth, required this.gender, this.nationalId, required this.bloodType, this.weight, required this.city, this.chronicDiseases, this.avatarUrl, required this.isDonor, required this.isRecipient, required this.isActive});
  

@override final  String id;
@override final  String email;
@override final  String username;
@override final  String fullName;
@override final  String phone;
@override final  String dateOfBirth;
@override final  String gender;
@override final  String? nationalId;
@override final  String bloodType;
@override final  double? weight;
@override final  String city;
@override final  String? chronicDiseases;
@override final  String? avatarUrl;
@override final  bool isDonor;
@override final  bool isRecipient;
@override final  bool isActive;

/// Create a copy of ProfileEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileEntityCopyWith<_ProfileEntity> get copyWith => __$ProfileEntityCopyWithImpl<_ProfileEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.username, username) || other.username == username)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.nationalId, nationalId) || other.nationalId == nationalId)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.city, city) || other.city == city)&&(identical(other.chronicDiseases, chronicDiseases) || other.chronicDiseases == chronicDiseases)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isDonor, isDonor) || other.isDonor == isDonor)&&(identical(other.isRecipient, isRecipient) || other.isRecipient == isRecipient)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,id,email,username,fullName,phone,dateOfBirth,gender,nationalId,bloodType,weight,city,chronicDiseases,avatarUrl,isDonor,isRecipient,isActive);

@override
String toString() {
  return 'ProfileEntity(id: $id, email: $email, username: $username, fullName: $fullName, phone: $phone, dateOfBirth: $dateOfBirth, gender: $gender, nationalId: $nationalId, bloodType: $bloodType, weight: $weight, city: $city, chronicDiseases: $chronicDiseases, avatarUrl: $avatarUrl, isDonor: $isDonor, isRecipient: $isRecipient, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$ProfileEntityCopyWith<$Res> implements $ProfileEntityCopyWith<$Res> {
  factory _$ProfileEntityCopyWith(_ProfileEntity value, $Res Function(_ProfileEntity) _then) = __$ProfileEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String username, String fullName, String phone, String dateOfBirth, String gender, String? nationalId, String bloodType, double? weight, String city, String? chronicDiseases, String? avatarUrl, bool isDonor, bool isRecipient, bool isActive
});




}
/// @nodoc
class __$ProfileEntityCopyWithImpl<$Res>
    implements _$ProfileEntityCopyWith<$Res> {
  __$ProfileEntityCopyWithImpl(this._self, this._then);

  final _ProfileEntity _self;
  final $Res Function(_ProfileEntity) _then;

/// Create a copy of ProfileEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? username = null,Object? fullName = null,Object? phone = null,Object? dateOfBirth = null,Object? gender = null,Object? nationalId = freezed,Object? bloodType = null,Object? weight = freezed,Object? city = null,Object? chronicDiseases = freezed,Object? avatarUrl = freezed,Object? isDonor = null,Object? isRecipient = null,Object? isActive = null,}) {
  return _then(_ProfileEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,nationalId: freezed == nationalId ? _self.nationalId : nationalId // ignore: cast_nullable_to_non_nullable
as String?,bloodType: null == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as String,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,chronicDiseases: freezed == chronicDiseases ? _self.chronicDiseases : chronicDiseases // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isDonor: null == isDonor ? _self.isDonor : isDonor // ignore: cast_nullable_to_non_nullable
as bool,isRecipient: null == isRecipient ? _self.isRecipient : isRecipient // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
