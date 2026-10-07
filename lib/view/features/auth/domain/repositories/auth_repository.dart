import 'package:tommy/core/result/result.dart';

abstract class AuthRepository {
  Future<Result<void>> login(String email, String password);
}
