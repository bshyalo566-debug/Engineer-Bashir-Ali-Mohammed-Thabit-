import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/label_data.dart';
import '../repositories/ocr_repository.dart';

class ProcessImageUseCase implements UseCase<LabelData, ProcessImageParams> {
  final OcrRepository repository;

  const ProcessImageUseCase(this.repository);

  @override
  Future<Either<Failure, LabelData>> call(ProcessImageParams params) async {
    return await repository.processImage(params.imagePath);
  }
}

class ProcessImageParams {
  final String imagePath;

  const ProcessImageParams({required this.imagePath});
}
