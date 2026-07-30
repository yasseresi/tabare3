// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'donor_card_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DonorCardSummaryModel {

@JsonKey(name: 'total_points') int get totalPoints;@JsonKey(name: 'total_donations_count') int get totalDonations;
/// Create a copy of DonorCardSummaryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DonorCardSummaryModelCopyWith<DonorCardSummaryModel> get copyWith => _$DonorCardSummaryModelCopyWithImpl<DonorCardSummaryModel>(this as DonorCardSummaryModel, _$identity);

  /// Serializes this DonorCardSummaryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DonorCardSummaryModel&&(identical(other.totalPoints, totalPoints) || other.totalPoints == totalPoints)&&(identical(other.totalDonations, totalDonations) || other.totalDonations == totalDonations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalPoints,totalDonations);

@override
String toString() {
  return 'DonorCardSummaryModel(totalPoints: $totalPoints, totalDonations: $totalDonations)';
}


}

/// @nodoc
abstract mixin class $DonorCardSummaryModelCopyWith<$Res>  {
  factory $DonorCardSummaryModelCopyWith(DonorCardSummaryModel value, $Res Function(DonorCardSummaryModel) _then) = _$DonorCardSummaryModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_points') int totalPoints,@JsonKey(name: 'total_donations_count') int totalDonations
});




}
/// @nodoc
class _$DonorCardSummaryModelCopyWithImpl<$Res>
    implements $DonorCardSummaryModelCopyWith<$Res> {
  _$DonorCardSummaryModelCopyWithImpl(this._self, this._then);

  final DonorCardSummaryModel _self;
  final $Res Function(DonorCardSummaryModel) _then;

/// Create a copy of DonorCardSummaryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalPoints = null,Object? totalDonations = null,}) {
  return _then(_self.copyWith(
totalPoints: null == totalPoints ? _self.totalPoints : totalPoints // ignore: cast_nullable_to_non_nullable
as int,totalDonations: null == totalDonations ? _self.totalDonations : totalDonations // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DonorCardSummaryModel].
extension DonorCardSummaryModelPatterns on DonorCardSummaryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DonorCardSummaryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DonorCardSummaryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DonorCardSummaryModel value)  $default,){
final _that = this;
switch (_that) {
case _DonorCardSummaryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DonorCardSummaryModel value)?  $default,){
final _that = this;
switch (_that) {
case _DonorCardSummaryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_points')  int totalPoints, @JsonKey(name: 'total_donations_count')  int totalDonations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DonorCardSummaryModel() when $default != null:
return $default(_that.totalPoints,_that.totalDonations);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_points')  int totalPoints, @JsonKey(name: 'total_donations_count')  int totalDonations)  $default,) {final _that = this;
switch (_that) {
case _DonorCardSummaryModel():
return $default(_that.totalPoints,_that.totalDonations);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_points')  int totalPoints, @JsonKey(name: 'total_donations_count')  int totalDonations)?  $default,) {final _that = this;
switch (_that) {
case _DonorCardSummaryModel() when $default != null:
return $default(_that.totalPoints,_that.totalDonations);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DonorCardSummaryModel implements DonorCardSummaryModel {
  const _DonorCardSummaryModel({@JsonKey(name: 'total_points') required this.totalPoints, @JsonKey(name: 'total_donations_count') required this.totalDonations});
  factory _DonorCardSummaryModel.fromJson(Map<String, dynamic> json) => _$DonorCardSummaryModelFromJson(json);

@override@JsonKey(name: 'total_points') final  int totalPoints;
@override@JsonKey(name: 'total_donations_count') final  int totalDonations;

/// Create a copy of DonorCardSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DonorCardSummaryModelCopyWith<_DonorCardSummaryModel> get copyWith => __$DonorCardSummaryModelCopyWithImpl<_DonorCardSummaryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DonorCardSummaryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DonorCardSummaryModel&&(identical(other.totalPoints, totalPoints) || other.totalPoints == totalPoints)&&(identical(other.totalDonations, totalDonations) || other.totalDonations == totalDonations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalPoints,totalDonations);

@override
String toString() {
  return 'DonorCardSummaryModel(totalPoints: $totalPoints, totalDonations: $totalDonations)';
}


}

/// @nodoc
abstract mixin class _$DonorCardSummaryModelCopyWith<$Res> implements $DonorCardSummaryModelCopyWith<$Res> {
  factory _$DonorCardSummaryModelCopyWith(_DonorCardSummaryModel value, $Res Function(_DonorCardSummaryModel) _then) = __$DonorCardSummaryModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_points') int totalPoints,@JsonKey(name: 'total_donations_count') int totalDonations
});




}
/// @nodoc
class __$DonorCardSummaryModelCopyWithImpl<$Res>
    implements _$DonorCardSummaryModelCopyWith<$Res> {
  __$DonorCardSummaryModelCopyWithImpl(this._self, this._then);

  final _DonorCardSummaryModel _self;
  final $Res Function(_DonorCardSummaryModel) _then;

/// Create a copy of DonorCardSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalPoints = null,Object? totalDonations = null,}) {
  return _then(_DonorCardSummaryModel(
totalPoints: null == totalPoints ? _self.totalPoints : totalPoints // ignore: cast_nullable_to_non_nullable
as int,totalDonations: null == totalDonations ? _self.totalDonations : totalDonations // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$DonorLevelModel {

@JsonKey(name: 'level_number') int get levelNumber;@JsonKey(name: 'min_points') int get minPoints;@JsonKey(name: 'name_ar') String get nameAr;@JsonKey(name: 'icon_url') String? get iconUrl;
/// Create a copy of DonorLevelModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DonorLevelModelCopyWith<DonorLevelModel> get copyWith => _$DonorLevelModelCopyWithImpl<DonorLevelModel>(this as DonorLevelModel, _$identity);

  /// Serializes this DonorLevelModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DonorLevelModel&&(identical(other.levelNumber, levelNumber) || other.levelNumber == levelNumber)&&(identical(other.minPoints, minPoints) || other.minPoints == minPoints)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,levelNumber,minPoints,nameAr,iconUrl);

@override
String toString() {
  return 'DonorLevelModel(levelNumber: $levelNumber, minPoints: $minPoints, nameAr: $nameAr, iconUrl: $iconUrl)';
}


}

/// @nodoc
abstract mixin class $DonorLevelModelCopyWith<$Res>  {
  factory $DonorLevelModelCopyWith(DonorLevelModel value, $Res Function(DonorLevelModel) _then) = _$DonorLevelModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'level_number') int levelNumber,@JsonKey(name: 'min_points') int minPoints,@JsonKey(name: 'name_ar') String nameAr,@JsonKey(name: 'icon_url') String? iconUrl
});




}
/// @nodoc
class _$DonorLevelModelCopyWithImpl<$Res>
    implements $DonorLevelModelCopyWith<$Res> {
  _$DonorLevelModelCopyWithImpl(this._self, this._then);

  final DonorLevelModel _self;
  final $Res Function(DonorLevelModel) _then;

/// Create a copy of DonorLevelModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? levelNumber = null,Object? minPoints = null,Object? nameAr = null,Object? iconUrl = freezed,}) {
  return _then(_self.copyWith(
levelNumber: null == levelNumber ? _self.levelNumber : levelNumber // ignore: cast_nullable_to_non_nullable
as int,minPoints: null == minPoints ? _self.minPoints : minPoints // ignore: cast_nullable_to_non_nullable
as int,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,iconUrl: freezed == iconUrl ? _self.iconUrl : iconUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DonorLevelModel].
extension DonorLevelModelPatterns on DonorLevelModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DonorLevelModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DonorLevelModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DonorLevelModel value)  $default,){
final _that = this;
switch (_that) {
case _DonorLevelModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DonorLevelModel value)?  $default,){
final _that = this;
switch (_that) {
case _DonorLevelModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'level_number')  int levelNumber, @JsonKey(name: 'min_points')  int minPoints, @JsonKey(name: 'name_ar')  String nameAr, @JsonKey(name: 'icon_url')  String? iconUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DonorLevelModel() when $default != null:
return $default(_that.levelNumber,_that.minPoints,_that.nameAr,_that.iconUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'level_number')  int levelNumber, @JsonKey(name: 'min_points')  int minPoints, @JsonKey(name: 'name_ar')  String nameAr, @JsonKey(name: 'icon_url')  String? iconUrl)  $default,) {final _that = this;
switch (_that) {
case _DonorLevelModel():
return $default(_that.levelNumber,_that.minPoints,_that.nameAr,_that.iconUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'level_number')  int levelNumber, @JsonKey(name: 'min_points')  int minPoints, @JsonKey(name: 'name_ar')  String nameAr, @JsonKey(name: 'icon_url')  String? iconUrl)?  $default,) {final _that = this;
switch (_that) {
case _DonorLevelModel() when $default != null:
return $default(_that.levelNumber,_that.minPoints,_that.nameAr,_that.iconUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DonorLevelModel extends DonorLevelModel {
  const _DonorLevelModel({@JsonKey(name: 'level_number') required this.levelNumber, @JsonKey(name: 'min_points') required this.minPoints, @JsonKey(name: 'name_ar') required this.nameAr, @JsonKey(name: 'icon_url') this.iconUrl}): super._();
  factory _DonorLevelModel.fromJson(Map<String, dynamic> json) => _$DonorLevelModelFromJson(json);

@override@JsonKey(name: 'level_number') final  int levelNumber;
@override@JsonKey(name: 'min_points') final  int minPoints;
@override@JsonKey(name: 'name_ar') final  String nameAr;
@override@JsonKey(name: 'icon_url') final  String? iconUrl;

/// Create a copy of DonorLevelModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DonorLevelModelCopyWith<_DonorLevelModel> get copyWith => __$DonorLevelModelCopyWithImpl<_DonorLevelModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DonorLevelModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DonorLevelModel&&(identical(other.levelNumber, levelNumber) || other.levelNumber == levelNumber)&&(identical(other.minPoints, minPoints) || other.minPoints == minPoints)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,levelNumber,minPoints,nameAr,iconUrl);

@override
String toString() {
  return 'DonorLevelModel(levelNumber: $levelNumber, minPoints: $minPoints, nameAr: $nameAr, iconUrl: $iconUrl)';
}


}

/// @nodoc
abstract mixin class _$DonorLevelModelCopyWith<$Res> implements $DonorLevelModelCopyWith<$Res> {
  factory _$DonorLevelModelCopyWith(_DonorLevelModel value, $Res Function(_DonorLevelModel) _then) = __$DonorLevelModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'level_number') int levelNumber,@JsonKey(name: 'min_points') int minPoints,@JsonKey(name: 'name_ar') String nameAr,@JsonKey(name: 'icon_url') String? iconUrl
});




}
/// @nodoc
class __$DonorLevelModelCopyWithImpl<$Res>
    implements _$DonorLevelModelCopyWith<$Res> {
  __$DonorLevelModelCopyWithImpl(this._self, this._then);

  final _DonorLevelModel _self;
  final $Res Function(_DonorLevelModel) _then;

/// Create a copy of DonorLevelModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? levelNumber = null,Object? minPoints = null,Object? nameAr = null,Object? iconUrl = freezed,}) {
  return _then(_DonorLevelModel(
levelNumber: null == levelNumber ? _self.levelNumber : levelNumber // ignore: cast_nullable_to_non_nullable
as int,minPoints: null == minPoints ? _self.minPoints : minPoints // ignore: cast_nullable_to_non_nullable
as int,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,iconUrl: freezed == iconUrl ? _self.iconUrl : iconUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$DonorBadgeModel {

 String get id;@JsonKey(name: 'name_ar') String get nameAr;@JsonKey(name: 'description_ar') String? get descriptionAr;@JsonKey(name: 'icon_url') String? get iconUrl;
/// Create a copy of DonorBadgeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DonorBadgeModelCopyWith<DonorBadgeModel> get copyWith => _$DonorBadgeModelCopyWithImpl<DonorBadgeModel>(this as DonorBadgeModel, _$identity);

  /// Serializes this DonorBadgeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DonorBadgeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.descriptionAr, descriptionAr) || other.descriptionAr == descriptionAr)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nameAr,descriptionAr,iconUrl);

@override
String toString() {
  return 'DonorBadgeModel(id: $id, nameAr: $nameAr, descriptionAr: $descriptionAr, iconUrl: $iconUrl)';
}


}

/// @nodoc
abstract mixin class $DonorBadgeModelCopyWith<$Res>  {
  factory $DonorBadgeModelCopyWith(DonorBadgeModel value, $Res Function(DonorBadgeModel) _then) = _$DonorBadgeModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'name_ar') String nameAr,@JsonKey(name: 'description_ar') String? descriptionAr,@JsonKey(name: 'icon_url') String? iconUrl
});




}
/// @nodoc
class _$DonorBadgeModelCopyWithImpl<$Res>
    implements $DonorBadgeModelCopyWith<$Res> {
  _$DonorBadgeModelCopyWithImpl(this._self, this._then);

  final DonorBadgeModel _self;
  final $Res Function(DonorBadgeModel) _then;

/// Create a copy of DonorBadgeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nameAr = null,Object? descriptionAr = freezed,Object? iconUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,descriptionAr: freezed == descriptionAr ? _self.descriptionAr : descriptionAr // ignore: cast_nullable_to_non_nullable
as String?,iconUrl: freezed == iconUrl ? _self.iconUrl : iconUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DonorBadgeModel].
extension DonorBadgeModelPatterns on DonorBadgeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DonorBadgeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DonorBadgeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DonorBadgeModel value)  $default,){
final _that = this;
switch (_that) {
case _DonorBadgeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DonorBadgeModel value)?  $default,){
final _that = this;
switch (_that) {
case _DonorBadgeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'name_ar')  String nameAr, @JsonKey(name: 'description_ar')  String? descriptionAr, @JsonKey(name: 'icon_url')  String? iconUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DonorBadgeModel() when $default != null:
return $default(_that.id,_that.nameAr,_that.descriptionAr,_that.iconUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'name_ar')  String nameAr, @JsonKey(name: 'description_ar')  String? descriptionAr, @JsonKey(name: 'icon_url')  String? iconUrl)  $default,) {final _that = this;
switch (_that) {
case _DonorBadgeModel():
return $default(_that.id,_that.nameAr,_that.descriptionAr,_that.iconUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'name_ar')  String nameAr, @JsonKey(name: 'description_ar')  String? descriptionAr, @JsonKey(name: 'icon_url')  String? iconUrl)?  $default,) {final _that = this;
switch (_that) {
case _DonorBadgeModel() when $default != null:
return $default(_that.id,_that.nameAr,_that.descriptionAr,_that.iconUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DonorBadgeModel implements DonorBadgeModel {
  const _DonorBadgeModel({required this.id, @JsonKey(name: 'name_ar') required this.nameAr, @JsonKey(name: 'description_ar') this.descriptionAr, @JsonKey(name: 'icon_url') this.iconUrl});
  factory _DonorBadgeModel.fromJson(Map<String, dynamic> json) => _$DonorBadgeModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'name_ar') final  String nameAr;
@override@JsonKey(name: 'description_ar') final  String? descriptionAr;
@override@JsonKey(name: 'icon_url') final  String? iconUrl;

/// Create a copy of DonorBadgeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DonorBadgeModelCopyWith<_DonorBadgeModel> get copyWith => __$DonorBadgeModelCopyWithImpl<_DonorBadgeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DonorBadgeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DonorBadgeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.descriptionAr, descriptionAr) || other.descriptionAr == descriptionAr)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nameAr,descriptionAr,iconUrl);

@override
String toString() {
  return 'DonorBadgeModel(id: $id, nameAr: $nameAr, descriptionAr: $descriptionAr, iconUrl: $iconUrl)';
}


}

/// @nodoc
abstract mixin class _$DonorBadgeModelCopyWith<$Res> implements $DonorBadgeModelCopyWith<$Res> {
  factory _$DonorBadgeModelCopyWith(_DonorBadgeModel value, $Res Function(_DonorBadgeModel) _then) = __$DonorBadgeModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'name_ar') String nameAr,@JsonKey(name: 'description_ar') String? descriptionAr,@JsonKey(name: 'icon_url') String? iconUrl
});




}
/// @nodoc
class __$DonorBadgeModelCopyWithImpl<$Res>
    implements _$DonorBadgeModelCopyWith<$Res> {
  __$DonorBadgeModelCopyWithImpl(this._self, this._then);

  final _DonorBadgeModel _self;
  final $Res Function(_DonorBadgeModel) _then;

/// Create a copy of DonorBadgeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nameAr = null,Object? descriptionAr = freezed,Object? iconUrl = freezed,}) {
  return _then(_DonorBadgeModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,descriptionAr: freezed == descriptionAr ? _self.descriptionAr : descriptionAr // ignore: cast_nullable_to_non_nullable
as String?,iconUrl: freezed == iconUrl ? _self.iconUrl : iconUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$EarnedDonorBadgeModel {

@JsonKey(name: 'earned_at') DateTime get earnedAt; DonorBadgeModel get badge;
/// Create a copy of EarnedDonorBadgeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EarnedDonorBadgeModelCopyWith<EarnedDonorBadgeModel> get copyWith => _$EarnedDonorBadgeModelCopyWithImpl<EarnedDonorBadgeModel>(this as EarnedDonorBadgeModel, _$identity);

  /// Serializes this EarnedDonorBadgeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EarnedDonorBadgeModel&&(identical(other.earnedAt, earnedAt) || other.earnedAt == earnedAt)&&(identical(other.badge, badge) || other.badge == badge));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,earnedAt,badge);

@override
String toString() {
  return 'EarnedDonorBadgeModel(earnedAt: $earnedAt, badge: $badge)';
}


}

/// @nodoc
abstract mixin class $EarnedDonorBadgeModelCopyWith<$Res>  {
  factory $EarnedDonorBadgeModelCopyWith(EarnedDonorBadgeModel value, $Res Function(EarnedDonorBadgeModel) _then) = _$EarnedDonorBadgeModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'earned_at') DateTime earnedAt, DonorBadgeModel badge
});


$DonorBadgeModelCopyWith<$Res> get badge;

}
/// @nodoc
class _$EarnedDonorBadgeModelCopyWithImpl<$Res>
    implements $EarnedDonorBadgeModelCopyWith<$Res> {
  _$EarnedDonorBadgeModelCopyWithImpl(this._self, this._then);

  final EarnedDonorBadgeModel _self;
  final $Res Function(EarnedDonorBadgeModel) _then;

/// Create a copy of EarnedDonorBadgeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? earnedAt = null,Object? badge = null,}) {
  return _then(_self.copyWith(
earnedAt: null == earnedAt ? _self.earnedAt : earnedAt // ignore: cast_nullable_to_non_nullable
as DateTime,badge: null == badge ? _self.badge : badge // ignore: cast_nullable_to_non_nullable
as DonorBadgeModel,
  ));
}
/// Create a copy of EarnedDonorBadgeModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonorBadgeModelCopyWith<$Res> get badge {
  
  return $DonorBadgeModelCopyWith<$Res>(_self.badge, (value) {
    return _then(_self.copyWith(badge: value));
  });
}
}


/// Adds pattern-matching-related methods to [EarnedDonorBadgeModel].
extension EarnedDonorBadgeModelPatterns on EarnedDonorBadgeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EarnedDonorBadgeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EarnedDonorBadgeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EarnedDonorBadgeModel value)  $default,){
final _that = this;
switch (_that) {
case _EarnedDonorBadgeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EarnedDonorBadgeModel value)?  $default,){
final _that = this;
switch (_that) {
case _EarnedDonorBadgeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'earned_at')  DateTime earnedAt,  DonorBadgeModel badge)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EarnedDonorBadgeModel() when $default != null:
return $default(_that.earnedAt,_that.badge);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'earned_at')  DateTime earnedAt,  DonorBadgeModel badge)  $default,) {final _that = this;
switch (_that) {
case _EarnedDonorBadgeModel():
return $default(_that.earnedAt,_that.badge);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'earned_at')  DateTime earnedAt,  DonorBadgeModel badge)?  $default,) {final _that = this;
switch (_that) {
case _EarnedDonorBadgeModel() when $default != null:
return $default(_that.earnedAt,_that.badge);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EarnedDonorBadgeModel extends EarnedDonorBadgeModel {
  const _EarnedDonorBadgeModel({@JsonKey(name: 'earned_at') required this.earnedAt, required this.badge}): super._();
  factory _EarnedDonorBadgeModel.fromJson(Map<String, dynamic> json) => _$EarnedDonorBadgeModelFromJson(json);

@override@JsonKey(name: 'earned_at') final  DateTime earnedAt;
@override final  DonorBadgeModel badge;

/// Create a copy of EarnedDonorBadgeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EarnedDonorBadgeModelCopyWith<_EarnedDonorBadgeModel> get copyWith => __$EarnedDonorBadgeModelCopyWithImpl<_EarnedDonorBadgeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EarnedDonorBadgeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EarnedDonorBadgeModel&&(identical(other.earnedAt, earnedAt) || other.earnedAt == earnedAt)&&(identical(other.badge, badge) || other.badge == badge));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,earnedAt,badge);

@override
String toString() {
  return 'EarnedDonorBadgeModel(earnedAt: $earnedAt, badge: $badge)';
}


}

/// @nodoc
abstract mixin class _$EarnedDonorBadgeModelCopyWith<$Res> implements $EarnedDonorBadgeModelCopyWith<$Res> {
  factory _$EarnedDonorBadgeModelCopyWith(_EarnedDonorBadgeModel value, $Res Function(_EarnedDonorBadgeModel) _then) = __$EarnedDonorBadgeModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'earned_at') DateTime earnedAt, DonorBadgeModel badge
});


@override $DonorBadgeModelCopyWith<$Res> get badge;

}
/// @nodoc
class __$EarnedDonorBadgeModelCopyWithImpl<$Res>
    implements _$EarnedDonorBadgeModelCopyWith<$Res> {
  __$EarnedDonorBadgeModelCopyWithImpl(this._self, this._then);

  final _EarnedDonorBadgeModel _self;
  final $Res Function(_EarnedDonorBadgeModel) _then;

/// Create a copy of EarnedDonorBadgeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? earnedAt = null,Object? badge = null,}) {
  return _then(_EarnedDonorBadgeModel(
earnedAt: null == earnedAt ? _self.earnedAt : earnedAt // ignore: cast_nullable_to_non_nullable
as DateTime,badge: null == badge ? _self.badge : badge // ignore: cast_nullable_to_non_nullable
as DonorBadgeModel,
  ));
}

/// Create a copy of EarnedDonorBadgeModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonorBadgeModelCopyWith<$Res> get badge {
  
  return $DonorBadgeModelCopyWith<$Res>(_self.badge, (value) {
    return _then(_self.copyWith(badge: value));
  });
}
}

/// @nodoc
mixin _$DonorCardModel {

 DonorCardSummaryModel get summary; List<DonorLevelModel> get levels; List<EarnedDonorBadgeModel> get badges;
/// Create a copy of DonorCardModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DonorCardModelCopyWith<DonorCardModel> get copyWith => _$DonorCardModelCopyWithImpl<DonorCardModel>(this as DonorCardModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DonorCardModel&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.levels, levels)&&const DeepCollectionEquality().equals(other.badges, badges));
}


@override
int get hashCode => Object.hash(runtimeType,summary,const DeepCollectionEquality().hash(levels),const DeepCollectionEquality().hash(badges));

@override
String toString() {
  return 'DonorCardModel(summary: $summary, levels: $levels, badges: $badges)';
}


}

/// @nodoc
abstract mixin class $DonorCardModelCopyWith<$Res>  {
  factory $DonorCardModelCopyWith(DonorCardModel value, $Res Function(DonorCardModel) _then) = _$DonorCardModelCopyWithImpl;
@useResult
$Res call({
 DonorCardSummaryModel summary, List<DonorLevelModel> levels, List<EarnedDonorBadgeModel> badges
});


$DonorCardSummaryModelCopyWith<$Res> get summary;

}
/// @nodoc
class _$DonorCardModelCopyWithImpl<$Res>
    implements $DonorCardModelCopyWith<$Res> {
  _$DonorCardModelCopyWithImpl(this._self, this._then);

  final DonorCardModel _self;
  final $Res Function(DonorCardModel) _then;

/// Create a copy of DonorCardModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? summary = null,Object? levels = null,Object? badges = null,}) {
  return _then(_self.copyWith(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as DonorCardSummaryModel,levels: null == levels ? _self.levels : levels // ignore: cast_nullable_to_non_nullable
as List<DonorLevelModel>,badges: null == badges ? _self.badges : badges // ignore: cast_nullable_to_non_nullable
as List<EarnedDonorBadgeModel>,
  ));
}
/// Create a copy of DonorCardModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonorCardSummaryModelCopyWith<$Res> get summary {
  
  return $DonorCardSummaryModelCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// Adds pattern-matching-related methods to [DonorCardModel].
extension DonorCardModelPatterns on DonorCardModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DonorCardModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DonorCardModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DonorCardModel value)  $default,){
final _that = this;
switch (_that) {
case _DonorCardModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DonorCardModel value)?  $default,){
final _that = this;
switch (_that) {
case _DonorCardModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DonorCardSummaryModel summary,  List<DonorLevelModel> levels,  List<EarnedDonorBadgeModel> badges)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DonorCardModel() when $default != null:
return $default(_that.summary,_that.levels,_that.badges);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DonorCardSummaryModel summary,  List<DonorLevelModel> levels,  List<EarnedDonorBadgeModel> badges)  $default,) {final _that = this;
switch (_that) {
case _DonorCardModel():
return $default(_that.summary,_that.levels,_that.badges);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DonorCardSummaryModel summary,  List<DonorLevelModel> levels,  List<EarnedDonorBadgeModel> badges)?  $default,) {final _that = this;
switch (_that) {
case _DonorCardModel() when $default != null:
return $default(_that.summary,_that.levels,_that.badges);case _:
  return null;

}
}

}

/// @nodoc


class _DonorCardModel extends DonorCardModel {
  const _DonorCardModel({required this.summary, required final  List<DonorLevelModel> levels, required final  List<EarnedDonorBadgeModel> badges}): _levels = levels,_badges = badges,super._();
  

@override final  DonorCardSummaryModel summary;
 final  List<DonorLevelModel> _levels;
@override List<DonorLevelModel> get levels {
  if (_levels is EqualUnmodifiableListView) return _levels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_levels);
}

 final  List<EarnedDonorBadgeModel> _badges;
@override List<EarnedDonorBadgeModel> get badges {
  if (_badges is EqualUnmodifiableListView) return _badges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_badges);
}


/// Create a copy of DonorCardModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DonorCardModelCopyWith<_DonorCardModel> get copyWith => __$DonorCardModelCopyWithImpl<_DonorCardModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DonorCardModel&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other._levels, _levels)&&const DeepCollectionEquality().equals(other._badges, _badges));
}


@override
int get hashCode => Object.hash(runtimeType,summary,const DeepCollectionEquality().hash(_levels),const DeepCollectionEquality().hash(_badges));

@override
String toString() {
  return 'DonorCardModel(summary: $summary, levels: $levels, badges: $badges)';
}


}

/// @nodoc
abstract mixin class _$DonorCardModelCopyWith<$Res> implements $DonorCardModelCopyWith<$Res> {
  factory _$DonorCardModelCopyWith(_DonorCardModel value, $Res Function(_DonorCardModel) _then) = __$DonorCardModelCopyWithImpl;
@override @useResult
$Res call({
 DonorCardSummaryModel summary, List<DonorLevelModel> levels, List<EarnedDonorBadgeModel> badges
});


@override $DonorCardSummaryModelCopyWith<$Res> get summary;

}
/// @nodoc
class __$DonorCardModelCopyWithImpl<$Res>
    implements _$DonorCardModelCopyWith<$Res> {
  __$DonorCardModelCopyWithImpl(this._self, this._then);

  final _DonorCardModel _self;
  final $Res Function(_DonorCardModel) _then;

/// Create a copy of DonorCardModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? summary = null,Object? levels = null,Object? badges = null,}) {
  return _then(_DonorCardModel(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as DonorCardSummaryModel,levels: null == levels ? _self._levels : levels // ignore: cast_nullable_to_non_nullable
as List<DonorLevelModel>,badges: null == badges ? _self._badges : badges // ignore: cast_nullable_to_non_nullable
as List<EarnedDonorBadgeModel>,
  ));
}

/// Create a copy of DonorCardModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DonorCardSummaryModelCopyWith<$Res> get summary {
  
  return $DonorCardSummaryModelCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}

// dart format on
