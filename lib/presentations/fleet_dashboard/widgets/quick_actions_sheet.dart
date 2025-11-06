import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsSheet extends StatelessWidget {
  final BuildContext context;

  const QuickActionsSheet({
    Key? key,
    required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> actions = [
      {
        'title': 'Assign Driver',
        'description': 'Assign driver to vehicle',
        'icon': 'person_add',
        'color': AppTheme.lightTheme.colorScheme.primary,
        'action': () => _handleAssignDriver(context),
      },
      {
        'title': 'Schedule Maintenance',
        'description': 'Schedule vehicle maintenance',
        'icon': 'build',
        'color': AppTheme.warningLight,
        'action': () => _handleScheduleMaintenance(context),
      },
      {
        'title': 'Create Geofence',
        'description': 'Set up location boundaries',
        'icon': 'location_on',
        'color': AppTheme.successLight,
        'action': () => _handleCreateGeofence(context),
      },
      {
        'title': 'Track Vehicle',
        'description': 'View live vehicle location',
        'icon': 'gps_fixed',
        'color': AppTheme.lightTheme.colorScheme.tertiary,
        'action': () => _handleTrackVehicle(context),
      },
      {
        'title': 'Generate Report',
        'description': 'Create fleet performance report',
        'icon': 'assessment',
        'color': AppTheme.lightTheme.colorScheme.secondary,
        'action': () => _handleGenerateReport(context),
      },
      {
        'title': 'Emergency Alert',
        'description': 'Send emergency notification',
        'icon': 'emergency',
        'color': AppTheme.lightTheme.colorScheme.error,
        'action': () => _handleEmergencyAlert(context),
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Text(
                  'Quick Actions',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              itemCount: actions.length,
              itemBuilder: (context, index) {
                final action = actions[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 2.h),
                  child: ListTile(
                    onTap: action['action'] as VoidCallback?,
                    leading: Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color:
                            (action['color'] as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: action['icon'] as String,
                          color: action['color'] as Color,
                          size: 24,
                        ),
                      ),
                    ),
                    title: Text(
                      action['title'] as String,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      action['description'] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'arrow_forward_ios',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 2.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  void _handleAssignDriver(BuildContext context) {
    Navigator.pop(context);
    // Navigate to driver assignment screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening driver assignment...')),
    );
  }

  void _handleScheduleMaintenance(BuildContext context) {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/maintenance-scheduler');
  }

  void _handleCreateGeofence(BuildContext context) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening geofence creator...')),
    );
  }

  void _handleTrackVehicle(BuildContext context) {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/live-vehicle-tracking');
  }

  void _handleGenerateReport(BuildContext context) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Generating fleet report...')),
    );
  }

  void _handleEmergencyAlert(BuildContext context) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Alert'),
        content: const Text('Send emergency notification to all drivers?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Emergency alert sent!')),
              );
            },
            child: const Text('Send Alert'),
          ),
        ],
      ),
    );
  }
}
