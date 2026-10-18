import 'package:tommy/core/network/api_service.dart';
import 'package:tommy/view/features/progress/data/models/progress_model.dart';

abstract class ProgressRemoteDataSource {
  Future<ProgressDataModel> getProgress({required String period});
}

class ProgressRemoteDataSourceImpl implements ProgressRemoteDataSource {
  final ApiService apiService;

  ProgressRemoteDataSourceImpl(this.apiService);

  @override
  Future<ProgressDataModel> getProgress({required String period}) async {
    final response = await apiService.getData<ProgressDataModel>(
      '/employees/progress',
      query: {'period': period},
      decoder: (json) {
        final map = json as Map<String, dynamic>;
        final data = map['data'] is Map<String, dynamic>
            ? map['data'] as Map<String, dynamic>
            : map;
        return ProgressDataModel.fromJson(data);
      },
    );
    return response.data;
  }
}

