// Base use case interface
abstract class UseCase<Out, In> {
  Future<Result<Out>> call(In params);
}

class NoParams {
  const NoParams();
}