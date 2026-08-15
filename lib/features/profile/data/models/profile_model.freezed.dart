// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfileModel {

 String get id; String get email; String get username;@JsonKey(name: 'full_name') String get fullName; String get phone;@JsonKey(name: 'date_of_birth') String get dateOfBirth; String get gender;@JsonKey(name: 'national_id') String? get nationalId;@JsonKey(name: 'blood_type') String get bloodType; double? get weight; String get city;@JsonKey(name: 'chronic_diseases') String? get chronicDiseases;@JsonKey(name: 'avatar_url') String? get avatarUrl;@JsonKey(name: 'is_donor') bool get isDonor;@JsonKey(name: 'is_recipient') bool get isRecipient;@JsonKey(name: 'is_active') bool get isActive;
/// Create a copy of ProfileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileModelCopyWith<ProfileModel> get copyWith => _$ProfileModelCopyWithImpl<ProfileModel>(this as ProfileModel, _$identity);

  /// Serializes this ProfileModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileModel&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.username, username) || other.username == username)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.nationalId, nationalId) || other.nationalId == nationalId)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.city, city) || other.city == city)&&(identical(other.chronicDiseases, chronicDiseases) || other.chronicDiseases == chronicDiseases)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isDonor, isDonor) || other.isDonor == isDonor)&&(identical(other.isRecipient, isRecipient) || other.isRecipient == isRecipient)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,username,fullName,phone,dateOfBirth,gender,nationalId,bloodType,weight,city,chronicDiseases,avatarUrl,isDonor,isRecipient,isActive);

@override
String toString() {
  return 'ProfileModel(id: $id, email: $email, username: $username, fullName: $fullName, phone: $phone, dateOfBirth: $dateOfBirth, gender: $gender, nationalId: $nationalId, bloodType: $bloodType, weight: $weight, city: $city, chronicDiseases: $chronicDiseases, avatarUrl: $avatarUrl, isDonor: $isDonor, isRecipient: $isRecipient, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $ProfileModelCopyWith<$Res>  {
  factory $ProfileModelCopyWith(ProfileModel value, $Res Function(ProfileModel) _then) = _$ProfileModelCopyWithImpl;
@useResult
$Res call({
 String id, String email, String username,@JsonKey(name: 'full_name') String fullName, String phone,@JsonKey(name: 'date_of_birth') String dateOfBirth, String gender,@JsonKey(name: 'national_id') String? nationalId,@JsonKey(name: 'blood_type') String bloodType, double? weight, String city,@JsonKey(name: 'chronic_diseases') String? chronicDiseases,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'is_donor') bool isDonor,@JsonKey(name: 'is_recipient') bool isRecipient,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class _$ProfileModelCopyWithImpl<$Res>
    implements $ProfileModelCopyWith<$Res> {
  _$ProfileModelCopyWithImpl(this._self, this._then);

  final ProfileModel _self;
  final $Res Function(ProfileModel) _then;

/// Create a copy of ProfileModel
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


/// Adds pattern-matching-related methods to [ProfileModel].
extension ProfileModelPatterns on ProfileModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileModel value)  $default,){
final _that = this;
switch (_that) {
case _ProfileModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String username, @JsonKey(name: 'full_name')  String fullName,  String phone, @JsonKey(name: 'date_of_birth')  String dateOfBirth,  String gender, @JsonKey(name: 'national_id')  String? nationalId, @JsonKey(name: 'blood_type')  String bloodType,  double? weight,  String city, @JsonKey(name: 'chronic_diseases')  String? chronicDiseases, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'is_donor')  bool isDonor, @JsonKey(name: 'is_recipient')  bool isRecipient, @JsonKey(name: 'is_active')  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String username, @JsonKey(name: 'full_name')  String fullName,  String phone, @JsonKey(name: 'date_of_birth')  String dateOfBirth,  String gender, @JsonKey(name: 'national_id')  String? nationalId, @JsonKey(name: 'blood_type')  String bloodType,  double? weight,  String city, @JsonKey(name: 'chronic_diseases')  String? chronicDiseases, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'is_donor')  bool isDonor, @JsonKey(name: 'is_recipient')  bool isRecipient, @JsonKey(name: 'is_active')  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _ProfileModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String username, @JsonKey(name: 'full_name')  String fullName,  String phone, @JsonKey(name: 'date_of_birth')  String dateOfBirth,  String gender, @JsonKey(name: 'national_id')  String? nationalId, @JsonKey(name: 'blood_type')  String bloodType,  double? weight,  String city, @JsonKey(name: 'chronic_diseases')  String? chronicDiseases, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'is_donor')  bool isDonor, @JsonKey(name: 'is_recipient')  bool isRecipient, @JsonKey(name: 'is_active')  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _ProfileModel() when $default != null:
return $default(_that.id,_that.email,_that.username,_that.fullName,_that.phone,_that.dateOfBirth,_that.gender,_that.nationalId,_that.bloodType,_that.weight,_that.city,_that.chronicDiseases,_that.avatarUrl,_that.isDonor,_that.isRecipient,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileModel implements ProfileModel {
  const _ProfileModel({required this.id, this.email = '', required this.username, @JsonKey(name: 'full_name') required this.fullName, required this.phone, @JsonKey(name: 'date_of_birth') required this.dateOfBirth, required this.gender, @JsonKey(name: 'national_id') this.nationalId, @JsonKey(name: 'blood_type') required this.bloodType, this.weight, required this.city, @JsonKey(name: 'chronic_diseases') this.chronicDiseases, @JsonKey(name: 'avatar_url') this.avatarUrl, @JsonKey(name: 'is_donor') this.isDonor = false, @JsonKey(name: 'is_recipient') this.isRecipient = false, @JsonKey(name: 'is_active') this.isActive = true});
  factory _ProfileModel.fromJson(Map<String, dynamic> json) => _$ProfileModelFromJson(json);

@override final  String id;
@override@JsonKey() final  String email;
@override final  String username;
@override@JsonKey(name: 'full_name') final  String fullName;
@override final  String phone;
@override@JsonKey(name: 'date_of_birth') final  String dateOfBirth;
@override final  String gender;
@override@JsonKey(name: 'national_id') final  String? nationalId;
@override@JsonKey(name: 'blood_type') final  String bloodType;
@override final  double? weight;
@override final  String city;
@override@JsonKey(name: 'chronic_diseases') final  String? chronicDiseases;
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;
@override@JsonKey(name: 'is_donor') final  bool isDonor;
@override@JsonKey(name: 'is_recipient') final  bool isRecipient;
@override@JsonKey(name: 'is_active') final  bool isActive;

/// Create a copy of ProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileModelCopyWith<_ProfileModel> get copyWith => __$ProfileModelCopyWithImpl<_ProfileModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileModel&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.username, username) || other.username == username)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.nationalId, nationalId) || other.nationalId == nationalId)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.city, city) || other.city == city)&&(identical(other.chronicDiseases, chronicDiseases) || other.chronicDiseases == chronicDiseases)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isDonor, isDonor) || other.isDonor == isDonor)&&(identical(other.isRecipient, isRecipient) || other.isRecipient == isRecipient)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,username,fullName,phone,dateOfBirth,gender,nationalId,bloodType,weight,city,chronicDiseases,avatarUrl,isDonor,isRecipient,isActive);

@override
String toString() {
  return 'ProfileModel(id: $id, email: $email, username: $username, fullName: $fullName, phone: $phone, dateOfBirth: $dateOfBirth, gender: $gender, nationalId: $nationalId, bloodType: $bloodType, weight: $weight, city: $city, chronicDiseases: $chronicDiseases, avatarUrl: $avatarUrl, isDonor: $isDonor, isRecipient: $isRecipient, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$ProfileModelCopyWith<$Res> implements $ProfileModelCopyWith<$Res> {
  factory _$ProfileModelCopyWith(_ProfileModel value, $Res Function(_ProfileModel) _then) = __$ProfileModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String username,@JsonKey(name: 'full_name') String fullName, String phone,@JsonKey(name: 'date_of_birth') String dateOfBirth, String gender,@JsonKey(name: 'national_id') String? nationalId,@JsonKey(name: 'blood_type') String bloodType, double? weight, String city,@JsonKey(name: 'chronic_diseases') String? chronicDiseases,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'is_donor') bool isDonor,@JsonKey(name: 'is_recipient') bool isRecipient,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class __$ProfileModelCopyWithImpl<$Res>
    implements _$ProfileModelCopyWith<$Res> {
  __$ProfileModelCopyWithImpl(this._self, this._then);

  final _ProfileModel _self;
  final $Res Function(_ProfileModel) _then;

/// Create a copy of ProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? username = null,Object? fullName = null,Object? phone = null,Object? dateOfBirth = null,Object? gender = null,Object? nationalId = freezed,Object? bloodType = null,Object? weight = freezed,Object? city = null,Object? chronicDiseases = freezed,Object? avatarUrl = freezed,Object? isDonor = null,Object? isRecipient = null,Object? isActive = null,}) {
  return _then(_ProfileModel(
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
