import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

type Result<T> = Either<Failure, T>;

extension ResultExtension<T> on Result<T> {
  T? getOrNull() => fold((_) => null, (r) => r);

  Failure? getFailureOrNull() => fold((l) => l, (_) => null);

  T getOrElse(T Function() orElse) => fold((_) => orElse(), (r) => r);

  bool get isSuccess => isRight();
  bool get isFailure => isLeft();
}
