// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoginParams {

 String get username; String get password;
/// Create a copy of LoginParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginParamsCopyWith<LoginParams> get copyWith => _$LoginParamsCopyWithImpl<LoginParams>(this as LoginParams, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginParams&&(identical(other.username, username) || other.username == username)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,username,password);

@override
String toString() {
  return 'LoginParams(username: $username, password: $password)';
}


}

/// @nodoc
abstract mixin class $LoginParamsCopyWith<$Res>  {
  factory $LoginParamsCopyWith(LoginParams value, $Res Function(LoginParams) _then) = _$LoginParamsCopyWithImpl;
@useResult
$Res call({
 String username, String password
});




}
/// @nodoc
class _$LoginParamsCopyWithImpl<$Res>
    implements $LoginParamsCopyWith<$Res> {
  _$LoginParamsCopyWithImpl(this._self, this._then);

  final LoginParams _self;
  final $Res Function(LoginParams) _then;

/// Create a copy of LoginParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? username = null,Object? password = null,}) {
  return _then(_self.copyWith(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LoginParams].
extension LoginParamsPatterns on LoginParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginParams value)  $default,){
final _that = this;
switch (_that) {
case _LoginParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginParams value)?  $default,){
final _that = this;
switch (_that) {
case _LoginParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String username,  String password)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginParams() when $default != null:
return $default(_that.username,_that.password);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String username,  String password)  $default,) {final _that = this;
switch (_that) {
case _LoginParams():
return $default(_that.username,_that.password);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String username,  String password)?  $default,) {final _that = this;
switch (_that) {
case _LoginParams() when $default != null:
return $default(_that.username,_that.password);case _:
  return null;

}
}

}

/// @nodoc


class _LoginParams implements LoginParams {
  const _LoginParams({required this.username, required this.password});
  

@override final  String username;
@override final  String password;

/// Create a copy of LoginParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginParamsCopyWith<_LoginParams> get copyWith => __$LoginParamsCopyWithImpl<_LoginParams>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginParams&&(identical(other.username, username) || other.username == username)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,username,password);

@override
String toString() {
  return 'LoginParams(username: $username, password: $password)';
}


}

/// @nodoc
abstract mixin class _$LoginParamsCopyWith<$Res> implements $LoginParamsCopyWith<$Res> {
  factory _$LoginParamsCopyWith(_LoginParams value, $Res Function(_LoginParams) _then) = __$LoginParamsCopyWithImpl;
@override @useResult
$Res call({
 String username, String password
});




}
/// @nodoc
class __$LoginParamsCopyWithImpl<$Res>
    implements _$LoginParamsCopyWith<$Res> {
  __$LoginParamsCopyWithImpl(this._self, this._then);

  final _LoginParams _self;
  final $Res Function(_LoginParams) _then;

/// Create a copy of LoginParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? username = null,Object? password = null,}) {
  return _then(_LoginParams(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$SignupParams {

 String get username; String get fullName; String get password; String get phone; DateTime get dateOfBirth; String get gender; String get bloodType; String get city; String? get nationalId; double? get weight; String? get chronicDiseases;
/// Create a copy of SignupParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignupParamsCopyWith<SignupParams> get copyWith => _$SignupParamsCopyWithImpl<SignupParams>(this as SignupParams, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignupParams&&(identical(other.username, username) || other.username == username)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.password, password) || other.password == password)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.city, city) || other.city == city)&&(identical(other.nationalId, nationalId) || other.nationalId == nationalId)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.chronicDiseases, chronicDiseases) || other.chronicDiseases == chronicDiseases));
}


@override
int get hashCode => Object.hash(runtimeType,username,fullName,password,phone,dateOfBirth,gender,bloodType,city,nationalId,weight,chronicDiseases);

@override
String toString() {
  return 'SignupParams(username: $username, fullName: $fullName, password: $password, phone: $phone, dateOfBirth: $dateOfBirth, gender: $gender, bloodType: $bloodType, city: $city, nationalId: $nationalId, weight: $weight, chronicDiseases: $chronicDiseases)';
}


}

/// @nodoc
abstract mixin class $SignupParamsCopyWith<$Res>  {
  factory $SignupParamsCopyWith(SignupParams value, $Res Function(SignupParams) _then) = _$SignupParamsCopyWithImpl;
@useResult
$Res call({
 String username, String fullName, String password, String phone, DateTime dateOfBirth, String gender, String bloodType, String city, String? nationalId, double? weight, String? chronicDiseases
});




}
/// @nodoc
class _$SignupParamsCopyWithImpl<$Res>
    implements $SignupParamsCopyWith<$Res> {
  _$SignupParamsCopyWithImpl(this._self, this._then);

  final SignupParams _self;
  final $Res Function(SignupParams) _then;

/// Create a copy of SignupParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? username = null,Object? fullName = null,Object? password = null,Object? phone = null,Object? dateOfBirth = null,Object? gender = null,Object? bloodType = null,Object? city = null,Object? nationalId = freezed,Object? weight = freezed,Object? chronicDiseases = freezed,}) {
  return _then(_self.copyWith(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,bloodType: null == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,nationalId: freezed == nationalId ? _self.nationalId : nationalId // ignore: cast_nullable_to_non_nullable
as String?,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,chronicDiseases: freezed == chronicDiseases ? _self.chronicDiseases : chronicDiseases // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SignupParams].
extension SignupParamsPatterns on SignupParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SignupParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SignupParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SignupParams value)  $default,){
final _that = this;
switch (_that) {
case _SignupParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SignupParams value)?  $default,){
final _that = this;
switch (_that) {
case _SignupParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String username,  String fullName,  String password,  String phone,  DateTime dateOfBirth,  String gender,  String bloodType,  String city,  String? nationalId,  double? weight,  String? chronicDiseases)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SignupParams() when $default != null:
return $default(_that.username,_that.fullName,_that.password,_that.phone,_that.dateOfBirth,_that.gender,_that.bloodType,_that.city,_that.nationalId,_that.weight,_that.chronicDiseases);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String username,  String fullName,  String password,  String phone,  DateTime dateOfBirth,  String gender,  String bloodType,  String city,  String? nationalId,  double? weight,  String? chronicDiseases)  $default,) {final _that = this;
switch (_that) {
case _SignupParams():
return $default(_that.username,_that.fullName,_that.password,_that.phone,_that.dateOfBirth,_that.gender,_that.bloodType,_that.city,_that.nationalId,_that.weight,_that.chronicDiseases);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String username,  String fullName,  String password,  String phone,  DateTime dateOfBirth,  String gender,  String bloodType,  String city,  String? nationalId,  double? weight,  String? chronicDiseases)?  $default,) {final _that = this;
switch (_that) {
case _SignupParams() when $default != null:
return $default(_that.username,_that.fullName,_that.password,_that.phone,_that.dateOfBirth,_that.gender,_that.bloodType,_that.city,_that.nationalId,_that.weight,_that.chronicDiseases);case _:
  return null;

}
}

}

/// @nodoc


class _SignupParams implements SignupParams {
  const _SignupParams({required this.username, required this.fullName, required this.password, required this.phone, required this.dateOfBirth, required this.gender, required this.bloodType, required this.city, this.nationalId, this.weight, this.chronicDiseases});
  

@override final  String username;
@override final  String fullName;
@override final  String password;
@override final  String phone;
@override final  DateTime dateOfBirth;
@override final  String gender;
@override final  String bloodType;
@override final  String city;
@override final  String? nationalId;
@override final  double? weight;
@override final  String? chronicDiseases;

/// Create a copy of SignupParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SignupParamsCopyWith<_SignupParams> get copyWith => __$SignupParamsCopyWithImpl<_SignupParams>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignupParams&&(identical(other.username, username) || other.username == username)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.password, password) || other.password == password)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.city, city) || other.city == city)&&(identical(other.nationalId, nationalId) || other.nationalId == nationalId)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.chronicDiseases, chronicDiseases) || other.chronicDiseases == chronicDiseases));
}


@override
int get hashCode => Object.hash(runtimeType,username,fullName,password,phone,dateOfBirth,gender,bloodType,city,nationalId,weight,chronicDiseases);

@override
String toString() {
  return 'SignupParams(username: $username, fullName: $fullName, password: $password, phone: $phone, dateOfBirth: $dateOfBirth, gender: $gender, bloodType: $bloodType, city: $city, nationalId: $nationalId, weight: $weight, chronicDiseases: $chronicDiseases)';
}


}

/// @nodoc
abstract mixin class _$SignupParamsCopyWith<$Res> implements $SignupParamsCopyWith<$Res> {
  factory _$SignupParamsCopyWith(_SignupParams value, $Res Function(_SignupParams) _then) = __$SignupParamsCopyWithImpl;
@override @useResult
$Res call({
 String username, String fullName, String password, String phone, DateTime dateOfBirth, String gender, String bloodType, String city, String? nationalId, double? weight, String? chronicDiseases
});




}
/// @nodoc
class __$SignupParamsCopyWithImpl<$Res>
    implements _$SignupParamsCopyWith<$Res> {
  __$SignupParamsCopyWithImpl(this._self, this._then);

  final _SignupParams _self;
  final $Res Function(_SignupParams) _then;

/// Create a copy of SignupParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? username = null,Object? fullName = null,Object? password = null,Object? phone = null,Object? dateOfBirth = null,Object? gender = null,Object? bloodType = null,Object? city = null,Object? nationalId = freezed,Object? weight = freezed,Object? chronicDiseases = freezed,}) {
  return _then(_SignupParams(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,bloodType: null == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,nationalId: freezed == nationalId ? _self.nationalId : nationalId // ignore: cast_nullable_to_non_nullable
as String?,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,chronicDiseases: freezed == chronicDiseases ? _self.chronicDiseases : chronicDiseases // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
