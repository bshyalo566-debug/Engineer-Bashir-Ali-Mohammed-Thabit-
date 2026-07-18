import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_print_pro/features/scanning/data/repositories/ocr_repository_impl.dart';

void main() {
  group('OcrRepositoryImpl', () {
    late OcrRepositoryImpl repository;

    setUp(() {
      repository = OcrRepositoryImpl();
    });

    tearDown(() {
      repository.dispose();
    });

    test('should be initialized correctly', () {
      expect(repository, isNotNull);
    });

    test('should handle non-existent image gracefully', () async {
      final result = await repository.processImage('/nonexistent/path.png');
      expect(result.isLeft(), true);
    });
  });
}