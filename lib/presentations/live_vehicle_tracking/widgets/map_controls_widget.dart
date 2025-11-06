import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MapControlsWidget extends StatelessWidget {
  final VoidCallback? onLocationPressed;
  final VoidCallback? onZoomIn;
  final VoidCallback? onZoomOut;
  final VoidCallback? onLayerToggle;
  final VoidCallback? onFilterPressed;
  final bool isTrafficEnabled;
  final String currentMapType;

  const MapControlsWidget({
    Key? key,
    this.onLocationPressed,
    this.onZoomIn,
    this.onZoomOut,
    this.onLayerToggle,
    this.onFilterPressed,
    this.isTrafficEnabled = false,
    this.currentMapType = 'normal',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Filter button (top-right)
        Positioned(
          top: 8.h,
          right: 4.w,
          child: _buildControlButton(
            iconName: 'tune',
            onPressed: onFilterPressed,
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            iconColor: Colors.white,
          ),
        ),

        // Layer toggle button (top-right, below filter)
        Positioned(
          top: 16.h,
          right: 4.w,
          child: _buildControlButton(
            iconName: _getLayerIcon(),
            onPressed: onLayerToggle,
            backgroundColor: isTrafficEnabled
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.surface,
            iconColor: isTrafficEnabled
                ? Colors.white
                : AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),

        // Location button (bottom-right)
        Positioned(
          bottom: 20.h,
          right: 4.w,
          child: _buildControlButton(
            iconName: 'my_location',
            onPressed: onLocationPressed,
            backgroundColor: AppTheme.lightTheme.colorScheme.surface,
            iconColor: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),

        // Zoom controls (bottom-right, stacked)
        Positioned(
          bottom: 12.h,
          right: 4.w,
          child: Column(
            children: [
              _buildControlButton(
                iconName: 'add',
                onPressed: onZoomIn,
                backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                iconColor: AppTheme.lightTheme.colorScheme.onSurface,
                isTopButton: true,
              ),
              _buildControlButton(
                iconName: 'remove',
                onPressed: onZoomOut,
                backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                iconColor: AppTheme.lightTheme.colorScheme.onSurface,
                isBottomButton: true,
              ),
            ],
          ),
        ),

        // Connection status indicator (top-left)
        Positioned(
          top: 8.h,
          left: 4.w,
          child: _buildConnectionStatus(),
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required String iconName,
    required VoidCallback? onPressed,
    required Color backgroundColor,
    required Color iconColor,
    bool isTopButton = false,
    bool isBottomButton = false,
  }) {
    BorderRadius borderRadius;
    if (isTopButton) {
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      );
    } else if (isBottomButton) {
      borderRadius = const BorderRadius.only(
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(12),
      );
    } else {
      borderRadius = BorderRadius.circular(12);
    }

    return Container(
      width: 12.w,
      height: 12.w,
      margin: EdgeInsets.only(bottom: isTopButton ? 0 : 1.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: borderRadius,
          child: Center(
            child: CustomIconWidget(
              iconName: iconName,
              color: iconColor,
              size: 6.w,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionStatus() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.onlineStatus,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 2.w,
            height: 2.w,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            'Live',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _getLayerIcon() {
    switch (currentMapType) {
      case 'satellite':
        return 'satellite_alt';
      case 'terrain':
        return 'terrain';
      case 'hybrid':
        return 'layers';
      default:
        return 'map';
    }
  }
}
