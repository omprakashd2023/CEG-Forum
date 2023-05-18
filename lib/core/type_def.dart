import 'package:fpdart/fpdart.dart';

//Failure Class
import '../core/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;

typedef FutureVoid = FutureEither<void>;