import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActivityItemWidget extends StatelessWidget {
  final Map<String, dynamic> activity;

  const ActivityItemWidget({
    Key? key,
    required this.activity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String type = activity['type'] as String? ?? 'general';
    final Color typeColor = _getActivityColor(type);
    final String iconName = _getActivityIcon(type);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.5.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: iconName,
                color: typeColor,
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'] as String? ?? 'Activity',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  activity['description'] as String? ?? '',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (activity['vehicle'] != null) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    'Vehicle: ${activity['vehicle']}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          Text(
            activity['time'] as String? ?? '',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }

  Color _getActivityColor(String type) {
    switch (type.toLowerCase()) {
      case 'checkin':
      case 'checkout':
        return AppTheme.successLight;
      case 'maintenance':
        return AppTheme.warningLight;
      case 'trip':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'alert':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.secondary;
    }
  }

  String _getActivityIcon(String type) {
    switch (type.toLowerCase()) {
      case 'checkin':
        return 'login';
      case 'checkout':
        return 'logout';
      case 'maintenance':
        return 'build';
      case 'trip':
        return 'directions_car';
      case 'alert':
        return 'warning';
      default:
        return 'event';
    }
  }
}
