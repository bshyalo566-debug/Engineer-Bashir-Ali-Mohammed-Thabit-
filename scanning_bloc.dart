import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/label_data.dart';
import '../../domain/usecases/process_image_usecase.dart';

part 'scanning_event.dart';
part 'scanning_state.dart';

class ScanningBloc extends Bloc<ScanningEvent, ScanningState> {
  final ProcessImageUseCase processImageUseCase;

  ScanningBloc({required this.processImageUseCase}) : super(ScanningInitial()) {
    on<ProcessImageEvent>(_onProcessImage);
    on<ProcessCameraFrameEvent>(_onProcessCameraFrame);
    on<ClearScanningResultEvent>(_onClearResult);
    on<UpdateLabelDataEvent>(_onUpdateLabelData);
  }

  Future<void> _onProcessImage(
    ProcessImageEvent event,
    Emitter<ScanningState> emit,
  ) async {
    emit(ScanningLoading());

    final result = await processImageUseCase(
      ProcessImageParams(imagePath: event.imagePath),
    );

    result.fold(
      (failure) {
        AppLogger.error('Scanning failed: ${failure.message}');
        emit(ScanningError(failure.message));
      },
      (labelData) {
        AppLogger.info('Scanning successful: ${labelData.barcode}');
        emit(ScanningSuccess(labelData));
      },
    );
  }

  Future<void> _onProcessCameraFrame(
    ProcessCameraFrameEvent event,
    Emitter<ScanningState> emit,
  ) async {
    emit(ScanningLoading());

    final result = await processImageUseCase(
      ProcessImageParams(imagePath: event.imagePath),
    );

    result.fold(
      (failure) => emit(ScanningError(failure.message)),
      (labelData) => emit(ScanningSuccess(labelData)),
    );
  }

  void _onClearResult(
    ClearScanningResultEvent event,
    Emitter<ScanningState> emit,
  ) {
    emit(ScanningInitial());
  }

  void _onUpdateLabelData(
    UpdateLabelDataEvent event,
    Emitter<ScanningState> emit,
  ) {
    emit(ScanningSuccess(event.labelData));
  }
}
