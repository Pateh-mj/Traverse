import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MaintenanceCardWidget extends StatelessWidget {
  final Map<String, dynamic> maintenance;
  final VoidCallback? onTap;
  final VoidCallback? onReschedule;
  final VoidCallback? onMarkComplete;
  final VoidCallback? onAddNotes;
  final VoidCallback? onCancel;
  final VoidCallback? onAssignTechnician;
  final VoidCallback? onViewHistory;

  const MaintenanceCardWidget({
    Key? key,
    required this.maintenance,
    this.onTap,
    this.onReschedule,
    this.onMarkComplete,
    this.onAddNotes,
    this.onCancel,
    this.onAssignTechnician,
    this.onViewHistory,
  }) : super(key: key);

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
    return '${date.day}/${date.month}/${date.year}';
  }

  bool _isOverdue(DateTime dueDate) {
    return DateTime.now().isAfter(dueDate) &&
        maintenance['status']?.toLowerCase() != 'completed';
  }

  @override
  Widget build(BuildContext context) {
    final dueDate = maintenance['dueDate'] as DateTime;
    final isOverdue = _isOverdue(dueDate);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(maintenance['id']),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onReschedule?.call(),
              backgroundColor: AppTheme.lightTheme.primaryColor,
              foregroundColor: Colors.white,
              icon: Icons.schedule,
              label: 'Reschedule',
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            SlidableAction(
              onPressed: (_) => onMarkComplete?.call(),
              backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
              foregroundColor: Colors.white,
              icon: Icons.check_circle,
              label: 'Complete',
            ),
            SlidableAction(
              onPressed: (_) => onAddNotes?.call(),
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              icon: Icons.note_add,
              label: 'Notes',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onAssignTechnician?.call(),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.person_add,
              label: 'Assign',
            ),
            SlidableAction(
              onPressed: (_) => onViewHistory?.call(),
              backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
              foregroundColor: Colors.white,
              icon: Icons.history,
              label: 'History',
            ),
            SlidableAction(
              onPressed: (_) => onCancel?.call(),
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              foregroundColor: Colors.white,
              icon: Icons.cancel,
              label: 'Cancel',
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isOverdue
                    ? AppTheme.lightTheme.colorScheme.error
                        .withValues(alpha: 0.3)
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                width: isOverdue ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
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
                    color:
                        _getStatusColor(maintenance['status'] ?? 'scheduled'),
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
                              imageUrl: maintenance['vehicleImage'] ?? '',
                              width: 15.w,
                              height: 15.w,
                              fit: BoxFit.cover,
                              semanticLabel:
                                  maintenance['vehicleImageSemanticLabel'] ??
                                      'Vehicle image',
                            ),
                          ),
                          SizedBox(width: 3.w),
                          // Vehicle Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  maintenance['vehicleName'] ??
                                      'Unknown Vehicle',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  maintenance['vehicleId'] ?? '',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Priority Badge
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: _getPriorityColor(
                                      maintenance['priority'] ?? 'medium')
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _getPriorityColor(
                                    maintenance['priority'] ?? 'medium'),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              (maintenance['priority'] ?? 'Medium')
                                  .toUpperCase(),
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: _getPriorityColor(
                                    maintenance['priority'] ?? 'medium'),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      // Service Description
                      Text(
                        maintenance['serviceDescription'] ?? 'No description',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 1.h),
                      // Service Type
                      if (maintenance['serviceType'] != null)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.primaryColor
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            maintenance['serviceType'],
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      SizedBox(height: 2.h),
                      // Footer Row
                      Row(
                        children: [
                          // Due Date
                          Expanded(
                            child: Row(
                              children: [
                                CustomIconWidget(
                                  iconName: isOverdue ? 'warning' : 'schedule',
                                  color: isOverdue
                                      ? AppTheme.lightTheme.colorScheme.error
                                      : AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                  size: 16,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  isOverdue
                                      ? 'Overdue: ${_formatDate(dueDate)}'
                                      : 'Due: ${_formatDate(dueDate)}',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: isOverdue
                                        ? AppTheme.lightTheme.colorScheme.error
                                        : AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                    fontWeight: isOverdue
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Status Badge
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: _getStatusColor(
                                      maintenance['status'] ?? 'scheduled')
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              (maintenance['status'] ?? 'Scheduled')
                                  .toUpperCase(),
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: _getStatusColor(
                                    maintenance['status'] ?? 'scheduled'),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Technician Info (if assigned)
                      if (maintenance['assignedTechnician'] != null) ...[
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'person',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 16,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              'Assigned to: ${maintenance['assignedTechnician']}',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
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
          ),
        ),
      ),
    );
  }
}
