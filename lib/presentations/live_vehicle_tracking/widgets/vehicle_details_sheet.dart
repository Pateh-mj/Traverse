import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VehicleDetailsSheet extends StatefulWidget {
  final Map<String, dynamic> vehicleData;
  final VoidCallback? onClose;

  const VehicleDetailsSheet({
    Key? key,
    required this.vehicleData,
    this.onClose,
  }) : super(key: key);

  @override
  State<VehicleDetailsSheet> createState() => _VehicleDetailsSheetState();
}

class _VehicleDetailsSheetState extends State<VehicleDetailsSheet> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.2,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                margin: EdgeInsets.symmetric(vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  children: [
                    _buildHeader(),
                    SizedBox(height: 2.h),
                    _buildQuickStats(),
                    SizedBox(height: 2.h),
                    _buildLocationInfo(),
                    SizedBox(height: 2.h),
                    _buildTripProgress(),
                    SizedBox(height: 2.h),
                    _buildDiagnostics(),
                    SizedBox(height: 2.h),
                    _buildRecentStops(),
                    SizedBox(height: 2.h),
                    _buildQuickActions(),
                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 15.w,
          height: 15.w,
          decoration: BoxDecoration(
            color: _getStatusColor(widget.vehicleData['status'] as String),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: _getVehicleIcon(widget.vehicleData['type'] as String),
              color: Colors.white,
              size: 8.w,
            ),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.vehicleData['vehicleId'] as String,
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                widget.vehicleData['driverName'] as String,
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 0.5.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: _getStatusColor(widget.vehicleData['status'] as String)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  widget.vehicleData['status'] as String,
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color:
                        _getStatusColor(widget.vehicleData['status'] as String),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: widget.onClose,
          icon: CustomIconWidget(
            iconName: 'close',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 6.w,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Speed',
            '${widget.vehicleData['speed']} mph',
            'speed',
            AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: _buildStatCard(
            'Fuel',
            '${widget.vehicleData['fuelLevel']}%',
            'local_gas_station',
            AppTheme.onlineStatus,
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: _buildStatCard(
            'Engine',
            widget.vehicleData['engineStatus'] as String,
            'settings',
            AppTheme.warningStatus,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String label, String value, String iconName, Color color) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 6.w,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInfo() {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Location',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  widget.vehicleData['currentLocation'] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'navigation',
                color: AppTheme.onlineStatus,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Destination: ${widget.vehicleData['destination']}',
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTripProgress() {
    final progress =
        (widget.vehicleData['tripProgress'] as num).toDouble() / 100;

    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trip Progress',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'ETA: ${widget.vehicleData['eta']}',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          LinearProgressIndicator(
            value: progress,
            backgroundColor:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.lightTheme.colorScheme.primary,
            ),
            minHeight: 1.h,
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.vehicleData['tripProgress']}% Complete',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              Text(
                '${widget.vehicleData['remainingDistance']} miles left',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnostics() {
    final diagnostics =
        widget.vehicleData['diagnostics'] as Map<String, dynamic>;

    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vehicle Diagnostics',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildDiagnosticItem(
                  'Battery',
                  '${diagnostics['battery']}%',
                  'battery_full',
                ),
              ),
              Expanded(
                child: _buildDiagnosticItem(
                  'Oil Pressure',
                  diagnostics['oilPressure'] as String,
                  'oil_barrel',
                ),
              ),
              Expanded(
                child: _buildDiagnosticItem(
                  'Temperature',
                  '${diagnostics['temperature']}°F',
                  'thermostat',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosticItem(String label, String value, String iconName) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 5.w,
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRecentStops() {
    final recentStops = widget.vehicleData['recentStops'] as List;

    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Stops',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ...recentStops.take(3).map((stop) {
            final stopData = stop as Map<String, dynamic>;
            return Padding(
              padding: EdgeInsets.only(bottom: 1.h),
              child: Row(
                children: [
                  Container(
                    width: 2.w,
                    height: 2.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stopData['location'] as String,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${stopData['time']} • ${stopData['duration']}',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                'Call Driver',
                'phone',
                AppTheme.lightTheme.colorScheme.primary,
                () {},
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: _buildActionButton(
                'Send Message',
                'message',
                AppTheme.onlineStatus,
                () {},
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: _buildActionButton(
                'Emergency',
                'warning',
                AppTheme.alertStatus,
                () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
      String label, String iconName, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: color,
              size: 6.w,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppTheme.onlineStatus;
      case 'idle':
        return AppTheme.warningStatus;
      case 'offline':
        return AppTheme.offlineStatus;
      case 'maintenance':
        return AppTheme.alertStatus;
      default:
        return AppTheme.offlineStatus;
    }
  }

  String _getVehicleIcon(String type) {
    switch (type.toLowerCase()) {
      case 'truck':
        return 'local_shipping';
      case 'van':
        return 'airport_shuttle';
      case 'car':
        return 'directions_car';
      case 'motorcycle':
        return 'two_wheeler';
      default:
        return 'directions_car';
    }
  }
}
