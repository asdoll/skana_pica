// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comicstore.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ComicStoreState {
  PicaComicItem get comic;
  List<PicaEpsImages> get epsList;
  PicaComments get comments;
  DownloadTask? get task;
  bool get isLoading;
  bool get isDrag;
  bool get readModeMenu;
  bool get barVisible;
  bool get disableTap;
  bool get useDarkBackground;
  int get currentEps;
  int get currentIndex;
  int get readMode;
  int get imageLayout;
  bool get limitImageWidth;
  int get tapThreshold;
  int get autoPageTurningInterval;
  int get orientation;
  int get animationDuration;
  bool get autoPageTurning;
  PageController? get autoPagingPageController;
  ItemScrollController? get autoPagingScrollController;
  Map<int, bool> get selectDownload;

  /// Create a copy of ComicStoreState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ComicStoreStateCopyWith<ComicStoreState> get copyWith =>
      _$ComicStoreStateCopyWithImpl<ComicStoreState>(
          this as ComicStoreState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ComicStoreState &&
            (identical(other.comic, comic) || other.comic == comic) &&
            const DeepCollectionEquality().equals(other.epsList, epsList) &&
            (identical(other.comments, comments) ||
                other.comments == comments) &&
            (identical(other.task, task) || other.task == task) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isDrag, isDrag) || other.isDrag == isDrag) &&
            (identical(other.readModeMenu, readModeMenu) ||
                other.readModeMenu == readModeMenu) &&
            (identical(other.barVisible, barVisible) ||
                other.barVisible == barVisible) &&
            (identical(other.disableTap, disableTap) ||
                other.disableTap == disableTap) &&
            (identical(other.useDarkBackground, useDarkBackground) ||
                other.useDarkBackground == useDarkBackground) &&
            (identical(other.currentEps, currentEps) ||
                other.currentEps == currentEps) &&
            (identical(other.currentIndex, currentIndex) ||
                other.currentIndex == currentIndex) &&
            (identical(other.readMode, readMode) ||
                other.readMode == readMode) &&
            (identical(other.imageLayout, imageLayout) ||
                other.imageLayout == imageLayout) &&
            (identical(other.limitImageWidth, limitImageWidth) ||
                other.limitImageWidth == limitImageWidth) &&
            (identical(other.tapThreshold, tapThreshold) ||
                other.tapThreshold == tapThreshold) &&
            (identical(
                    other.autoPageTurningInterval, autoPageTurningInterval) ||
                other.autoPageTurningInterval == autoPageTurningInterval) &&
            (identical(other.orientation, orientation) ||
                other.orientation == orientation) &&
            (identical(other.animationDuration, animationDuration) ||
                other.animationDuration == animationDuration) &&
            (identical(other.autoPageTurning, autoPageTurning) ||
                other.autoPageTurning == autoPageTurning) &&
            (identical(
                    other.autoPagingPageController, autoPagingPageController) ||
                other.autoPagingPageController == autoPagingPageController) &&
            (identical(other.autoPagingScrollController,
                    autoPagingScrollController) ||
                other.autoPagingScrollController ==
                    autoPagingScrollController) &&
            const DeepCollectionEquality()
                .equals(other.selectDownload, selectDownload));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        comic,
        const DeepCollectionEquality().hash(epsList),
        comments,
        task,
        isLoading,
        isDrag,
        readModeMenu,
        barVisible,
        disableTap,
        useDarkBackground,
        currentEps,
        currentIndex,
        readMode,
        imageLayout,
        limitImageWidth,
        tapThreshold,
        autoPageTurningInterval,
        orientation,
        animationDuration,
        autoPageTurning,
        autoPagingPageController,
        autoPagingScrollController,
        const DeepCollectionEquality().hash(selectDownload)
      ]);

  @override
  String toString() {
    return 'ComicStoreState(comic: $comic, epsList: $epsList, comments: $comments, task: $task, isLoading: $isLoading, isDrag: $isDrag, readModeMenu: $readModeMenu, barVisible: $barVisible, disableTap: $disableTap, useDarkBackground: $useDarkBackground, currentEps: $currentEps, currentIndex: $currentIndex, readMode: $readMode, imageLayout: $imageLayout, limitImageWidth: $limitImageWidth, tapThreshold: $tapThreshold, autoPageTurningInterval: $autoPageTurningInterval, orientation: $orientation, animationDuration: $animationDuration, autoPageTurning: $autoPageTurning, autoPagingPageController: $autoPagingPageController, autoPagingScrollController: $autoPagingScrollController, selectDownload: $selectDownload)';
  }
}

/// @nodoc
abstract mixin class $ComicStoreStateCopyWith<$Res> {
  factory $ComicStoreStateCopyWith(
          ComicStoreState value, $Res Function(ComicStoreState) _then) =
      _$ComicStoreStateCopyWithImpl;
  @useResult
  $Res call(
      {PicaComicItem comic,
      List<PicaEpsImages> epsList,
      PicaComments comments,
      DownloadTask? task,
      bool isLoading,
      bool isDrag,
      bool readModeMenu,
      bool barVisible,
      bool disableTap,
      bool useDarkBackground,
      int currentEps,
      int currentIndex,
      int readMode,
      int imageLayout,
      bool limitImageWidth,
      int tapThreshold,
      int autoPageTurningInterval,
      int orientation,
      int animationDuration,
      bool autoPageTurning,
      PageController? autoPagingPageController,
      ItemScrollController? autoPagingScrollController,
      Map<int, bool> selectDownload});
}

/// @nodoc
class _$ComicStoreStateCopyWithImpl<$Res>
    implements $ComicStoreStateCopyWith<$Res> {
  _$ComicStoreStateCopyWithImpl(this._self, this._then);

  final ComicStoreState _self;
  final $Res Function(ComicStoreState) _then;

  /// Create a copy of ComicStoreState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? comic = null,
    Object? epsList = null,
    Object? comments = null,
    Object? task = freezed,
    Object? isLoading = null,
    Object? isDrag = null,
    Object? readModeMenu = null,
    Object? barVisible = null,
    Object? disableTap = null,
    Object? useDarkBackground = null,
    Object? currentEps = null,
    Object? currentIndex = null,
    Object? readMode = null,
    Object? imageLayout = null,
    Object? limitImageWidth = null,
    Object? tapThreshold = null,
    Object? autoPageTurningInterval = null,
    Object? orientation = null,
    Object? animationDuration = null,
    Object? autoPageTurning = null,
    Object? autoPagingPageController = freezed,
    Object? autoPagingScrollController = freezed,
    Object? selectDownload = null,
  }) {
    return _then(_self.copyWith(
      comic: null == comic
          ? _self.comic
          : comic // ignore: cast_nullable_to_non_nullable
              as PicaComicItem,
      epsList: null == epsList
          ? _self.epsList
          : epsList // ignore: cast_nullable_to_non_nullable
              as List<PicaEpsImages>,
      comments: null == comments
          ? _self.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as PicaComments,
      task: freezed == task
          ? _self.task
          : task // ignore: cast_nullable_to_non_nullable
              as DownloadTask?,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isDrag: null == isDrag
          ? _self.isDrag
          : isDrag // ignore: cast_nullable_to_non_nullable
              as bool,
      readModeMenu: null == readModeMenu
          ? _self.readModeMenu
          : readModeMenu // ignore: cast_nullable_to_non_nullable
              as bool,
      barVisible: null == barVisible
          ? _self.barVisible
          : barVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      disableTap: null == disableTap
          ? _self.disableTap
          : disableTap // ignore: cast_nullable_to_non_nullable
              as bool,
      useDarkBackground: null == useDarkBackground
          ? _self.useDarkBackground
          : useDarkBackground // ignore: cast_nullable_to_non_nullable
              as bool,
      currentEps: null == currentEps
          ? _self.currentEps
          : currentEps // ignore: cast_nullable_to_non_nullable
              as int,
      currentIndex: null == currentIndex
          ? _self.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      readMode: null == readMode
          ? _self.readMode
          : readMode // ignore: cast_nullable_to_non_nullable
              as int,
      imageLayout: null == imageLayout
          ? _self.imageLayout
          : imageLayout // ignore: cast_nullable_to_non_nullable
              as int,
      limitImageWidth: null == limitImageWidth
          ? _self.limitImageWidth
          : limitImageWidth // ignore: cast_nullable_to_non_nullable
              as bool,
      tapThreshold: null == tapThreshold
          ? _self.tapThreshold
          : tapThreshold // ignore: cast_nullable_to_non_nullable
              as int,
      autoPageTurningInterval: null == autoPageTurningInterval
          ? _self.autoPageTurningInterval
          : autoPageTurningInterval // ignore: cast_nullable_to_non_nullable
              as int,
      orientation: null == orientation
          ? _self.orientation
          : orientation // ignore: cast_nullable_to_non_nullable
              as int,
      animationDuration: null == animationDuration
          ? _self.animationDuration
          : animationDuration // ignore: cast_nullable_to_non_nullable
              as int,
      autoPageTurning: null == autoPageTurning
          ? _self.autoPageTurning
          : autoPageTurning // ignore: cast_nullable_to_non_nullable
              as bool,
      autoPagingPageController: freezed == autoPagingPageController
          ? _self.autoPagingPageController
          : autoPagingPageController // ignore: cast_nullable_to_non_nullable
              as PageController?,
      autoPagingScrollController: freezed == autoPagingScrollController
          ? _self.autoPagingScrollController
          : autoPagingScrollController // ignore: cast_nullable_to_non_nullable
              as ItemScrollController?,
      selectDownload: null == selectDownload
          ? _self.selectDownload
          : selectDownload // ignore: cast_nullable_to_non_nullable
              as Map<int, bool>,
    ));
  }
}

/// Adds pattern-matching-related methods to [ComicStoreState].
extension ComicStoreStatePatterns on ComicStoreState {
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
    TResult Function(_ComicStoreState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ComicStoreState() when $default != null:
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
    TResult Function(_ComicStoreState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ComicStoreState():
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
    TResult? Function(_ComicStoreState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ComicStoreState() when $default != null:
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
            PicaComicItem comic,
            List<PicaEpsImages> epsList,
            PicaComments comments,
            DownloadTask? task,
            bool isLoading,
            bool isDrag,
            bool readModeMenu,
            bool barVisible,
            bool disableTap,
            bool useDarkBackground,
            int currentEps,
            int currentIndex,
            int readMode,
            int imageLayout,
            bool limitImageWidth,
            int tapThreshold,
            int autoPageTurningInterval,
            int orientation,
            int animationDuration,
            bool autoPageTurning,
            PageController? autoPagingPageController,
            ItemScrollController? autoPagingScrollController,
            Map<int, bool> selectDownload)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ComicStoreState() when $default != null:
        return $default(
            _that.comic,
            _that.epsList,
            _that.comments,
            _that.task,
            _that.isLoading,
            _that.isDrag,
            _that.readModeMenu,
            _that.barVisible,
            _that.disableTap,
            _that.useDarkBackground,
            _that.currentEps,
            _that.currentIndex,
            _that.readMode,
            _that.imageLayout,
            _that.limitImageWidth,
            _that.tapThreshold,
            _that.autoPageTurningInterval,
            _that.orientation,
            _that.animationDuration,
            _that.autoPageTurning,
            _that.autoPagingPageController,
            _that.autoPagingScrollController,
            _that.selectDownload);
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
            PicaComicItem comic,
            List<PicaEpsImages> epsList,
            PicaComments comments,
            DownloadTask? task,
            bool isLoading,
            bool isDrag,
            bool readModeMenu,
            bool barVisible,
            bool disableTap,
            bool useDarkBackground,
            int currentEps,
            int currentIndex,
            int readMode,
            int imageLayout,
            bool limitImageWidth,
            int tapThreshold,
            int autoPageTurningInterval,
            int orientation,
            int animationDuration,
            bool autoPageTurning,
            PageController? autoPagingPageController,
            ItemScrollController? autoPagingScrollController,
            Map<int, bool> selectDownload)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ComicStoreState():
        return $default(
            _that.comic,
            _that.epsList,
            _that.comments,
            _that.task,
            _that.isLoading,
            _that.isDrag,
            _that.readModeMenu,
            _that.barVisible,
            _that.disableTap,
            _that.useDarkBackground,
            _that.currentEps,
            _that.currentIndex,
            _that.readMode,
            _that.imageLayout,
            _that.limitImageWidth,
            _that.tapThreshold,
            _that.autoPageTurningInterval,
            _that.orientation,
            _that.animationDuration,
            _that.autoPageTurning,
            _that.autoPagingPageController,
            _that.autoPagingScrollController,
            _that.selectDownload);
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
            PicaComicItem comic,
            List<PicaEpsImages> epsList,
            PicaComments comments,
            DownloadTask? task,
            bool isLoading,
            bool isDrag,
            bool readModeMenu,
            bool barVisible,
            bool disableTap,
            bool useDarkBackground,
            int currentEps,
            int currentIndex,
            int readMode,
            int imageLayout,
            bool limitImageWidth,
            int tapThreshold,
            int autoPageTurningInterval,
            int orientation,
            int animationDuration,
            bool autoPageTurning,
            PageController? autoPagingPageController,
            ItemScrollController? autoPagingScrollController,
            Map<int, bool> selectDownload)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ComicStoreState() when $default != null:
        return $default(
            _that.comic,
            _that.epsList,
            _that.comments,
            _that.task,
            _that.isLoading,
            _that.isDrag,
            _that.readModeMenu,
            _that.barVisible,
            _that.disableTap,
            _that.useDarkBackground,
            _that.currentEps,
            _that.currentIndex,
            _that.readMode,
            _that.imageLayout,
            _that.limitImageWidth,
            _that.tapThreshold,
            _that.autoPageTurningInterval,
            _that.orientation,
            _that.animationDuration,
            _that.autoPageTurning,
            _that.autoPagingPageController,
            _that.autoPagingScrollController,
            _that.selectDownload);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ComicStoreState implements ComicStoreState {
  const _ComicStoreState(
      {required this.comic,
      final List<PicaEpsImages> epsList = const [],
      required this.comments,
      this.task,
      this.isLoading = false,
      this.isDrag = false,
      this.readModeMenu = false,
      this.barVisible = false,
      this.disableTap = false,
      this.useDarkBackground = false,
      this.currentEps = 0,
      this.currentIndex = 0,
      this.readMode = 0,
      this.imageLayout = 0,
      this.limitImageWidth = false,
      this.tapThreshold = 0,
      this.autoPageTurningInterval = 0,
      this.orientation = 0,
      this.animationDuration = 0,
      this.autoPageTurning = false,
      this.autoPagingPageController,
      this.autoPagingScrollController,
      final Map<int, bool> selectDownload = const {}})
      : _epsList = epsList,
        _selectDownload = selectDownload;

  @override
  final PicaComicItem comic;
  final List<PicaEpsImages> _epsList;
  @override
  @JsonKey()
  List<PicaEpsImages> get epsList {
    if (_epsList is EqualUnmodifiableListView) return _epsList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_epsList);
  }

  @override
  final PicaComments comments;
  @override
  final DownloadTask? task;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isDrag;
  @override
  @JsonKey()
  final bool readModeMenu;
  @override
  @JsonKey()
  final bool barVisible;
  @override
  @JsonKey()
  final bool disableTap;
  @override
  @JsonKey()
  final bool useDarkBackground;
  @override
  @JsonKey()
  final int currentEps;
  @override
  @JsonKey()
  final int currentIndex;
  @override
  @JsonKey()
  final int readMode;
  @override
  @JsonKey()
  final int imageLayout;
  @override
  @JsonKey()
  final bool limitImageWidth;
  @override
  @JsonKey()
  final int tapThreshold;
  @override
  @JsonKey()
  final int autoPageTurningInterval;
  @override
  @JsonKey()
  final int orientation;
  @override
  @JsonKey()
  final int animationDuration;
  @override
  @JsonKey()
  final bool autoPageTurning;
  @override
  final PageController? autoPagingPageController;
  @override
  final ItemScrollController? autoPagingScrollController;
  final Map<int, bool> _selectDownload;
  @override
  @JsonKey()
  Map<int, bool> get selectDownload {
    if (_selectDownload is EqualUnmodifiableMapView) return _selectDownload;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_selectDownload);
  }

  /// Create a copy of ComicStoreState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ComicStoreStateCopyWith<_ComicStoreState> get copyWith =>
      __$ComicStoreStateCopyWithImpl<_ComicStoreState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ComicStoreState &&
            (identical(other.comic, comic) || other.comic == comic) &&
            const DeepCollectionEquality().equals(other._epsList, _epsList) &&
            (identical(other.comments, comments) ||
                other.comments == comments) &&
            (identical(other.task, task) || other.task == task) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isDrag, isDrag) || other.isDrag == isDrag) &&
            (identical(other.readModeMenu, readModeMenu) ||
                other.readModeMenu == readModeMenu) &&
            (identical(other.barVisible, barVisible) ||
                other.barVisible == barVisible) &&
            (identical(other.disableTap, disableTap) ||
                other.disableTap == disableTap) &&
            (identical(other.useDarkBackground, useDarkBackground) ||
                other.useDarkBackground == useDarkBackground) &&
            (identical(other.currentEps, currentEps) ||
                other.currentEps == currentEps) &&
            (identical(other.currentIndex, currentIndex) ||
                other.currentIndex == currentIndex) &&
            (identical(other.readMode, readMode) ||
                other.readMode == readMode) &&
            (identical(other.imageLayout, imageLayout) ||
                other.imageLayout == imageLayout) &&
            (identical(other.limitImageWidth, limitImageWidth) ||
                other.limitImageWidth == limitImageWidth) &&
            (identical(other.tapThreshold, tapThreshold) ||
                other.tapThreshold == tapThreshold) &&
            (identical(
                    other.autoPageTurningInterval, autoPageTurningInterval) ||
                other.autoPageTurningInterval == autoPageTurningInterval) &&
            (identical(other.orientation, orientation) ||
                other.orientation == orientation) &&
            (identical(other.animationDuration, animationDuration) ||
                other.animationDuration == animationDuration) &&
            (identical(other.autoPageTurning, autoPageTurning) ||
                other.autoPageTurning == autoPageTurning) &&
            (identical(
                    other.autoPagingPageController, autoPagingPageController) ||
                other.autoPagingPageController == autoPagingPageController) &&
            (identical(other.autoPagingScrollController,
                    autoPagingScrollController) ||
                other.autoPagingScrollController ==
                    autoPagingScrollController) &&
            const DeepCollectionEquality()
                .equals(other._selectDownload, _selectDownload));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        comic,
        const DeepCollectionEquality().hash(_epsList),
        comments,
        task,
        isLoading,
        isDrag,
        readModeMenu,
        barVisible,
        disableTap,
        useDarkBackground,
        currentEps,
        currentIndex,
        readMode,
        imageLayout,
        limitImageWidth,
        tapThreshold,
        autoPageTurningInterval,
        orientation,
        animationDuration,
        autoPageTurning,
        autoPagingPageController,
        autoPagingScrollController,
        const DeepCollectionEquality().hash(_selectDownload)
      ]);

  @override
  String toString() {
    return 'ComicStoreState(comic: $comic, epsList: $epsList, comments: $comments, task: $task, isLoading: $isLoading, isDrag: $isDrag, readModeMenu: $readModeMenu, barVisible: $barVisible, disableTap: $disableTap, useDarkBackground: $useDarkBackground, currentEps: $currentEps, currentIndex: $currentIndex, readMode: $readMode, imageLayout: $imageLayout, limitImageWidth: $limitImageWidth, tapThreshold: $tapThreshold, autoPageTurningInterval: $autoPageTurningInterval, orientation: $orientation, animationDuration: $animationDuration, autoPageTurning: $autoPageTurning, autoPagingPageController: $autoPagingPageController, autoPagingScrollController: $autoPagingScrollController, selectDownload: $selectDownload)';
  }
}

/// @nodoc
abstract mixin class _$ComicStoreStateCopyWith<$Res>
    implements $ComicStoreStateCopyWith<$Res> {
  factory _$ComicStoreStateCopyWith(
          _ComicStoreState value, $Res Function(_ComicStoreState) _then) =
      __$ComicStoreStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {PicaComicItem comic,
      List<PicaEpsImages> epsList,
      PicaComments comments,
      DownloadTask? task,
      bool isLoading,
      bool isDrag,
      bool readModeMenu,
      bool barVisible,
      bool disableTap,
      bool useDarkBackground,
      int currentEps,
      int currentIndex,
      int readMode,
      int imageLayout,
      bool limitImageWidth,
      int tapThreshold,
      int autoPageTurningInterval,
      int orientation,
      int animationDuration,
      bool autoPageTurning,
      PageController? autoPagingPageController,
      ItemScrollController? autoPagingScrollController,
      Map<int, bool> selectDownload});
}

/// @nodoc
class __$ComicStoreStateCopyWithImpl<$Res>
    implements _$ComicStoreStateCopyWith<$Res> {
  __$ComicStoreStateCopyWithImpl(this._self, this._then);

  final _ComicStoreState _self;
  final $Res Function(_ComicStoreState) _then;

  /// Create a copy of ComicStoreState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? comic = null,
    Object? epsList = null,
    Object? comments = null,
    Object? task = freezed,
    Object? isLoading = null,
    Object? isDrag = null,
    Object? readModeMenu = null,
    Object? barVisible = null,
    Object? disableTap = null,
    Object? useDarkBackground = null,
    Object? currentEps = null,
    Object? currentIndex = null,
    Object? readMode = null,
    Object? imageLayout = null,
    Object? limitImageWidth = null,
    Object? tapThreshold = null,
    Object? autoPageTurningInterval = null,
    Object? orientation = null,
    Object? animationDuration = null,
    Object? autoPageTurning = null,
    Object? autoPagingPageController = freezed,
    Object? autoPagingScrollController = freezed,
    Object? selectDownload = null,
  }) {
    return _then(_ComicStoreState(
      comic: null == comic
          ? _self.comic
          : comic // ignore: cast_nullable_to_non_nullable
              as PicaComicItem,
      epsList: null == epsList
          ? _self._epsList
          : epsList // ignore: cast_nullable_to_non_nullable
              as List<PicaEpsImages>,
      comments: null == comments
          ? _self.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as PicaComments,
      task: freezed == task
          ? _self.task
          : task // ignore: cast_nullable_to_non_nullable
              as DownloadTask?,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isDrag: null == isDrag
          ? _self.isDrag
          : isDrag // ignore: cast_nullable_to_non_nullable
              as bool,
      readModeMenu: null == readModeMenu
          ? _self.readModeMenu
          : readModeMenu // ignore: cast_nullable_to_non_nullable
              as bool,
      barVisible: null == barVisible
          ? _self.barVisible
          : barVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      disableTap: null == disableTap
          ? _self.disableTap
          : disableTap // ignore: cast_nullable_to_non_nullable
              as bool,
      useDarkBackground: null == useDarkBackground
          ? _self.useDarkBackground
          : useDarkBackground // ignore: cast_nullable_to_non_nullable
              as bool,
      currentEps: null == currentEps
          ? _self.currentEps
          : currentEps // ignore: cast_nullable_to_non_nullable
              as int,
      currentIndex: null == currentIndex
          ? _self.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      readMode: null == readMode
          ? _self.readMode
          : readMode // ignore: cast_nullable_to_non_nullable
              as int,
      imageLayout: null == imageLayout
          ? _self.imageLayout
          : imageLayout // ignore: cast_nullable_to_non_nullable
              as int,
      limitImageWidth: null == limitImageWidth
          ? _self.limitImageWidth
          : limitImageWidth // ignore: cast_nullable_to_non_nullable
              as bool,
      tapThreshold: null == tapThreshold
          ? _self.tapThreshold
          : tapThreshold // ignore: cast_nullable_to_non_nullable
              as int,
      autoPageTurningInterval: null == autoPageTurningInterval
          ? _self.autoPageTurningInterval
          : autoPageTurningInterval // ignore: cast_nullable_to_non_nullable
              as int,
      orientation: null == orientation
          ? _self.orientation
          : orientation // ignore: cast_nullable_to_non_nullable
              as int,
      animationDuration: null == animationDuration
          ? _self.animationDuration
          : animationDuration // ignore: cast_nullable_to_non_nullable
              as int,
      autoPageTurning: null == autoPageTurning
          ? _self.autoPageTurning
          : autoPageTurning // ignore: cast_nullable_to_non_nullable
              as bool,
      autoPagingPageController: freezed == autoPagingPageController
          ? _self.autoPagingPageController
          : autoPagingPageController // ignore: cast_nullable_to_non_nullable
              as PageController?,
      autoPagingScrollController: freezed == autoPagingScrollController
          ? _self.autoPagingScrollController
          : autoPagingScrollController // ignore: cast_nullable_to_non_nullable
              as ItemScrollController?,
      selectDownload: null == selectDownload
          ? _self._selectDownload
          : selectDownload // ignore: cast_nullable_to_non_nullable
              as Map<int, bool>,
    ));
  }
}

// dart format on
