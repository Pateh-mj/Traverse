import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FleetMapWidget extends StatefulWidget {
  final List<Map<String, dynamic>> vehicles;

  const FleetMapWidget({
    Key? key,
    required this.vehicles,
  }) : super(key: key);

  @override
  State<FleetMapWidget> createState() => _FleetMapWidgetState();
}

class _FleetMapWidgetState extends State<FleetMapWidget> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Map<String, dynamic>? _selectedVehicle;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194), // San Francisco
    zoom: 12.0,
  );

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  void _createMarkers() {
    _markers = widget.vehicles.map((vehicle) {
      final double lat = (vehicle['latitude'] as num?)?.toDouble() ?? 37.7749;
      final double lng =
          (vehicle['longitude'] as num?)?.toDouble() ?? -122.4194;
      final String status = vehicle['status'] as String? ?? 'idle';

      return Marker(
        markerId: MarkerId(vehicle['id'].toString()),
        position: LatLng(lat, lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(_getMarkerColor(status)),
        infoWindow: InfoWindow(
          title: vehicle['name'] as String? ?? 'Vehicle',
          snippet: '${vehicle['driver'] ?? 'No driver'} • $status',
        ),
        onTap: () => _showVehicleDetails(vehicle),
      );
    }).toSet();
  }

  double _getMarkerColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'driving':
        return BitmapDescriptor.hueGreen;
      case 'idle':
      case 'parked':
        return BitmapDescriptor.hueYellow;
      case 'maintenance':
      case 'alert':
        return BitmapDescriptor.hueRed;
      default:
        return BitmapDescriptor.hueBlue;
    }
  }

  void _showVehicleDetails(Map<String, dynamic> vehicle) {
    setState(() {
      _selectedVehicle = vehicle;
    });

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildVehicleDetailsSheet(vehicle),
    );
  }

  Widget _buildVehicleDetailsSheet(Map<String, dynamic> vehicle) {
    final String status = vehicle['status'] as String? ?? 'unknown';
    final Color statusColor = AppTheme.getStatusColor(status);

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    vehicle['name'] as String? ?? 'Vehicle',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            _buildDetailRow('Driver',
                vehicle['driver'] as String? ?? 'Unassigned', 'person'),
            _buildDetailRow(
                'License Plate',
                vehicle['licensePlate'] as String? ?? 'N/A',
                'confirmation_number'),
            _buildDetailRow('Fuel Level', '${vehicle['fuelLevel'] ?? 0}%',
                'local_gas_station'),
            _buildDetailRow('Speed', '${vehicle['speed'] ?? 0} mph', 'speed'),
            _buildDetailRow('Last Update',
                vehicle['lastUpdate'] as String? ?? 'Unknown', 'schedule'),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/live-vehicle-tracking');
                    },
                    icon: CustomIconWidget(
                      iconName: 'gps_fixed',
                      color: Colors.white,
                      size: 20,
                    ),
                    label: const Text('Track Vehicle'),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // Handle contact driver
                    },
                    icon: CustomIconWidget(
                      iconName: 'phone',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    label: const Text('Contact'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, String iconName) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Text(
            '$label:',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GoogleMap(
          initialCameraPosition: _initialPosition,
          markers: _markers,
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
          },
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          myLocationButtonEnabled: false,
          compassEnabled: false,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
