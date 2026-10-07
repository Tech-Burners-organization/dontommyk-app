import 'package:tommy/core/network/api_service.dart';
import 'package:tommy/view/features/auth/data/models/login_response.dart';

abstract class AuthRemoteDataSource {
  Future<LoginData> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService apiService;

  AuthRemoteDataSourceImpl(this.apiService);

  @override
  Future<LoginData> login(String email, String password) async {
    final response = await apiService.postData<LoginData>(
      '/auth/login',
      {
        'email': email,
        'password': password,
      },
      decoder: (json) => LoginData.fromJson(json as Map<String, dynamic>),
    );
    return response.data;
  }
}
