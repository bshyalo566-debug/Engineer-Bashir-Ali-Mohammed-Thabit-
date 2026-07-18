class DatabaseException implements Exception {
  final String message;
  final String? code;

  const DatabaseException(this.message, {this.code});

  @override
  String toString() => 'DatabaseException: $message${code != null ? ' (code: $code)' : ''}';
}

class PrinterException implements Exception {
  final String message;
  final String? code;

  const PrinterException(this.message, {this.code});

  @override
  String toString() => 'PrinterException: $message${code != null ? ' (code: $code)' : ''}';
}

class OcrException implements Exception {
  final String message;
  final String? code;

  const OcrException(this.message, {this.code});

  @override
  String toString() => 'OcrException: $message${code != null ? ' (code: $code)' : ''}';
}

class PermissionException implements Exception {
  final String message;

  const PermissionException(this.message);

  @override
  String toString() => 'PermissionException: $message';
}
