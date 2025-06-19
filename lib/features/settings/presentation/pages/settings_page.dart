import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = true;
  bool _notificationsEnabled = true;
  bool _offlineRelayEnabled = true;
  bool _autoAcceptFiles = false;
  bool _compressFiles = true;
  int _compressionQuality = 80;
  String _defaultProtocol = 'WebRTC';
  int _maxFileSize = 100; // MB

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.padding),
        children: [
          _buildSection(
            title: 'Appearance',
            icon: Icons.palette,
            children: [
              _buildSwitchTile(
                title: 'Dark Mode',
                subtitle: 'Use dark theme',
                value: _darkMode,
                onChanged: (value) => setState(() => _darkMode = value),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          _buildSection(
            title: 'Notifications',
            icon: Icons.notifications,
            children: [
              _buildSwitchTile(
                title: 'Enable Notifications',
                subtitle: 'Receive message notifications',
                value: _notificationsEnabled,
                onChanged: (value) => setState(() => _notificationsEnabled = value),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          _buildSection(
            title: 'Privacy & Security',
            icon: Icons.security,
            children: [
              _buildSwitchTile(
                title: 'Offline Message Relay',
                subtitle: 'Help relay messages when peers are offline',
                value: _offlineRelayEnabled,
                onChanged: (value) => setState(() => _offlineRelayEnabled = value),
              ),
              _buildListTile(
                title: 'Encryption Settings',
                subtitle: 'Manage encryption keys and settings',
                onTap: () => _showEncryptionSettings(),
              ),
              _buildListTile(
                title: 'Blocked Users',
                subtitle: 'Manage blocked contacts',
                onTap: () => _showBlockedUsers(),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          _buildSection(
            title: 'File Transfer',
            icon: Icons.file_copy,
            children: [
              _buildSwitchTile(
                title: 'Auto Accept Files',
                subtitle: 'Automatically accept file transfers',
                value: _autoAcceptFiles,
                onChanged: (value) => setState(() => _autoAcceptFiles = value),
              ),
              _buildSwitchTile(
                title: 'Compress Files',
                subtitle: 'Compress files before sending',
                value: _compressFiles,
                onChanged: (value) => setState(() => _compressFiles = value),
              ),
              _buildSliderTile(
                title: 'Compression Quality',
                subtitle: 'Higher quality = larger file size',
                value: _compressionQuality.toDouble(),
                min: 10,
                max: 100,
                divisions: 9,
                onChanged: _compressFiles 
                    ? (value) => setState(() => _compressionQuality = value.round())
                    : null,
              ),
              _buildDropdownTile(
                title: 'Default Protocol',
                subtitle: 'Preferred file transfer protocol',
                value: _defaultProtocol,
                items: ['WebRTC', 'WebTorrent', 'HTTP', 'FTP'],
                onChanged: (value) => setState(() => _defaultProtocol = value!),
              ),
              _buildSliderTile(
                title: 'Max File Size (MB)',
                subtitle: 'Maximum allowed file size',
                value: _maxFileSize.toDouble(),
                min: 1,
                max: 1000,
                divisions: 20,
                onChanged: (value) => setState(() => _maxFileSize = value.round()),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          _buildSection(
            title: 'Network',
            icon: Icons.wifi,
            children: [
              _buildListTile(
                title: 'Connection Settings',
                subtitle: 'Configure network and connection options',
                onTap: () => _showNetworkSettings(),
              ),
              _buildListTile(
                title: 'Peer Discovery',
                subtitle: 'Manage peer discovery methods',
                onTap: () => _showPeerDiscoverySettings(),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          _buildSection(
            title: 'Data & Storage',
            icon: Icons.storage,
            children: [
              _buildListTile(
                title: 'Clear Cache',
                subtitle: 'Clear temporary files and cache',
                onTap: () => _showClearCacheDialog(),
              ),
              _buildListTile(
                title: 'Export Data',
                subtitle: 'Export chat history and settings',
                onTap: () => _exportData(),
              ),
              _buildListTile(
                title: 'Import Data',
                subtitle: 'Import chat history and settings',
                onTap: () => _importData(),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          _buildSection(
            title: 'About',
            icon: Icons.info,
            children: [
              _buildListTile(
                title: 'Version',
                subtitle: 'Chat P2P v1.0.0',
                onTap: () => _showAboutDialog(),
              ),
              _buildListTile(
                title: 'Privacy Policy',
                subtitle: 'Read our privacy policy',
                onTap: () => _showPrivacyPolicy(),
              ),
              _buildListTile(
                title: 'Open Source Licenses',
                subtitle: 'View third-party licenses',
                onTap: () => _showLicenses(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildListTile({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildSliderTile({
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    int? divisions,
    ValueChanged<double>? onChanged,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle),
          const SizedBox(height: 8),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            label: value.round().toString(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownTile({
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle),
          const SizedBox(height: 8),
          DropdownButton<String>(
            value: value,
            isExpanded: true,
            items: items.map((item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            )).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  void _showEncryptionSettings() {
    // TODO: Implement encryption settings
  }

  void _showBlockedUsers() {
    // TODO: Implement blocked users management
  }

  void _showNetworkSettings() {
    // TODO: Implement network settings
  }

  void _showPeerDiscoverySettings() {
    // TODO: Implement peer discovery settings
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('This will clear all temporary files and cached data. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement cache clearing
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared successfully')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    // TODO: Implement data export
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data export feature coming soon')),
    );
  }

  void _importData() {
    // TODO: Implement data import
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data import feature coming soon')),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Chat P2P',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.chat, size: 48),
      children: [
        const Text('A decentralized peer-to-peer chat application built with Flutter.'),
        const SizedBox(height: 16),
        const Text('Features end-to-end encryption, file sharing, and offline message relay.'),
      ],
    );
  }

  void _showPrivacyPolicy() {
    // TODO: Implement privacy policy viewer
  }

  void _showLicenses() {
    showLicensePage(context: context);
  }
}
