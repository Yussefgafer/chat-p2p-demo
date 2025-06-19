import 'dart:async';
import 'dart:isolate';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../constants/app_constants.dart';
import '../di/injection_container.dart';

/// Background service for handling P2P operations
class BackgroundService {
  static const String _taskName = AppConstants.backgroundTaskName;
  static final FlutterLocalNotificationsPlugin _notifications = 
      FlutterLocalNotificationsPlugin();
  
  static bool _isInitialized = false;
  static Timer? _heartbeatTimer;
  static ReceivePort? _receivePort;

  /// Initialize background service
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize WorkManager
      await Workmanager().initialize(
        _callbackDispatcher,
        isInDebugMode: false,
      );

      // Initialize notifications
      await _initializeNotifications();

      // Register periodic task
      await Workmanager().registerPeriodicTask(
        _taskName,
        _taskName,
        frequency: AppConstants.backgroundInterval,
        constraints: Constraints(
          networkType: NetworkType.connected,
          requiresBatteryNotLow: true,
        ),
      );

      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize background service: $e');
    }
  }

  /// Start background operations
  static Future<void> start() async {
    if (!_isInitialized) {
      await initialize();
    }

    // Start heartbeat timer for foreground operations
    _heartbeatTimer = Timer.periodic(
      const Duration(minutes: 5),
      (timer) => _performHeartbeat(),
    );

    // Create isolate for background operations
    _receivePort = ReceivePort();
    await Isolate.spawn(_backgroundIsolate, _receivePort!.sendPort);
    
    _receivePort!.listen((message) {
      _handleBackgroundMessage(message);
    });
  }

  /// Stop background operations
  static Future<void> stop() async {
    _heartbeatTimer?.cancel();
    _receivePort?.close();
    
    await Workmanager().cancelByUniqueName(_taskName);
  }

  /// Initialize local notifications
  static Future<void> _initializeNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(initSettings);

    // Create notification channels
    await _createNotificationChannels();
  }

  /// Create notification channels
  static Future<void> _createNotificationChannels() async {
    // Message notifications channel
    const messageChannel = AndroidNotificationChannel(
      AppConstants.messageChannelId,
      'Message Notifications',
      description: 'Notifications for new messages',
      importance: Importance.high,
      sound: RawResourceAndroidNotificationSound('notification'),
    );

    // Connection notifications channel
    const connectionChannel = AndroidNotificationChannel(
      AppConstants.connectionChannelId,
      'Connection Notifications',
      description: 'Notifications for peer connections',
      importance: Importance.defaultImportance,
    );

    // File transfer notifications channel
    const fileTransferChannel = AndroidNotificationChannel(
      AppConstants.fileTransferChannelId,
      'File Transfer Notifications',
      description: 'Notifications for file transfers',
      importance: Importance.low,
      showBadge: false,
    );

    final plugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    
    await plugin?.createNotificationChannel(messageChannel);
    await plugin?.createNotificationChannel(connectionChannel);
    await plugin?.createNotificationChannel(fileTransferChannel);
  }

  /// Show notification
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String channelId = AppConstants.messageChannelId,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      AppConstants.messageChannelId,
      'Message Notifications',
      channelDescription: 'Notifications for new messages',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, details, payload: payload);
  }

  /// Perform heartbeat operations
  static void _performHeartbeat() {
    // Update online status
    // Check for pending messages
    // Maintain peer connections
    // Clean up expired data
  }

  /// Handle messages from background isolate
  static void _handleBackgroundMessage(dynamic message) {
    if (message is Map<String, dynamic>) {
      switch (message['type']) {
        case 'new_message':
          _handleNewMessage(message);
          break;
        case 'peer_connected':
          _handlePeerConnected(message);
          break;
        case 'file_transfer_complete':
          _handleFileTransferComplete(message);
          break;
      }
    }
  }

  /// Handle new message notification
  static void _handleNewMessage(Map<String, dynamic> data) {
    showNotification(
      id: data['messageId'].hashCode,
      title: 'New message from ${data['senderName']}',
      body: data['content'],
      channelId: AppConstants.messageChannelId,
      payload: data['messageId'],
    );
  }

  /// Handle peer connected notification
  static void _handlePeerConnected(Map<String, dynamic> data) {
    showNotification(
      id: data['peerId'].hashCode,
      title: 'Peer Connected',
      body: '${data['peerName']} is now online',
      channelId: AppConstants.connectionChannelId,
    );
  }

  /// Handle file transfer complete notification
  static void _handleFileTransferComplete(Map<String, dynamic> data) {
    showNotification(
      id: data['transferId'].hashCode,
      title: 'File Transfer Complete',
      body: '${data['fileName']} has been transferred successfully',
      channelId: AppConstants.fileTransferChannelId,
    );
  }

  /// Background isolate entry point
  static void _backgroundIsolate(SendPort sendPort) async {
    // Initialize dependencies in isolate
    await initializeDependencies();
    
    // Perform background operations
    Timer.periodic(const Duration(minutes: 1), (timer) {
      _performBackgroundTasks(sendPort);
    });
  }

  /// Perform background tasks
  static void _performBackgroundTasks(SendPort sendPort) {
    // Check for new messages
    // Maintain peer connections
    // Process offline message relay
    // Update connection status
    // Clean up temporary files
  }
}

/// WorkManager callback dispatcher
@pragma('vm:entry-point')
void _callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      // Initialize dependencies
      await initializeDependencies();
      
      switch (task) {
        case AppConstants.backgroundTaskName:
          await _performBackgroundWork();
          break;
      }
      
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  });
}

/// Perform background work
Future<void> _performBackgroundWork() async {
  // Check for pending messages
  // Update peer connection status
  // Process offline message relay
  // Clean up expired data
  // Sync with local storage
}

/// Background task manager
class BackgroundTaskManager {
  static final Map<String, Timer> _tasks = {};

  /// Schedule a recurring task
  static void scheduleTask({
    required String taskId,
    required Duration interval,
    required VoidCallback callback,
  }) {
    cancelTask(taskId);
    
    _tasks[taskId] = Timer.periodic(interval, (timer) {
      try {
        callback();
      } catch (e) {
        // Log error
      }
    });
  }

  /// Cancel a task
  static void cancelTask(String taskId) {
    _tasks[taskId]?.cancel();
    _tasks.remove(taskId);
  }

  /// Cancel all tasks
  static void cancelAllTasks() {
    for (final timer in _tasks.values) {
      timer.cancel();
    }
    _tasks.clear();
  }
}
