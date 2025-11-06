import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AlertItemWidget extends StatelessWidget {
  final Map<String, dynamic> alert;
  final VoidCallback? onDismiss;

  const AlertItemWidget({
    Key? key,
    required this.alert,
    this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String priority = alert['priority'] as String? ?? 'medium';
    final Color priorityColor = _getPriorityColor(priority);
    final String iconName = _getPriorityIcon(priority);

    return Dismissible(
      key: Key(alert['id'].toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.error,
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomIconWidget(
          iconName: 'delete',
          color: Colors.white,
          size: 24,
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 0.5.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: priorityColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: priorityColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  color: priorityColor,
                  size: 16,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alert['title'] as String? ?? 'Alert',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    alert['description'] as String? ?? '',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  alert['time'] as String? ?? '',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontSize: 10.sp,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: priorityColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    priority.toUpperCase(),
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: priorityColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 9.sp,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
      case 'critical':
        return AppTheme.lightTheme.colorScheme.error;
      case 'medium':
        return AppTheme.warningLight;
      case 'low':
        return AppTheme.successLight;
      default:
        return AppTheme.lightTheme.colorScheme.secondary;
    }
  }

  String _getPriorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
      case 'critical':
        return 'error';
      case 'medium':
        return 'warning';
      case 'low':
        return 'info';
      default:
        return 'notifications';
    }
  }
}
