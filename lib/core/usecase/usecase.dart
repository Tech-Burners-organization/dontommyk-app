import 'package:equatable/equatable.dart';

abstract interface class UseCase<Result, Params> {
  Future<Result> call(Params params);
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => const [];
}
