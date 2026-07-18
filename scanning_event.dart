part of 'scanning_bloc.dart';

abstract class ScanningEvent extends Equatable {
  const ScanningEvent();

  @override
  List<Object?> get props => [];
}

class ProcessImageEvent extends ScanningEvent {
  final String imagePath;

  const ProcessImageEvent(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

class ProcessCameraFrameEvent extends ScanningEvent {
  final String imagePath;

  const ProcessCameraFrameEvent(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

class ClearScanningResultEvent extends ScanningEvent {
  const ClearScanningResultEvent();
}

class UpdateLabelDataEvent extends ScanningEvent {
  final LabelData labelData;

  const UpdateLabelDataEvent(this.labelData);

  @override
  List<Object?> get props => [labelData];
}
