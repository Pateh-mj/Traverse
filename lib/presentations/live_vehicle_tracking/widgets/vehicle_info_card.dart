import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VehicleInfoCard extends StatelessWidget {
  final Map<String, dynamic> vehicleData;
  final VoidCallback? onTap;

  const VehicleInfoCard({
    Key? key,
    required this.vehicleData,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 85.w,
        padding: EdgeInsets.all(4.w),
        margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: _getStatusColor(vehicleData['status'] as String),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: _getVehicleIcon(vehicleData['type'] as String),
                      color: Colors.white,
                      size: 6.w,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicleData['vehicleId'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        vehicleData['driverName'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor(vehicleData['status'] as String)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    vehicleData['status'] as String,
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: _getStatusColor(vehicleData['status'] as String),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    'Speed',
                    '${vehicleData['speed']} mph',
                    'speed',
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    'Fuel',
                    '${vehicleData['fuelLevel']}%',
                    'local_gas_station',
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    'ETA',
                    vehicleData['eta'] as String,
                    'schedule',
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'location_on',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    vehicleData['currentLocation'] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, String iconName) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 4.w,
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
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
