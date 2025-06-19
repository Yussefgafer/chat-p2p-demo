import 'package:flutter/foundation.dart';
import '../../../../shared/models/user_model.dart';
import '../../domain/usecases/create_user_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';

/// Provider for managing user state
class UserProvider extends ChangeNotifier {
  final CreateUserUseCase createUserUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  UserProvider({
    required this.createUserUseCase,
    required this.getCurrentUserUseCase,
  });

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;

  /// Initialize user data
  Future<void> initialize() async {
    _setLoading(true);
    _clearError();

    final result = await getCurrentUserUseCase();
    result.fold(
      (failure) => _setError(failure.message),
      (user) => _setCurrentUser(user),
    );

    _setLoading(false);
  }

  /// Create a new user
  Future<bool> createUser({
    required String name,
    String? avatar,
    int? age,
    String? phoneNumber,
  }) async {
    _setLoading(true);
    _clearError();

    final params = CreateUserParams(
      name: name,
      avatar: avatar,
      age: age,
      phoneNumber: phoneNumber,
    );

    final result = await createUserUseCase(params);
    
    return result.fold(
      (failure) {
        _setError(failure.message);
        _setLoading(false);
        return false;
      },
      (user) {
        _setCurrentUser(user);
        _setLoading(false);
        return true;
      },
    );
  }

  /// Update user profile
  Future<bool> updateUser(UserModel updatedUser) async {
    _setLoading(true);
    _clearError();

    // For now, we'll just update the local state
    // In a full implementation, you'd call an update use case
    _setCurrentUser(updatedUser);
    _setLoading(false);
    return true;
  }

  /// Logout user
  void logout() {
    _currentUser = null;
    _clearError();
    notifyListeners();
  }

  /// Update online status
  void updateOnlineStatus(bool isOnline) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        isOnline: isOnline,
        lastSeen: isOnline ? null : DateTime.now(),
      );
      notifyListeners();
    }
  }

  // Private methods
  void _setCurrentUser(UserModel? user) {
    _currentUser = user;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
