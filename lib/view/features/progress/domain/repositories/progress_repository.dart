import 'package:tommy/core/result/result.dart';
import 'package:tommy/view/features/progress/data/models/progress_model.dart';

abstract class ProgressRepository {
  Future<Result<ProgressDataModel>> getProgress({required String period});
}

