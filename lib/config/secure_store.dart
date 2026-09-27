import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart' as upstream;
import 'package:flutter_secure_storage_ohos/flutter_secure_storage_ohos.dart'
    as ohos;

/// Secure storage for the login cookies.
///
/// HarmonyOS needs its own implementation. The upstream
/// `flutter_secure_storage` package resolves its platform options with a chain
/// of `Platform.isX` checks and throws
/// `UnsupportedError('unsupported_platform')` for anything it does not know -
/// OHOS included, which makes `readAll()` fail on startup. The CPF-Flutter fork
/// used here adds `Platform.operatingSystem == 'ohos'` to that chain.
///
/// Both packages talk to the same method channel
/// (`plugins.it_nomads.com/flutter_secure_storage`, see
/// `FlutterSecureStorageOhosPlugin.ets`), so only the option mapping differs -
/// which is why this file exposes just the three calls the app actually makes
/// and keeps the option classes out of the rest of the code.
abstract class SecureStore {
  /// Returns the implementation matching the current platform.
  factory SecureStore() =>
      Platform.isOhos ? OhosSecureStorage() : DefaultSecureStorage();

  Future<Map<String, String>> readAll();

  Future<void> write({required String key, required String? value});

  Future<void> deleteAll();
}

/// Android, iOS, macOS, Linux and Windows.
class DefaultSecureStorage implements SecureStore {
  final _storage = upstream.FlutterSecureStorage(
      iOptions: upstream.IOSOptions(
          accessibility: upstream.KeychainAccessibility.first_unlock),
      aOptions: upstream.AndroidOptions(encryptedSharedPreferences: true));

  @override
  Future<Map<String, String>> readAll() => _storage.readAll();

  @override
  Future<void> write({required String key, required String? value}) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> deleteAll() => _storage.deleteAll();
}

/// HarmonyOS. Default [ohos.OhosOptions] are fine: the data is AES encrypted
/// with a key held in the HarmonyOS keystore and no option has to be opted
/// into.
///
/// [readAll] deliberately does not call the plugin's own `readAll`, because that
/// one is broken in this fork. The native plugin stores every entry as
/// `<prefix>_<key>` (`FlutterSecureStorageOhosPlugin.getKeyFromCall`), but the
/// storage class recovers the key with `rawKey.split('_')[1]`
/// (`FlutterSecureStorage.ets:137`). For this app that turns
/// `picacg_account`, `picacg_password` and `picacg_token` into three writes to
/// a single `picacg` entry, so `readAll` yields `{'picacg': <last value>}` and
/// the keys the app looks for are never found - the session silently
/// disappeared on every restart.
///
/// `write`, `read` and `delete` all apply the prefix the same way, so they are
/// consistent with each other and only enumeration has to be worked around.
/// Keeping our own index of the stored keys does that.
class OhosSecureStorage implements SecureStore {
  final _storage = ohos.FlutterSecureStorage();

  /// Holds the newline separated list of keys written so far. The native
  /// `deleteAll` removes every entry carrying the storage prefix, so this is
  /// dropped along with the rest.
  static const _indexKey = '__keys__';

  /// Serialises the read-modify-write of the index, so two overlapping callers
  /// cannot each write back an index containing only their own key.
  Future<void> _tail = Future<void>.value();

  Future<T> _locked<T>(Future<T> Function() body) {
    final result = _tail.then((_) => body());
    _tail = result.then((_) {}, onError: (_) {});
    return result;
  }

  @override
  Future<Map<String, String>> readAll() => _locked(() async {
        final values = <String, String>{};
        for (final key in await _readKeys()) {
          final value = await _storage.read(key: key);
          // An empty result means the entry is gone or the cipher refused to
          // decrypt it (the plugin catches and answers ''). Nothing this app
          // stores is meaningfully empty, so report it as missing instead of
          // handing back a blank credential.
          if (value != null && value.isNotEmpty) {
            values[key] = value;
          }
        }
        return values;
      });

  @override
  Future<void> write({required String key, required String? value}) =>
      _locked(() async {
        final keys = await _readKeys();
        if (value == null) {
          await _storage.delete(key: key);
          if (keys.remove(key)) await _writeKeys(keys);
        } else {
          await _storage.write(key: key, value: value);
          if (keys.add(key)) await _writeKeys(keys);
        }
      });

  @override
  Future<void> deleteAll() => _locked(() => _storage.deleteAll());

  Future<Set<String>> _readKeys() async {
    final raw = await _storage.read(key: _indexKey);
    if (raw == null || raw.isEmpty) return <String>{};
    return raw.split('\n').where((key) => key.isNotEmpty).toSet();
  }

  Future<void> _writeKeys(Set<String> keys) async {
    if (keys.isEmpty) {
      await _storage.delete(key: _indexKey);
      return;
    }
    await _storage.write(key: _indexKey, value: keys.join('\n'));
  }
}
