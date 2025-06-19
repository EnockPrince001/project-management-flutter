import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  int? _userId;
  bool _isGuestMode = false; // NEW: Flag to indicate guest mode

  int? get userId => _userId;
  bool get isLoggedIn => _userId != null;
  bool get isGuestMode => _isGuestMode; // NEW: Getter for guest mode status

  // Call this when a user logs in with an ID
  void login(int userId) {
    _userId = userId;
    _isGuestMode = false; // No longer in guest mode when logged in
    notifyListeners();
  }

  // NEW: Call this when the user chooses "Continue as Guest"
  void enterGuestMode() {
    _userId = null; // No specific user ID for guest
    _isGuestMode = true; // Set guest mode flag to true
    notifyListeners();
  }

  // Call this to log out from either authenticated or guest mode
  void logout() {
    _userId = null;
    _isGuestMode = false; // Exit guest mode
    notifyListeners();
  }
}
