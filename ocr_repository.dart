import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/label_data.dart';

abstract class OcrRepository {
  Future<Either<Failure, LabelData>> processImage(String imagePath);
  Future<Either<Failure, LabelData>> processCameraFrame(dynamic cameraImage);
  Future<Either<Failure, List<LabelData>>> processBatchImages(List<String> imagePaths);
  void dispose();
}
