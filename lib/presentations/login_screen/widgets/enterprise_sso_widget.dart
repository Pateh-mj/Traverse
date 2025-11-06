import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EnterpriseSsoWidget extends StatelessWidget {
  final VoidCallback? onMicrosoftLogin;
  final VoidCallback? onGoogleLogin;
  final bool isEnabled;

  const EnterpriseSsoWidget({
    super.key,
    this.onMicrosoftLogin,
    this.onGoogleLogin,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 3.h),

        Text(
          'Enterprise Single Sign-On',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),

        SizedBox(height: 2.h),

        // Microsoft SSO Button
        SizedBox(
          width: double.infinity,
          height: 6.h,
          child: OutlinedButton.icon(
            onPressed: isEnabled ? onMicrosoftLogin : null,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: isEnabled
                    ? AppTheme.lightTheme.colorScheme.outline
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: Container(
              width: 5.w,
              height: 5.w,
              decoration: BoxDecoration(
                color: const Color(0xFF0078D4),
                borderRadius: BorderRadius.circular(2),
              ),
              child: CustomIconWidget(
                iconName: 'business',
                color: Colors.white,
                size: 3.w,
              ),
            ),
            label: Text(
              'Continue with Microsoft',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isEnabled
                    ? AppTheme.lightTheme.colorScheme.onSurface
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.5),
              ),
            ),
          ),
        ),

        SizedBox(height: 1.5.h),

        // Google SSO Button
        SizedBox(
          width: double.infinity,
          height: 6.h,
          child: OutlinedButton.icon(
            onPressed: isEnabled ? onGoogleLogin : null,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: isEnabled
                    ? AppTheme.lightTheme.colorScheme.outline
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: Container(
              width: 5.w,
              height: 5.w,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF4285F4),
                    Color(0xFF34A853),
                    Color(0xFFFBBC05),
                    Color(0xFFEA4335)
                  ],
                  stops: [0.0, 0.33, 0.66, 1.0],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
              child: CustomIconWidget(
                iconName: 'g_translate',
                color: Colors.white,
                size: 3.w,
              ),
            ),
            label: Text(
              'Continue with Google',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isEnabled
                    ? AppTheme.lightTheme.colorScheme.onSurface
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
