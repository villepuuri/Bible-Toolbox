

/// Generic result type
/// Is used especially for handling exceptions
///
sealed class Result<T> {
  const Result();

  /// Creates a successful [Result]
  const factory Result.ok(T value) = Ok._;

  /// Creates an error [Result]
  const factory Result.error(Exception error) = Error._;


  // Helpers to get the state
  bool get isOk => this is Ok<T>;
  bool get isError => this is Error<T>;

  T get value => (this as Ok<T>).value;
  Exception get error => (this as Error<T>).error;

  Result get type => this;

}

/// A successful [Result]
final class Ok<T> extends Result<T> {
  const Ok._(this.value);

  @override
  final T value;

  T get getValue => value;

  @override
  String toString() => 'Result<$T>.ok($value)';
}

/// An error [Result]
final class Error<T> extends Result<T> {

  const Error._(this.error);

  @override
  final Exception error;

  @override
  String toString() => 'Result<$T>.error($error)';
}