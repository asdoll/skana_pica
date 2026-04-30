// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blocker.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlockerState {
  List<String> get keywords;
  List<String> get categories;

  /// Create a copy of BlockerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BlockerStateCopyWith<BlockerState> get copyWith =>
      _$BlockerStateCopyWithImpl<BlockerState>(
          this as BlockerState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BlockerState &&
            const DeepCollectionEquality().equals(other.keywords, keywords) &&
            const DeepCollectionEquality()
                .equals(other.categories, categories));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(keywords),
      const DeepCollectionEquality().hash(categories));

  @override
  String toString() {
    return 'BlockerState(keywords: $keywords, categories: $categories)';
  }
}

/// @nodoc
abstract mixin class $BlockerStateCopyWith<$Res> {
  factory $BlockerStateCopyWith(
          BlockerState value, $Res Function(BlockerState) _then) =
      _$BlockerStateCopyWithImpl;
  @useResult
  $Res call({List<String> keywords, List<String> categories});
}

/// @nodoc
class _$BlockerStateCopyWithImpl<$Res> implements $BlockerStateCopyWith<$Res> {
  _$BlockerStateCopyWithImpl(this._self, this._then);

  final BlockerState _self;
  final $Res Function(BlockerState) _then;

  /// Create a copy of BlockerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? keywords = null,
    Object? categories = null,
  }) {
    return _then(_self.copyWith(
      keywords: null == keywords
          ? _self.keywords
          : keywords // ignore: cast_nullable_to_non_nullable
              as List<String>,
      categories: null == categories
          ? _self.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// Adds pattern-matching-related methods to [BlockerState].
extension BlockerStatePatterns on BlockerState {
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
    TResult Function(_BlockerState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BlockerState() when $default != null:
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
    TResult Function(_BlockerState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BlockerState():
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
    TResult? Function(_BlockerState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BlockerState() when $default != null:
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
    TResult Function(List<String> keywords, List<String> categories)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BlockerState() when $default != null:
        return $default(_that.keywords, _that.categories);
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
    TResult Function(List<String> keywords, List<String> categories) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BlockerState():
        return $default(_that.keywords, _that.categories);
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
    TResult? Function(List<String> keywords, List<String> categories)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BlockerState() when $default != null:
        return $default(_that.keywords, _that.categories);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _BlockerState implements BlockerState {
  _BlockerState(
      {required final List<String> keywords,
      required final List<String> categories})
      : _keywords = keywords,
        _categories = categories;

  final List<String> _keywords;
  @override
  List<String> get keywords {
    if (_keywords is EqualUnmodifiableListView) return _keywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keywords);
  }

  final List<String> _categories;
  @override
  List<String> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  /// Create a copy of BlockerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BlockerStateCopyWith<_BlockerState> get copyWith =>
      __$BlockerStateCopyWithImpl<_BlockerState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BlockerState &&
            const DeepCollectionEquality().equals(other._keywords, _keywords) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_keywords),
      const DeepCollectionEquality().hash(_categories));

  @override
  String toString() {
    return 'BlockerState(keywords: $keywords, categories: $categories)';
  }
}

/// @nodoc
abstract mixin class _$BlockerStateCopyWith<$Res>
    implements $BlockerStateCopyWith<$Res> {
  factory _$BlockerStateCopyWith(
          _BlockerState value, $Res Function(_BlockerState) _then) =
      __$BlockerStateCopyWithImpl;
  @override
  @useResult
  $Res call({List<String> keywords, List<String> categories});
}

/// @nodoc
class __$BlockerStateCopyWithImpl<$Res>
    implements _$BlockerStateCopyWith<$Res> {
  __$BlockerStateCopyWithImpl(this._self, this._then);

  final _BlockerState _self;
  final $Res Function(_BlockerState) _then;

  /// Create a copy of BlockerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? keywords = null,
    Object? categories = null,
  }) {
    return _then(_BlockerState(
      keywords: null == keywords
          ? _self._keywords
          : keywords // ignore: cast_nullable_to_non_nullable
              as List<String>,
      categories: null == categories
          ? _self._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

// dart format on
