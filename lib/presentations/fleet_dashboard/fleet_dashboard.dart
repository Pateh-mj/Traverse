import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/activity_item_widget.dart';
import './widgets/alert_item_widget.dart';
import './widgets/fleet_map_widget.dart';
import './widgets/metric_card_widget.dart';
import './widgets/quick_actions_sheet.dart';

class FleetDashboard extends StatefulWidget {
  const FleetDashboard({Key? key}) : super(key: key);

  @override
  State<FleetDashboard> createState() => _FleetDashboardState();
}

class _FleetDashboardState extends State<FleetDashboard>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isRefreshing = false;

  // Mock data for fleet metrics
  final List<Map<String, dynamic>> _metricsData = [
    {
      'title': 'Total Vehicles',
      'value': '247',
      'subtitle': '+12 this month',
      'color': AppTheme.lightTheme.colorScheme.primary,
      'icon': 'directions_car',
    },
    {
      'title': 'Active Trips',
      'value': '89',
      'subtitle': '36% of fleet',
      'color': AppTheme.successLight,
      'icon': 'route',
    },
    {
      'title': 'Alerts',
      'value': '7',
      'subtitle': '3 critical',
      'color': AppTheme.lightTheme.colorScheme.error,
      'icon': 'warning',
    },
    {
      'title': 'Fuel Efficiency',
      'value': '8.2',
      'subtitle': 'MPG average',
      'color': AppTheme.warningLight,
      'icon': 'local_gas_station',
    },
  ];

  // Mock data for priority alerts
  final List<Map<String, dynamic>> _alertsData = [
    {
      'id': 1,
      'title': 'Engine Overheating',
      'description': 'Vehicle FL-2847 requires immediate attention',
      'priority': 'high',
      'time': '2 min ago',
      'vehicle': 'FL-2847',
    },
    {
      'id': 2,
      'title': 'Maintenance Due',
      'description': 'Vehicle FL-1923 scheduled for service tomorrow',
      'priority': 'medium',
      'time': '15 min ago',
      'vehicle': 'FL-1923',
    },
    {
      'id': 3,
      'title': 'Geofence Violation',
      'description': 'Vehicle FL-3456 left authorized area',
      'priority': 'medium',
      'time': '1 hour ago',
      'vehicle': 'FL-3456',
    },
  ];

  // Mock data for recent activities
  final List<Map<String, dynamic>> _activitiesData = [
    {
      'id': 1,
      'title': 'Driver Check-in',
      'description': 'Sarah Johnson started shift',
      'type': 'checkin',
      'time': '8:30 AM',
      'vehicle': 'FL-2847',
    },
    {
      'id': 2,
      'title': 'Trip Completed',
      'description': 'Delivery route #1247 finished',
      'type': 'trip',
      'time': '8:15 AM',
      'vehicle': 'FL-1923',
    },
    {
      'id': 3,
      'title': 'Maintenance Reminder',
      'description': 'Oil change due in 500 miles',
      'type': 'maintenance',
      'time': '7:45 AM',
      'vehicle': 'FL-3456',
    },
    {
      'id': 4,
      'title': 'Driver Check-out',
      'description': 'Mike Davis ended shift',
      'type': 'checkout',
      'time': '6:00 PM',
      'vehicle': 'FL-7891',
    },
  ];

  // Mock data for vehicle locations
  final List<Map<String, dynamic>> _vehiclesData = [
    {
      'id': 1,
      'name': 'FL-2847',
      'driver': 'Sarah Johnson',
      'status': 'active',
      'latitude': 37.7849,
      'longitude': -122.4094,
      'licensePlate': 'FL-2847',
      'fuelLevel': 78,
      'speed': 35,
      'lastUpdate': '2 min ago',
    },
    {
      'id': 2,
      'name': 'FL-1923',
      'driver': 'Mike Davis',
      'status': 'idle',
      'latitude': 37.7649,
      'longitude': -122.4194,
      'licensePlate': 'FL-1923',
      'fuelLevel': 45,
      'speed': 0,
      'lastUpdate': '5 min ago',
    },
    {
      'id': 3,
      'name': 'FL-3456',
      'driver': 'Emma Wilson',
      'status': 'maintenance',
      'latitude': 37.7949,
      'longitude': -122.3994,
      'licensePlate': 'FL-3456',
      'fuelLevel': 92,
      'speed': 0,
      'lastUpdate': '1 hour ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      elevation: 1,
      title: Row(
        children: [
          CustomIconWidget(
            iconName: 'local_shipping',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 28,
          ),
          SizedBox(width: 2.w),
          Text(
            'FleetTracker Pro',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
        ],
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              onPressed: () {
                // Handle notifications
              },
              icon: CustomIconWidget(
                iconName: 'notifications',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ),
            if (_alertsData.isNotEmpty)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.error,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
          ],
        ),
        IconButton(
          onPressed: () {
            // Handle profile/settings
          },
          icon: CustomIconWidget(
            iconName: 'account_circle',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusBar(),
            _buildMetricsSection(),
            _buildMapSection(),
            _buildAlertsSection(),
            _buildActivitiesSection(),
            SizedBox(height: 10.h), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 3.w,
            height: 3.w,
            decoration: BoxDecoration(
              color: AppTheme.successLight,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            'System Online',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.successLight,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            'Last updated: ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Text(
              'Fleet Overview',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Wrap(
            children: _metricsData.map((metric) {
              return MetricCardWidget(
                title: metric['title'] as String,
                value: metric['value'] as String,
                subtitle: metric['subtitle'] as String,
                color: metric['color'] as Color,
                iconName: metric['icon'] as String,
                onTap: () => _handleMetricTap(metric),
                onLongPress: () => _handleMetricLongPress(metric),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
          child: Row(
            children: [
              Text(
                'Live Fleet Map',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/live-vehicle-tracking');
                },
                icon: CustomIconWidget(
                  iconName: 'fullscreen',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 16,
                ),
                label: const Text('Full View'),
              ),
            ],
          ),
        ),
        FleetMapWidget(vehicles: _vehiclesData),
      ],
    );
  }

  Widget _buildAlertsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: Row(
            children: [
              Text(
                'Priority Alerts',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (_alertsData.isNotEmpty)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.error
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_alertsData.length}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (_alertsData.isEmpty)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.successLight,
                  size: 48,
                ),
                SizedBox(height: 2.h),
                Text(
                  'No Active Alerts',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'All vehicles are operating normally',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: _alertsData.length,
            itemBuilder: (context, index) {
              return AlertItemWidget(
                alert: _alertsData[index],
                onDismiss: () => _handleAlertDismiss(index),
              );
            },
          ),
      ],
    );
  }

  Widget _buildActivitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: Text(
            'Recent Activity',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          itemCount: _activitiesData.length,
          itemBuilder: (context, index) {
            return ActivityItemWidget(
              activity: _activitiesData[index],
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _handleBottomNavTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
      unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'dashboard',
            color: _currentIndex == 0
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'directions_car',
            color: _currentIndex == 1
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Vehicles',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'people',
            color: _currentIndex == 2
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Drivers',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'assessment',
            color: _currentIndex == 3
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Reports',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'more_horiz',
            color: _currentIndex == 4
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'More',
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: _showQuickActions,
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      foregroundColor: Colors.white,
      icon: CustomIconWidget(
        iconName: 'add',
        color: Colors.white,
        size: 24,
      ),
      label: const Text('Quick Actions'),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fleet data refreshed'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleMetricTap(Map<String, dynamic> metric) {
    // Handle metric card tap
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing ${metric['title']} details')),
    );
  }

  void _handleMetricLongPress(Map<String, dynamic> metric) {
    // Show detailed breakdown
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(metric['title'] as String),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current Value: ${metric['value']}'),
            SizedBox(height: 1.h),
            Text('Change: ${metric['subtitle']}'),
            SizedBox(height: 1.h),
            const Text('Detailed breakdown would be shown here...'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleAlertDismiss(int index) {
    setState(() {
      _alertsData.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Alert dismissed')),
    );
  }

  void _handleBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Handle navigation based on index
    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        // Navigate to vehicles
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vehicles section coming soon')),
        );
        break;
      case 2:
        // Navigate to drivers
        Navigator.pushNamed(context, '/driver-mobile-dashboard');
        break;
      case 3:
        // Navigate to reports
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reports section coming soon')),
        );
        break;
      case 4:
        // Navigate to more
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('More options coming soon')),
        );
        break;
    }
  }

  void _showQuickActions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => QuickActionsSheet(context: context),
    );
  }
}
