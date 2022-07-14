part of 'internet_status_bloc.dart';

abstract class InternetStatusEvent extends Equatable {
  const InternetStatusEvent();

  @override
  List<Object?> get props => [];
}

class StartListening extends InternetStatusEvent {}

class OnChangedStatus extends InternetStatusEvent {
  final InternetStatusState status;

  const OnChangedStatus(this.status);

  @override
  List<Object> get props => [status];
}
