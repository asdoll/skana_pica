/// Create a Pair
///
/// [M] is type of [left]
///
/// [V] is type of [right]
///
/// [left] and [right] with same pair can create a list
class Pair<M, V> {
  final M left;
  final V right;

  const Pair(
    this.left,
    this.right,
  );

  Pair.fromMap(Map<M, V> map, M key)
      : left = key,
        right = map[key] ?? (throw Exception("Pair not found"));

  /// deserialized pair
  (M, V) call() {
    return (left, right);
  }

  /// Pair to Map
  Map<M, V> get toMap {
    return <M, V>{
      left: right,
    };
  }

  /// Pair to MapEntry
  MapEntry<M, V> get toMapEntry {
    return MapEntry(
      left,
      right,
    );
  }

  /// reverse pair
  ///
  /// [left] will be the [right] and vice versa
  Pair<V, M> get reverse {
    return Pair<V, M>(
      right,
      left,
    );
  }

  /// copy with function
  ///
  /// [key] and [value] are optional
  ///
  /// if no value are supplied will take the instance value
  Pair<M, V> copyWith({
    M? key,
    V? value,
  }) {
    return Pair(
      key ?? this.left,
      value ?? this.right,
    );
  }

  /// mutate this pair into another pair with difference type
  ///
  /// [f] is your mutation function
  Pair<A, B> mutate<A, B>(Pair<A, B> Function(M key, V value) f) {
    return f(
      left,
      right,
    );
  }

  /// transform pair to new value with [A] type
  ///
  /// [f] is your function to transform into new value
  A transform<A>(A Function(M key, V value) f) {
    return f(
      left,
      right,
    );
  }

  @override
  String toString() {
    return "Pair($left, $right)";
  }

  @override
  bool operator ==(other) {
    if (other is! Pair) {
      return false;
    }
    return other.left.runtimeType == left.runtimeType &&
        other.left == left &&
        other.right.runtimeType == right.runtimeType &&
        other.right == right;
  }

  @override
  int get hashCode => Object.hash(
        left,
        right,
      );
}

extension PairExtension<T> on Pair<T, T> {
  List<T> get toList {
    assert(left.runtimeType == right.runtimeType,
        "key and value do not have same type");
    return [
      left,
      right,
    ];
  }
}
