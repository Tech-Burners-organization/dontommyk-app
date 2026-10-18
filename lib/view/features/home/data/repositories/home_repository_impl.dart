import 'package:tommy/core/errors/failure_mapper.dart';
import 'package:tommy/core/result/result.dart';
import 'package:tommy/core/utils/prefs_helper.dart';
import 'package:tommy/view/features/home/data/datasources/home_remote_data_source.dart';
import 'package:tommy/view/features/home/data/models/home_data_model.dart';
import 'package:tommy/view/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<HomeDataModel>> getHomeData() async {
    try {
      final homeData = await remoteDataSource.getHomeData();

      // Sync user profile with local cache
      if (homeData.profile.fullName.isNotEmpty) {
        await PrefsHelper.setString('name', homeData.profile.fullName);
      }
      if (homeData.profile.designation.isNotEmpty) {
        await PrefsHelper.setString('role', homeData.profile.designation);
      }
      if (homeData.profile.profilePhoto.isNotEmpty) {
        await PrefsHelper.setString(
          'profileImage',
          homeData.profile.profilePhoto,
        );
      }

      // Sync onboarding flags if returned
      if (homeData.onboarding != null) {
        await PrefsHelper.setProfileCompleted(
          homeData.onboarding!.isProfileCompleted,
        );
        await PrefsHelper.setInitialAssessmentCompleted(
          homeData.onboarding!.isInitialAssessmentCompleted,
        );
      }

      return ResultSuccess(homeData);
    } catch (e) {
      return ResultFailure(FailureMapper.from(e));
    }
  }
}

