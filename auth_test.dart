import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_print_pro/features/auth/data/repositories/auth_repository_impl.dart';

void main() {
  group('AuthRepositoryImpl', () {
    late AuthRepositoryImpl repository;

    setUp(() {
      repository = AuthRepositoryImpl();
    });

    test('should authenticate with valid credentials', () async {
      final result = await repository.login('admin', 'password');
      expect(result.isRight(), true);
    });

    test('should fail with invalid credentials', () async {
      final result = await repository.login('wrong', 'wrong');
      expect(result.isLeft(), true);
    });
  });
}