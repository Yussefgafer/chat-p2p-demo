import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// TODO: Add QR dependencies when needed
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_constants.dart';

class QRCodePage extends StatefulWidget {
  const QRCodePage({super.key});

  @override
  State<QRCodePage> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // QR Code Generation (demo version)
  String _qrData = '';
  bool _isGenerating = false;

  // QR Code Scanning (demo version - disabled)
  // QRViewController? _qrController;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  bool _isScanning = false;
  String? _scannedData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _generateQRCode();
  }

  @override
  void dispose() {
    _tabController.dispose();
    // _qrController?.dispose(); // Commented out for demo
    super.dispose();
  }

  Future<void> _generateQRCode() async {
    setState(() => _isGenerating = true);

    try {
      // TODO: Get actual user data and generate QR code
      final userData = {
        'userId': 'user_123',
        'userName': 'Test User',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'expires': DateTime.now()
            .add(const Duration(hours: 1))
            .millisecondsSinceEpoch,
      };

      setState(() {
        _qrData = userData.toString();
        _isGenerating = false;
      });
    } catch (e) {
      setState(() => _isGenerating = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate QR code: $e')),
        );
      }
    }
  }

  // Demo version - QR scanning disabled
  void _onQRViewCreated(dynamic controller) {
    // _qrController = controller;
    // controller.scannedDataStream.listen((scanData) {
    //   if (!_isScanning) {
    //     _isScanning = true;
    //     _handleScannedData(scanData.code);
    //   }
    // });

    // Demo: Show a message that QR scanning is not available
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('QR scanning not available in demo version'),
      ),
    );
  }

  void _handleScannedData(String? data) {
    if (data != null) {
      setState(() {
        _scannedData = data;
        _isScanning = false;
      });

      _showScannedDataDialog(data);
    }
  }

  void _showScannedDataDialog(String data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('QR Code Scanned'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Scanned data:'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                data,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() => _isScanning = false);
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _connectToPeer(data);
            },
            child: const Text('Connect'),
          ),
        ],
      ),
    );
  }

  void _connectToPeer(String data) {
    // TODO: Implement peer connection logic
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Connecting to peer...')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.qr_code), text: 'Share'),
            Tab(icon: Icon(Icons.qr_code_scanner), text: 'Scan'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildShareTab(theme), _buildScanTab(theme)],
      ),
    );
  }

  Widget _buildShareTab(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.padding),
      child: Column(
        children: [
          const SizedBox(height: 32),

          // Header
          Text(
            'Share Your QR Code',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            'Others can scan this code to connect with you',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 48),

          // QR Code
          if (_isGenerating)
            const CircularProgressIndicator()
          else if (_qrData.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.qr_code, size: 100, color: Colors.black),
                      const SizedBox(height: 16),
                      Text(
                        'QR Code Demo',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _qrData.isNotEmpty
                            ? 'Data: ${_qrData.substring(0, 20)}...'
                            : 'No data',
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          const SizedBox(height: 32),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                icon: Icons.refresh,
                label: 'Regenerate',
                onPressed: _generateQRCode,
                theme: theme,
              ),
              _buildActionButton(
                icon: Icons.share,
                label: 'Share',
                onPressed: _shareQRCode,
                theme: theme,
              ),
              _buildActionButton(
                icon: Icons.copy,
                label: 'Copy',
                onPressed: _copyQRCode,
                theme: theme,
              ),
            ],
          ),

          const Spacer(),

          // Expiration Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'This QR code expires in 1 hour for security',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanTab(ThemeData theme) {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.qr_code_scanner,
                    size: 100,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'QR Scanner Demo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Camera scanning not available in demo',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),

        Expanded(
          flex: 1,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppConstants.padding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Point camera at QR code',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Make sure the QR code is clearly visible',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),

                if (_scannedData != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Last scanned: ${_scannedData!.substring(0, 20)}...',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required ThemeData theme,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FilledButton.tonal(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
          ),
          child: Icon(icon, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }

  void _shareQRCode() {
    if (_qrData.isNotEmpty) {
      // Demo version - sharing disabled
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Demo: Would share QR code data: ${_qrData.substring(0, 30)}...',
          ),
          backgroundColor: Colors.blue,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Generate a QR code first'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _copyQRCode() {
    if (_qrData.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _qrData));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('QR code data copied to clipboard')),
      );
    }
  }
}
