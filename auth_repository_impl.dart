import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  static const String _userKey = 'current_user';
  static const String _loginTimeKey = 'login_time';
  static const String _sessionDurationKey = 'session_duration_hours';

  // Demo credentials - In production, use secure backend
  static const String _demoUsername = 'admin';
  static const String _demoPasswordHash = '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8'; // "password"

  @override
  Future<Either<Failure, User>> login(String username, String password) async {
    try {
      AppLogger.info('Login attempt: $username');

      // Hash input password
      final passwordBytes = utf8.encode(password);
      final passwordHash = sha256.convert(passwordBytes).toString();

      // Validate credentials
      if (username != _demoUsername || passwordHash != _demoPasswordHash) {
        return Left(ValidationFailure('Invalid username or password'));
      }

      final user = User(
        id: '1',
        username: username,
        fullName: 'System Administrator',
        createdAt: DateTime.now(),
        isActive: true,
      );

      // Save session
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode({
        'id': user.id,
        'username': user.username,
        'fullName': user.fullName,
        'createdAt': user.createdAt?.toIso8601String(),
      }));
      await prefs.setString(_loginTimeKey, DateTime.now().toIso8601String());
      await prefs.setInt(_sessionDurationKey, 24); // 24 hours session

      AppLogger.info('Login successful: $username');
      return Right(user);
    } catch (e, stackTrace) {
      AppLogger.error('Login error', error: e, stackTrace: stackTrace);
      return Left(DatabaseFailure('Login failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await prefs.remove(_loginTimeKey);
      AppLogger.info('User logged out');
      return Right(true);
    } catch (e) {
      return Left(DatabaseFailure('Logout failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);

      if (userJson == null) return Right(null);

      final map = jsonDecode(userJson) as Map<String, dynamic>;
      final user = User(
        id: map['id'] as String,
        username: map['username'] as String,
        fullName: map['fullName'] as String?,
        createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt'] as String) 
          : null,
      );

      return Right(user);
    } catch (e) {
      return Left(DatabaseFailure('Failed to get user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      final loginTimeStr = prefs.getString(_loginTimeKey);
      final sessionHours = prefs.getInt(_sessionDurationKey) ?? 24;

      if (userJson == null || loginTimeStr == null) {
        return Right(false);
      }

      // Check session expiry
      final loginTime = DateTime.parse(loginTimeStr);
      final expiryTime = loginTime.add(Duration(hours: sessionHours));

      if (DateTime.now().isAfter(expiryTime)) {
        await logout();
        return Right(false);
      }

      return Right(true);
    } catch (e) {
      return Right(false);
    }
  }

  @override
  Future<Either<Failure, bool>> changePassword(String oldPassword, String newPassword) async {
    try {
      final oldBytes = utf8.encode(oldPassword);
      final oldHash = sha256.convert(oldBytes).toString();

      if (oldHash != _demoPasswordHash) {
        return Left(ValidationFailure('Current password is incorrect'));
      }

      // In production: update password in backend
      AppLogger.info('Password changed successfully');
      return Right(true);
    } catch (e) {
      return Left(DatabaseFailure('Password change failed: ${e.toString()}'));
    }
  }
}
