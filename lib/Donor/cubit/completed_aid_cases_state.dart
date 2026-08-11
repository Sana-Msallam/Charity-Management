import '../model/completed_aid_cases_model.dart';

abstract class CompletedAidCasesState {}

class CompletedAidCasesInitialState
    extends CompletedAidCasesState {}

class CompletedAidCasesLoadingState
    extends CompletedAidCasesState {}

class CompletedAidCasesSuccessState
    extends CompletedAidCasesState {
  final CompletedAidCasesModel data;

  CompletedAidCasesSuccessState(this.data);
}

class CompletedAidCasesErrorState
    extends CompletedAidCasesState {
  final String errorMessage;

  CompletedAidCasesErrorState(this.errorMessage);
}