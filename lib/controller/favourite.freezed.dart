// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favourite.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FavorState {
  List<String> get favorComics;
  bool get isLoading;
  String get lastId;
  String get sort;

  /// Create a copy of FavorState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FavorStateCopyWith<FavorState> get copyWith =>
      _$FavorStateCopyWithImpl<FavorState>(this as FavorState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FavorState &&
            const DeepCollectionEquality()
                .equals(other.favorComics, favorComics) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.lastId, lastId) || other.lastId == lastId) &&
            (identical(other.sort, sort) || other.sort == sort));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(favorComics),
      isLoading,
      lastId,
      sort);

  @override
  String toString() {
    return 'FavorState(favorComics: $favorComics, isLoading: $isLoading, lastId: $lastId, sort: $sort)';
  }
}

/// @nodoc
abstract mixin class $FavorStateCopyWith<$Res> {
  factory $FavorStateCopyWith(
          FavorState value, $Res Function(FavorState) _then) =
      _$FavorStateCopyWithImpl;
  @useResult
  $Res call(
      {List<String> favorComics, bool isLoading, String lastId, String sort});
}

/// @nodoc
class _$FavorStateCopyWithImpl<$Res> implements $FavorStateCopyWith<$Res> {
  _$FavorStateCopyWithImpl(this._self, this._then);

  final FavorState _self;
  final $Res Function(FavorState) _then;

  /// Create a copy of FavorState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? favorComics = null,
    Object? isLoading = null,
    Object? lastId = null,
    Object? sort = null,
  }) {
    return _then(_self.copyWith(
      favorComics: null == favorComics
          ? _self.favorComics
          : favorComics // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      lastId: null == lastId
          ? _self.lastId
          : lastId // ignore: cast_nullable_to_non_nullable
              as String,
      sort: null == sort
          ? _self.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [FavorState].
extension FavorStatePatterns on FavorState {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_FavorState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FavorState() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_FavorState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FavorState():
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_FavorState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FavorState() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(List<String> favorComics, bool isLoading, String lastId,
            String sort)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FavorState() when $default != null:
        return $default(
            _that.favorComics, _that.isLoading, _that.lastId, _that.sort);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(List<String> favorComics, bool isLoading, String lastId,
            String sort)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FavorState():
        return $default(
            _that.favorComics, _that.isLoading, _that.lastId, _that.sort);
      case _:
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(List<String> favorComics, bool isLoading, String lastId,
            String sort)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FavorState() when $default != null:
        return $default(
            _that.favorComics, _that.isLoading, _that.lastId, _that.sort);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FavorState implements FavorState {
  const _FavorState(
      {final List<String> favorComics = const [],
      this.isLoading = false,
      this.lastId = "",
      this.sort = ""})
      : _favorComics = favorComics;

  final List<String> _favorComics;
  @override
  @JsonKey()
  List<String> get favorComics {
    if (_favorComics is EqualUnmodifiableListView) return _favorComics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_favorComics);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final String lastId;
  @override
  @JsonKey()
  final String sort;

  /// Create a copy of FavorState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FavorStateCopyWith<_FavorState> get copyWith =>
      __$FavorStateCopyWithImpl<_FavorState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FavorState &&
            const DeepCollectionEquality()
                .equals(other._favorComics, _favorComics) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.lastId, lastId) || other.lastId == lastId) &&
            (identical(other.sort, sort) || other.sort == sort));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_favorComics),
      isLoading,
      lastId,
      sort);

  @override
  String toString() {
    return 'FavorState(favorComics: $favorComics, isLoading: $isLoading, lastId: $lastId, sort: $sort)';
  }
}

/// @nodoc
abstract mixin class _$FavorStateCopyWith<$Res>
    implements $FavorStateCopyWith<$Res> {
  factory _$FavorStateCopyWith(
          _FavorState value, $Res Function(_FavorState) _then) =
      __$FavorStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<String> favorComics, bool isLoading, String lastId, String sort});
}

/// @nodoc
class __$FavorStateCopyWithImpl<$Res> implements _$FavorStateCopyWith<$Res> {
  __$FavorStateCopyWithImpl(this._self, this._then);

  final _FavorState _self;
  final $Res Function(_FavorState) _then;

  /// Create a copy of FavorState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? favorComics = null,
    Object? isLoading = null,
    Object? lastId = null,
    Object? sort = null,
  }) {
    return _then(_FavorState(
      favorComics: null == favorComics
          ? _self._favorComics
          : favorComics // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      lastId: null == lastId
          ? _self.lastId
          : lastId // ignore: cast_nullable_to_non_nullable
              as String,
      sort: null == sort
          ? _self.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$LikeState {
  bool get isLike;
  bool get isLoading;
  String get id;
  bool get isComment;

  /// Create a copy of LikeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LikeStateCopyWith<LikeState> get copyWith =>
      _$LikeStateCopyWithImpl<LikeState>(this as LikeState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LikeState &&
            (identical(other.isLike, isLike) || other.isLike == isLike) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.isComment, isComment) ||
                other.isComment == isComment));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isLike, isLoading, id, isComment);

  @override
  String toString() {
    return 'LikeState(isLike: $isLike, isLoading: $isLoading, id: $id, isComment: $isComment)';
  }
}

/// @nodoc
abstract mixin class $LikeStateCopyWith<$Res> {
  factory $LikeStateCopyWith(LikeState value, $Res Function(LikeState) _then) =
      _$LikeStateCopyWithImpl;
  @useResult
  $Res call({bool isLike, bool isLoading, String id, bool isComment});
}

/// @nodoc
class _$LikeStateCopyWithImpl<$Res> implements $LikeStateCopyWith<$Res> {
  _$LikeStateCopyWithImpl(this._self, this._then);

  final LikeState _self;
  final $Res Function(LikeState) _then;

  /// Create a copy of LikeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLike = null,
    Object? isLoading = null,
    Object? id = null,
    Object? isComment = null,
  }) {
    return _then(_self.copyWith(
      isLike: null == isLike
          ? _self.isLike
          : isLike // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      isComment: null == isComment
          ? _self.isComment
          : isComment // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [LikeState].
extension LikeStatePatterns on LikeState {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_LikeState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LikeState() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_LikeState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LikeState():
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_LikeState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LikeState() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(bool isLike, bool isLoading, String id, bool isComment)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LikeState() when $default != null:
        return $default(
            _that.isLike, _that.isLoading, _that.id, _that.isComment);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(bool isLike, bool isLoading, String id, bool isComment)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LikeState():
        return $default(
            _that.isLike, _that.isLoading, _that.id, _that.isComment);
      case _:
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(bool isLike, bool isLoading, String id, bool isComment)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LikeState() when $default != null:
        return $default(
            _that.isLike, _that.isLoading, _that.id, _that.isComment);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _LikeState implements LikeState {
  const _LikeState(
      {this.isLike = false,
      this.isLoading = false,
      required this.id,
      this.isComment = false});

  @override
  @JsonKey()
  final bool isLike;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String id;
  @override
  @JsonKey()
  final bool isComment;

  /// Create a copy of LikeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LikeStateCopyWith<_LikeState> get copyWith =>
      __$LikeStateCopyWithImpl<_LikeState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LikeState &&
            (identical(other.isLike, isLike) || other.isLike == isLike) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.isComment, isComment) ||
                other.isComment == isComment));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isLike, isLoading, id, isComment);

  @override
  String toString() {
    return 'LikeState(isLike: $isLike, isLoading: $isLoading, id: $id, isComment: $isComment)';
  }
}

/// @nodoc
abstract mixin class _$LikeStateCopyWith<$Res>
    implements $LikeStateCopyWith<$Res> {
  factory _$LikeStateCopyWith(
          _LikeState value, $Res Function(_LikeState) _then) =
      __$LikeStateCopyWithImpl;
  @override
  @useResult
  $Res call({bool isLike, bool isLoading, String id, bool isComment});
}

/// @nodoc
class __$LikeStateCopyWithImpl<$Res> implements _$LikeStateCopyWith<$Res> {
  __$LikeStateCopyWithImpl(this._self, this._then);

  final _LikeState _self;
  final $Res Function(_LikeState) _then;

  /// Create a copy of LikeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isLike = null,
    Object? isLoading = null,
    Object? id = null,
    Object? isComment = null,
  }) {
    return _then(_LikeState(
      isLike: null == isLike
          ? _self.isLike
          : isLike // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      isComment: null == isComment
          ? _self.isComment
          : isComment // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
