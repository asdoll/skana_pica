// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comiclist.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ComicListState {
  List<PicaComicItemBrief> get comics;
  bool get isLoading;
  int get page;
  int get total;
  bool get isDrag;
  int get loadedPage;
  int get lastFetchTime;
  int get sort;
  bool get filterMenu;

  /// Create a copy of ComicListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ComicListStateCopyWith<ComicListState> get copyWith =>
      _$ComicListStateCopyWithImpl<ComicListState>(
          this as ComicListState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ComicListState &&
            const DeepCollectionEquality().equals(other.comics, comics) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.isDrag, isDrag) || other.isDrag == isDrag) &&
            (identical(other.loadedPage, loadedPage) ||
                other.loadedPage == loadedPage) &&
            (identical(other.lastFetchTime, lastFetchTime) ||
                other.lastFetchTime == lastFetchTime) &&
            (identical(other.sort, sort) || other.sort == sort) &&
            (identical(other.filterMenu, filterMenu) ||
                other.filterMenu == filterMenu));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(comics),
      isLoading,
      page,
      total,
      isDrag,
      loadedPage,
      lastFetchTime,
      sort,
      filterMenu);

  @override
  String toString() {
    return 'ComicListState(comics: $comics, isLoading: $isLoading, page: $page, total: $total, isDrag: $isDrag, loadedPage: $loadedPage, lastFetchTime: $lastFetchTime, sort: $sort, filterMenu: $filterMenu)';
  }
}

/// @nodoc
abstract mixin class $ComicListStateCopyWith<$Res> {
  factory $ComicListStateCopyWith(
          ComicListState value, $Res Function(ComicListState) _then) =
      _$ComicListStateCopyWithImpl;
  @useResult
  $Res call(
      {List<PicaComicItemBrief> comics,
      bool isLoading,
      int page,
      int total,
      bool isDrag,
      int loadedPage,
      int lastFetchTime,
      int sort,
      bool filterMenu});
}

/// @nodoc
class _$ComicListStateCopyWithImpl<$Res>
    implements $ComicListStateCopyWith<$Res> {
  _$ComicListStateCopyWithImpl(this._self, this._then);

  final ComicListState _self;
  final $Res Function(ComicListState) _then;

  /// Create a copy of ComicListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? comics = null,
    Object? isLoading = null,
    Object? page = null,
    Object? total = null,
    Object? isDrag = null,
    Object? loadedPage = null,
    Object? lastFetchTime = null,
    Object? sort = null,
    Object? filterMenu = null,
  }) {
    return _then(_self.copyWith(
      comics: null == comics
          ? _self.comics
          : comics // ignore: cast_nullable_to_non_nullable
              as List<PicaComicItemBrief>,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      page: null == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      isDrag: null == isDrag
          ? _self.isDrag
          : isDrag // ignore: cast_nullable_to_non_nullable
              as bool,
      loadedPage: null == loadedPage
          ? _self.loadedPage
          : loadedPage // ignore: cast_nullable_to_non_nullable
              as int,
      lastFetchTime: null == lastFetchTime
          ? _self.lastFetchTime
          : lastFetchTime // ignore: cast_nullable_to_non_nullable
              as int,
      sort: null == sort
          ? _self.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as int,
      filterMenu: null == filterMenu
          ? _self.filterMenu
          : filterMenu // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [ComicListState].
extension ComicListStatePatterns on ComicListState {
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
    TResult Function(_ComicListState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ComicListState() when $default != null:
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
    TResult Function(_ComicListState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ComicListState():
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
    TResult? Function(_ComicListState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ComicListState() when $default != null:
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
            List<PicaComicItemBrief> comics,
            bool isLoading,
            int page,
            int total,
            bool isDrag,
            int loadedPage,
            int lastFetchTime,
            int sort,
            bool filterMenu)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ComicListState() when $default != null:
        return $default(
            _that.comics,
            _that.isLoading,
            _that.page,
            _that.total,
            _that.isDrag,
            _that.loadedPage,
            _that.lastFetchTime,
            _that.sort,
            _that.filterMenu);
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
            List<PicaComicItemBrief> comics,
            bool isLoading,
            int page,
            int total,
            bool isDrag,
            int loadedPage,
            int lastFetchTime,
            int sort,
            bool filterMenu)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ComicListState():
        return $default(
            _that.comics,
            _that.isLoading,
            _that.page,
            _that.total,
            _that.isDrag,
            _that.loadedPage,
            _that.lastFetchTime,
            _that.sort,
            _that.filterMenu);
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
            List<PicaComicItemBrief> comics,
            bool isLoading,
            int page,
            int total,
            bool isDrag,
            int loadedPage,
            int lastFetchTime,
            int sort,
            bool filterMenu)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ComicListState() when $default != null:
        return $default(
            _that.comics,
            _that.isLoading,
            _that.page,
            _that.total,
            _that.isDrag,
            _that.loadedPage,
            _that.lastFetchTime,
            _that.sort,
            _that.filterMenu);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ComicListState implements ComicListState {
  const _ComicListState(
      {final List<PicaComicItemBrief> comics = const [],
      this.isLoading = false,
      this.page = 1,
      this.total = 0,
      this.isDrag = false,
      this.loadedPage = 0,
      this.lastFetchTime = 0,
      this.sort = 0,
      this.filterMenu = false})
      : _comics = comics;

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
  final bool isLoading;
  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey()
  final int total;
  @override
  @JsonKey()
  final bool isDrag;
  @override
  @JsonKey()
  final int loadedPage;
  @override
  @JsonKey()
  final int lastFetchTime;
  @override
  @JsonKey()
  final int sort;
  @override
  @JsonKey()
  final bool filterMenu;

  /// Create a copy of ComicListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ComicListStateCopyWith<_ComicListState> get copyWith =>
      __$ComicListStateCopyWithImpl<_ComicListState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ComicListState &&
            const DeepCollectionEquality().equals(other._comics, _comics) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.isDrag, isDrag) || other.isDrag == isDrag) &&
            (identical(other.loadedPage, loadedPage) ||
                other.loadedPage == loadedPage) &&
            (identical(other.lastFetchTime, lastFetchTime) ||
                other.lastFetchTime == lastFetchTime) &&
            (identical(other.sort, sort) || other.sort == sort) &&
            (identical(other.filterMenu, filterMenu) ||
                other.filterMenu == filterMenu));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_comics),
      isLoading,
      page,
      total,
      isDrag,
      loadedPage,
      lastFetchTime,
      sort,
      filterMenu);

  @override
  String toString() {
    return 'ComicListState(comics: $comics, isLoading: $isLoading, page: $page, total: $total, isDrag: $isDrag, loadedPage: $loadedPage, lastFetchTime: $lastFetchTime, sort: $sort, filterMenu: $filterMenu)';
  }
}

/// @nodoc
abstract mixin class _$ComicListStateCopyWith<$Res>
    implements $ComicListStateCopyWith<$Res> {
  factory _$ComicListStateCopyWith(
          _ComicListState value, $Res Function(_ComicListState) _then) =
      __$ComicListStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<PicaComicItemBrief> comics,
      bool isLoading,
      int page,
      int total,
      bool isDrag,
      int loadedPage,
      int lastFetchTime,
      int sort,
      bool filterMenu});
}

/// @nodoc
class __$ComicListStateCopyWithImpl<$Res>
    implements _$ComicListStateCopyWith<$Res> {
  __$ComicListStateCopyWithImpl(this._self, this._then);

  final _ComicListState _self;
  final $Res Function(_ComicListState) _then;

  /// Create a copy of ComicListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? comics = null,
    Object? isLoading = null,
    Object? page = null,
    Object? total = null,
    Object? isDrag = null,
    Object? loadedPage = null,
    Object? lastFetchTime = null,
    Object? sort = null,
    Object? filterMenu = null,
  }) {
    return _then(_ComicListState(
      comics: null == comics
          ? _self._comics
          : comics // ignore: cast_nullable_to_non_nullable
              as List<PicaComicItemBrief>,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      page: null == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      isDrag: null == isDrag
          ? _self.isDrag
          : isDrag // ignore: cast_nullable_to_non_nullable
              as bool,
      loadedPage: null == loadedPage
          ? _self.loadedPage
          : loadedPage // ignore: cast_nullable_to_non_nullable
              as int,
      lastFetchTime: null == lastFetchTime
          ? _self.lastFetchTime
          : lastFetchTime // ignore: cast_nullable_to_non_nullable
              as int,
      sort: null == sort
          ? _self.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as int,
      filterMenu: null == filterMenu
          ? _self.filterMenu
          : filterMenu // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
