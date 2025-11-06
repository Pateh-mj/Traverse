import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentTripsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> recentTrips;

  const RecentTripsWidget({
    Key? key,
    required this.recentTrips,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Trips',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          recentTrips.isEmpty
              ? Container(
                  width: double.infinity,
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
                        iconName: 'route',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 32,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'No recent trips',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentTrips.length > 3 ? 3 : recentTrips.length,
                  separatorBuilder: (context, index) => SizedBox(height: 2.h),
                  itemBuilder: (context, index) {
                    final trip = recentTrips[index];
                    final destination =
                        trip['destination'] as String? ?? 'Unknown';
                    final completedTime =
                        trip['completedTime'] as String? ?? '';
                    final distance = trip['distance'] as String? ?? '0 mi';
                    final status = trip['status'] as String? ?? 'completed';

                    Color statusColor;
                    String statusText;
                    switch (status.toLowerCase()) {
                      case 'completed':
                        statusColor = AppTheme.lightTheme.colorScheme.tertiary;
                        statusText = 'Completed';
                        break;
                      case 'cancelled':
                        statusColor = AppTheme.errorLight;
                        statusText = 'Cancelled';
                        break;
                      default:
                        statusColor =
                            AppTheme.lightTheme.colorScheme.onSurfaceVariant;
                        statusText = 'Unknown';
                    }

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
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CustomIconWidget(
                              iconName: status.toLowerCase() == 'completed'
                                  ? 'check_circle'
                                  : 'cancel',
                              color: statusColor,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  destination,
                                  style: AppTheme
                                      .lightTheme.textTheme.titleSmall
                                      ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 0.5.h),
                                Row(
                                  children: [
                                    Text(
                                      completedTime,
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                                    if (completedTime.isNotEmpty &&
                                        distance.isNotEmpty) ...[
                                      Text(
                                        ' • ',
                                        style: AppTheme
                                            .lightTheme.textTheme.bodySmall
                                            ?.copyWith(
                                          color: AppTheme.lightTheme.colorScheme
                                              .onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                    Text(
                                      distance,
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              statusText,
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: statusColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
