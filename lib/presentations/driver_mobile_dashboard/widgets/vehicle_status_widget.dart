import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VehicleStatusWidget extends StatelessWidget {
  final Map<String, dynamic> vehicleData;

  const VehicleStatusWidget({
    Key? key,
    required this.vehicleData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fuelLevel = (vehicleData['fuelLevel'] as num?)?.toDouble() ?? 0.0;
    final engineStatus = vehicleData['engineStatus'] as String? ?? 'unknown';
    final maintenanceAlert = vehicleData['maintenanceAlert'] as bool? ?? false;
    final vehicleName =
        vehicleData['vehicleName'] as String? ?? 'Unknown Vehicle';

    Color engineStatusColor;
    String engineStatusText;
    switch (engineStatus.toLowerCase()) {
      case 'good':
        engineStatusColor = AppTheme.lightTheme.colorScheme.tertiary;
        engineStatusText = 'Good';
        break;
      case 'warning':
        engineStatusColor = AppTheme.warningLight;
        engineStatusText = 'Warning';
        break;
      case 'critical':
        engineStatusColor = AppTheme.errorLight;
        engineStatusText = 'Critical';
        break;
      default:
        engineStatusColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant;
        engineStatusText = 'Unknown';
    }

    Color fuelLevelColor;
    if (fuelLevel > 0.5) {
      fuelLevelColor = AppTheme.lightTheme.colorScheme.tertiary;
    } else if (fuelLevel > 0.25) {
      fuelLevelColor = AppTheme.warningLight;
    } else {
      fuelLevelColor = AppTheme.errorLight;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vehicle Status',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 1,
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
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'local_shipping',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        vehicleName,
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (maintenanceAlert)
                      Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          color: AppTheme.warningLight.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: CustomIconWidget(
                          iconName: 'build',
                          color: AppTheme.warningLight,
                          size: 16,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'local_gas_station',
                                color: fuelLevelColor,
                                size: 20,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Fuel Level',
                                style: AppTheme.lightTheme.textTheme.labelMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: fuelLevel,
                                    backgroundColor: AppTheme
                                        .lightTheme.colorScheme.outline
                                        .withValues(alpha: 0.2),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        fuelLevelColor),
                                    minHeight: 6,
                                  ),
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                '${(fuelLevel * 100).toInt()}%',
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: fuelLevelColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'settings',
                                color: engineStatusColor,
                                size: 20,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Engine Status',
                                style: AppTheme.lightTheme.textTheme.labelMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: engineStatusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                engineStatusText,
                                style: AppTheme.lightTheme.textTheme.labelMedium
                                    ?.copyWith(
                                  color: engineStatusColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (maintenanceAlert) ...[
                  SizedBox(height: 3.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.warningLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.warningLight.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'warning',
                          color: AppTheme.warningLight,
                          size: 18,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            'Maintenance reminder: Service due in 500 miles',
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: AppTheme.warningLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
-