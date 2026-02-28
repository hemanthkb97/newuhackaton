import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountdownCubit extends Cubit<int> {
  Timer? _timer;

  CountdownCubit() : super(3);

  void start() {
    _timer?.cancel();
    emit(3);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state > 1) {
        emit(state - 1);
      } else {
        _timer?.cancel();
        emit(0);
      }
    });
  }

  void stop() {
    _timer?.cancel();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
