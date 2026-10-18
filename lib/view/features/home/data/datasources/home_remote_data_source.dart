import 'package:tommy/core/network/api_service.dart';
import 'package:tommy/view/features/home/data/models/home_data_model.dart';

abstract class HomeRemoteDataSource {
  Future<HomeDataModel> getHomeData();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiService apiService;

  HomeRemoteDataSourceImpl(this.apiService);

  @override
  Future<HomeDataModel> getHomeData() async {
    final response = await apiService.getData<HomeDataModel>(
      '/employees/home',
      decoder: (json) => HomeDataModel.fromJson(
        json as Map<String, dynamic>,
      ),
    );
    return response.data;
  }
}

