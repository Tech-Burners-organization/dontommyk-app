import 'package:bloc/bloc.dart';
import 'package:tommy/core/result/result.dart';
import 'package:tommy/core/usecase/usecase.dart';
import 'package:tommy/view/features/home/domain/usecases/get_home_data_usecase.dart';
import 'package:tommy/view/features/home/presentation/bloc/home_event.dart';
import 'package:tommy/view/features/home/presentation/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeDataUseCase getHomeDataUseCase;

  HomeBloc({required this.getHomeDataUseCase}) : super(const HomeInitial()) {
    on<FetchHomeDataEvent>(_onFetchHomeData);
  }

  Future<void> _onFetchHomeData(
    FetchHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());
    final result = await getHomeDataUseCase(const NoParams());

    switch (result) {
      case ResultSuccess(data: final homeData):
        emit(HomeLoaded(homeData));
      case ResultFailure(failure: final failure):
        emit(HomeError(failure.message));
    }
  }
}

