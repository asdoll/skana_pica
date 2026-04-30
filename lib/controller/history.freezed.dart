// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HistoryState {
  List<VisitHistory> get history;
  List<PicaComicItemBrief> get comics;
  int get total;
  bool get isLoading;
  int get perPage;
  int get page;
  int get totalPage;

  /// Create a copy of HistoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HistoryStateCopyWith<HistoryState> get copyWith =>
      _$HistoryStateCopyWithImpl<HistoryState>(
          this as HistoryState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HistoryState &&
            const DeepCollectionEquality().equals(other.history, history) &&
            const DeepCollectionEquality().equals(other.comics, comics) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.perPage, perPage) || other.perPage == perPage) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.totalPage, totalPage) ||
                other.totalPage == totalPage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(history),
      const DeepCollectionEquality().hash(comics),
      total,
      isLoading,
      perPage,
      page,
      totalPage);

  @override
  String toString() {
    return 'HistoryState(history: $history, comics: $comics, total: $total, isLoading: $isLoading, perPage: $perPage, page: $page, totalPage: $totalPage)';
  }
}

/// @nodoc
abstract mixin class $HistoryStateCopyWith<$Res> {
  factory $HistoryStateCopyWith(
          HistoryState value, $Res Function(HistoryState) _then) =
      _$HistoryStateCopyWithImpl;
  @useResult
  $Res call(
      {List<VisitHistory> history,
      List<PicaComicItemBrief> comics,
      int total,
      bool isLoading,
      int perPage,
      int page,
      int totalPage});
}

/// @nodoc
class _$HistoryStateCopyWithImpl<$Res> implements $HistoryStateCopyWith<$Res> {
  _$HistoryStateCopyWithImpl(this._self, this._then);

  final HistoryState _self;
  final $Res Function(HistoryState) _then;

  /// Create a copy of HistoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? history = null,
    Object? comics = null,
    Object? total = null,
    Object? isLoading = null,
    Object? perPage = null,
    Object? page = null,
    Object? totalPage = null,
  }) {
    return _then(_self.copyWith(
      history: null == history
          ? _self.history
          : history // ignore: cast_nullable_to_non_nullable
              as List<VisitHistory>,
      comics: null == comics
          ? _self.comics
          : comics // ignore: cast_nullable_to_non_nullable
              as List<PicaComicItemBrief>,
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      perPage: null == perPage
          ? _self.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      totalPage: null == totalPage
          ? _self.totalPage
          : totalPage // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [HistoryState].
extension HistoryStatePatterns on HistoryState {
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
    TResult Function(_HistoryState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HistoryState() when $default != null:
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
    TResult Function(_HistoryState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HistoryState():
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
    TResult? Function(_HistoryState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HistoryState() when $default != null:
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
            List<VisitHistory> history,
            List<PicaComicItemBrief> comics,
            int total,
            bool isLoading,
            int perPage,
            int page,
            int totalPage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HistoryState() when $default != null:
        return $default(_that.history, _that.comics, _that.total,
            _that.isLoading, _that.perPage, _that.page, _that.totalPage);
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
            List<VisitHistory> history,
            List<PicaComicItemBrief> comics,
            int total,
            bool isLoading,
            int perPage,
            int page,
            int totalPage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HistoryState():
        return $default(_that.history, _that.comics, _that.total,
            _that.isLoading, _that.perPage, _that.page, _that.totalPage);
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
            List<VisitHistory> history,
            List<PicaComicItemBrief> comics,
            int total,
            bool isLoading,
            int perPage,
            int page,
            int totalPage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HistoryState() when $default != null:
        return $default(_that.history, _that.comics, _that.total,
            _that.isLoading, _that.perPage, _that.page, _that.totalPage);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _HistoryState implements HistoryState {
  const _HistoryState(
      {final List<VisitHistory> history = const [],
      final List<PicaComicItemBrief> comics = const [],
      this.total = 0,
      this.isLoading = false,
      this.perPage = 10,
      this.page = 0,
      this.totalPage = 0})
      : _history = history,
        _comics = comics;

  final List<VisitHistory> _history;
  @override
  @JsonKey()
  List<VisitHistory> get history {
    if (_history is EqualUnmodifiableListView) return _history;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_history);
  }

  final List<PicaComicItemBrief> _comics;
  @override
  @JsonKey()
  List<PicaComicItemBrief> get comics {
    if (_comics is EqualUnmodifiableListView) return _comics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_comics);
  }

  @override
  @JsonKey()
  final int total;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final int perPage;
  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey()
  final int totalPage;

  /// Create a copy of HistoryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HistoryStateCopyWith<_HistoryState> get copyWith =>
      __$HistoryStateCopyWithImpl<_HistoryState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HistoryState &&
            const DeepCollectionEquality().equals(other._history, _history) &&
            const DeepCollectionEquality().equals(other._comics, _comics) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.perPage, perPage) || other.perPage == perPage) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.totalPage, totalPage) ||
                other.totalPage == totalPage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_history),
      const DeepCollectionEquality().hash(_comics),
      total,
      isLoading,
      perPage,
      page,
      totalPage);

  @override
  String toString() {
    return 'HistoryState(history: $history, comics: $comics, total: $total, isLoading: $isLoading, perPage: $perPage, page: $page, totalPage: $totalPage)';
  }
}

/// @nodoc
abstract mixin class _$HistoryStateCopyWith<$Res>
    implements $HistoryStateCopyWith<$Res> {
  factory _$HistoryStateCopyWith(
          _HistoryState value, $Res Function(_HistoryState) _then) =
      __$HistoryStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<VisitHistory> history,
      List<PicaComicItemBrief> comics,
      int total,
      bool isLoading,
      int perPage,
      int page,
      int totalPage});
}

/// @nodoc
class __$HistoryStateCopyWithImpl<$Res>
    implements _$HistoryStateCopyWith<$Res> {
  __$HistoryStateCopyWithImpl(this._self, this._then);

  final _HistoryState _self;
  final $Res Function(_HistoryState) _then;

  /// Create a copy of HistoryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? history = null,
    Object? comics = null,
    Object? total = null,
    Object? isLoading = null,
    Object? perPage = null,
    Object? page = null,
    Object? totalPage = null,
  }) {
    return _then(_HistoryState(
      history: null == history
          ? _self._history
          : history // ignore: cast_nullable_to_non_nullable
              as List<VisitHistory>,
      comics: null == comics
          ? _self._comics
          : comics // ignore: cast_nullable_to_non_nullable
              as List<PicaComicItemBrief>,
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      perPage: null == perPage
          ? _self.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      totalPage: null == totalPage
          ? _self.totalPage
          : totalPage // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
