import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../providers/user_provider.dart';

class UserSetupPage extends StatefulWidget {
  const UserSetupPage({super.key});

  @override
  State<UserSetupPage> createState() => _UserSetupPageState();
}

class _UserSetupPageState extends State<UserSetupPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: AppConstants.mediumAnimation,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildContent(context, theme),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          
          // Header
          _buildHeader(theme),
          
          const SizedBox(height: 48),
          
          // Form
          Expanded(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Avatar Section
                  _buildAvatarSection(theme),
                  
                  const SizedBox(height: 32),
                  
                  // Name Field
                  _buildNameField(theme),
                  
                  const SizedBox(height: 16),
                  
                  // Age Field (Optional)
                  _buildAgeField(theme),
                  
                  const SizedBox(height: 16),
                  
                  // Phone Field (Optional)
                  _buildPhoneField(theme),
                  
                  const Spacer(),
                  
                  // Create Profile Button
                  _buildCreateButton(context, theme),
                  
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        Icon(
          Icons.person_add_outlined,
          size: 64,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'Create Your Profile',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Set up your profile to start chatting securely with peers',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAvatarSection(ThemeData theme) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            shape: BoxShape.circle,
            border: Border.all(
              color: theme.colorScheme.outline,
              width: 2,
            ),
          ),
          child: Icon(
            Icons.person,
            size: 50,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: () {
            // TODO: Implement avatar selection
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Avatar selection coming soon!')),
            );
          },
          icon: const Icon(Icons.camera_alt),
          label: const Text('Add Photo'),
        ),
      ],
    );
  }

  Widget _buildNameField(ThemeData theme) {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Display Name *',
        hintText: 'Enter your display name',
        prefixIcon: Icon(Icons.person_outline),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your display name';
        }
        if (value.trim().length < 2) {
          return 'Name must be at least 2 characters';
        }
        return null;
      },
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildAgeField(ThemeData theme) {
    return TextFormField(
      controller: _ageController,
      decoration: const InputDecoration(
        labelText: 'Age (Optional)',
        hintText: 'Enter your age',
        prefixIcon: Icon(Icons.cake_outlined),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          final age = int.tryParse(value);
          if (age == null || age < 13 || age > 120) {
            return 'Please enter a valid age (13-120)';
          }
        }
        return null;
      },
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildPhoneField(ThemeData theme) {
    return TextFormField(
      controller: _phoneController,
      decoration: const InputDecoration(
        labelText: 'Phone Number (Optional)',
        hintText: 'Enter your phone number',
        prefixIcon: Icon(Icons.phone_outlined),
      ),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          // Basic phone validation
          if (value.length < 10) {
            return 'Please enter a valid phone number';
          }
        }
        return null;
      },
      textInputAction: TextInputAction.done,
    );
  }

  Widget _buildCreateButton(BuildContext context, ThemeData theme) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton(
            onPressed: userProvider.isLoading ? null : () => _createProfile(context),
            child: userProvider.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'Create Profile',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
          ),
        );
      },
    );
  }

  Future<void> _createProfile(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final userProvider = context.read<UserProvider>();
    
    final success = await userProvider.createUser(
      name: _nameController.text.trim(),
      age: _ageController.text.isNotEmpty ? int.tryParse(_ageController.text) : null,
      phoneNumber: _phoneController.text.isNotEmpty ? _phoneController.text.trim() : null,
    );

    if (success && mounted) {
      // Navigate to main app
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const PlaceholderHomePage(),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(userProvider.error ?? 'Failed to create profile'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}

// Temporary placeholder (will be replaced with actual home page)
class PlaceholderHomePage extends StatelessWidget {
  const PlaceholderHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat P2P')),
      body: const Center(
        child: Text('Welcome to Chat P2P!'),
      ),
    );
  }
}
