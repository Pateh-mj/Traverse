import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsGridWidget extends StatelessWidget {
  final Function(String)? onActionPressed;

  const QuickActionsGridWidget({
    Key? key,
    this.onActionPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final actions = [
      {
        'id': 'inspection',
        'title': 'Vehicle\nInspection',
        'icon': 'checklist',
        'color': AppTheme.lightTheme.colorScheme.primary,
      },
      {
        'id': 'report_issue',
        'title': 'Report\nIssue',
        'icon': 'report_problem',
        'color': AppTheme.warningLight,
      },
      {
        'id': 'contact_dispatch',
        'title': 'Contact\nDispatch',
        'icon': 'headset_mic',
        'color': AppTheme.lightTheme.colorScheme.tertiary,
      },
      {
        'id': 'emergency',
        'title': 'Emergency\nAssistance',
        'icon': 'emergency',
        'color': AppTheme.errorLight,
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 1.2,
            ),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final action = actions[index];
              final actionId = action['id'] as String;
              final title = action['title'] as String;
              final iconName = action['icon'] as String;
              final color = action['color'] as Color;

              return GestureDetector(
                onTap: () => onActionPressed?.call(actionId),
                child: Container(
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CustomIconWidget(
                          iconName: iconName,
                          color: color,
                          size: 28,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
