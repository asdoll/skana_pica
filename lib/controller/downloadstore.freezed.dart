// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'downloadstore.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DownloadState {
  List<DownloadTask> get tasks;
  Map<int, int> get progress;
  Map<int, int> get total;
  Map<int, bool> get stop;
  Map<int, bool> get working;

  /// Create a copy of DownloadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DownloadStateCopyWith<DownloadState> get copyWith =>
      _$DownloadStateCopyWithImpl<DownloadState>(
          this as DownloadState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DownloadState &&
            const DeepCollectionEquality().equals(other.tasks, tasks) &&
            const DeepCollectionEquality().equals(other.progress, progress) &&
            const DeepCollectionEquality().equals(other.total, total) &&
            const DeepCollectionEquality().equals(other.stop, stop) &&
            const DeepCollectionEquality().equals(other.working, working));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(tasks),
      const DeepCollectionEquality().hash(progress),
      const DeepCollectionEquality().hash(total),
      const DeepCollectionEquality().hash(stop),
      const DeepCollectionEquality().hash(working));

  @override
  String toString() {
    return 'DownloadState(tasks: $tasks, progress: $progress, total: $total, stop: $stop, working: $working)';
  }
}

/// @nodoc
abstract mixin class $DownloadStateCopyWith<$Res> {
  factory $DownloadStateCopyWith(
          DownloadState value, $Res Function(DownloadState) _then) =
      _$DownloadStateCopyWithImpl;
  @useResult
  $Res call(
      {List<DownloadTask> tasks,
      Map<int, int> progress,
      Map<int, int> total,
      Map<int, bool> stop,
      Map<int, bool> working});
}

/// @nodoc
class _$DownloadStateCopyWithImpl<$Res>
    implements $DownloadStateCopyWith<$Res> {
  _$DownloadStateCopyWithImpl(this._self, this._then);

  final DownloadState _self;
  final $Res Function(DownloadState) _then;

  /// Create a copy of DownloadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tasks = null,
    Object? progress = null,
    Object? total = null,
    Object? stop = null,
    Object? working = null,
  }) {
    return _then(_self.copyWith(
      tasks: null == tasks
          ? _self.tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<DownloadTask>,
      progress: null == progress
          ? _self.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as Map<int, int>,
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as Map<int, int>,
      stop: null == stop
          ? _self.stop
          : stop // ignore: cast_nullable_to_non_nullable
              as Map<int, bool>,
      working: null == working
          ? _self.working
          : working // ignore: cast_nullable_to_non_nullable
              as Map<int, bool>,
    ));
  }
}

/// Adds pattern-matching-related methods to [DownloadState].
extension DownloadStatePatterns on DownloadState {
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
    TResult Function(_DownloadState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DownloadState() when $default != null:
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
    TResult Function(_DownloadState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DownloadState():
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
    TResult? Function(_DownloadState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DownloadState() when $default != null:
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
    TResult Function(List<DownloadTask> tasks, Map<int, int> progress,
            Map<int, int> total, Map<int, bool> stop, Map<int, bool> working)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DownloadState() when $default != null:
        return $default(_that.tasks, _that.progress, _that.total, _that.stop,
            _that.working);
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
    TResult Function(List<DownloadTask> tasks, Map<int, int> progress,
            Map<int, int> total, Map<int, bool> stop, Map<int, bool> working)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DownloadState():
        return $default(_that.tasks, _that.progress, _that.total, _that.stop,
            _that.working);
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
    TResult? Function(List<DownloadTask> tasks, Map<int, int> progress,
            Map<int, int> total, Map<int, bool> stop, Map<int, bool> working)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DownloadState() when $default != null:
        return $default(_that.tasks, _that.progress, _that.total, _that.stop,
            _that.working);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _DownloadState implements DownloadState {
  _DownloadState(
      {final List<DownloadTask> tasks = const [],
      final Map<int, int> progress = const {},
      final Map<int, int> total = const {},
      final Map<int, bool> stop = const {},
      final Map<int, bool> working = const {}})
      : _tasks = tasks,
        _progress = progress,
        _total = total,
        _stop = stop,
        _working = working;

  final List<DownloadTask> _tasks;
  @override
  @JsonKey()
  List<DownloadTask> get tasks {
    if (_tasks is EqualUnmodifiableListView) return _tasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tasks);
  }

  final Map<int, int> _progress;
  @override
  @JsonKey()
  Map<int, int> get progress {
    if (_progress is EqualUnmodifiableMapView) return _progress;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_progress);
  }

  final Map<int, int> _total;
  @override
  @JsonKey()
  Map<int, int> get total {
    if (_total is EqualUnmodifiableMapView) return _total;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_total);
  }

  final Map<int, bool> _stop;
  @override
  @JsonKey()
  Map<int, bool> get stop {
    if (_stop is EqualUnmodifiableMapView) return _stop;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_stop);
  }

  final Map<int, bool> _working;
  @override
  @JsonKey()
  Map<int, bool> get working {
    if (_working is EqualUnmodifiableMapView) return _working;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_working);
  }

  /// Create a copy of DownloadState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DownloadStateCopyWith<_DownloadState> get copyWith =>
      __$DownloadStateCopyWithImpl<_DownloadState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DownloadState &&
            const DeepCollectionEquality().equals(other._tasks, _tasks) &&
            const DeepCollectionEquality().equals(other._progress, _progress) &&
            const DeepCollectionEquality().equals(other._total, _total) &&
            const DeepCollectionEquality().equals(other._stop, _stop) &&
            const DeepCollectionEquality().equals(other._working, _working));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_tasks),
      const DeepCollectionEquality().hash(_progress),
      const DeepCollectionEquality().hash(_total),
      const DeepCollectionEquality().hash(_stop),
      const DeepCollectionEquality().hash(_working));

  @override
  String toString() {
    return 'DownloadState(tasks: $tasks, progress: $progress, total: $total, stop: $stop, working: $working)';
  }
}

/// @nodoc
abstract mixin class _$DownloadStateCopyWith<$Res>
    implements $DownloadStateCopyWith<$Res> {
  factory _$DownloadStateCopyWith(
          _DownloadState value, $Res Function(_DownloadState) _then) =
      __$DownloadStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<DownloadTask> tasks,
      Map<int, int> progress,
      Map<int, int> total,
      Map<int, bool> stop,
      Map<int, bool> working});
}

/// @nodoc
class __$DownloadStateCopyWithImpl<$Res>
    implements _$DownloadStateCopyWith<$Res> {
  __$DownloadStateCopyWithImpl(this._self, this._then);

  final _DownloadState _self;
  final $Res Function(_DownloadState) _then;

  /// Create a copy of DownloadState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? tasks = null,
    Object? progress = null,
    Object? total = null,
    Object? stop = null,
    Object? working = null,
  }) {
    return _then(_DownloadState(
      tasks: null == tasks
          ? _self._tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<DownloadTask>,
      progress: null == progress
          ? _self._progress
          : progress // ignore: cast_nullable_to_non_nullable
              as Map<int, int>,
      total: null == total
          ? _self._total
          : total // ignore: cast_nullable_to_non_nullable
              as Map<int, int>,
      stop: null == stop
          ? _self._stop
          : stop // ignore: cast_nullable_to_non_nullable
              as Map<int, bool>,
      working: null == working
          ? _self._working
          : working // ignore: cast_nullable_to_non_nullable
              as Map<int, bool>,
    ));
  }
}

// dart format on
