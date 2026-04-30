// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CommentState {
  PicaComment get comment;
  bool get isLoading;
  PicaReply get replies;

  /// Create a copy of CommentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CommentStateCopyWith<CommentState> get copyWith =>
      _$CommentStateCopyWithImpl<CommentState>(
          this as CommentState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CommentState &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.replies, replies) || other.replies == replies));
  }

  @override
  int get hashCode => Object.hash(runtimeType, comment, isLoading, replies);

  @override
  String toString() {
    return 'CommentState(comment: $comment, isLoading: $isLoading, replies: $replies)';
  }
}

/// @nodoc
abstract mixin class $CommentStateCopyWith<$Res> {
  factory $CommentStateCopyWith(
          CommentState value, $Res Function(CommentState) _then) =
      _$CommentStateCopyWithImpl;
  @useResult
  $Res call({PicaComment comment, bool isLoading, PicaReply replies});
}

/// @nodoc
class _$CommentStateCopyWithImpl<$Res> implements $CommentStateCopyWith<$Res> {
  _$CommentStateCopyWithImpl(this._self, this._then);

  final CommentState _self;
  final $Res Function(CommentState) _then;

  /// Create a copy of CommentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? comment = null,
    Object? isLoading = null,
    Object? replies = null,
  }) {
    return _then(_self.copyWith(
      comment: null == comment
          ? _self.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as PicaComment,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      replies: null == replies
          ? _self.replies
          : replies // ignore: cast_nullable_to_non_nullable
              as PicaReply,
    ));
  }
}

/// Adds pattern-matching-related methods to [CommentState].
extension CommentStatePatterns on CommentState {
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
    TResult Function(_CommentState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CommentState() when $default != null:
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
    TResult Function(_CommentState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CommentState():
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
    TResult? Function(_CommentState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CommentState() when $default != null:
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
    TResult Function(PicaComment comment, bool isLoading, PicaReply replies)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CommentState() when $default != null:
        return $default(_that.comment, _that.isLoading, _that.replies);
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
    TResult Function(PicaComment comment, bool isLoading, PicaReply replies)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CommentState():
        return $default(_that.comment, _that.isLoading, _that.replies);
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
    TResult? Function(PicaComment comment, bool isLoading, PicaReply replies)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CommentState() when $default != null:
        return $default(_that.comment, _that.isLoading, _that.replies);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _CommentState implements CommentState {
  const _CommentState(
      {required this.comment, this.isLoading = false, required this.replies});

  @override
  final PicaComment comment;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final PicaReply replies;

  /// Create a copy of CommentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CommentStateCopyWith<_CommentState> get copyWith =>
      __$CommentStateCopyWithImpl<_CommentState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CommentState &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.replies, replies) || other.replies == replies));
  }

  @override
  int get hashCode => Object.hash(runtimeType, comment, isLoading, replies);

  @override
  String toString() {
    return 'CommentState(comment: $comment, isLoading: $isLoading, replies: $replies)';
  }
}

/// @nodoc
abstract mixin class _$CommentStateCopyWith<$Res>
    implements $CommentStateCopyWith<$Res> {
  factory _$CommentStateCopyWith(
          _CommentState value, $Res Function(_CommentState) _then) =
      __$CommentStateCopyWithImpl;
  @override
  @useResult
  $Res call({PicaComment comment, bool isLoading, PicaReply replies});
}

/// @nodoc
class __$CommentStateCopyWithImpl<$Res>
    implements _$CommentStateCopyWith<$Res> {
  __$CommentStateCopyWithImpl(this._self, this._then);

  final _CommentState _self;
  final $Res Function(_CommentState) _then;

  /// Create a copy of CommentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? comment = null,
    Object? isLoading = null,
    Object? replies = null,
  }) {
    return _then(_CommentState(
      comment: null == comment
          ? _self.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as PicaComment,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      replies: null == replies
          ? _self.replies
          : replies // ignore: cast_nullable_to_non_nullable
              as PicaReply,
    ));
  }
}

// dart format on
