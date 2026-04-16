import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/base/controllers/auth_controller.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/users_firestore_service.dart';

class AccountPasswordController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UsersFirestoreService _usersService = UsersFirestoreService();

  // Form controllers
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final contactController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final currentPasswordController = TextEditingController();

  // Observable states
  final isLoading = false.obs;
  final isSaving = false.obs;
  final isUsernameEditable = false.obs;
  final isEmailEditable = false.obs;
  final isContactEditable = false.obs;
  final isPasswordEditable = false.obs;
  final showPassword = false.obs;
  final showConfirmPassword = false.obs;
  final showCurrentPassword = false.obs;

  // Two-step password change flow states
  final isVerifyingCurrentPassword = false.obs;
  final isCurrentPasswordVerified = false.obs;
  final canEditNewPassword = false.obs;
  final isChangingPassword = false.obs;

  // User data
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  // Original values for comparison
  String _originalUsername = '';
  String _originalEmail = '';
  String _originalContact = '';

  // Validation errors
  final usernameError = ''.obs;
  final emailError = ''.obs;
  final contactError = ''.obs;
  final passwordError = ''.obs;
  final confirmPasswordError = ''.obs;
  final currentPasswordError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    _setupValidationListeners();
  }

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    contactController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    currentPasswordController.dispose();
    super.onClose();
  }

  /// Setup real-time validation listeners
  void _setupValidationListeners() {
    // Username validation
    usernameController.addListener(() {
      _validateUsername();
    });

    // Email validation
    emailController.addListener(() {
      _validateEmail();
    });

    // Contact validation
    contactController.addListener(() {
      _validateContact();
    });

    // Password validation
    passwordController.addListener(() {
      _validatePassword();
      _validateConfirmPassword();
    });

    // Confirm password validation
    confirmPasswordController.addListener(() {
      _validateConfirmPassword();
    });

    // Current password validation
    currentPasswordController.addListener(() {
      _validateCurrentPassword();
    });
  }

  /// Load current user data from Firebase
  Future<void> _loadUserData() async {
    try {
      isLoading.value = true;

      final user = _auth.currentUser;
      if (user == null) {
        Get.snackbar('Error', 'User not authenticated');
        return;
      }

      // Get user profile from Firestore
      final userProfile = await _usersService.getUserProfile(user.uid);
      if (userProfile != null) {
        currentUser.value = userProfile;
        _populateFields(userProfile);
      } else {
        // Fallback to Firebase Auth data
        _populateFromFirebaseAuth(user);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load user data: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Populate form fields with user data
  void _populateFields(UserModel user) {
    _originalUsername = user.username;
    _originalEmail = user.email;
    _originalContact = user.phone;

    usernameController.text = user.username;
    emailController.text = user.email;
    contactController.text = user.phone;
    passwordController.clear();
    confirmPasswordController.clear();
    currentPasswordController.clear();

    // Clear validation errors
    _clearValidationErrors();
  }

  /// Populate from Firebase Auth when Firestore profile is missing
  void _populateFromFirebaseAuth(User user) {
    _originalUsername = user.displayName ?? user.email?.split('@')[0] ?? '';
    _originalEmail = user.email ?? '';
    _originalContact = user.phoneNumber ?? '';

    usernameController.text = _originalUsername;
    emailController.text = _originalEmail;
    contactController.text = _originalContact;
    passwordController.clear();
    confirmPasswordController.clear();
    currentPasswordController.clear();

    // Clear validation errors
    _clearValidationErrors();
  }

  /// Clear all validation errors
  void _clearValidationErrors() {
    usernameError.value = '';
    emailError.value = '';
    contactError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';
    currentPasswordError.value = '';
  }

  /// Validate username field
  void _validateUsername() {
    final username = usernameController.text.trim();
    if (username.isEmpty) {
      usernameError.value = 'Username cannot be empty';
    } else if (username.length < 3) {
      usernameError.value = 'Username must be at least 3 characters';
    } else {
      usernameError.value = '';
    }
  }

  /// Validate email field
  void _validateEmail() {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      emailError.value = 'Email cannot be empty';
    } else if (!GetUtils.isEmail(email)) {
      emailError.value = 'Please enter a valid email address';
    } else {
      emailError.value = '';
    }
  }

  /// Validate contact field
  void _validateContact() {
    final contact = contactController.text.trim();
    if (contact.isNotEmpty && !GetUtils.isPhoneNumber(contact)) {
      contactError.value = 'Please enter a valid phone number';
    } else {
      contactError.value = '';
    }
  }

  /// Validate password field for two-step flow
  void _validatePassword() {
    // Only validate if we can edit new password (after current password verification)
    if (!canEditNewPassword.value) {
      passwordError.value = '';
      return;
    }

    final password = passwordController.text;
    if (password.isEmpty) {
      passwordError.value = 'New password cannot be empty';
    } else if (password.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
    } else if (!_isPasswordStrong(password)) {
      passwordError.value = 'Password must contain letters and numbers';
    } else {
      passwordError.value = '';
    }

    // Also revalidate confirm password when password changes
    _validateConfirmPassword();
  }

  /// Validate confirm password field for two-step flow
  void _validateConfirmPassword() {
    // Only validate if we can edit new password (after current password verification)
    if (!canEditNewPassword.value) {
      confirmPasswordError.value = '';
      return;
    }

    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (confirmPassword.isEmpty) {
      confirmPasswordError.value = 'Please confirm your new password';
    } else if (password != confirmPassword) {
      confirmPasswordError.value = 'Passwords do not match';
    } else {
      confirmPasswordError.value = '';
    }
  }

  /// Validate current password field for two-step flow
  void _validateCurrentPassword() {
    // Only validate if we're in password edit mode and haven't verified yet
    if (!isPasswordEditable.value || isCurrentPasswordVerified.value) {
      currentPasswordError.value = '';
      return;
    }

    final currentPassword = currentPasswordController.text;
    if (currentPassword.isEmpty) {
      currentPasswordError.value =
          'Current password is required for verification';
    } else {
      currentPasswordError.value = '';
    }
  }

  /// Check if password is strong enough
  bool _isPasswordStrong(String password) {
    // Must contain at least one letter and one number
    return password.contains(RegExp(r'[a-zA-Z]')) &&
        password.contains(RegExp(r'[0-9]'));
  }

  /// Check if reauthentication is needed (updated for two-step password flow)
  // ignore: unused_element
  bool _needsReauth() {
    return emailController.text.trim() != _originalEmail ||
        (isCurrentPasswordVerified.value && passwordController.text.isNotEmpty);
  }

  /// Validate password strength requirements
  bool _isPasswordValid(String password) {
    if (password.isEmpty) return false;
    if (password.length < 6) return false;
    if (!_isPasswordStrong(password)) return false;
    return true;
  }

  /// Validate password confirmation
  bool _isPasswordConfirmationValid() {
    if (!canEditNewPassword.value) return true;

    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (password.isEmpty && confirmPassword.isEmpty) return true;
    if (password.isEmpty || confirmPassword.isEmpty) return false;

    return password == confirmPassword;
  }

  /// Toggle edit mode for username
  void toggleUsernameEdit() {
    isUsernameEditable.value = !isUsernameEditable.value;
    if (!isUsernameEditable.value) {
      // Reset to original value if cancelled
      usernameController.text = _originalUsername;
      usernameError.value = '';
    } else {
      _validateUsername();
    }
  }

  /// Toggle edit mode for email
  void toggleEmailEdit() {
    isEmailEditable.value = !isEmailEditable.value;
    if (!isEmailEditable.value) {
      // Reset to original value if cancelled
      emailController.text = _originalEmail;
      emailError.value = '';
    } else {
      _validateEmail();
    }
  }

  /// Toggle edit mode for contact
  void toggleContactEdit() {
    isContactEditable.value = !isContactEditable.value;
    if (!isContactEditable.value) {
      // Reset to original value if cancelled
      contactController.text = _originalContact;
      contactError.value = '';
    } else {
      _validateContact();
    }
  }

  /// Toggle edit mode for password with two-step verification
  void togglePasswordEdit() {
    isPasswordEditable.value = !isPasswordEditable.value;
    if (isPasswordEditable.value) {
      // Start password change flow - show current password verification
      showCurrentPassword.value = true;
      showPassword.value = false;
      showConfirmPassword.value = false;

      // Reset password change states
      isCurrentPasswordVerified.value = false;
      canEditNewPassword.value = false;

      // Clear all password fields
      passwordController.clear();
      confirmPasswordController.clear();
      currentPasswordController.clear();

      // Clear password-related errors
      passwordError.value = '';
      confirmPasswordError.value = '';
      currentPasswordError.value = '';
    } else {
      // Cancel password change - reset everything
      showPassword.value = false;
      showConfirmPassword.value = false;
      showCurrentPassword.value = false;

      // Reset password change states
      isCurrentPasswordVerified.value = false;
      canEditNewPassword.value = false;
      isVerifyingCurrentPassword.value = false;

      // Clear all password fields and errors
      passwordController.clear();
      confirmPasswordController.clear();
      currentPasswordController.clear();
      passwordError.value = '';
      confirmPasswordError.value = '';
      currentPasswordError.value = '';
    }
  }

  /// Verify current password - Step 1 of password change flow
  Future<void> verifyCurrentPassword() async {
    try {
      // Validate current password input
      if (currentPasswordController.text.isEmpty) {
        currentPasswordError.value = 'Please enter your current password';
        return;
      }

      isVerifyingCurrentPassword.value = true;
      currentPasswordError.value = '';

      // Perform reauthentication to verify current password
      final verificationSuccess = await _reauthenticateUser(
        currentPasswordController.text,
      );

      if (verificationSuccess) {
        // Current password verified successfully
        isCurrentPasswordVerified.value = true;
        canEditNewPassword.value = true;

        // Show new password fields
        showPassword.value = true;
        showConfirmPassword.value = true;

        // Hide current password field (keep the value for later use)
        showCurrentPassword.value = false;

        Get.snackbar(
          'Password Verified',
          'Current password verified successfully. You can now set a new password.',
          backgroundColor: const Color(0xFFC2D86A),
          colorText: Colors.black,
          duration: const Duration(seconds: 3),
        );
      } else {
        // Verification failed - error already shown by _reauthenticateUser
        isCurrentPasswordVerified.value = false;
        canEditNewPassword.value = false;
      }
    } catch (e) {
      isCurrentPasswordVerified.value = false;
      canEditNewPassword.value = false;
      currentPasswordError.value = 'Verification failed: ${e.toString()}';

      Get.snackbar(
        'Verification Error',
        'Failed to verify current password: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isVerifyingCurrentPassword.value = false;
    }
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    showPassword.value = !showPassword.value;
  }

  /// Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    showConfirmPassword.value = !showConfirmPassword.value;
  }

  /// Toggle current password visibility
  void toggleCurrentPasswordVisibility() {
    showCurrentPassword.value = !showCurrentPassword.value;
  }

  /// Validate all form data with enhanced checks
  // ignore: unused_element
  bool _validateAllData() {
    _validateUsername();
    _validateEmail();
    _validateContact();
    _validatePassword();
    _validateConfirmPassword();
    _validateCurrentPassword();

    // Additional validation for password changes
    if (isPasswordEditable.value && passwordController.text.isNotEmpty) {
      // Ensure password meets strength requirements
      if (!_isPasswordValid(passwordController.text)) {
        passwordError.value =
            'Password must be at least 6 characters with letters and numbers';
        return false;
      }

      // Ensure password confirmation matches
      if (!_isPasswordConfirmationValid()) {
        confirmPasswordError.value = 'Passwords do not match';
        return false;
      }
    }

    // Check if all validation errors are cleared
    return usernameError.value.isEmpty &&
        emailError.value.isEmpty &&
        contactError.value.isEmpty &&
        passwordError.value.isEmpty &&
        confirmPasswordError.value.isEmpty &&
        currentPasswordError.value.isEmpty;
  }

  /// Check if any changes were made (updated for two-step password flow)
  bool _hasChanges() {
    return usernameController.text.trim() != _originalUsername ||
        emailController.text.trim() != _originalEmail ||
        contactController.text.trim() != _originalContact ||
        (isCurrentPasswordVerified.value && passwordController.text.isNotEmpty);
  }

  /// Re-authenticate user for sensitive operations with enhanced validation
  Future<bool> _reauthenticateUser(String currentPassword) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        Get.snackbar(
          'Authentication Error',
          'No authenticated user found. Please log in again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      if (user.email == null || user.email!.isEmpty) {
        Get.snackbar(
          'Authentication Error',
          'User email not found. Cannot proceed with reauthentication.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      if (currentPassword.isEmpty) {
        Get.snackbar(
          'Current Password Required',
          'Please enter your current password to verify your identity.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      // Create credential for reauthentication
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      // Perform reauthentication
      await user.reauthenticateWithCredential(credential);

      // If we reach here, reauthentication was successful
      Get.snackbar(
        'Authentication Verified',
        'Identity verified successfully. Proceeding with updates...',
        backgroundColor: const Color(0xFFC2D86A),
        colorText: Colors.black,
        duration: const Duration(seconds: 2),
      );

      return true;
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors
      String errorTitle = 'Authentication Failed';
      String errorMessage = 'Failed to verify current password.';

      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
          errorTitle = 'Incorrect Password';
          errorMessage =
              'The current password you entered is incorrect. Please try again.';
          break;
        case 'too-many-requests':
          errorTitle = 'Too Many Attempts';
          errorMessage =
              'Too many failed authentication attempts. Please wait a few minutes before trying again.';
          break;
        case 'user-disabled':
          errorTitle = 'Account Disabled';
          errorMessage =
              'Your account has been disabled. Please contact support for assistance.';
          break;
        case 'user-not-found':
          errorTitle = 'User Not Found';
          errorMessage = 'User account not found. Please log in again.';
          break;
        case 'invalid-email':
          errorTitle = 'Invalid Email';
          errorMessage = 'The email address is invalid. Please log in again.';
          break;
        case 'network-request-failed':
          errorTitle = 'Network Error';
          errorMessage =
              'Network connection failed. Please check your internet connection and try again.';
          break;
        default:
          errorMessage =
              e.message ?? 'An unexpected authentication error occurred.';
      }

      Get.snackbar(
        errorTitle,
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );

      return false;
    } catch (e) {
      Get.snackbar(
        'Authentication Error',
        'An unexpected error occurred during authentication: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
      return false;
    }
  }

  /// Update email in Firebase Auth with enhanced validation
  Future<bool> _updateEmail(String newEmail) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        Get.snackbar(
          'Authentication Error',
          'No authenticated user found. Please log in again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      // Validate email format before attempting update
      if (!GetUtils.isEmail(newEmail)) {
        Get.snackbar(
          'Invalid Email',
          'Please enter a valid email address.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      // Update email in Firebase Auth
      await user.verifyBeforeUpdateEmail(newEmail);

      // Reload user to get updated information
      await user.reload();

      Get.snackbar(
        'Email Update Initiated',
        'A verification email has been sent to $newEmail. Please verify to complete the update.',
        backgroundColor: const Color(0xFFC2D86A),
        colorText: Colors.black,
        duration: const Duration(seconds: 4),
      );

      return true;
    } on FirebaseAuthException catch (e) {
      String errorTitle = 'Email Update Failed';
      String errorMessage = 'Failed to update email address.';

      switch (e.code) {
        case 'email-already-in-use':
          errorTitle = 'Email Already in Use';
          errorMessage =
              'This email address is already associated with another account.';
          break;
        case 'invalid-email':
          errorTitle = 'Invalid Email';
          errorMessage = 'The email address format is invalid.';
          break;
        case 'requires-recent-login':
          errorTitle = 'Reauthentication Required';
          errorMessage =
              'For security reasons, please log out and log back in before changing your email.';
          break;
        case 'operation-not-allowed':
          errorTitle = 'Operation Not Allowed';
          errorMessage =
              'Email updates are currently disabled. Please contact support.';
          break;
        case 'network-request-failed':
          errorTitle = 'Network Error';
          errorMessage =
              'Network connection failed. Please check your internet connection and try again.';
          break;
        default:
          errorMessage =
              e.message ?? 'An unexpected error occurred while updating email.';
      }

      Get.snackbar(
        errorTitle,
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );

      return false;
    } catch (e) {
      Get.snackbar(
        'Email Update Error',
        'An unexpected error occurred: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
      return false;
    }
  }

  /// Update password in Firebase Auth with comprehensive validation
  Future<bool> _updatePassword(String newPassword) async {
    try {
      debugPrint(
        'DEBUG: _updatePassword called with password length: ${newPassword.length}',
      );

      final user = _auth.currentUser;
      if (user == null) {
        debugPrint('DEBUG: No current user found');
        Get.snackbar(
          'Authentication Error',
          'No authenticated user found. Please log in again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      // Validate password before attempting update
      if (!_isPasswordValid(newPassword)) {
        debugPrint('DEBUG: Password validation failed');
        Get.snackbar(
          'Invalid Password',
          'Password must be at least 6 characters and contain both letters and numbers.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      // Validate password confirmation
      if (!_isPasswordConfirmationValid()) {
        debugPrint('DEBUG: Password confirmation validation failed');
        Get.snackbar(
          'Password Mismatch',
          'Password and confirmation password do not match.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      debugPrint('DEBUG: About to call user.updatePassword()');
      // Update password in Firebase Auth
      await user.updatePassword(newPassword);

      debugPrint('DEBUG: Password update successful');
      Get.snackbar(
        'Password Updated',
        'Your password has been updated successfully.',
        backgroundColor: const Color(0xFFC2D86A),
        colorText: Colors.black,
        duration: const Duration(seconds: 3),
      );

      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint('DEBUG: FirebaseAuthException: ${e.code} - ${e.message}');
      String errorTitle = 'Password Update Failed';
      String errorMessage = 'Failed to update password.';

      switch (e.code) {
        case 'weak-password':
          errorTitle = 'Weak Password';
          errorMessage =
              'The password is too weak. Please choose a stronger password with at least 6 characters, including letters and numbers.';
          break;
        case 'requires-recent-login':
          errorTitle = 'Reauthentication Required';
          errorMessage =
              'For security reasons, please log out and log back in before changing your password.';
          break;
        case 'operation-not-allowed':
          errorTitle = 'Operation Not Allowed';
          errorMessage =
              'Password updates are currently disabled. Please contact support.';
          break;
        case 'network-request-failed':
          errorTitle = 'Network Error';
          errorMessage =
              'Network connection failed. Please check your internet connection and try again.';
          break;
        default:
          errorMessage =
              e.message ??
              'An unexpected error occurred while updating password.';
      }

      Get.snackbar(
        errorTitle,
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );

      return false;
    } catch (e) {
      Get.snackbar(
        'Password Update Error',
        'An unexpected error occurred: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
      return false;
    }
  }

  /// Update user profile in Firestore
  Future<bool> _updateUserProfile() async {
    try {
      final user = _auth.currentUser;
      if (user == null || currentUser.value == null) return false;

      // Create updated user model
      final updatedUser = UserModel(
        id: currentUser.value!.id,
        email: emailController.text.trim(),
        username: usernameController.text.trim(),
        phone: contactController.text.trim(),
        firstName: currentUser.value!.firstName,
        lastName: currentUser.value!.lastName,
        profileImage: currentUser.value!.profileImage,
        age: currentUser.value!.age,
        weight: currentUser.value!.weight,
        height: currentUser.value!.height,
        activityLevel: currentUser.value!.activityLevel,
        goals: currentUser.value!.goals,
        joinDate: currentUser.value!.joinDate,
        targetWeight: currentUser.value!.targetWeight,
        planName: currentUser.value!.planName,
        planDuration: currentUser.value!.planDuration,
        progressPercentage: currentUser.value!.progressPercentage,
        initialWeight: currentUser.value!.initialWeight,
        fatLost: currentUser.value!.fatLost,
        muscleGained: currentUser.value!.muscleGained,
        goalDuration: currentUser.value!.goalDuration,
      );

      await _usersService.updateUserProfile(updatedUser);

      // Update local storage
      final authController = Get.find<AuthController>();
      await authController.userdataStore(updatedUser.toJson());

      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: ${e.toString()}');
      return false;
    }
  }

  /// Save profile changes (excluding password changes)
  Future<void> saveChanges() async {
    try {
      debugPrint('=== SAVE PROFILE CHANGES DEBUG ===');
      debugPrint('usernameController.text: "${usernameController.text}"');
      debugPrint('emailController.text: "${emailController.text}"');
      debugPrint('contactController.text: "${contactController.text}"');
      debugPrint('canSave: $canSave');
      debugPrint('_hasChanges(): ${_hasChanges()}');
      debugPrint('hasValidationErrors: $hasValidationErrors');

      // Step 1: Validate all form data first (excluding password fields)
      _validateUsername();
      _validateEmail();
      _validateContact();

      if (hasValidationErrors) {
        debugPrint('DEBUG: Validation failed');
        Get.snackbar(
          'Validation Error',
          'Please fix all validation errors before saving.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Step 2: Check if any non-password changes were made
      final hasNonPasswordChanges =
          usernameController.text.trim() != _originalUsername ||
          emailController.text.trim() != _originalEmail ||
          contactController.text.trim() != _originalContact;

      if (!hasNonPasswordChanges) {
        debugPrint('DEBUG: No profile changes detected');
        Get.snackbar(
          'No Changes',
          'No profile changes detected to save.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      isSaving.value = true;

      // Step 3: Determine what operations need to be performed
      final needsEmailUpdate = emailController.text.trim() != _originalEmail;
      final needsProfileUpdate =
          usernameController.text.trim() != _originalUsername ||
          contactController.text.trim() != _originalContact ||
          needsEmailUpdate; // Email also needs to be updated in Firestore

      debugPrint('DEBUG: needsEmailUpdate: $needsEmailUpdate');
      debugPrint('DEBUG: needsProfileUpdate: $needsProfileUpdate');

      // Step 4: Handle reauthentication for email changes
      if (needsEmailUpdate) {
        if (currentPasswordController.text.isEmpty) {
          Get.snackbar(
            'Current Password Required',
            'Please enter your current password to verify your identity before changing email.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }

        // Perform reauthentication for email change
        final reauthSuccess = await _reauthenticateUser(
          currentPasswordController.text,
        );
        if (!reauthSuccess) {
          // Reauthentication failed - error already shown by _reauthenticateUser
          return;
        }
      }

      // Step 5: Perform operations in sequence
      bool allOperationsSuccessful = true;
      List<String> successfulOperations = [];
      String lastError = '';

      try {
        // Update email in Firebase Auth if changed
        if (needsEmailUpdate) {
          final emailUpdateSuccess = await _updateEmail(
            emailController.text.trim(),
          );
          if (emailUpdateSuccess) {
            successfulOperations.add('Email verification initiated');
          } else {
            allOperationsSuccessful = false;
            lastError = 'Email update failed';
          }
        }

        // Update user profile in Firestore if needed
        if (needsProfileUpdate && allOperationsSuccessful) {
          final profileUpdateSuccess = await _updateUserProfile();
          if (profileUpdateSuccess) {
            successfulOperations.add('Profile updated');
          } else {
            allOperationsSuccessful = false;
            lastError = 'Profile update failed';
          }
        }

        // Step 6: Handle results
        if (allOperationsSuccessful) {
          // All operations successful - update local state
          _originalUsername = usernameController.text.trim();
          _originalEmail = emailController.text.trim();
          _originalContact = contactController.text.trim();

          // Reset edit states for profile fields only
          isUsernameEditable.value = false;
          isEmailEditable.value = false;
          isContactEditable.value = false;

          // Clear current password field if it was used for email verification
          if (needsEmailUpdate) {
            currentPasswordController.clear();
          }

          // Clear validation errors for profile fields
          usernameError.value = '';
          emailError.value = '';
          contactError.value = '';
          currentPasswordError.value = '';

          // Refresh user data from Firestore
          try {
            currentUser.value = await _usersService.getUserProfile(
              _auth.currentUser!.uid,
            );
          } catch (e) {
            // Non-critical error - data refresh failed but updates were successful
            debugPrint('Warning: Failed to refresh user data: $e');
          }

          // Show success message
          String successMessage = 'Profile updated successfully!';
          if (successfulOperations.isNotEmpty) {
            successMessage += '\n\nUpdated: ${successfulOperations.join(', ')}';
          }

          Get.snackbar(
            'Success',
            successMessage,
            backgroundColor: const Color(0xFFC2D86A),
            colorText: Colors.black,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 4),
          );
        } else {
          // Some operations failed
          String errorMessage = 'Some changes could not be saved: $lastError';
          if (successfulOperations.isNotEmpty) {
            errorMessage +=
                '\n\nSuccessful updates: ${successfulOperations.join(', ')}';
          }

          Get.snackbar(
            'Partial Success',
            errorMessage,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
          );
        }
      } catch (e) {
        // Unexpected error during operations
        String errorMessage =
            'An unexpected error occurred while saving changes: ${e.toString()}';
        if (successfulOperations.isNotEmpty) {
          errorMessage +=
              '\n\nSuccessful updates: ${successfulOperations.join(', ')}';
        }

        Get.snackbar(
          'Save Error',
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      }
    } catch (e) {
      // Top-level error handling
      Get.snackbar(
        'Save Failed',
        'Failed to save changes: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isSaving.value = false;
    }
  }

  /// Refresh user data
  Future<void> refreshUserData() async {
    await _loadUserData();
  }

  /// Get password display (dots with last few characters)
  String getPasswordDisplay() {
    if (isPasswordEditable.value || showPassword.value) {
      return passwordController.text;
    }
    return '••••••••';
  }

  /// Check if save button should be enabled (for non-password profile updates)
  bool get canSave {
    debugPrint('=== CANSAVE DEBUG (Profile Updates Only) ===');

    // Don't allow save if currently saving
    if (isSaving.value) {
      debugPrint('canSave: false - currently saving');
      return false;
    }

    // Check if there are non-password changes
    final hasNonPasswordChanges =
        usernameController.text.trim() != _originalUsername ||
        emailController.text.trim() != _originalEmail ||
        contactController.text.trim() != _originalContact;

    if (!hasNonPasswordChanges) {
      debugPrint('canSave: false - no non-password changes detected');
      return false;
    }

    // Don't allow save if there are validation errors (excluding password fields)
    if (hasValidationErrors) {
      debugPrint('canSave: false - validation errors in profile fields');
      debugPrint('  usernameError: "${usernameError.value}"');
      debugPrint('  emailError: "${emailError.value}"');
      debugPrint('  contactError: "${contactError.value}"');
      return false;
    }

    debugPrint('canSave: true - profile changes ready to save');
    return true;
  }

  /// Check if current password verification button should be enabled
  bool get canVerifyCurrentPassword {
    return isPasswordEditable.value &&
        !isCurrentPasswordVerified.value &&
        currentPasswordController.text.isNotEmpty &&
        !isVerifyingCurrentPassword.value;
  }

  /// Get validation status for UI feedback (excluding password fields for general save)
  bool get hasValidationErrors {
    return usernameError.value.isNotEmpty ||
        emailError.value.isNotEmpty ||
        contactError.value.isNotEmpty;
  }

  /// Get validation status including password fields
  bool get hasPasswordValidationErrors {
    return passwordError.value.isNotEmpty ||
        confirmPasswordError.value.isNotEmpty ||
        currentPasswordError.value.isNotEmpty;
  }

  /// Dedicated method to change password independently
  Future<void> changePassword() async {
    try {
      debugPrint('=== CHANGE PASSWORD DEBUG ===');
      debugPrint(
        'currentPasswordController.text: "${currentPasswordController.text}"',
      );
      debugPrint('passwordController.text: "${passwordController.text}"');
      debugPrint(
        'confirmPasswordController.text: "${confirmPasswordController.text}"',
      );

      // Step 1: Validate all password fields are filled
      if (currentPasswordController.text.isEmpty) {
        Get.snackbar(
          'Current Password Required',
          'Please enter your current password.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (passwordController.text.isEmpty) {
        Get.snackbar(
          'New Password Required',
          'Please enter your new password.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (confirmPasswordController.text.isEmpty) {
        Get.snackbar(
          'Confirm Password Required',
          'Please confirm your new password.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Step 2: Validate new password meets requirements
      if (!_isPasswordValid(passwordController.text)) {
        Get.snackbar(
          'Invalid Password',
          'Password must be at least 6 characters and contain both letters and numbers.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Step 3: Validate passwords match
      if (passwordController.text != confirmPasswordController.text) {
        Get.snackbar(
          'Password Mismatch',
          'New password and confirmation password do not match.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      isChangingPassword.value = true;

      // Step 4: Reauthenticate with current password
      debugPrint('DEBUG: Starting reauthentication for password change');
      final reauthSuccess = await _reauthenticateUser(
        currentPasswordController.text,
      );

      if (!reauthSuccess) {
        debugPrint('DEBUG: Reauthentication failed');
        return;
      }

      // Step 5: Update password in Firebase
      debugPrint('DEBUG: Reauthentication successful, updating password');
      final passwordUpdateSuccess = await _updatePassword(
        passwordController.text,
      );

      if (passwordUpdateSuccess) {
        debugPrint('DEBUG: Password update successful');

        // Reset password change flow
        isPasswordEditable.value = false;
        isCurrentPasswordVerified.value = false;
        canEditNewPassword.value = false;
        showPassword.value = false;
        showConfirmPassword.value = false;
        showCurrentPassword.value = false;

        // Clear all password fields
        passwordController.clear();
        confirmPasswordController.clear();
        currentPasswordController.clear();

        // Clear password-related errors
        passwordError.value = '';
        confirmPasswordError.value = '';
        currentPasswordError.value = '';

        Get.snackbar(
          'Password Changed',
          'Your password has been changed successfully!',
          backgroundColor: const Color(0xFFC2D86A),
          colorText: Colors.black,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      } else {
        debugPrint('DEBUG: Password update failed');
        Get.snackbar(
          'Password Change Failed',
          'Failed to update password. Please try again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('DEBUG: Exception during password change: $e');
      Get.snackbar(
        'Password Change Error',
        'An error occurred while changing password: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isChangingPassword.value = false;
    }
  }

  /// Check if change password button should be enabled
  bool get canChangePassword {
    return isCurrentPasswordVerified.value &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        currentPasswordController.text.isNotEmpty &&
        !isChangingPassword.value &&
        passwordError.value.isEmpty &&
        confirmPasswordError.value.isEmpty &&
        currentPasswordError.value.isEmpty;
  }

  /// Debug method to check current state
  void debugCurrentState() {
    debugPrint('=== DEBUG STATE ===');
    debugPrint('isPasswordEditable: ${isPasswordEditable.value}');
    debugPrint('isCurrentPasswordVerified: ${isCurrentPasswordVerified.value}');
    debugPrint('canEditNewPassword: ${canEditNewPassword.value}');
    debugPrint('passwordController.text: "${passwordController.text}"');
    debugPrint(
      'confirmPasswordController.text: "${confirmPasswordController.text}"',
    );
    debugPrint(
      'currentPasswordController.text: "${currentPasswordController.text}"',
    );
    debugPrint('canSave: $canSave');
    debugPrint('_hasChanges(): ${_hasChanges()}');
    debugPrint('hasValidationErrors: $hasValidationErrors');
    debugPrint('==================');
  }
}
