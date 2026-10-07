import 'package:tommy/core/errors/failure_mapper.dart';
import 'package:tommy/core/result/result.dart';
import 'package:tommy/core/utils/prefs_helper.dart';
import 'package:tommy/view/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:tommy/view/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<void>> login(String email, String password) async {
    try {
      final loginData = await remoteDataSource.login(email, password);
      await PrefsHelper.setString('token', loginData.accessToken);
      // await PrefsHelper.setString('refreshToken', loginData.refreshToken);
      return const ResultSuccess(null);
    } catch (e) {
      return ResultFailure(FailureMapper.from(e));
    }
  }
}
