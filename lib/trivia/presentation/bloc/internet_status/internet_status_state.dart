part of 'internet_status_bloc.dart';

abstract class InternetStatusState extends Equatable {
  const InternetStatusState();

  @override
  List<Object?> get props => [];
}

class InternetStatusInitial extends InternetStatusState {}

class InternetStatusConnected extends InternetStatusState {}

class InternetStatusDisconnected extends InternetStatusState {}
