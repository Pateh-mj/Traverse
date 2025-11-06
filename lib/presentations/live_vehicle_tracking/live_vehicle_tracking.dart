import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/map_controls_widget.dart';
import './widgets/map_filter_modal.dart';
import './widgets/vehicle_details_sheet.dart';
import './widgets/vehicle_info_card.dart';

class LiveVehicleTracking extends StatefulWidget {
  const LiveVehicleTracking({Key? key}) : super(key: key);

  @override
  State<LiveVehicleTracking> createState() => _LiveVehicleTrackingState();
}

class _LiveVehicleTrackingState extends State<LiveVehicleTracking>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Map<String, dynamic>? _selectedVehicle;
  bool _isLoading = true;
  bool _isTrafficEnabled = false;
  MapType _currentMapType = MapType.normal;
  LatLng _currentPosition =
      const LatLng(37.7749, -122.4194); // San Francisco default

  // Animation controllers
  late AnimationController _pulseController;
  late AnimationController _slideController;

  // Filter state
  Map<String, bool> _filters = {
    'active': true,
    'idle': true,
    'offline': true,
    'maintenance': true,
    'trucks': true,
    'vans': true,
    'cars': true,
    'motorcycles': true,
    'traffic': false,
    'routeHistory': false,
  };

  // Mock vehicle data
  final List<Map<String, dynamic>> _vehicleData = [
    {
      "id": "V001",
      "vehicleId": "Fleet-001",
      "driverName": "Michael Rodriguez",
      "type": "truck",
      "status": "active",
      "speed": 45,
      "fuelLevel": 78,
      "eta": "2:30 PM",
      "currentLocation": "1234 Market Street, San Francisco, CA",
      "destination": "Oakland Port Terminal",
      "latitude": 37.7849,
      "longitude": -122.4094,
      "tripProgress": 65,
      "remainingDistance": 12.5,
      "engineStatus": "Good",
      "diagnostics": {
        "battery": 95,
        "oilPressure": "Normal",
        "temperature": 185
      },
      "recentStops": [
        {
          "location": "Warehouse District",
          "time": "11:45 AM",
          "duration": "15 min"
        },
        {"location": "Fuel Station", "time": "10:30 AM", "duration": "8 min"},
        {"location": "Customer Pickup", "time": "9:15 AM", "duration": "25 min"}
      ]
    },
    {
      "id": "V002",
      "vehicleId": "Fleet-002",
      "driverName": "Sarah Chen",
      "type": "van",
      "status": "idle",
      "speed": 0,
      "fuelLevel": 45,
      "eta": "On Break",
      "currentLocation": "Golden Gate Park, San Francisco, CA",
      "destination": "Downtown Delivery",
      "latitude": 37.7694,
      "longitude": -122.4862,
      "tripProgress": 30,
      "remainingDistance": 8.2,
      "engineStatus": "Good",
      "diagnostics": {
        "battery": 88,
        "oilPressure": "Normal",
        "temperature": 175
      },
      "recentStops": [
        {"location": "Coffee Shop", "time": "1:15 PM", "duration": "20 min"},
        {"location": "Client Office", "time": "12:00 PM", "duration": "45 min"}
      ]
    },
    {
      "id": "V003",
      "vehicleId": "Fleet-003",
      "driverName": "James Wilson",
      "type": "car",
      "status": "active",
      "speed": 35,
      "fuelLevel": 92,
      "eta": "3:45 PM",
      "currentLocation": "Mission District, San Francisco, CA",
      "destination": "Airport Terminal",
      "latitude": 37.7599,
      "longitude": -122.4148,
      "tripProgress": 80,
      "remainingDistance": 5.1,
      "engineStatus": "Excellent",
      "diagnostics": {
        "battery": 100,
        "oilPressure": "Optimal",
        "temperature": 180
      },
      "recentStops": [
        {"location": "Hotel Pickup", "time": "2:30 PM", "duration": "5 min"}
      ]
    },
    {
      "id": "V004",
      "vehicleId": "Fleet-004",
      "driverName": "Emma Thompson",
      "type": "motorcycle",
      "status": "offline",
      "speed": 0,
      "fuelLevel": 25,
      "eta": "Offline",
      "currentLocation": "Maintenance Garage, San Francisco, CA",
      "destination": "Service Complete",
      "latitude": 37.7849,
      "longitude": -122.3994,
      "tripProgress": 0,
      "remainingDistance": 0,
      "engineStatus": "Maintenance",
      "diagnostics": {"battery": 65, "oilPressure": "Low", "temperature": 160},
      "recentStops": [
        {"location": "Service Center", "time": "9:00 AM", "duration": "4 hours"}
      ]
    },
    {
      "id": "V005",
      "vehicleId": "Fleet-005",
      "driverName": "David Park",
      "type": "truck",
      "status": "maintenance",
      "speed": 0,
      "fuelLevel": 60,
      "eta": "Under Service",
      "currentLocation": "Fleet Maintenance Center, San Francisco, CA",
      "destination": "Scheduled Maintenance",
      "latitude": 37.7749,
      "longitude": -122.4294,
      "tripProgress": 0,
      "remainingDistance": 0,
      "engineStatus": "Service Required",
      "diagnostics": {
        "battery": 75,
        "oilPressure": "Warning",
        "temperature": 195
      },
      "recentStops": [
        {
          "location": "Maintenance Bay",
          "time": "8:00 AM",
          "duration": "6 hours"
        }
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeLocation();
    _createMarkers();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  Future<void> _initializeLocation() async {
    try {
      if (!kIsWeb) {
        final permission = await Permission.location.request();
        if (!permission.isGranted) {
          setState(() => _isLoading = false);
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });

      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(_currentPosition),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _createMarkers() {
    _markers.clear();

    for (final vehicle in _vehicleData) {
      if (_shouldShowVehicle(vehicle)) {
        _markers.add(
          Marker(
            markerId: MarkerId(vehicle['id'] as String),
            position: LatLng(
              vehicle['latitude'] as double,
              vehicle['longitude'] as double,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              _getMarkerColor(vehicle['status'] as String),
            ),
            infoWindow: InfoWindow(
              title: vehicle['vehicleId'] as String,
              snippet: '${vehicle['driverName']} • ${vehicle['status']}',
            ),
            onTap: () => _selectVehicle(vehicle),
          ),
        );
      }
    }

    if (mounted) setState(() {});
  }

  bool _shouldShowVehicle(Map<String, dynamic> vehicle) {
    final status = vehicle['status'] as String;
    final type = vehicle['type'] as String;

    return (_filters[status] ?? false) && (_filters['${type}s'] ?? false);
  }

  double _getMarkerColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return BitmapDescriptor.hueGreen;
      case 'idle':
        return BitmapDescriptor.hueYellow;
      case 'offline':
        return BitmapDescriptor.hueRed;
      case 'maintenance':
        return BitmapDescriptor.hueOrange;
      default:
        return BitmapDescriptor.hueRed;
    }
  }

  void _selectVehicle(Map<String, dynamic> vehicle) {
    setState(() {
      _selectedVehicle = vehicle;
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(
          vehicle['latitude'] as double,
          vehicle['longitude'] as double,
        ),
        16.0,
      ),
    );

    _slideController.forward();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (!_isLoading) {
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition, 12.0),
      );
    }
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MapFilterModal(
        currentFilters: _filters,
        onFiltersChanged: (newFilters) {
          setState(() {
            _filters = newFilters;
            _isTrafficEnabled = newFilters['traffic'] ?? false;
          });
          _createMarkers();
        },
      ),
    );
  }

  void _toggleMapType() {
    setState(() {
      switch (_currentMapType) {
        case MapType.normal:
          _currentMapType = MapType.satellite;
          break;
        case MapType.satellite:
          _currentMapType = MapType.terrain;
          break;
        case MapType.terrain:
          _currentMapType = MapType.hybrid;
          break;
        case MapType.hybrid:
          _currentMapType = MapType.normal;
          break;
        case MapType.none:
          _currentMapType = MapType.normal;
          break;
      }
    });
  }

  void _goToCurrentLocation() {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition, 15.0),
      );
    }
  }

  void _zoomIn() {
    _mapController?.animateCamera(CameraUpdate.zoomIn());
  }

  void _zoomOut() {
    _mapController?.animateCamera(CameraUpdate.zoomOut());
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Live Vehicle Tracking',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/fleet-dashboard'),
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
          ),
        ],
        elevation: 0,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Loading vehicle locations...',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                // Google Maps
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition,
                    zoom: 12.0,
                  ),
                  markers: _markers,
                  mapType: _currentMapType,
                  trafficEnabled: _isTrafficEnabled,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  compassEnabled: true,
                  mapToolbarEnabled: false,
                  onTap: (LatLng position) {
                    setState(() {
                      _selectedVehicle = null;
                    });
                    _slideController.reverse();
                  },
                ),

                // Map Controls
                MapControlsWidget(
                  onLocationPressed: _goToCurrentLocation,
                  onZoomIn: _zoomIn,
                  onZoomOut: _zoomOut,
                  onLayerToggle: _toggleMapType,
                  onFilterPressed: _showFilterModal,
                  isTrafficEnabled: _isTrafficEnabled,
                  currentMapType: _currentMapType.toString().split('.').last,
                ),

                // Selected Vehicle Info Card
                if (_selectedVehicle != null)
                  Positioned(
                    bottom: 2.h,
                    left: 2.w,
                    right: 2.w,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: _slideController,
                        curve: Curves.easeInOut,
                      )),
                      child: VehicleInfoCard(
                        vehicleData: _selectedVehicle!,
                        onTap: () => _showVehicleDetails(_selectedVehicle!),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  void _showVehicleDetails(Map<String, dynamic> vehicleData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VehicleDetailsSheet(
        vehicleData: vehicleData,
        onClose: () {
          Navigator.pop(context);
          setState(() {
            _selectedVehicle = null;
          });
          _slideController.reverse();
        },
      ),
    );
  }
}