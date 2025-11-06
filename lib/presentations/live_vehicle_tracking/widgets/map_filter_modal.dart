import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MapFilterModal extends StatefulWidget {
  final Map<String, bool> currentFilters;
  final Function(Map<String, bool>) onFiltersChanged;

  const MapFilterModal({
    Key? key,
    required this.currentFilters,
    required this.onFiltersChanged,
  }) : super(key: key);

  @override
  State<MapFilterModal> createState() => _MapFilterModalState();
}

class _MapFilterModalState extends State<MapFilterModal> {
  late Map<String, bool> _filters;
  String _selectedTimeRange = '24 hours';
  bool _showGeofences = false;

  final List<String> _timeRanges = [
    '1 hour',
    '6 hours',
    '12 hours',
    '24 hours',
    '7 days',
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Map Filters',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 6.w,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  _buildVehicleStatusFilters(),
                  SizedBox(height: 3.h),
                  _buildVehicleTypeFilters(),
                  SizedBox(height: 3.h),
                  _buildTimeRangeSelector(),
                  SizedBox(height: 3.h),
                  _buildMapOptions(),
                  SizedBox(height: 4.h),
                  _buildActionButtons(),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleStatusFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vehicle Status',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: [
            _buildFilterChip('Active', 'active', AppTheme.onlineStatus),
            _buildFilterChip('Idle', 'idle', AppTheme.warningStatus),
            _buildFilterChip('Offline', 'offline', AppTheme.offlineStatus),
            _buildFilterChip(
                'Maintenance', 'maintenance', AppTheme.alertStatus),
          ],
        ),
      ],
    );
  }

  Widget _buildVehicleTypeFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vehicle Type',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: [
            _buildFilterChip(
                'Trucks', 'trucks', AppTheme.lightTheme.colorScheme.primary),
            _buildFilterChip(
                'Vans', 'vans', AppTheme.lightTheme.colorScheme.primary),
            _buildFilterChip(
                'Cars', 'cars', AppTheme.lightTheme.colorScheme.primary),
            _buildFilterChip('Motorcycles', 'motorcycles',
                AppTheme.lightTheme.colorScheme.primary),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, String key, Color color) {
    final isSelected = _filters[key] ?? false;

    return GestureDetector(
      onTap: () {
        setState(() {
          _filters[key] = !isSelected;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              CustomIconWidget(
                iconName: 'check',
                color: Colors.white,
                size: 4.w,
              ),
            if (isSelected) SizedBox(width: 1.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: isSelected ? Colors.white : color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time Range',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedTimeRange,
              isExpanded: true,
              icon: CustomIconWidget(
                iconName: 'keyboard_arrow_down',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 6.w,
              ),
              items: _timeRanges.map((String range) {
                return DropdownMenuItem<String>(
                  value: range,
                  child: Text(
                    range,
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedTimeRange = newValue;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Map Options',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        _buildSwitchOption(
          'Show Geofences',
          'Display geofence boundaries on map',
          _showGeofences,
          (value) {
            setState(() {
              _showGeofences = value;
            });
          },
        ),
        SizedBox(height: 1.h),
        _buildSwitchOption(
          'Traffic Layer',
          'Show real-time traffic information',
          _filters['traffic'] ?? false,
          (value) {
            setState(() {
              _filters['traffic'] = value;
            });
          },
        ),
        SizedBox(height: 1.h),
        _buildSwitchOption(
          'Route History',
          'Display vehicle route trails',
          _filters['routeHistory'] ?? false,
          (value) {
            setState(() {
              _filters['routeHistory'] = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSwitchOption(
      String title, String subtitle, bool value, Function(bool) onChanged) {
    return Container(
      padding: EdgeInsets.all(3.w),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  subtitle,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.lightTheme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _filters.updateAll((key, value) => false);
                _selectedTimeRange = '24 hours';
                _showGeofences = false;
              });
            },
            child: Text('Reset All'),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              widget.onFiltersChanged(_filters);
              Navigator.pop(context);
            },
            child: Text('Apply Filters'),
          ),
        ),
      ],
    );
  }
}
