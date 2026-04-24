sealed class Result<T> {
  const Result();

  R when<R>({
    required R Function(T value) success,
    required R Function(String message) failure,
  }) {
    return switch (this) {
      Success<T>(value: final value) => success(value),
      Failure<T>(message: final message) => failure(message),
    };
  }
}

class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

class Failure<T> extends Result<T> {
  const Failure(this.message);

  final String message;
}
