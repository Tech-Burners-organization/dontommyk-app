import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tommy/core/result/result.dart';
import 'package:tommy/view/features/profile/data/models/legal_content_model.dart';
import 'package:tommy/view/features/profile/domain/usecases/get_legal_content_usecase.dart';

sealed class LegalContentState extends Equatable {
  const LegalContentState();

  @override
  List<Object?> get props => [];
}

class LegalContentInitial extends LegalContentState {
  const LegalContentInitial();
}

class LegalContentLoading extends LegalContentState {
  const LegalContentLoading();
}

class LegalContentLoaded extends LegalContentState {
  final LegalContentModel content;

  const LegalContentLoaded(this.content);

  @override
  List<Object?> get props => [content];
}

class LegalContentError extends LegalContentState {
  final String message;

  const LegalContentError(this.message);

  @override
  List<Object?> get props => [message];
}

class LegalContentCubit extends Cubit<LegalContentState> {
  final GetLegalContentUseCase getLegalContentUseCase;

  LegalContentCubit({required this.getLegalContentUseCase})
      : super(const LegalContentInitial());

  Future<void> fetchContent(String slug) async {
    emit(const LegalContentLoading());

    final result = await getLegalContentUseCase(slug);

    switch (result) {
      case ResultSuccess(data: final content):
        emit(LegalContentLoaded(content));
      case ResultFailure(failure: final failure):
        emit(LegalContentError(failure.message));
    }
  }
}

