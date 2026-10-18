import 'package:tommy/core/result/result.dart';
import 'package:tommy/view/features/home/data/models/home_data_model.dart';

abstract class HomeRepository {
  Future<Result<HomeDataModel>> getHomeData();
}

