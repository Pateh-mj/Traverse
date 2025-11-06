import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  bool _isInitializing = true;
  String _initializationStatus = 'Initializing FleetTracker Pro...';
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _animationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Set system UI overlay style
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: AppTheme.lightTheme.primaryColor,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppTheme.lightTheme.primaryColor,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );

      // Simulate initialization steps
      await _performInitializationSteps();

      // Navigate based on authentication status
      await _navigateToNextScreen();
    } catch (e) {
      setState(() {
        _hasError = true;
        _initializationStatus = 'Initialization failed. Tap to retry.';
      });
    }
  }

  Future<void> _performInitializationSteps() async {
    final steps = [
      {'status': 'Checking authentication...', 'duration': 800},
      {'status': 'Loading user permissions...', 'duration': 600},
      {'status': 'Fetching fleet configuration...', 'duration': 700},
      {'status': 'Preparing vehicle data...', 'duration': 500},
      {'status': 'Initializing GPS services...', 'duration': 400},
    ];

    for (final step in steps) {
      if (mounted) {
        setState(() {
          _initializationStatus = step['status'] as String;
        });
        await Future.delayed(Duration(milliseconds: step['duration'] as int));
      }
    }

    if (mounted) {
      setState(() {
        _isInitializing = false;
        _initializationStatus = 'Ready to launch!';
      });
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  Future<void> _navigateToNextScreen() async {
    if (!mounted) return;

    // Simulate authentication check
    final isAuthenticated = await _checkAuthenticationStatus();
    final userRole = await _getUserRole();

    if (isAuthenticated) {
      switch (userRole) {
        case 'manager':
        case 'dispatcher':
          Navigator.pushReplacementNamed(context, '/fleet-dashboard');
          break;
        case 'driver':
          Navigator.pushReplacementNamed(context, '/driver-mobile-dashboard');
          break;
        default:
          Navigator.pushReplacementNamed(context, '/fleet-dashboard');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/login-screen');
    }
  }

  Future<bool> _checkAuthenticationStatus() async {
    // Simulate authentication check
    await Future.delayed(const Duration(milliseconds: 200));
    // For demo purposes, return false to show login screen
    return false;
  }

  Future<String> _getUserRole() async {
    // Simulate user role retrieval
    await Future.delayed(const Duration(milliseconds: 100));
    return 'manager'; // Default role
  }

  void _retryInitialization() {
    setState(() {
      _hasError = false;
      _isInitializing = true;
      _initializationStatus = 'Retrying initialization...';
    });
    _initializeApp();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.lightTheme.primaryColor,
              AppTheme.lightTheme.primaryColor.withValues(alpha: 0.8),
              AppTheme.lightTheme.colorScheme.secondary,
            ],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo Section
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: _buildLogo(),
                        ),
                      ),
                    ),

                    // Loading Section
                    Expanded(
                      flex: 1,
                      child: _buildLoadingSection(),
                    ),

                    // Footer Section
                    _buildFooter(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // App Icon/Logo
        Container(
          width: 25.w,
          height: 25.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.w),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: 'local_shipping',
              color: AppTheme.lightTheme.primaryColor,
              size: 12.w,
            ),
          ),
        ),

        SizedBox(height: 3.h),

        // App Name
        Text(
          'FleetTracker Pro',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 1.h),

        // Tagline
        Text(
          'Enterprise Fleet Management',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoadingSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Loading Indicator
        _hasError
            ? GestureDetector(
                onTap: _retryInitialization,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2.w),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'refresh',
                        color: Colors.white,
                        size: 5.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Retry',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox(
                width: 6.w,
                height: 6.w,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ),

        SizedBox(height: 3.h),

        // Status Text
        Container(
          constraints: BoxConstraints(maxWidth: 80.w),
          child: Text(
            _initializationStatus,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Version Info
          Text(
            'Version 1.0.0',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 10.sp,
            ),
          ),

          SizedBox(height: 1.h),

          // Copyright
          Text(
            '© 2024 FleetTracker Pro. All rights reserved.',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 9.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
