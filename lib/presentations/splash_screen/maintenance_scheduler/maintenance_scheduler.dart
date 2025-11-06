import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/calendar_view_widget.dart';
import './widgets/filter_options_widget.dart';
import './widgets/maintenance_card_widget.dart';
import './widgets/maintenance_detail_bottom_sheet.dart';
import './widgets/schedule_maintenance_dialog.dart';

class MaintenanceScheduler extends StatefulWidget {
  const MaintenanceScheduler({Key? key}) : super(key: key);

  @override
  State<MaintenanceScheduler> createState() => _MaintenanceSchedulerState();
}

class _MaintenanceSchedulerState extends State<MaintenanceScheduler>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allMaintenanceData = [];
  List<Map<String, dynamic>> _filteredMaintenanceData = [];
  Map<DateTime, List<Map<String, dynamic>>> _maintenanceEvents = {};
  Map<String, dynamic> _currentFilters = {
    'serviceType': 'All Services',
    'vehicleGroup': 'All Vehicles',
    'urgency': 'All Priorities',
    'status': 'All Status',
    'dateRange': null,
  };
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeMockData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _initializeMockData() {
    _allMaintenanceData = [
      {
        'id': 'MNT001',
        'vehicleId': 'VH001',
        'vehicleName': 'Ford Transit Van',
        'vehicleImage':
            'https://images.unsplash.com/photo-1716765691546-b9392bd233e5',
        'vehicleImageSemanticLabel':
            'White Ford Transit delivery van parked on concrete surface with clear blue sky background',
        'serviceType': 'Oil Change',
        'serviceDescription': 'Regular oil change and filter replacement',
        'dueDate': DateTime.now().add(const Duration(days: 3)),
        'priority': 'Medium',
        'status': 'scheduled',
        'assignedTechnician': 'Mike Johnson',
        'isRecurring': true,
        'recurringInterval': 'Monthly',
        'createdAt': DateTime.now().subtract(const Duration(days: 5)),
      },
      {
        'id': 'MNT002',
        'vehicleId': 'VH002',
        'vehicleName': 'Mercedes Sprinter',
        'vehicleImage':
            'https://images.unsplash.com/photo-1606385408575-ed00d1c51263',
        'vehicleImageSemanticLabel':
            'Silver Mercedes Sprinter commercial van on urban street with modern buildings in background',
        'serviceType': 'Brake Inspection',
        'serviceDescription':
            'Complete brake system inspection and pad replacement if needed',
        'dueDate': DateTime.now().subtract(const Duration(days: 2)),
        'priority': 'High',
        'status': 'overdue',
        'assignedTechnician': null,
        'isRecurring': false,
        'recurringInterval': null,
        'createdAt': DateTime.now().subtract(const Duration(days: 10)),
      },
      {
        'id': 'MNT003',
        'vehicleId': 'VH003',
        'vehicleName': 'Chevrolet Express',
        'vehicleImage':
            'https://images.unsplash.com/photo-1502352981868-f957ab3e10eb',
        'vehicleImageSemanticLabel':
            'Blue Chevrolet Express cargo van in industrial parking area with warehouse buildings',
        'serviceType': 'Tire Rotation',
        'serviceDescription': 'Rotate tires and check tire pressure',
        'dueDate': DateTime.now().add(const Duration(days: 7)),
        'priority': 'Low',
        'status': 'scheduled',
        'assignedTechnician': 'Sarah Wilson',
        'isRecurring': true,
        'recurringInterval': 'Quarterly',
        'createdAt': DateTime.now().subtract(const Duration(days: 3)),
      },
      {
        'id': 'MNT004',
        'vehicleId': 'VH001',
        'vehicleName': 'Ford Transit Van',
        'vehicleImage':
            'https://images.unsplash.com/photo-1716765691546-b9392bd233e5',
        'vehicleImageSemanticLabel':
            'White Ford Transit delivery van parked on concrete surface with clear blue sky background',
        'serviceType': 'Engine Tune-up',
        'serviceDescription': 'Complete engine diagnostic and tune-up service',
        'dueDate': DateTime.now().add(const Duration(days: 14)),
        'priority': 'Medium',
        'status': 'scheduled',
        'assignedTechnician': 'David Brown',
        'isRecurring': false,
        'recurringInterval': null,
        'createdAt': DateTime.now().subtract(const Duration(days: 1)),
      },
      {
        'id': 'MNT005',
        'vehicleId': 'VH002',
        'vehicleName': 'Mercedes Sprinter',
        'vehicleImage':
            'https://images.unsplash.com/photo-1606385408575-ed00d1c51263',
        'vehicleImageSemanticLabel':
            'Silver Mercedes Sprinter commercial van on urban street with modern buildings in background',
        'serviceType': 'Battery Check',
        'serviceDescription': 'Battery performance test and terminal cleaning',
        'dueDate': DateTime.now().subtract(const Duration(days: 7)),
        'priority': 'High',
        'status': 'completed',
        'assignedTechnician': 'Mike Johnson',
        'isRecurring': false,
        'recurringInterval': null,
        'createdAt': DateTime.now().subtract(const Duration(days: 15)),
      },
    ];

    _applyFilters();
    _buildMaintenanceEvents();
  }

  void _buildMaintenanceEvents() {
    _maintenanceEvents.clear();
    for (final maintenance in _filteredMaintenanceData) {
      final date = maintenance['dueDate'] as DateTime;
      final normalizedDate = DateTime(date.year, date.month, date.day);

      if (_maintenanceEvents[normalizedDate] == null) {
        _maintenanceEvents[normalizedDate] = [];
      }
      _maintenanceEvents[normalizedDate]!.add(maintenance);
    }
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      _filteredMaintenanceData = _allMaintenanceData.where((maintenance) {
        // Search filter
        final searchQuery = _searchController.text.toLowerCase();
        if (searchQuery.isNotEmpty) {
          final vehicleName = (maintenance['vehicleName'] ?? '').toLowerCase();
          final vehicleId = (maintenance['vehicleId'] ?? '').toLowerCase();
          final serviceType = (maintenance['serviceType'] ?? '').toLowerCase();
          final serviceDescription =
              (maintenance['serviceDescription'] ?? '').toLowerCase();

          if (!vehicleName.contains(searchQuery) &&
              !vehicleId.contains(searchQuery) &&
              !serviceType.contains(searchQuery) &&
              !serviceDescription.contains(searchQuery)) {
            return false;
          }
        }

        // Service type filter
        if (_currentFilters['serviceType'] != null &&
            _currentFilters['serviceType'] != 'All Services' &&
            maintenance['serviceType'] != _currentFilters['serviceType']) {
          return false;
        }

        // Priority filter
        if (_currentFilters['urgency'] != null &&
            _currentFilters['urgency'] != 'All Priorities' &&
            maintenance['priority'] != _currentFilters['urgency']) {
          return false;
        }

        // Status filter
        if (_currentFilters['status'] != null &&
            _currentFilters['status'] != 'All Status' &&
            maintenance['status'] != _currentFilters['status'].toLowerCase()) {
          return false;
        }

        // Date range filter
        if (_currentFilters['dateRange'] != null) {
          final dateRange = _currentFilters['dateRange'] as DateTimeRange;
          final maintenanceDate = maintenance['dueDate'] as DateTime;
          if (maintenanceDate.isBefore(dateRange.start) ||
              maintenanceDate.isAfter(dateRange.end)) {
            return false;
          }
        }

        return true;
      }).toList();

      // Sort by due date
      _filteredMaintenanceData.sort((a, b) {
        final dateA = a['dueDate'] as DateTime;
        final dateB = b['dueDate'] as DateTime;
        return dateA.compareTo(dateB);
      });
    });

    _buildMaintenanceEvents();
  }

  void _onDateSelected(DateTime selectedDate) {
    final events = _maintenanceEvents[DateTime(
            selectedDate.year, selectedDate.month, selectedDate.day)] ??
        [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MaintenanceDetailBottomSheet(
        maintenanceEvents: events,
        selectedDate: selectedDate,
      ),
    );
  }

  void _onFiltersChanged(Map<String, dynamic> filters) {
    setState(() {
      _currentFilters = filters;
    });
    _applyFilters();
  }

  void _scheduleNewMaintenance() {
    showDialog(
      context: context,
      builder: (context) => ScheduleMaintenanceDialog(
        onSchedule: (maintenanceData) {
          setState(() {
            _allMaintenanceData.add(maintenanceData);
          });
          _applyFilters();
          Fluttertoast.showToast(
            msg: "Maintenance scheduled successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
            textColor: Colors.white,
          );
        },
      ),
    );
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    Fluttertoast.showToast(
      msg: "Data refreshed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleMaintenanceAction(
      String action, Map<String, dynamic> maintenance) {
    switch (action) {
      case 'reschedule':
        _showRescheduleDialog(maintenance);
        break;
      case 'complete':
        _markMaintenanceComplete(maintenance);
        break;
      case 'add_notes':
        _showNotesDialog(maintenance);
        break;
      case 'cancel':
        _cancelMaintenance(maintenance);
        break;
      case 'assign_technician':
        _showAssignTechnicianDialog(maintenance);
        break;
      case 'view_history':
        _viewMaintenanceHistory(maintenance);
        break;
    }
  }

  void _showRescheduleDialog(Map<String, dynamic> maintenance) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reschedule Maintenance'),
        content: Text(
            'Reschedule ${maintenance['serviceType']} for ${maintenance['vehicleName']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Fluttertoast.showToast(msg: "Maintenance rescheduled");
            },
            child: const Text('Reschedule'),
          ),
        ],
      ),
    );
  }

  void _markMaintenanceComplete(Map<String, dynamic> maintenance) {
    setState(() {
      final index = _allMaintenanceData
          .indexWhere((item) => item['id'] == maintenance['id']);
      if (index != -1) {
        _allMaintenanceData[index]['status'] = 'completed';
      }
    });
    _applyFilters();
    Fluttertoast.showToast(
      msg: "Maintenance marked as complete",
      backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      textColor: Colors.white,
    );
  }

  void _showNotesDialog(Map<String, dynamic> maintenance) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Notes'),
        content: TextField(
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Enter maintenance notes...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Fluttertoast.showToast(msg: "Notes added successfully");
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _cancelMaintenance(Map<String, dynamic> maintenance) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Maintenance'),
        content: Text(
            'Are you sure you want to cancel ${maintenance['serviceType']} for ${maintenance['vehicleName']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _allMaintenanceData
                    .removeWhere((item) => item['id'] == maintenance['id']);
              });
              _applyFilters();
              Navigator.of(context).pop();
              Fluttertoast.showToast(
                msg: "Maintenance cancelled",
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
                textColor: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  void _showAssignTechnicianDialog(Map<String, dynamic> maintenance) {
    final technicians = [
      'Mike Johnson',
      'Sarah Wilson',
      'David Brown',
      'Lisa Garcia'
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Assign Technician'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: technicians.map((technician) {
            return ListTile(
              title: Text(technician),
              onTap: () {
                setState(() {
                  final index = _allMaintenanceData
                      .indexWhere((item) => item['id'] == maintenance['id']);
                  if (index != -1) {
                    _allMaintenanceData[index]['assignedTechnician'] =
                        technician;
                  }
                });
                _applyFilters();
                Navigator.of(context).pop();
                Fluttertoast.showToast(msg: "Technician assigned: $technician");
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _viewMaintenanceHistory(Map<String, dynamic> maintenance) {
    Navigator.pushNamed(context, '/maintenance-history');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Maintenance Scheduler',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/fleet-dashboard'),
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
          ),
        ],
        elevation: 0,
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        foregroundColor: AppTheme.lightTheme.colorScheme.onSurface,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppTheme.lightTheme.primaryColor,
        child: CustomScrollView(
          slivers: [
            // Search Bar
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search vehicles, services, or descriptions...',
                    prefixIcon: CustomIconWidget(
                      iconName: 'search',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                            },
                            icon: CustomIconWidget(
                              iconName: 'clear',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ),
            // Filter Options
            SliverToBoxAdapter(
              child: FilterOptionsWidget(
                onFiltersChanged: _onFiltersChanged,
                currentFilters: _currentFilters,
              ),
            ),
            // Calendar View
            SliverToBoxAdapter(
              child: CalendarViewWidget(
                onDateSelected: _onDateSelected,
                maintenanceEvents: _maintenanceEvents,
              ),
            ),
            // Upcoming Maintenance Header
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Row(
                  children: [
                    Text(
                      'Upcoming Maintenance',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_filteredMaintenanceData.length} ${_filteredMaintenanceData.length == 1 ? 'Service' : 'Services'}',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Maintenance List
            _isLoading
                ? SliverToBoxAdapter(
                    child: Container(
                      height: 30.h,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.lightTheme.primaryColor,
                        ),
                      ),
                    ),
                  )
                : _filteredMaintenanceData.isEmpty
                    ? SliverToBoxAdapter(
                        child: Container(
                          height: 30.h,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'build',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 48,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'No maintenance scheduled',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'Schedule maintenance services for your fleet vehicles',
                                textAlign: TextAlign.center,
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final maintenance = _filteredMaintenanceData[index];
                            return MaintenanceCardWidget(
                              maintenance: maintenance,
                              onTap: () => _viewMaintenanceHistory(maintenance),
                              onReschedule: () => _handleMaintenanceAction(
                                  'reschedule', maintenance),
                              onMarkComplete: () => _handleMaintenanceAction(
                                  'complete', maintenance),
                              onAddNotes: () => _handleMaintenanceAction(
                                  'add_notes', maintenance),
                              onCancel: () => _handleMaintenanceAction(
                                  'cancel', maintenance),
                              onAssignTechnician: () =>
                                  _handleMaintenanceAction(
                                      'assign_technician', maintenance),
                              onViewHistory: () => _handleMaintenanceAction(
                                  'view_history', maintenance),
                            );
                          },
                          childCount: _filteredMaintenanceData.length,
                        ),
                      ),
            // Bottom Spacing
            SliverToBoxAdapter(
              child: SizedBox(height: 10.h),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _scheduleNewMaintenance,
        backgroundColor: AppTheme.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        icon: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 24,
        ),
        label: Text(
          'Schedule',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
