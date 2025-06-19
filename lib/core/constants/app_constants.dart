/// Application-wide constants
class AppConstants {
  // App Info
  static const String appName = 'Chat P2P';
  static const String appVersion = '1.0.0';
  
  // WebRTC Configuration
  static const Map<String, dynamic> rtcConfiguration = {
    'iceServers': [
      {'urls': 'stun:stun.l.google.com:19302'},
      {'urls': 'stun:stun1.l.google.com:19302'},
    ],
    'iceCandidatePoolSize': 10,
  };
  
  // Network Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration messageTimeout = Duration(seconds: 10);
  static const Duration discoveryTimeout = Duration(seconds: 60);
  
  // File Transfer
  static const int maxFileSize = 100 * 1024 * 1024; // 100MB
  static const int chunkSize = 64 * 1024; // 64KB
  static const List<String> supportedFileTypes = [
    'jpg', 'jpeg', 'png', 'gif', 'webp',
    'mp4', 'avi', 'mov', 'mkv',
    'pdf', 'doc', 'docx', 'txt',
    'mp3', 'wav', 'aac', 'flac'
  ];
  
  // Encryption
  static const int keyLength = 256;
  static const String encryptionAlgorithm = 'AES-GCM';
  
  // Database
  static const String databaseName = 'chat_p2p.db';
  static const int databaseVersion = 1;
  
  // Storage Keys
  static const String userIdKey = 'user_id';
  static const String userNameKey = 'user_name';
  static const String userAvatarKey = 'user_avatar';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  
  // UI Constants
  static const double borderRadius = 12.0;
  static const double padding = 16.0;
  static const double avatarSize = 40.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Network Discovery
  static const int discoveryPort = 8888;
  static const String discoveryMessage = 'CHAT_P2P_DISCOVERY';
  static const String broadcastAddress = '255.255.255.255';
  
  // Background Service
  static const String backgroundTaskName = 'chat_p2p_background';
  static const Duration backgroundInterval = Duration(minutes: 15);
  
  // Notification Channels
  static const String messageChannelId = 'message_notifications';
  static const String connectionChannelId = 'connection_notifications';
  static const String fileTransferChannelId = 'file_transfer_notifications';
}
