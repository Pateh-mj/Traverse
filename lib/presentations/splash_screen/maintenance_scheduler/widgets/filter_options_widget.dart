import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterOptionsWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onFiltersChanged;
  final Map<String, dynamic> currentFilters;

  const FilterOptionsWidget({
    Key? key,
    required this.onFiltersChanged,
    required this.currentFilters,
  }) : super(key: key);

  @override
  State<FilterOptionsWidget> createState() => _FilterOptionsWidgetState();
}

class _FilterOptionsWidgetState extends State<FilterOptionsWidget> {
  late Map<String, dynamic> _filters;

  final List<String> _serviceTypes = [
    'All Services',
    'Oil Change',
    'Tire Rotation',
    'Brake Inspection',
    'Engine Tune-up',
    'Transmission Service',
    'Battery Check',
    'Air Filter Replacement',
    'Coolant System',
    'Electrical System',
    'General Inspection',
  ];

  final List<String> _vehicleGroups = [
    'All Vehicles',
    'Delivery Vans',
    'Cargo Trucks',
    'Service Vehicles',
    'Emergency Vehicles',
  ];

  final List<String> _urgencyLevels = [
    'All Priorities',
    'High',
    'Medium',
    'Low',
  ];

  final List<String> _statusOptions = [
    'All Status',
    'Scheduled',
    'Overdue',
    'In Progress',
    'Completed',
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  void _updateFilter(String key, dynamic value) {
    setState(() {
      _filters[key] = value;
    });
    widget.onFiltersChanged(_filters);
  }

  void _clearAllFilters() {
    setState(() {
      _filters = {
        'serviceType': 'All Services',
        'vehicleGroup': 'All Vehicles',
        'urgency': 'All Priorities',
        'status': 'All Status',
        'dateRange': null,
      };
    });
    widget.onFiltersChanged(_filters);
  }

  int _getActiveFilterCount() {
    int count = 0;
    if (_filters['serviceType'] != null &&
        _filters['serviceType'] != 'All Services') count++;
    if (_filters['vehicleGroup'] != null &&
        _filters['vehicleGroup'] != 'All Vehicles') count++;
    if (_filters['urgency'] != null && _filters['urgency'] != 'All Priorities')
      count++;
    if (_filters['status'] != null && _filters['status'] != 'All Status')
      count++;
    if (_filters['dateRange'] != null) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final activeFilterCount = _getActiveFilterCount();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: ExpansionTile(
        leading: CustomIconWidget(
          iconName: 'filter_list',
          color: AppTheme.lightTheme.primaryColor,
          size: 24,
        ),
        title: Row(
          children: [
            Text(
              'Filters',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.primaryColor,
              ),
            ),
            if (activeFilterCount > 0) ...[
              SizedBox(width: 2.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  activeFilterCount.toString(),
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        trailing: activeFilterCount > 0
            ? TextButton(
                onPressed: _clearAllFilters,
                child: Text(
                  'Clear All',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : CustomIconWidget(
                iconName: 'expand_more',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service Type Filter
                _buildFilterSection(
                  'Service Type',
                  _filters['serviceType'] ?? 'All Services',
                  _serviceTypes,
                  (value) => _updateFilter('serviceType', value),
                  Icons.build,
                ),
                SizedBox(height: 3.h),
                // Vehicle Group Filter
                _buildFilterSection(
                  'Vehicle Group',
                  _filters['vehicleGroup'] ?? 'All Vehicles',
                  _vehicleGroups,
                  (value) => _updateFilter('vehicleGroup', value),
                  Icons.directions_car,
                ),
                SizedBox(height: 3.h),
                // Priority Filter
                _buildFilterSection(
                  'Priority Level',
                  _filters['urgency'] ?? 'All Priorities',
                  _urgencyLevels,
                  (value) => _updateFilter('urgency', value),
                  Icons.priority_high,
                ),
                SizedBox(height: 3.h),
                // Status Filter
                _buildFilterSection(
                  'Status',
                  _filters['status'] ?? 'All Status',
                  _statusOptions,
                  (value) => _updateFilter('status', value),
                  Icons.info,
                ),
                SizedBox(height: 3.h),
                // Date Range Filter
                _buildDateRangeFilter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
    String title,
    String currentValue,
    List<String> options,
    Function(String) onChanged,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: icon.toString().split('.').last,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currentValue,
              isExpanded: true,
              items: options.map((option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(
                    option,
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  onChanged(value);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'date_range',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'Date Range',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final DateTimeRange? picked = await showDateRangePicker(
                    context: context,
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    initialDateRange: _filters['dateRange'],
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: Theme.of(context).colorScheme.copyWith(
                                primary: AppTheme.lightTheme.primaryColor,
                              ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    _updateFilter('dateRange', picked);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'calendar_today',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          _filters['dateRange'] != null
                              ? '${_formatDate((_filters['dateRange'] as DateTimeRange).start)} - ${_formatDate((_filters['dateRange'] as DateTimeRange).end)}'
                              : 'Select date range',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: _filters['dateRange'] != null
                                ? AppTheme.lightTheme.colorScheme.onSurface
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_filters['dateRange'] != null) ...[
              SizedBox(width: 2.w),
              IconButton(
                onPressed: () => _updateFilter('dateRange', null),
                icon: CustomIconWidget(
                  iconName: 'clear',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 20,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
