import '../model/zakat_result_model.dart';

sealed class ZakatState {
  const ZakatState();
}

class ZakatInitial extends ZakatState {
  const ZakatInitial();
}

class ZakatLoading extends ZakatState {
  const ZakatLoading();
}

class ZakatSuccess extends ZakatState {
  const ZakatSuccess({
    required this.result,
  });

  final ZakatResultModel result;
}

class ZakatFailure extends ZakatState {
  const ZakatFailure({
    required this.message,
  });

  final String message;
}