import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/biometric_auth_widget.dart';
import './widgets/enterprise_sso_widget.dart';
import './widgets/fleet_logo_widget.dart';
import './widgets/login_form_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  String? _errorMessage;

  // Mock credentials for different user types
  final Map<String, Map<String, String>> _mockCredentials = {
    'manager@fleettracker.com': {
      'password': 'manager123',
      'role': 'manager',
      'route': '/fleet-dashboard'
    },
    'dispatcher@fleettracker.com': {
      'password': 'dispatch123',
      'role': 'dispatcher',
      'route': '/live-vehicle-tracking'
    },
    'driver@fleettracker.com': {
      'password': 'driver123',
      'role': 'driver',
      'route': '/driver-mobile-dashboard'
    },
    'admin@fleettracker.com': {
      'password': 'admin123',
      'role': 'admin',
      'route': '/fleet-dashboard'
    },
  };

  @override
  void initState() {
    super.initState();
    // Set status bar style for login screen
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  Future<void> _handleLogin(String email, String password) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Check mock credentials
    if (_mockCredentials.containsKey(email.toLowerCase())) {
      final userCredentials = _mockCredentials[email.toLowerCase()]!;
      if (userCredentials['password'] == password) {
        // Success - navigate to appropriate dashboard
        HapticFeedback.mediumImpact();

        if (mounted) {
          Navigator.pushReplacementNamed(context, userCredentials['route']!);
        }
        return;
      }
    }

    // Authentication failed
    setState(() {
      _isLoading = false;
      _errorMessage =
          'Invalid email or password. Please check your credentials and try again.';
    });

    HapticFeedback.heavyImpact();
  }

  void _handleBiometricAuth() {
    // Simulate biometric authentication
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
            'Biometric authentication will be available in the next update'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  void _handleMicrosoftSSO() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Microsoft SSO integration coming soon'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  void _handleGoogleSSO() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Google SSO integration coming soon'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 8.h),

                    // Fleet Logo
                    const Center(child: FleetLogoWidget()),

                    SizedBox(height: 6.h),

                    // Welcome Text
                    Text(
                      'Welcome Back',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),

                    SizedBox(height: 1.h),

                    Text(
                      'Sign in to access your fleet management dashboard',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Error Message
                    if (_errorMessage != null) ...[
                      Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.error
                                .withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'error_outline',
                              color: AppTheme.lightTheme.colorScheme.error,
                              size: 5.w,
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme
                                      .lightTheme.colorScheme.onErrorContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 2.h),
                    ],

                    // Login Form
                    LoginFormWidget(
                      onLogin: _handleLogin,
                      isLoading: _isLoading,
                    ),

                    // Biometric Authentication
                    BiometricAuthWidget(
                      onBiometricAuth: _handleBiometricAuth,
                      isEnabled: !_isLoading,
                    ),

                    // Enterprise SSO Options
                    EnterpriseSsoWidget(
                      onMicrosoftLogin: _handleMicrosoftSSO,
                      onGoogleLogin: _handleGoogleSSO,
                      isEnabled: !_isLoading,
                    ),

                    SizedBox(height: 4.h),

                    // Demo Credentials Info
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'info_outline',
                                color: AppTheme.lightTheme.primaryColor,
                                size: 5.w,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Demo Credentials',
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.lightTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Manager: manager@fleettracker.com / manager123\n'
                            'Dispatcher: dispatcher@fleettracker.com / dispatch123\n'
                            'Driver: driver@fleettracker.com / driver123',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w400,
                              color: AppTheme
                                  .lightTheme.colorScheme.onPrimaryContainer,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
