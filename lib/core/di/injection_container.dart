import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../constants/app_constants.dart';

import 'injection_container.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();

/// Initialize all dependencies
Future<void> initializeDependencies() async {
  // Register external dependencies
  await _registerExternalDependencies();
  
  // Configure injectable dependencies
  await configureDependencies();
}

/// Register external dependencies that need async initialization
Future<void> _registerExternalDependencies() async {
  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  
  // Database
  final database = await _initializeDatabase();
  getIt.registerSingleton<Database>(database);
}

/// Initialize SQLite database
Future<Database> _initializeDatabase() async {
  final databasesPath = await getDatabasesPath();
  final path = join(databasesPath, AppConstants.databaseName);
  
  return await openDatabase(
    path,
    version: AppConstants.databaseVersion,
    onCreate: _createDatabase,
    onUpgrade: _upgradeDatabase,
  );
}

/// Create database tables
Future<void> _createDatabase(Database db, int version) async {
  // Users table
  await db.execute('''
    CREATE TABLE users (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      avatar TEXT,
      public_key TEXT,
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL
    )
  ''');
  
  // Messages table
  await db.execute('''
    CREATE TABLE messages (
      id TEXT PRIMARY KEY,
      sender_id TEXT NOT NULL,
      receiver_id TEXT NOT NULL,
      content TEXT NOT NULL,
      message_type TEXT NOT NULL,
      is_encrypted INTEGER NOT NULL DEFAULT 1,
      timestamp INTEGER NOT NULL,
      is_sent INTEGER NOT NULL DEFAULT 0,
      is_delivered INTEGER NOT NULL DEFAULT 0,
      is_read INTEGER NOT NULL DEFAULT 0,
      file_path TEXT,
      file_size INTEGER,
      file_type TEXT,
      FOREIGN KEY (sender_id) REFERENCES users (id),
      FOREIGN KEY (receiver_id) REFERENCES users (id)
    )
  ''');
  
  // Peer connections table
  await db.execute('''
    CREATE TABLE peer_connections (
      id TEXT PRIMARY KEY,
      peer_id TEXT NOT NULL,
      connection_type TEXT NOT NULL,
      status TEXT NOT NULL,
      last_seen INTEGER NOT NULL,
      connection_data TEXT,
      created_at INTEGER NOT NULL,
      FOREIGN KEY (peer_id) REFERENCES users (id)
    )
  ''');
  
  // File transfers table
  await db.execute('''
    CREATE TABLE file_transfers (
      id TEXT PRIMARY KEY,
      message_id TEXT NOT NULL,
      file_name TEXT NOT NULL,
      file_path TEXT NOT NULL,
      file_size INTEGER NOT NULL,
      transfer_type TEXT NOT NULL,
      status TEXT NOT NULL,
      progress REAL NOT NULL DEFAULT 0.0,
      created_at INTEGER NOT NULL,
      completed_at INTEGER,
      FOREIGN KEY (message_id) REFERENCES messages (id)
    )
  ''');
  
  // Settings table
  await db.execute('''
    CREATE TABLE settings (
      key TEXT PRIMARY KEY,
      value TEXT NOT NULL,
      updated_at INTEGER NOT NULL
    )
  ''');
  
  // Offline messages table (for relay feature)
  await db.execute('''
    CREATE TABLE offline_messages (
      id TEXT PRIMARY KEY,
      original_message_id TEXT NOT NULL,
      target_user_id TEXT NOT NULL,
      relay_user_id TEXT NOT NULL,
      encrypted_content TEXT NOT NULL,
      timestamp INTEGER NOT NULL,
      expiry_timestamp INTEGER NOT NULL,
      is_delivered INTEGER NOT NULL DEFAULT 0
    )
  ''');
  
  // Create indexes for better performance
  await db.execute('CREATE INDEX idx_messages_sender ON messages(sender_id)');
  await db.execute('CREATE INDEX idx_messages_receiver ON messages(receiver_id)');
  await db.execute('CREATE INDEX idx_messages_timestamp ON messages(timestamp)');
  await db.execute('CREATE INDEX idx_peer_connections_peer ON peer_connections(peer_id)');
  await db.execute('CREATE INDEX idx_file_transfers_message ON file_transfers(message_id)');
  await db.execute('CREATE INDEX idx_offline_messages_target ON offline_messages(target_user_id)');
}

/// Upgrade database schema
Future<void> _upgradeDatabase(Database db, int oldVersion, int newVersion) async {
  // Handle database migrations here
  if (oldVersion < 2) {
    // Add new columns or tables for version 2
  }
}
