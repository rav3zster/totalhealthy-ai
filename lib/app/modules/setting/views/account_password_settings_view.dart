import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/account_password_controller.dart';

class AccountPasswordSettingsView extends StatelessWidget {
  const AccountPasswordSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AccountPasswordController());

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF1A1A1A), Colors.black],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFC2D86A).withValues(alpha: 0.2),
                              const Color(0xFFC2D86A).withValues(alpha: 0.1),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Account & Password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'inter',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Obx(
                        () => TextButton(
                          onPressed: controller.canSave
                              ? controller.saveChanges
                              : null,
                          child: controller.isSaving.value
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFFC2D86A),
                                  ),
                                )
                              : Text(
                                  'Save',
                                  style: TextStyle(
                                    color: controller.canSave
                                        ? const Color(0xFFC2D86A)
                                        : Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFC2D86A),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: controller.refreshUserData,
                    color: const Color(0xFFC2D86A),
                    backgroundColor: const Color(0xFF2A2A2A),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User name
                          _buildInputField(
                            'User name',
                            controller.usernameController,
                            controller.isUsernameEditable,
                            controller.toggleUsernameEdit,
                            errorMessage: controller.usernameError,
                          ),

                          const SizedBox(height: 25),

                          // E-mail address
                          _buildInputField(
                            'E-mail address',
                            controller.emailController,
                            controller.isEmailEditable,
                            controller.toggleEmailEdit,
                            keyboardType: TextInputType.emailAddress,
                            errorMessage: controller.emailError,
                          ),

                          const SizedBox(height: 25),

                          // Contact no.
                          _buildInputField(
                            'Contact no.',
                            controller.contactController,
                            controller.isContactEditable,
                            controller.toggleContactEdit,
                            keyboardType: TextInputType.phone,
                            errorMessage: controller.contactError,
                          ),

                          const SizedBox(height: 25),

                          // Password section with two-step verification
                          _buildPasswordSection(controller),

                          const SizedBox(height: 40),

                          // Help text
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A2A2A),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(
                                  0xFFC2D86A,
                                ).withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: const Color(0xFFC2D86A),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Security Information',
                                      style: TextStyle(
                                        color: Color(0xFFC2D86A),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  '• Password changes require two-step verification\n'
                                  '• First verify your current password, then set a new one\n'
                                  '• Email changes require current password verification\n'
                                  '• All changes are synced to your Firebase account',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    RxBool isEditable,
    VoidCallback onEditTap, {
    TextInputType? keyboardType,
    RxString? errorMessage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(10),
              border: isEditable.value
                  ? Border.all(
                      color:
                          errorMessage != null && errorMessage.value.isNotEmpty
                          ? Colors.red
                          : const Color(0xFFC2D86A),
                      width: 1,
                    )
                  : null,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    enabled: isEditable.value,
                    keyboardType: keyboardType,
                    style: TextStyle(
                      color: isEditable.value ? Colors.white : Colors.white70,
                      fontSize: 16,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onEditTap,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      isEditable.value ? Icons.check : Icons.edit,
                      color: isEditable.value
                          ? const Color(0xFFC2D86A)
                          : Colors.white54,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Error message display
        if (errorMessage != null)
          Obx(
            () => errorMessage.value.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    child: Text(
                      errorMessage.value,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
      ],
    );
  }

  Widget _buildPasswordSection(AccountPasswordController controller) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Password header with edit toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Password',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: controller.togglePasswordEdit,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    controller.isPasswordEditable.value
                        ? Icons.close
                        : Icons.edit,
                    color: controller.isPasswordEditable.value
                        ? Colors.red
                        : Colors.white54,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          if (!controller.isPasswordEditable.value) ...[
            // Password display when not editing
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Text(
                      '••••••••',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            // Two-step password change flow
            if (!controller.isCurrentPasswordVerified.value) ...[
              // Step 1: Current password verification
              _buildCurrentPasswordVerificationStep(controller),
            ] else ...[
              // Step 2: New password entry (after verification)
              _buildNewPasswordStep(controller),
            ],
          ],
        ],
      );
    });
  }

  Widget _buildCurrentPasswordVerificationStep(
    AccountPasswordController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Info message
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.blue.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: const Row(
            children: [
              Icon(Icons.security, color: Colors.blue, size: 16),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Step 1: Verify your current password to proceed',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 15),

        // Current password input
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: controller.currentPasswordError.value.isNotEmpty
                  ? Colors.red
                  : Colors.blue.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.currentPasswordController,
                  obscureText: !controller.showCurrentPassword.value,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: 'Enter your current password',
                    hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                ),
              ),
              GestureDetector(
                onTap: controller.toggleCurrentPasswordVisibility,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    controller.showCurrentPassword.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.white54,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Error message
        if (controller.currentPasswordError.value.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: Text(
              controller.currentPasswordError.value,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),

        const SizedBox(height: 15),

        // Verify button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.canVerifyCurrentPassword
                ? controller.verifyCurrentPassword
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: controller.canVerifyCurrentPassword
                  ? Colors.blue
                  : Colors.grey,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: controller.isVerifyingCurrentPassword.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Verify Current Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildNewPasswordStep(AccountPasswordController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Success message
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFC2D86A).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFC2D86A).withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: const Row(
            children: [
              Icon(Icons.check_circle, color: Color(0xFFC2D86A), size: 16),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Step 2: Current password verified. Set your new password',
                  style: TextStyle(
                    color: Color(0xFFC2D86A),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 15),

        // New password field
        const Text(
          'New Password',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: controller.passwordError.value.isNotEmpty
                  ? Colors.red
                  : const Color(0xFFC2D86A),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.passwordController,
                  obscureText: !controller.showPassword.value,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: 'Enter new password',
                    hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                ),
              ),
              GestureDetector(
                onTap: controller.togglePasswordVisibility,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    controller.showPassword.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.white54,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),

        // New password error
        if (controller.passwordError.value.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: Text(
              controller.passwordError.value,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),

        const SizedBox(height: 15),

        // Confirm password field
        const Text(
          'Confirm New Password',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: controller.confirmPasswordError.value.isNotEmpty
                  ? Colors.red
                  : const Color(0xFFC2D86A),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.confirmPasswordController,
                  obscureText: !controller.showConfirmPassword.value,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: 'Confirm new password',
                    hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                ),
              ),
              GestureDetector(
                onTap: controller.toggleConfirmPasswordVisibility,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    controller.showConfirmPassword.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.white54,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Confirm password error
        if (controller.confirmPasswordError.value.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: Text(
              controller.confirmPasswordError.value,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),

        const SizedBox(height: 15),

        // Password requirements
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Password Requirements:',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '• At least 6 characters\n• Contains letters and numbers\n• Passwords must match',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 11,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Change Password button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.canChangePassword
                ? controller.changePassword
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: controller.canChangePassword
                  ? const Color(0xFFC2D86A)
                  : Colors.grey,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: controller.isChangingPassword.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  )
                : const Text(
                    'Change Password',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
