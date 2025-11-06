import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ScheduleMaintenanceDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onSchedule;

  const ScheduleMaintenanceDialog({
    Key? key,
    required this.onSchedule,
  }) : super(key: key);

  @override
  State<ScheduleMaintenanceDialog> createState() =>
      _ScheduleMaintenanceDialogState();
}

class _ScheduleMaintenanceDialogState extends State<ScheduleMaintenanceDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedVehicle;
  String? _selectedServiceType;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _priority = 'Medium';
  String _description = '';
  bool _isRecurring = false;
  String _recurringInterval = 'Monthly';

  final List<Map<String, dynamic>> _vehicles = [
    {
      'id': 'VH001',
      'name': 'Ford Transit Van',
      'image':
          'https://images.unsplash.com/photo-1716765691546-b9392bd233e5',
      'semanticLabel':
          'White Ford Transit delivery van parked on concrete surface with clear blue sky background',
    },
    {
      'id': 'VH002',
      'name': 'Mercedes Sprinter',
      'image':
          'https://images.unsplash.com/photo-1606385408575-ed00d1c51263',
      'semanticLabel':
          'Silver Mercedes Sprinter commercial van on urban street with modern buildings in background',
    },
    {
      'id': 'VH003',
      'name': 'Chevrolet Express',
      'image':
          'https://images.unsplash.com/photo-1502352981868-f957ab3e10eb',
      'semanticLabel':
          'Blue Chevrolet Express cargo van in industrial parking area with warehouse buildings',
    },
  ];

  final List<String> _serviceTypes = [
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

  final List<String> _priorities = ['Low', 'Medium', 'High'];
  final List<String> _recurringIntervals = [
    'Weekly',
    'Monthly',
    'Quarterly',
    'Annually'
  ];

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _scheduleMaintenanceService() {
    if (_formKey.currentState!.validate() &&
        _selectedVehicle != null &&
        _selectedServiceType != null &&
        _selectedDate != null &&
        _selectedTime != null) {
      final selectedVehicleData = _vehicles.firstWhere(
        (vehicle) => vehicle['id'] == _selectedVehicle,
      );

      final scheduledDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      final maintenanceData = {
        'id': 'MNT${DateTime.now().millisecondsSinceEpoch}',
        'vehicleId': _selectedVehicle,
        'vehicleName': selectedVehicleData['name'],
        'vehicleImage': selectedVehicleData['image'],
        'vehicleImageSemanticLabel': selectedVehicleData['semanticLabel'],
        'serviceType': _selectedServiceType,
        'serviceDescription':
            _description.isEmpty ? _selectedServiceType : _description,
        'dueDate': scheduledDateTime,
        'priority': _priority,
        'status': 'scheduled',
        'isRecurring': _isRecurring,
        'recurringInterval': _isRecurring ? _recurringInterval : null,
        'createdAt': DateTime.now(),
      };

      widget.onSchedule(maintenanceData);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 85.h,
          maxWidth: 90.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'build',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Schedule Maintenance',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.primaryColor,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            // Form Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Vehicle Selection
                      Text(
                        'Select Vehicle',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      DropdownButtonFormField<String>(
                        value: _selectedVehicle,
                        decoration: InputDecoration(
                          hintText: 'Choose a vehicle',
                          prefixIcon: CustomIconWidget(
                            iconName: 'directions_car',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                        items: _vehicles.map((vehicle) {
                          return DropdownMenuItem<String>(
                            value: vehicle['id'],
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: CustomImageWidget(
                                    imageUrl: vehicle['image'],
                                    width: 8.w,
                                    height: 8.w,
                                    fit: BoxFit.cover,
                                    semanticLabel: vehicle['semanticLabel'],
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        vehicle['name'],
                                        style: AppTheme
                                            .lightTheme.textTheme.bodyMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        vehicle['id'],
                                        style: AppTheme
                                            .lightTheme.textTheme.bodySmall
                                            ?.copyWith(
                                          color: AppTheme.lightTheme.colorScheme
                                              .onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedVehicle = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a vehicle';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 2.h),
                      // Service Type Selection
                      Text(
                        'Service Type',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      DropdownButtonFormField<String>(
                        value: _selectedServiceType,
                        decoration: InputDecoration(
                          hintText: 'Choose service type',
                          prefixIcon: CustomIconWidget(
                            iconName: 'build',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                        items: _serviceTypes.map((service) {
                          return DropdownMenuItem<String>(
                            value: service,
                            child: Text(service),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedServiceType = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a service type';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 2.h),
                      // Date and Time Selection
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Date',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleSmall
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                GestureDetector(
                                  onTap: _selectDate,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 4.w, vertical: 3.h),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppTheme
                                            .lightTheme.colorScheme.outline,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        CustomIconWidget(
                                          iconName: 'calendar_today',
                                          color: AppTheme.lightTheme.colorScheme
                                              .onSurfaceVariant,
                                          size: 20,
                                        ),
                                        SizedBox(width: 2.w),
                                        Text(
                                          _selectedDate != null
                                              ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                              : 'Select date',
                                          style: AppTheme
                                              .lightTheme.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: _selectedDate != null
                                                ? AppTheme.lightTheme
                                                    .colorScheme.onSurface
                                                : AppTheme
                                                    .lightTheme
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Time',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleSmall
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                GestureDetector(
                                  onTap: _selectTime,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 4.w, vertical: 3.h),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppTheme
                                            .lightTheme.colorScheme.outline,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        CustomIconWidget(
                                          iconName: 'access_time',
                                          color: AppTheme.lightTheme.colorScheme
                                              .onSurfaceVariant,
                                          size: 20,
                                        ),
                                        SizedBox(width: 2.w),
                                        Text(
                                          _selectedTime != null
                                              ? _selectedTime!.format(context)
                                              : 'Select time',
                                          style: AppTheme
                                              .lightTheme.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: _selectedTime != null
                                                ? AppTheme.lightTheme
                                                    .colorScheme.onSurface
                                                : AppTheme
                                                    .lightTheme
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      // Priority Selection
                      Text(
                        'Priority',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: _priorities.map((priority) {
                          final isSelected = _priority == priority;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _priority = priority;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    right:
                                        priority != _priorities.last ? 2.w : 0),
                                padding: EdgeInsets.symmetric(vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppTheme.lightTheme.primaryColor
                                      : AppTheme.lightTheme.colorScheme.surface,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppTheme.lightTheme.primaryColor
                                        : AppTheme
                                            .lightTheme.colorScheme.outline,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  priority,
                                  textAlign: TextAlign.center,
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: isSelected
                                        ? Colors.white
                                        : AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 2.h),
                      // Description
                      Text(
                        'Description (Optional)',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      TextFormField(
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText:
                              'Add additional notes or specific requirements...',
                        ),
                        onChanged: (value) {
                          _description = value;
                        },
                      ),
                      SizedBox(height: 2.h),
                      // Recurring Option
                      Row(
                        children: [
                          Checkbox(
                            value: _isRecurring,
                            onChanged: (value) {
                              setState(() {
                                _isRecurring = value ?? false;
                              });
                            },
                          ),
                          Text(
                            'Recurring Maintenance',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      if (_isRecurring) ...[
                        SizedBox(height: 1.h),
                        DropdownButtonFormField<String>(
                          value: _recurringInterval,
                          decoration: const InputDecoration(
                            labelText: 'Repeat Interval',
                          ),
                          items: _recurringIntervals.map((interval) {
                            return DropdownMenuItem<String>(
                              value: interval,
                              child: Text(interval),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _recurringInterval = value ?? 'Monthly';
                            });
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            // Action Buttons
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _scheduleMaintenanceService,
                      child: const Text('Schedule'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
