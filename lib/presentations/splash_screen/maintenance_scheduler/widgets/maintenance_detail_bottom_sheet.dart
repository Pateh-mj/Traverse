import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MaintenanceDetailBottomSheet extends StatelessWidget {
  final List<Map<String, dynamic>> maintenanceEvents;
  final DateTime selectedDate;

  const MaintenanceDetailBottomSheet({
    Key? key,
    required this.maintenanceEvents,
    required this.selectedDate,
  }) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return AppTheme.lightTheme.primaryColor;
      case 'overdue':
        return AppTheme.lightTheme.colorScheme.error;
      case 'completed':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'in_progress':
        return Colors.orange;
      default:
        return AppTheme.lightTheme.colorScheme.secondary;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 70.h,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 10.w,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'calendar_today',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Scheduled Maintenance',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _formatDate(selectedDate),
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${maintenanceEvents.length} ${maintenanceEvents.length == 1 ? 'Service' : 'Services'}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            height: 1,
          ),
          // Maintenance List
          Flexible(
            child: maintenanceEvents.isEmpty
                ? Container(
                    padding: EdgeInsets.all(8.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'event_available',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 48,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'No maintenance scheduled',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'No maintenance services are scheduled for this date.',
                          textAlign: TextAlign.center,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.all(4.w),
                    shrinkWrap: true,
                    itemCount: maintenanceEvents.length,
                    separatorBuilder: (context, index) => SizedBox(height: 2.h),
                    itemBuilder: (context, index) {
                      final maintenance = maintenanceEvents[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Status Bar
                            Container(
                              height: 4,
                              decoration: BoxDecoration(
                                color: _getStatusColor(
                                    maintenance['status'] ?? 'scheduled'),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(4.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header Row
                                  Row(
                                    children: [
                                      // Vehicle Image
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CustomImageWidget(
                                          imageUrl:
                                              maintenance['vehicleImage'] ?? '',
                                          width: 12.w,
                                          height: 12.w,
                                          fit: BoxFit.cover,
                                          semanticLabel: maintenance[
                                                  'vehicleImageSemanticLabel'] ??
                                              'Vehicle image',
                                        ),
                                      ),
                                      SizedBox(width: 3.w),
                                      // Vehicle Info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              maintenance['vehicleName'] ??
                                                  'Unknown Vehicle',
                                              style: AppTheme.lightTheme
                                                  .textTheme.titleSmall
                                                  ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              maintenance['vehicleId'] ?? '',
                                              style: AppTheme.lightTheme
                                                  .textTheme.bodySmall
                                                  ?.copyWith(
                                                color: AppTheme
                                                    .lightTheme
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Time
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.w, vertical: 0.5.h),
                                        decoration: BoxDecoration(
                                          color: AppTheme
                                              .lightTheme.primaryColor
                                              .withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          _formatTime(maintenance['dueDate']),
                                          style: AppTheme
                                              .lightTheme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: AppTheme
                                                .lightTheme.primaryColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2.h),
                                  // Service Info
                                  Row(
                                    children: [
                                      CustomIconWidget(
                                        iconName: 'build',
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                        size: 16,
                                      ),
                                      SizedBox(width: 2.w),
                                      Expanded(
                                        child: Text(
                                          maintenance['serviceType'] ??
                                              'General Service',
                                          style: AppTheme
                                              .lightTheme.textTheme.bodyMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (maintenance['serviceDescription'] !=
                                          null &&
                                      maintenance['serviceDescription'] !=
                                          maintenance['serviceType']) ...[
                                    SizedBox(height: 1.h),
                                    Text(
                                      maintenance['serviceDescription'],
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                  SizedBox(height: 2.h),
                                  // Footer Row
                                  Row(
                                    children: [
                                      // Priority
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.w, vertical: 0.5.h),
                                        decoration: BoxDecoration(
                                          color: _getPriorityColor(
                                                  maintenance['priority'] ??
                                                      'medium')
                                              .withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: _getPriorityColor(
                                                maintenance['priority'] ??
                                                    'medium'),
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          (maintenance['priority'] ?? 'Medium')
                                              .toUpperCase(),
                                          style: AppTheme
                                              .lightTheme.textTheme.labelSmall
                                              ?.copyWith(
                                            color: _getPriorityColor(
                                                maintenance['priority'] ??
                                                    'medium'),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      // Status
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.w, vertical: 0.5.h),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(
                                                  maintenance['status'] ??
                                                      'scheduled')
                                              .withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          (maintenance['status'] ?? 'Scheduled')
                                              .toUpperCase(),
                                          style: AppTheme
                                              .lightTheme.textTheme.labelSmall
                                              ?.copyWith(
                                            color: _getStatusColor(
                                                maintenance['status'] ??
                                                    'scheduled'),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Technician (if assigned)
                                  if (maintenance['assignedTechnician'] !=
                                      null) ...[
                                    SizedBox(height: 1.h),
                                    Row(
                                      children: [
                                        CustomIconWidget(
                                          iconName: 'person',
                                          color: AppTheme.lightTheme.colorScheme
                                              .onSurfaceVariant,
                                          size: 16,
                                        ),
                                        SizedBox(width: 2.w),
                                        Text(
                                          'Assigned to: ${maintenance['assignedTechnician']}',
                                          style: AppTheme
                                              .lightTheme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: AppTheme.lightTheme
                                                .colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppTheme.lightTheme.colorScheme.error;
      case 'medium':
        return Colors.orange;
      case 'low':
        return AppTheme.lightTheme.colorScheme.tertiary;
      default:
        return AppTheme.lightTheme.colorScheme.secondary;
    }
  }
}
