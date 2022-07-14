import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tdd_reso_coder/core/network/network_info.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'internet_status_event.dart';
part 'internet_status_state.dart';

class InternetStatusBloc extends Bloc<InternetStatusEvent, InternetStatusState> {
  final NetworkInfo networkInfo;

  late StreamSubscription _subscription;

  InternetStatusBloc({required this.networkInfo}) : super(InternetStatusInitial()) {
    on<StartListening>(_mapStartListeningToState);
    on<OnChangedStatus>(_mapOnChangedStatus);
  }

  FutureOr<void> _mapStartListeningToState(
    StartListening event,
    Emitter<InternetStatusState> emit,
  ) async {
    _subscription = networkInfo.stream.listen((event) {
      add(OnChangedStatus(event == InternetConnectionStatus.disconnected
          ? InternetStatusDisconnected()
          : InternetStatusConnected()));
    });
  }

  FutureOr<void> _mapOnChangedStatus(
    OnChangedStatus event,
    Emitter<InternetStatusState> emit,
  ) async {
    emit(event.status);
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
