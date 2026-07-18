import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logger.dart';

class DatabaseHelper {
  static const String _dbName = 'barcode_pro_secure.db';
  static const String _passwordKey = 'db_encryption_key';
  static Database? _database;

  static Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final path = join(docsDir.path, _dbName);

      final prefs = await SharedPreferences.getInstance();
      String? password = prefs.getString(_passwordKey);

      if (password == null || password.isEmpty) {
        password = _generateSecureKey();
        await prefs.setString(_passwordKey, password);
        AppLogger.info('Generated new database encryption key');
      }

      final db = await openDatabase(
        path,
        password: password,
        version: 3,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        singleInstance: true,
      );

      AppLogger.info('Database initialized successfully');
      return db;
    } catch (e, stackTrace) {
      AppLogger.error('Database initialization failed', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  static String _generateSecureKey() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final random = timestamp.split('').reversed.join();
    return 'BP_${timestamp}_$random';
  }

  static Future<void> _onCreate(Database db, int version) async {
    AppLogger.info('Creating database tables (version $version)');

    await db.execute(
      'CREATE TABLE IF NOT EXISTS print_history('
      'id INTEGER PRIMARY KEY AUTOINCREMENT,'
      'product_name TEXT,'
      'price REAL,'
      'currency TEXT,'
      'barcode TEXT,'
      'barcode_type TEXT,'
      'printer_name TEXT,'
      'printer_type TEXT,'
      'label_template TEXT,'
      'print_count INTEGER DEFAULT 1,'
      'print_status TEXT DEFAULT \'success\','
      'error_message TEXT,'
      'timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,'
      'synced INTEGER DEFAULT 0'
      ')'
    );

    await db.execute(
      'CREATE TABLE IF NOT EXISTS label_templates('
      'id INTEGER PRIMARY KEY AUTOINCREMENT,'
      'name TEXT NOT NULL,'
      'width_mm REAL,'
      'height_mm REAL,'
      'zpl_template TEXT,'
      'is_default INTEGER DEFAULT 0,'
      'created_at DATETIME DEFAULT CURRENT_TIMESTAMP'
      ')'
    );

    await db.execute(
      'CREATE TABLE IF NOT EXISTS saved_printers('
      'id INTEGER PRIMARY KEY AUTOINCREMENT,'
      'device_id TEXT NOT NULL UNIQUE,'
      'name TEXT,'
      'type TEXT,'
      'ip_address TEXT,'
      'mac_address TEXT,'
      'is_default INTEGER DEFAULT 0,'
      'last_connected DATETIME,'
      'created_at DATETIME DEFAULT CURRENT_TIMESTAMP'
      ')'
    );

    await db.execute('CREATE INDEX IF NOT EXISTS idx_history_timestamp ON print_history(timestamp)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_history_barcode ON print_history(barcode)');

    await _insertDefaultTemplates(db);
  }

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    AppLogger.info('Upgrading database from $oldVersion to $newVersion');

    if (oldVersion < 2) {
      await db.execute("ALTER TABLE print_history ADD COLUMN synced INTEGER DEFAULT 0");
    }
    if (oldVersion < 3) {
      await db.execute("ALTER TABLE print_history ADD COLUMN error_message TEXT");
      await db.execute("ALTER TABLE print_history ADD COLUMN print_status TEXT DEFAULT 'success'");
    }
  }

  static Future<void> _insertDefaultTemplates(Database db) async {
    await db.insert('label_templates', {
      'name': 'Standard Product Label',
      'width_mm': 50.0,
      'height_mm': 30.0,
      'zpl_template': _defaultProductLabel,
      'is_default': 1,
    });

    await db.insert('label_templates', {
      'name': 'Price Tag',
      'width_mm': 40.0,
      'height_mm': 25.0,
      'zpl_template': _priceTagLabel,
      'is_default': 0,
    });
  }

  static const String _defaultProductLabel =
      '^XA\n'
      '^CI28\n'
      '^FO20,15^A0N,25,25^FD{{store_name}}^FS\n'
      '^FO20,50^A0N,30,30^FD{{product_name}}^FS\n'
      '^FO20,90^A0N,40,40^FD{{price}} {{currency}}^FS\n'
      '^FO20,140^BY2^BCN,60,Y,N,N^FD{{barcode}}^FS\n'
      '^XZ';

  static const String _priceTagLabel =
      '^XA\n'
      '^CI28\n'
      '^FO10,10^A0N,35,35^FD{{price}}^FS\n'
      '^FO10,50^A0N,20,20^FD{{currency}}^FS\n'
      '^FO10,80^BY1^BCN,40,Y,N,N^FD{{barcode}}^FS\n'
      '^XZ';

  static Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
      AppLogger.info('Database connection closed');
    }
  }

  static Future<void> deleteDatabase() async {
    await close();
    final docsDir = await getApplicationDocumentsDirectory();
    final path = join(docsDir.path, _dbName);
    await databaseFactory.deleteDatabase(path);
    AppLogger.info('Database deleted');
  }
}
