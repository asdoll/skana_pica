// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'setting_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SettingState {
  String get defaultPage;
  String get mainOrientation;
  bool get highRefreshRate;
  String get language;
  bool get darkMenu;
  bool get langMenu;
  bool get homePageMenu;
  bool get orienMenu;

  /// Create a copy of SettingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SettingStateCopyWith<SettingState> get copyWith =>
      _$SettingStateCopyWithImpl<SettingState>(
          this as SettingState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SettingState &&
            (identical(other.defaultPage, defaultPage) ||
                other.defaultPage == defaultPage) &&
            (identical(other.mainOrientation, mainOrientation) ||
                other.mainOrientation == mainOrientation) &&
            (identical(other.highRefreshRate, highRefreshRate) ||
                other.highRefreshRate == highRefreshRate) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.darkMenu, darkMenu) ||
                other.darkMenu == darkMenu) &&
            (identical(other.langMenu, langMenu) ||
                other.langMenu == langMenu) &&
            (identical(other.homePageMenu, homePageMenu) ||
                other.homePageMenu == homePageMenu) &&
            (identical(other.orienMenu, orienMenu) ||
                other.orienMenu == orienMenu));
  }

  @override
  int get hashCode => Object.hash(runtimeType, defaultPage, mainOrientation,
      highRefreshRate, language, darkMenu, langMenu, homePageMenu, orienMenu);

  @override
  String toString() {
    return 'SettingState(defaultPage: $defaultPage, mainOrientation: $mainOrientation, highRefreshRate: $highRefreshRate, language: $language, darkMenu: $darkMenu, langMenu: $langMenu, homePageMenu: $homePageMenu, orienMenu: $orienMenu)';
  }
}

/// @nodoc
abstract mixin class $SettingStateCopyWith<$Res> {
  factory $SettingStateCopyWith(
          SettingState value, $Res Function(SettingState) _then) =
      _$SettingStateCopyWithImpl;
  @useResult
  $Res call(
      {String defaultPage,
      String mainOrientation,
      bool highRefreshRate,
      String language,
      bool darkMenu,
      bool langMenu,
      bool homePageMenu,
      bool orienMenu});
}

/// @nodoc
class _$SettingStateCopyWithImpl<$Res> implements $SettingStateCopyWith<$Res> {
  _$SettingStateCopyWithImpl(this._self, this._then);

  final SettingState _self;
  final $Res Function(SettingState) _then;

  /// Create a copy of SettingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? defaultPage = null,
    Object? mainOrientation = null,
    Object? highRefreshRate = null,
    Object? language = null,
    Object? darkMenu = null,
    Object? langMenu = null,
    Object? homePageMenu = null,
    Object? orienMenu = null,
  }) {
    return _then(_self.copyWith(
      defaultPage: null == defaultPage
          ? _self.defaultPage
          : defaultPage // ignore: cast_nullable_to_non_nullable
              as String,
      mainOrientation: null == mainOrientation
          ? _self.mainOrientation
          : mainOrientation // ignore: cast_nullable_to_non_nullable
              as String,
      highRefreshRate: null == highRefreshRate
          ? _self.highRefreshRate
          : highRefreshRate // ignore: cast_nullable_to_non_nullable
              as bool,
      language: null == language
          ? _self.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      darkMenu: null == darkMenu
          ? _self.darkMenu
          : darkMenu // ignore: cast_nullable_to_non_nullable
              as bool,
      langMenu: null == langMenu
          ? _self.langMenu
          : langMenu // ignore: cast_nullable_to_non_nullable
              as bool,
      homePageMenu: null == homePageMenu
          ? _self.homePageMenu
          : homePageMenu // ignore: cast_nullable_to_non_nullable
              as bool,
      orienMenu: null == orienMenu
          ? _self.orienMenu
          : orienMenu // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [SettingState].
extension SettingStatePatterns on SettingState {
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
    TResult Function(_SettingState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SettingState() when $default != null:
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
    TResult Function(_SettingState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SettingState():
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
    TResult? Function(_SettingState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SettingState() when $default != null:
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
            String defaultPage,
            String mainOrientation,
            bool highRefreshRate,
            String language,
            bool darkMenu,
            bool langMenu,
            bool homePageMenu,
            bool orienMenu)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SettingState() when $default != null:
        return $default(
            _that.defaultPage,
            _that.mainOrientation,
            _that.highRefreshRate,
            _that.language,
            _that.darkMenu,
            _that.langMenu,
            _that.homePageMenu,
            _that.orienMenu);
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
            String defaultPage,
            String mainOrientation,
            bool highRefreshRate,
            String language,
            bool darkMenu,
            bool langMenu,
            bool homePageMenu,
            bool orienMenu)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SettingState():
        return $default(
            _that.defaultPage,
            _that.mainOrientation,
            _that.highRefreshRate,
            _that.language,
            _that.darkMenu,
            _that.langMenu,
            _that.homePageMenu,
            _that.orienMenu);
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
            String defaultPage,
            String mainOrientation,
            bool highRefreshRate,
            String language,
            bool darkMenu,
            bool langMenu,
            bool homePageMenu,
            bool orienMenu)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SettingState() when $default != null:
        return $default(
            _that.defaultPage,
            _that.mainOrientation,
            _that.highRefreshRate,
            _that.language,
            _that.darkMenu,
            _that.langMenu,
            _that.homePageMenu,
            _that.orienMenu);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _SettingState implements SettingState {
  _SettingState(
      {required this.defaultPage,
      required this.mainOrientation,
      required this.highRefreshRate,
      required this.language,
      this.darkMenu = false,
      this.langMenu = false,
      this.homePageMenu = false,
      this.orienMenu = false});

  @override
  final String defaultPage;
  @override
  final String mainOrientation;
  @override
  final bool highRefreshRate;
  @override
  final String language;
  @override
  @JsonKey()
  final bool darkMenu;
  @override
  @JsonKey()
  final bool langMenu;
  @override
  @JsonKey()
  final bool homePageMenu;
  @override
  @JsonKey()
  final bool orienMenu;

  /// Create a copy of SettingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SettingStateCopyWith<_SettingState> get copyWith =>
      __$SettingStateCopyWithImpl<_SettingState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SettingState &&
            (identical(other.defaultPage, defaultPage) ||
                other.defaultPage == defaultPage) &&
            (identical(other.mainOrientation, mainOrientation) ||
                other.mainOrientation == mainOrientation) &&
            (identical(other.highRefreshRate, highRefreshRate) ||
                other.highRefreshRate == highRefreshRate) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.darkMenu, darkMenu) ||
                other.darkMenu == darkMenu) &&
            (identical(other.langMenu, langMenu) ||
                other.langMenu == langMenu) &&
            (identical(other.homePageMenu, homePageMenu) ||
                other.homePageMenu == homePageMenu) &&
            (identical(other.orienMenu, orienMenu) ||
                other.orienMenu == orienMenu));
  }

  @override
  int get hashCode => Object.hash(runtimeType, defaultPage, mainOrientation,
      highRefreshRate, language, darkMenu, langMenu, homePageMenu, orienMenu);

  @override
  String toString() {
    return 'SettingState(defaultPage: $defaultPage, mainOrientation: $mainOrientation, highRefreshRate: $highRefreshRate, language: $language, darkMenu: $darkMenu, langMenu: $langMenu, homePageMenu: $homePageMenu, orienMenu: $orienMenu)';
  }
}

/// @nodoc
abstract mixin class _$SettingStateCopyWith<$Res>
    implements $SettingStateCopyWith<$Res> {
  factory _$SettingStateCopyWith(
          _SettingState value, $Res Function(_SettingState) _then) =
      __$SettingStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String defaultPage,
      String mainOrientation,
      bool highRefreshRate,
      String language,
      bool darkMenu,
      bool langMenu,
      bool homePageMenu,
      bool orienMenu});
}

/// @nodoc
class __$SettingStateCopyWithImpl<$Res>
    implements _$SettingStateCopyWith<$Res> {
  __$SettingStateCopyWithImpl(this._self, this._then);

  final _SettingState _self;
  final $Res Function(_SettingState) _then;

  /// Create a copy of SettingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? defaultPage = null,
    Object? mainOrientation = null,
    Object? highRefreshRate = null,
    Object? language = null,
    Object? darkMenu = null,
    Object? langMenu = null,
    Object? homePageMenu = null,
    Object? orienMenu = null,
  }) {
    return _then(_SettingState(
      defaultPage: null == defaultPage
          ? _self.defaultPage
          : defaultPage // ignore: cast_nullable_to_non_nullable
              as String,
      mainOrientation: null == mainOrientation
          ? _self.mainOrientation
          : mainOrientation // ignore: cast_nullable_to_non_nullable
              as String,
      highRefreshRate: null == highRefreshRate
          ? _self.highRefreshRate
          : highRefreshRate // ignore: cast_nullable_to_non_nullable
              as bool,
      language: null == language
          ? _self.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      darkMenu: null == darkMenu
          ? _self.darkMenu
          : darkMenu // ignore: cast_nullable_to_non_nullable
              as bool,
      langMenu: null == langMenu
          ? _self.langMenu
          : langMenu // ignore: cast_nullable_to_non_nullable
              as bool,
      homePageMenu: null == homePageMenu
          ? _self.homePageMenu
          : homePageMenu // ignore: cast_nullable_to_non_nullable
              as bool,
      orienMenu: null == orienMenu
          ? _self.orienMenu
          : orienMenu // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
mixin _$MangaSettingState {
  int get picaStream;
  String get picaImageQuality;
  int get picaSearchMode;
  bool get picaPageViewMode;
  bool get autoCheckIn;
  String get preloadNumPages;
  bool get preloadDetailsPage;
  bool get mainTrigger;
  bool get streamMenu;
  bool get imageQualityMenu;
  bool get searchModeMenu;
  bool get preloadMenu;

  /// Create a copy of MangaSettingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MangaSettingStateCopyWith<MangaSettingState> get copyWith =>
      _$MangaSettingStateCopyWithImpl<MangaSettingState>(
          this as MangaSettingState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MangaSettingState &&
            (identical(other.picaStream, picaStream) ||
                other.picaStream == picaStream) &&
            (identical(other.picaImageQuality, picaImageQuality) ||
                other.picaImageQuality == picaImageQuality) &&
            (identical(other.picaSearchMode, picaSearchMode) ||
                other.picaSearchMode == picaSearchMode) &&
            (identical(other.picaPageViewMode, picaPageViewMode) ||
                other.picaPageViewMode == picaPageViewMode) &&
            (identical(other.autoCheckIn, autoCheckIn) ||
                other.autoCheckIn == autoCheckIn) &&
            (identical(other.preloadNumPages, preloadNumPages) ||
                other.preloadNumPages == preloadNumPages) &&
            (identical(other.preloadDetailsPage, preloadDetailsPage) ||
                other.preloadDetailsPage == preloadDetailsPage) &&
            (identical(other.mainTrigger, mainTrigger) ||
                other.mainTrigger == mainTrigger) &&
            (identical(other.streamMenu, streamMenu) ||
                other.streamMenu == streamMenu) &&
            (identical(other.imageQualityMenu, imageQualityMenu) ||
                other.imageQualityMenu == imageQualityMenu) &&
            (identical(other.searchModeMenu, searchModeMenu) ||
                other.searchModeMenu == searchModeMenu) &&
            (identical(other.preloadMenu, preloadMenu) ||
                other.preloadMenu == preloadMenu));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      picaStream,
      picaImageQuality,
      picaSearchMode,
      picaPageViewMode,
      autoCheckIn,
      preloadNumPages,
      preloadDetailsPage,
      mainTrigger,
      streamMenu,
      imageQualityMenu,
      searchModeMenu,
      preloadMenu);

  @override
  String toString() {
    return 'MangaSettingState(picaStream: $picaStream, picaImageQuality: $picaImageQuality, picaSearchMode: $picaSearchMode, picaPageViewMode: $picaPageViewMode, autoCheckIn: $autoCheckIn, preloadNumPages: $preloadNumPages, preloadDetailsPage: $preloadDetailsPage, mainTrigger: $mainTrigger, streamMenu: $streamMenu, imageQualityMenu: $imageQualityMenu, searchModeMenu: $searchModeMenu, preloadMenu: $preloadMenu)';
  }
}

/// @nodoc
abstract mixin class $MangaSettingStateCopyWith<$Res> {
  factory $MangaSettingStateCopyWith(
          MangaSettingState value, $Res Function(MangaSettingState) _then) =
      _$MangaSettingStateCopyWithImpl;
  @useResult
  $Res call(
      {int picaStream,
      String picaImageQuality,
      int picaSearchMode,
      bool picaPageViewMode,
      bool autoCheckIn,
      String preloadNumPages,
      bool preloadDetailsPage,
      bool mainTrigger,
      bool streamMenu,
      bool imageQualityMenu,
      bool searchModeMenu,
      bool preloadMenu});
}

/// @nodoc
class _$MangaSettingStateCopyWithImpl<$Res>
    implements $MangaSettingStateCopyWith<$Res> {
  _$MangaSettingStateCopyWithImpl(this._self, this._then);

  final MangaSettingState _self;
  final $Res Function(MangaSettingState) _then;

  /// Create a copy of MangaSettingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? picaStream = null,
    Object? picaImageQuality = null,
    Object? picaSearchMode = null,
    Object? picaPageViewMode = null,
    Object? autoCheckIn = null,
    Object? preloadNumPages = null,
    Object? preloadDetailsPage = null,
    Object? mainTrigger = null,
    Object? streamMenu = null,
    Object? imageQualityMenu = null,
    Object? searchModeMenu = null,
    Object? preloadMenu = null,
  }) {
    return _then(_self.copyWith(
      picaStream: null == picaStream
          ? _self.picaStream
          : picaStream // ignore: cast_nullable_to_non_nullable
              as int,
      picaImageQuality: null == picaImageQuality
          ? _self.picaImageQuality
          : picaImageQuality // ignore: cast_nullable_to_non_nullable
              as String,
      picaSearchMode: null == picaSearchMode
          ? _self.picaSearchMode
          : picaSearchMode // ignore: cast_nullable_to_non_nullable
              as int,
      picaPageViewMode: null == picaPageViewMode
          ? _self.picaPageViewMode
          : picaPageViewMode // ignore: cast_nullable_to_non_nullable
              as bool,
      autoCheckIn: null == autoCheckIn
          ? _self.autoCheckIn
          : autoCheckIn // ignore: cast_nullable_to_non_nullable
              as bool,
      preloadNumPages: null == preloadNumPages
          ? _self.preloadNumPages
          : preloadNumPages // ignore: cast_nullable_to_non_nullable
              as String,
      preloadDetailsPage: null == preloadDetailsPage
          ? _self.preloadDetailsPage
          : preloadDetailsPage // ignore: cast_nullable_to_non_nullable
              as bool,
      mainTrigger: null == mainTrigger
          ? _self.mainTrigger
          : mainTrigger // ignore: cast_nullable_to_non_nullable
              as bool,
      streamMenu: null == streamMenu
          ? _self.streamMenu
          : streamMenu // ignore: cast_nullable_to_non_nullable
              as bool,
      imageQualityMenu: null == imageQualityMenu
          ? _self.imageQualityMenu
          : imageQualityMenu // ignore: cast_nullable_to_non_nullable
              as bool,
      searchModeMenu: null == searchModeMenu
          ? _self.searchModeMenu
          : searchModeMenu // ignore: cast_nullable_to_non_nullable
              as bool,
      preloadMenu: null == preloadMenu
          ? _self.preloadMenu
          : preloadMenu // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [MangaSettingState].
extension MangaSettingStatePatterns on MangaSettingState {
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
    TResult Function(_MangaSettingState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MangaSettingState() when $default != null:
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
    TResult Function(_MangaSettingState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MangaSettingState():
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
    TResult? Function(_MangaSettingState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MangaSettingState() when $default != null:
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
            int picaStream,
            String picaImageQuality,
            int picaSearchMode,
            bool picaPageViewMode,
            bool autoCheckIn,
            String preloadNumPages,
            bool preloadDetailsPage,
            bool mainTrigger,
            bool streamMenu,
            bool imageQualityMenu,
            bool searchModeMenu,
            bool preloadMenu)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MangaSettingState() when $default != null:
        return $default(
            _that.picaStream,
            _that.picaImageQuality,
            _that.picaSearchMode,
            _that.picaPageViewMode,
            _that.autoCheckIn,
            _that.preloadNumPages,
            _that.preloadDetailsPage,
            _that.mainTrigger,
            _that.streamMenu,
            _that.imageQualityMenu,
            _that.searchModeMenu,
            _that.preloadMenu);
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
            int picaStream,
            String picaImageQuality,
            int picaSearchMode,
            bool picaPageViewMode,
            bool autoCheckIn,
            String preloadNumPages,
            bool preloadDetailsPage,
            bool mainTrigger,
            bool streamMenu,
            bool imageQualityMenu,
            bool searchModeMenu,
            bool preloadMenu)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MangaSettingState():
        return $default(
            _that.picaStream,
            _that.picaImageQuality,
            _that.picaSearchMode,
            _that.picaPageViewMode,
            _that.autoCheckIn,
            _that.preloadNumPages,
            _that.preloadDetailsPage,
            _that.mainTrigger,
            _that.streamMenu,
            _that.imageQualityMenu,
            _that.searchModeMenu,
            _that.preloadMenu);
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
            int picaStream,
            String picaImageQuality,
            int picaSearchMode,
            bool picaPageViewMode,
            bool autoCheckIn,
            String preloadNumPages,
            bool preloadDetailsPage,
            bool mainTrigger,
            bool streamMenu,
            bool imageQualityMenu,
            bool searchModeMenu,
            bool preloadMenu)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MangaSettingState() when $default != null:
        return $default(
            _that.picaStream,
            _that.picaImageQuality,
            _that.picaSearchMode,
            _that.picaPageViewMode,
            _that.autoCheckIn,
            _that.preloadNumPages,
            _that.preloadDetailsPage,
            _that.mainTrigger,
            _that.streamMenu,
            _that.imageQualityMenu,
            _that.searchModeMenu,
            _that.preloadMenu);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MangaSettingState implements MangaSettingState {
  _MangaSettingState(
      {required this.picaStream,
      required this.picaImageQuality,
      required this.picaSearchMode,
      required this.picaPageViewMode,
      required this.autoCheckIn,
      required this.preloadNumPages,
      required this.preloadDetailsPage,
      this.mainTrigger = false,
      this.streamMenu = false,
      this.imageQualityMenu = false,
      this.searchModeMenu = false,
      this.preloadMenu = false});

  @override
  final int picaStream;
  @override
  final String picaImageQuality;
  @override
  final int picaSearchMode;
  @override
  final bool picaPageViewMode;
  @override
  final bool autoCheckIn;
  @override
  final String preloadNumPages;
  @override
  final bool preloadDetailsPage;
  @override
  @JsonKey()
  final bool mainTrigger;
  @override
  @JsonKey()
  final bool streamMenu;
  @override
  @JsonKey()
  final bool imageQualityMenu;
  @override
  @JsonKey()
  final bool searchModeMenu;
  @override
  @JsonKey()
  final bool preloadMenu;

  /// Create a copy of MangaSettingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MangaSettingStateCopyWith<_MangaSettingState> get copyWith =>
      __$MangaSettingStateCopyWithImpl<_MangaSettingState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MangaSettingState &&
            (identical(other.picaStream, picaStream) ||
                other.picaStream == picaStream) &&
            (identical(other.picaImageQuality, picaImageQuality) ||
                other.picaImageQuality == picaImageQuality) &&
            (identical(other.picaSearchMode, picaSearchMode) ||
                other.picaSearchMode == picaSearchMode) &&
            (identical(other.picaPageViewMode, picaPageViewMode) ||
                other.picaPageViewMode == picaPageViewMode) &&
            (identical(other.autoCheckIn, autoCheckIn) ||
                other.autoCheckIn == autoCheckIn) &&
            (identical(other.preloadNumPages, preloadNumPages) ||
                other.preloadNumPages == preloadNumPages) &&
            (identical(other.preloadDetailsPage, preloadDetailsPage) ||
                other.preloadDetailsPage == preloadDetailsPage) &&
            (identical(other.mainTrigger, mainTrigger) ||
                other.mainTrigger == mainTrigger) &&
            (identical(other.streamMenu, streamMenu) ||
                other.streamMenu == streamMenu) &&
            (identical(other.imageQualityMenu, imageQualityMenu) ||
                other.imageQualityMenu == imageQualityMenu) &&
            (identical(other.searchModeMenu, searchModeMenu) ||
                other.searchModeMenu == searchModeMenu) &&
            (identical(other.preloadMenu, preloadMenu) ||
                other.preloadMenu == preloadMenu));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      picaStream,
      picaImageQuality,
      picaSearchMode,
      picaPageViewMode,
      autoCheckIn,
      preloadNumPages,
      preloadDetailsPage,
      mainTrigger,
      streamMenu,
      imageQualityMenu,
      searchModeMenu,
      preloadMenu);

  @override
  String toString() {
    return 'MangaSettingState(picaStream: $picaStream, picaImageQuality: $picaImageQuality, picaSearchMode: $picaSearchMode, picaPageViewMode: $picaPageViewMode, autoCheckIn: $autoCheckIn, preloadNumPages: $preloadNumPages, preloadDetailsPage: $preloadDetailsPage, mainTrigger: $mainTrigger, streamMenu: $streamMenu, imageQualityMenu: $imageQualityMenu, searchModeMenu: $searchModeMenu, preloadMenu: $preloadMenu)';
  }
}

/// @nodoc
abstract mixin class _$MangaSettingStateCopyWith<$Res>
    implements $MangaSettingStateCopyWith<$Res> {
  factory _$MangaSettingStateCopyWith(
          _MangaSettingState value, $Res Function(_MangaSettingState) _then) =
      __$MangaSettingStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int picaStream,
      String picaImageQuality,
      int picaSearchMode,
      bool picaPageViewMode,
      bool autoCheckIn,
      String preloadNumPages,
      bool preloadDetailsPage,
      bool mainTrigger,
      bool streamMenu,
      bool imageQualityMenu,
      bool searchModeMenu,
      bool preloadMenu});
}

/// @nodoc
class __$MangaSettingStateCopyWithImpl<$Res>
    implements _$MangaSettingStateCopyWith<$Res> {
  __$MangaSettingStateCopyWithImpl(this._self, this._then);

  final _MangaSettingState _self;
  final $Res Function(_MangaSettingState) _then;

  /// Create a copy of MangaSettingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? picaStream = null,
    Object? picaImageQuality = null,
    Object? picaSearchMode = null,
    Object? picaPageViewMode = null,
    Object? autoCheckIn = null,
    Object? preloadNumPages = null,
    Object? preloadDetailsPage = null,
    Object? mainTrigger = null,
    Object? streamMenu = null,
    Object? imageQualityMenu = null,
    Object? searchModeMenu = null,
    Object? preloadMenu = null,
  }) {
    return _then(_MangaSettingState(
      picaStream: null == picaStream
          ? _self.picaStream
          : picaStream // ignore: cast_nullable_to_non_nullable
              as int,
      picaImageQuality: null == picaImageQuality
          ? _self.picaImageQuality
          : picaImageQuality // ignore: cast_nullable_to_non_nullable
              as String,
      picaSearchMode: null == picaSearchMode
          ? _self.picaSearchMode
          : picaSearchMode // ignore: cast_nullable_to_non_nullable
              as int,
      picaPageViewMode: null == picaPageViewMode
          ? _self.picaPageViewMode
          : picaPageViewMode // ignore: cast_nullable_to_non_nullable
              as bool,
      autoCheckIn: null == autoCheckIn
          ? _self.autoCheckIn
          : autoCheckIn // ignore: cast_nullable_to_non_nullable
              as bool,
      preloadNumPages: null == preloadNumPages
          ? _self.preloadNumPages
          : preloadNumPages // ignore: cast_nullable_to_non_nullable
              as String,
      preloadDetailsPage: null == preloadDetailsPage
          ? _self.preloadDetailsPage
          : preloadDetailsPage // ignore: cast_nullable_to_non_nullable
              as bool,
      mainTrigger: null == mainTrigger
          ? _self.mainTrigger
          : mainTrigger // ignore: cast_nullable_to_non_nullable
              as bool,
      streamMenu: null == streamMenu
          ? _self.streamMenu
          : streamMenu // ignore: cast_nullable_to_non_nullable
              as bool,
      imageQualityMenu: null == imageQualityMenu
          ? _self.imageQualityMenu
          : imageQualityMenu // ignore: cast_nullable_to_non_nullable
              as bool,
      searchModeMenu: null == searchModeMenu
          ? _self.searchModeMenu
          : searchModeMenu // ignore: cast_nullable_to_non_nullable
              as bool,
      preloadMenu: null == preloadMenu
          ? _self.preloadMenu
          : preloadMenu // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
mixin _$CacheState {
  String get cachePeriod;
  bool get cacheMenu;

  /// Create a copy of CacheState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CacheStateCopyWith<CacheState> get copyWith =>
      _$CacheStateCopyWithImpl<CacheState>(this as CacheState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CacheState &&
            (identical(other.cachePeriod, cachePeriod) ||
                other.cachePeriod == cachePeriod) &&
            (identical(other.cacheMenu, cacheMenu) ||
                other.cacheMenu == cacheMenu));
  }

  @override
  int get hashCode => Object.hash(runtimeType, cachePeriod, cacheMenu);

  @override
  String toString() {
    return 'CacheState(cachePeriod: $cachePeriod, cacheMenu: $cacheMenu)';
  }
}

/// @nodoc
abstract mixin class $CacheStateCopyWith<$Res> {
  factory $CacheStateCopyWith(
          CacheState value, $Res Function(CacheState) _then) =
      _$CacheStateCopyWithImpl;
  @useResult
  $Res call({String cachePeriod, bool cacheMenu});
}

/// @nodoc
class _$CacheStateCopyWithImpl<$Res> implements $CacheStateCopyWith<$Res> {
  _$CacheStateCopyWithImpl(this._self, this._then);

  final CacheState _self;
  final $Res Function(CacheState) _then;

  /// Create a copy of CacheState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cachePeriod = null,
    Object? cacheMenu = null,
  }) {
    return _then(_self.copyWith(
      cachePeriod: null == cachePeriod
          ? _self.cachePeriod
          : cachePeriod // ignore: cast_nullable_to_non_nullable
              as String,
      cacheMenu: null == cacheMenu
          ? _self.cacheMenu
          : cacheMenu // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [CacheState].
extension CacheStatePatterns on CacheState {
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
    TResult Function(_CacheState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CacheState() when $default != null:
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
    TResult Function(_CacheState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CacheState():
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
    TResult? Function(_CacheState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CacheState() when $default != null:
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
    TResult Function(String cachePeriod, bool cacheMenu)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CacheState() when $default != null:
        return $default(_that.cachePeriod, _that.cacheMenu);
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
    TResult Function(String cachePeriod, bool cacheMenu) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CacheState():
        return $default(_that.cachePeriod, _that.cacheMenu);
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
    TResult? Function(String cachePeriod, bool cacheMenu)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CacheState() when $default != null:
        return $default(_that.cachePeriod, _that.cacheMenu);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _CacheState implements CacheState {
  _CacheState({required this.cachePeriod, this.cacheMenu = false});

  @override
  final String cachePeriod;
  @override
  @JsonKey()
  final bool cacheMenu;

  /// Create a copy of CacheState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CacheStateCopyWith<_CacheState> get copyWith =>
      __$CacheStateCopyWithImpl<_CacheState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CacheState &&
            (identical(other.cachePeriod, cachePeriod) ||
                other.cachePeriod == cachePeriod) &&
            (identical(other.cacheMenu, cacheMenu) ||
                other.cacheMenu == cacheMenu));
  }

  @override
  int get hashCode => Object.hash(runtimeType, cachePeriod, cacheMenu);

  @override
  String toString() {
    return 'CacheState(cachePeriod: $cachePeriod, cacheMenu: $cacheMenu)';
  }
}

/// @nodoc
abstract mixin class _$CacheStateCopyWith<$Res>
    implements $CacheStateCopyWith<$Res> {
  factory _$CacheStateCopyWith(
          _CacheState value, $Res Function(_CacheState) _then) =
      __$CacheStateCopyWithImpl;
  @override
  @useResult
  $Res call({String cachePeriod, bool cacheMenu});
}

/// @nodoc
class __$CacheStateCopyWithImpl<$Res> implements _$CacheStateCopyWith<$Res> {
  __$CacheStateCopyWithImpl(this._self, this._then);

  final _CacheState _self;
  final $Res Function(_CacheState) _then;

  /// Create a copy of CacheState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? cachePeriod = null,
    Object? cacheMenu = null,
  }) {
    return _then(_CacheState(
      cachePeriod: null == cachePeriod
          ? _self.cachePeriod
          : cachePeriod // ignore: cast_nullable_to_non_nullable
              as String,
      cacheMenu: null == cacheMenu
          ? _self.cacheMenu
          : cacheMenu // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
