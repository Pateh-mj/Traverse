import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/current_trip_card_widget.dart';
import './widgets/emergency_panic_button_widget.dart';
import './widgets/quick_actions_grid_widget.dart';
import './widgets/recent_trips_widget.dart';
import './widgets/vehicle_status_widget.dart';

class DriverMobileDashboard extends StatefulWidget {
  const DriverMobileDashboard({Key? key}) : super(key: key);

  @override
  State<DriverMobileDashboard> createState() => _DriverMobileDashboardState();
}

class _DriverMobileDashboardState extends State<DriverMobileDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isOnShift = false;
  bool _isLoading = false;

  // Mock data for driver dashboard
  final Map<String, dynamic> _driverData = {
    "name": "Michael Rodriguez",
    "employeeId": "DR-2024-001",
    "avatar":
        "https://img.rocket.new/generatedImages/rocket_gen_img_17616e717-1762274227967.png",
    "semanticLabel":
        "Professional headshot of Hispanic man with short black hair wearing navy blue uniform shirt",
    "shiftStatus": "off_shift",
    "assignedVehicle": "Truck-FL-2024-A",
  };

  final Map<String, dynamic> _currentTripData = {
    "destination": "Downtown Distribution Center - 1425 Commerce St",
    "estimatedArrival": "2:45 PM",
    "progress": 0.65,
    "remainingDistance": "12.3 mi",
    "remainingTime": "28 min",
  };

  final Map<String, dynamic> _vehicleData = {
    "vehicleName": "Truck FL-2024-A",
    "fuelLevel": 0.72,
    "engineStatus": "good",
    "maintenanceAlert": true,
  };

  final List<Map<String, dynamic>> _recentTripsData = [
    {
      "destination": "Westside Warehouse Complex",
      "completedTime": "Nov 5, 1:30 PM",
      "distance": "18.7 mi",
      "status": "completed",
    },
    {
      "destination": "Central Business District",
      "completedTime": "Nov 5, 10:15 AM",
      "distance": "24.1 mi",
      "status": "completed",
    },
    {
      "destination": "Industrial Park East",
      "completedTime": "Nov 4, 4:20 PM",
      "distance": "15.3 mi",
      "status": "completed",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      HapticFeedback.lightImpact();
    }
  }

  Future<void> _toggleShiftStatus() async {
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _isOnShift = !_isOnShift;
      _isLoading = false;
    });

    HapticFeedback.mediumImpact();

    Fluttertoast.showToast(
      msg: _isOnShift
          ? "Shift started successfully"
          : "Shift ended successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      textColor: Colors.white,
    );
  }

  void _handleQuickAction(String actionId) {
    HapticFeedback.lightImpact();

    String message;
    switch (actionId) {
      case 'inspection':
        message = "Opening vehicle inspection checklist...";
        break;
      case 'report_issue':
        message = "Opening issue reporting form...";
        break;
      case 'contact_dispatch':
        message = "Connecting to dispatch...";
        break;
      case 'emergency':
        _handleEmergencyAction();
        return;
      default:
        message = "Action not implemented yet";
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleEmergencyAction() {
    HapticFeedback.heavyImpact();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'emergency',
                color: AppTheme.errorLight,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Emergency Alert',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.errorLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'Emergency assistance has been requested. Dispatch and emergency services have been notified of your location.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _handleNavigation() {
    HapticFeedback.lightImpact();
    Fluttertoast.showToast(
      msg: "Opening GPS navigation...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  Future<void> _refreshData() async {
    HapticFeedback.lightImpact();
    setState(() => _isLoading = true);

    // Simulate data refresh
    await Future.delayed(const Duration(milliseconds: 1200));

    setState(() => _isLoading = false);

    Fluttertoast.showToast(
      msg: "Data refreshed successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      textColor: Colors.white,
    );
  }

  Widget _buildHeader() {
    final driverName = _driverData['name'] as String? ?? 'Driver';
    final assignedVehicle =
        _driverData['assignedVehicle'] as String? ?? 'No Vehicle';
    final avatar = _driverData['avatar'] as String? ?? '';
    final semanticLabel =
        _driverData['semanticLabel'] as String? ?? 'Driver profile photo';

    return Container(
      padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 3.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: CustomImageWidget(
                      imageUrl: avatar,
                      width: 12.w,
                      height: 12.w,
                      fit: BoxFit.cover,
                      semanticLabel: semanticLabel,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        driverName,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'local_shipping',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 14,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            assignedVehicle,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.pushNamed(context, '/fleet-dashboard');
                      },
                      child: Padding(
                        padding: EdgeInsets.all(2.w),
                        child: CustomIconWidget(
                          iconName: 'notifications',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Container(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _toggleShiftStatus,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isOnShift
                      ? AppTheme.errorLight
                      : AppTheme.lightTheme.colorScheme.tertiary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: _isOnShift ? 'stop' : 'play_arrow',
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            _isOnShift ? 'END SHIFT' : 'START SHIFT',
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 2.h),
            if (_isOnShift) ...[
              CurrentTripCardWidget(
                tripData: _currentTripData,
                onNavigationPressed: _handleNavigation,
              ),
              SizedBox(height: 3.h),
            ],
            QuickActionsGridWidget(
              onActionPressed: _handleQuickAction,
            ),
            SizedBox(height: 3.h),
            VehicleStatusWidget(
              vehicleData: _vehicleData,
            ),
            SizedBox(height: 3.h),
            RecentTripsWidget(
              recentTrips: _recentTripsData,
            ),
            SizedBox(height: 3.h),
            EmergencyPanicButtonWidget(
              onEmergencyPressed: _handleEmergencyAction,
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderTab(String title, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: icon.toString().split('.').last,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            '$title Coming Soon',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'This feature is under development',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildHomeTab(),
                _buildPlaceholderTab('Trips', Icons.route),
                _buildPlaceholderTab('Vehicle', Icons.local_shipping),
                _buildPlaceholderTab('Profile', Icons.person),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                icon: CustomIconWidget(
                  iconName: 'home',
                  color: _tabController.index == 0
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
                text: 'Home',
              ),
              Tab(
                icon: CustomIconWidget(
                  iconName: 'route',
                  color: _tabController.index == 1
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
                text: 'Trips',
              ),
              Tab(
                icon: CustomIconWidget(
                  iconName: 'local_shipping',
                  color: _tabController.index == 2
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
                text: 'Vehicle',
              ),
              Tab(
                icon: CustomIconWidget(
                  iconName: 'person',
                  color: _tabController.index == 3
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
                text: 'Profile',
              ),
            ],
            labelColor: AppTheme.lightTheme.colorScheme.primary,
            unselectedLabelColor:
                AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            indicatorColor: AppTheme.lightTheme.colorScheme.primary,
            indicatorWeight: 3,
            labelStyle: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle:
                AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
