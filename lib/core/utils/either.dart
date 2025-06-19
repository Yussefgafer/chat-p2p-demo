/// Demo Either implementation - simplified version for demo purposes
/// In production, use proper packages like dartz or fpdart
abstract class Either<L, R> {
  const Either();

  /// Returns true if this is a Left value
  bool get isLeft;

  /// Returns true if this is a Right value
  bool get isRight;

  /// Fold the Either into a single value
  T fold<T>(T Function(L left) ifLeft, T Function(R right) ifRight);

  /// Map the right value
  Either<L, T> map<T>(T Function(R right) f);

  /// FlatMap the right value
  Either<L, T> flatMap<T>(Either<L, T> Function(R right) f);

  /// Get the right value or throw
  R getOrElse(R Function() orElse);

  /// Get the right value or null
  R? get rightOrNull;

  /// Get the left value or null
  L? get leftOrNull;
}

/// Left side of Either (typically for errors)
class Left<L, R> extends Either<L, R> {
  final L value;

  const Left(this.value);

  @override
  bool get isLeft => true;

  @override
  bool get isRight => false;

  @override
  T fold<T>(T Function(L left) ifLeft, T Function(R right) ifRight) {
    return ifLeft(value);
  }

  @override
  Either<L, T> map<T>(T Function(R right) f) {
    return Left<L, T>(value);
  }

  @override
  Either<L, T> flatMap<T>(Either<L, T> Function(R right) f) {
    return Left<L, T>(value);
  }

  @override
  R getOrElse(R Function() orElse) {
    return orElse();
  }

  @override
  R? get rightOrNull => null;

  @override
  L? get leftOrNull => value;

  @override
  bool operator ==(Object other) {
    return other is Left<L, R> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Left($value)';
}

/// Right side of Either (typically for success values)
class Right<L, R> extends Either<L, R> {
  final R value;

  const Right(this.value);

  @override
  bool get isLeft => false;

  @override
  bool get isRight => true;

  @override
  T fold<T>(T Function(L left) ifLeft, T Function(R right) ifRight) {
    return ifRight(value);
  }

  @override
  Either<L, T> map<T>(T Function(R right) f) {
    return Right<L, T>(f(value));
  }

  @override
  Either<L, T> flatMap<T>(Either<L, T> Function(R right) f) {
    return f(value);
  }

  @override
  R getOrElse(R Function() orElse) {
    return value;
  }

  @override
  R? get rightOrNull => value;

  @override
  L? get leftOrNull => null;

  @override
  bool operator ==(Object other) {
    return other is Right<L, R> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Right($value)';
}
