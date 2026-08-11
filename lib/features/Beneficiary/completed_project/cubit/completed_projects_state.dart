import '../model/completed_project_model.dart';

sealed class CompletedProjectsState {
  const CompletedProjectsState();
}

class CompletedProjectsInitial
    extends CompletedProjectsState {
  const CompletedProjectsInitial();
}

class CompletedProjectsLoading
    extends CompletedProjectsState {
  const CompletedProjectsLoading();
}

class CompletedProjectsSuccess
    extends CompletedProjectsState {
  const CompletedProjectsSuccess(
    this.projects,
  );

  final List<CompletedProjectModel>
      projects;
}

class CompletedProjectsFailure
    extends CompletedProjectsState {
  const CompletedProjectsFailure(
    this.message,
  );

  final String message;
}