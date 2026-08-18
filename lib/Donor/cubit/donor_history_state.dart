import 'package:charity_management/Donor/model/donor_history_model.dart';

// import 'donor_history_model.dart';

abstract class DonorHistoryState {
  const DonorHistoryState();
}

class DonorHistoryInitial extends DonorHistoryState {
  const DonorHistoryInitial();
}

class DonorHistoryLoading extends DonorHistoryState {
  const DonorHistoryLoading();
}

class DonorHistorySuccess extends DonorHistoryState {
  final DonorHistoryModel history;

  const DonorHistorySuccess({
    required this.history,
  });
}

class DonorHistoryFailure extends DonorHistoryState {
  final String message;

  const DonorHistoryFailure({
    required this.message,
  });
}