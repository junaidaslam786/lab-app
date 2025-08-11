
sealed class Result<T> {
  const Result();
  R when<R>({required R Function(T) ok, required R Function(Object e) err});
}
class Ok<T> extends Result<T> {
  final T value;
  const Ok(this.value);
  @override
  R when<R>({required R Function(T) ok, required R Function(Object e) err}) => ok(value);
}
class Err<T> extends Result<T> {
  final Object error;
  const Err(this.error);
  @override
  R when<R>({required R Function(T) ok, required R Function(Object e) err}) => err(error);
}
