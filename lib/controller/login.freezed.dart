// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LogingState {
  bool get isLoading;
  bool get isLogin;
  String get error;
  bool get hideOldPassword;
  bool get hideNewPassword;
  bool get hideConfirmPassword;

  /// Create a copy of LogingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LogingStateCopyWith<LogingState> get copyWith =>
      _$LogingStateCopyWithImpl<LogingState>(this as LogingState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LogingState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isLogin, isLogin) || other.isLogin == isLogin) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.hideOldPassword, hideOldPassword) ||
                other.hideOldPassword == hideOldPassword) &&
            (identical(other.hideNewPassword, hideNewPassword) ||
                other.hideNewPassword == hideNewPassword) &&
            (identical(other.hideConfirmPassword, hideConfirmPassword) ||
                other.hideConfirmPassword == hideConfirmPassword));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, isLogin, error,
      hideOldPassword, hideNewPassword, hideConfirmPassword);

  @override
  String toString() {
    return 'LogingState(isLoading: $isLoading, isLogin: $isLogin, error: $error, hideOldPassword: $hideOldPassword, hideNewPassword: $hideNewPassword, hideConfirmPassword: $hideConfirmPassword)';
  }
}

/// @nodoc
abstract mixin class $LogingStateCopyWith<$Res> {
  factory $LogingStateCopyWith(
          LogingState value, $Res Function(LogingState) _then) =
      _$LogingStateCopyWithImpl;
  @useResult
  $Res call(
      {bool isLoading,
      bool isLogin,
      String error,
      bool hideOldPassword,
      bool hideNewPassword,
      bool hideConfirmPassword});
}

/// @nodoc
class _$LogingStateCopyWithImpl<$Res> implements $LogingStateCopyWith<$Res> {
  _$LogingStateCopyWithImpl(this._self, this._then);

  final LogingState _self;
  final $Res Function(LogingState) _then;

  /// Create a copy of LogingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isLogin = null,
    Object? error = null,
    Object? hideOldPassword = null,
    Object? hideNewPassword = null,
    Object? hideConfirmPassword = null,
  }) {
    return _then(_self.copyWith(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLogin: null == isLogin
          ? _self.isLogin
          : isLogin // ignore: cast_nullable_to_non_nullable
              as bool,
      error: null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      hideOldPassword: null == hideOldPassword
          ? _self.hideOldPassword
          : hideOldPassword // ignore: cast_nullable_to_non_nullable
              as bool,
      hideNewPassword: null == hideNewPassword
          ? _self.hideNewPassword
          : hideNewPassword // ignore: cast_nullable_to_non_nullable
              as bool,
      hideConfirmPassword: null == hideConfirmPassword
          ? _self.hideConfirmPassword
          : hideConfirmPassword // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [LogingState].
extension LogingStatePatterns on LogingState {
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
    TResult Function(_LogingState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LogingState() when $default != null:
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
    TResult Function(_LogingState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LogingState():
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
    TResult? Function(_LogingState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LogingState() when $default != null:
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
    TResult Function(
            bool isLoading,
            bool isLogin,
            String error,
            bool hideOldPassword,
            bool hideNewPassword,
            bool hideConfirmPassword)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LogingState() when $default != null:
        return $default(
            _that.isLoading,
            _that.isLogin,
            _that.error,
            _that.hideOldPassword,
            _that.hideNewPassword,
            _that.hideConfirmPassword);
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
    TResult Function(
            bool isLoading,
            bool isLogin,
            String error,
            bool hideOldPassword,
            bool hideNewPassword,
            bool hideConfirmPassword)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LogingState():
        return $default(
            _that.isLoading,
            _that.isLogin,
            _that.error,
            _that.hideOldPassword,
            _that.hideNewPassword,
            _that.hideConfirmPassword);
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
    TResult? Function(
            bool isLoading,
            bool isLogin,
            String error,
            bool hideOldPassword,
            bool hideNewPassword,
            bool hideConfirmPassword)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LogingState() when $default != null:
        return $default(
            _that.isLoading,
            _that.isLogin,
            _that.error,
            _that.hideOldPassword,
            _that.hideNewPassword,
            _that.hideConfirmPassword);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _LogingState implements LogingState {
  _LogingState(
      {this.isLoading = false,
      this.isLogin = false,
      this.error = "",
      this.hideOldPassword = false,
      this.hideNewPassword = false,
      this.hideConfirmPassword = false});

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isLogin;
  @override
  @JsonKey()
  final String error;
  @override
  @JsonKey()
  final bool hideOldPassword;
  @override
  @JsonKey()
  final bool hideNewPassword;
  @override
  @JsonKey()
  final bool hideConfirmPassword;

  /// Create a copy of LogingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LogingStateCopyWith<_LogingState> get copyWith =>
      __$LogingStateCopyWithImpl<_LogingState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LogingState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isLogin, isLogin) || other.isLogin == isLogin) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.hideOldPassword, hideOldPassword) ||
                other.hideOldPassword == hideOldPassword) &&
            (identical(other.hideNewPassword, hideNewPassword) ||
                other.hideNewPassword == hideNewPassword) &&
            (identical(other.hideConfirmPassword, hideConfirmPassword) ||
                other.hideConfirmPassword == hideConfirmPassword));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, isLogin, error,
      hideOldPassword, hideNewPassword, hideConfirmPassword);

  @override
  String toString() {
    return 'LogingState(isLoading: $isLoading, isLogin: $isLogin, error: $error, hideOldPassword: $hideOldPassword, hideNewPassword: $hideNewPassword, hideConfirmPassword: $hideConfirmPassword)';
  }
}

/// @nodoc
abstract mixin class _$LogingStateCopyWith<$Res>
    implements $LogingStateCopyWith<$Res> {
  factory _$LogingStateCopyWith(
          _LogingState value, $Res Function(_LogingState) _then) =
      __$LogingStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      bool isLogin,
      String error,
      bool hideOldPassword,
      bool hideNewPassword,
      bool hideConfirmPassword});
}

/// @nodoc
class __$LogingStateCopyWithImpl<$Res> implements _$LogingStateCopyWith<$Res> {
  __$LogingStateCopyWithImpl(this._self, this._then);

  final _LogingState _self;
  final $Res Function(_LogingState) _then;

  /// Create a copy of LogingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isLoading = null,
    Object? isLogin = null,
    Object? error = null,
    Object? hideOldPassword = null,
    Object? hideNewPassword = null,
    Object? hideConfirmPassword = null,
  }) {
    return _then(_LogingState(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLogin: null == isLogin
          ? _self.isLogin
          : isLogin // ignore: cast_nullable_to_non_nullable
              as bool,
      error: null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      hideOldPassword: null == hideOldPassword
          ? _self.hideOldPassword
          : hideOldPassword // ignore: cast_nullable_to_non_nullable
              as bool,
      hideNewPassword: null == hideNewPassword
          ? _self.hideNewPassword
          : hideNewPassword // ignore: cast_nullable_to_non_nullable
              as bool,
      hideConfirmPassword: null == hideConfirmPassword
          ? _self.hideConfirmPassword
          : hideConfirmPassword // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
