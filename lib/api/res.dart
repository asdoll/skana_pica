import 'package:skana_pica/util/log.dart';

class Res<T> {
  /// error info
  final String? errorMessage;

  String get errorMessageWithoutNull => errorMessage ?? "Unknown Error";

  /// data
  final T? _data;

  /// is there an error
  bool get error => errorMessage != null;

  /// whether succeed
  bool get success => !error;

  /// data
  ///
  /// must be called when no error happened
  T get data => _data ?? (throw Exception(errorMessage));

  /// get data, or null if there is an error
  T? get dataOrNull => _data;

  final dynamic subData;

  @override
  String toString() => _data.toString();

  Res.fromErrorRes(Res another, {this.subData})
      : _data = null,
        errorMessage = another.errorMessageWithoutNull {
    log.e(errorMessage);
  }

  /// network result
  const Res(this._data, {this.errorMessage, this.subData});

  Res.error(String err)
      : _data = null,
        subData = null,
        errorMessage = err {
    log.e(err);
  }
}
