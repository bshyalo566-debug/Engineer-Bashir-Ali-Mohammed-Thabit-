part of 'scanning_bloc.dart';

abstract class ScanningState extends Equatable {
  const ScanningState();

  @override
  List<Object?> get props => [];
}

class ScanningInitial extends ScanningState {}

class ScanningLoading extends ScanningState {}

class ScanningSuccess extends ScanningState {
  final LabelData labelData;

  const ScanningSuccess(this.labelData);

  @override
  List<Object?> get props => [labelData];
}

class ScanningError extends ScanningState {
  final String message;

  const ScanningError(this.message);

  @override
  List<Object?> get props => [message];
}
