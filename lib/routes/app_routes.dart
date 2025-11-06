import 'package:flutter/material.dart';
import '../presentation/live_vehicle_tracking/live_vehicle_tracking.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/fleet_dashboard/fleet_dashboard.dart';
import '../presentation/maintenance_scheduler/maintenance_scheduler.dart';
import '../presentation/driver_mobile_dashboard/driver_mobile_dashboard.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String liveVehicleTracking = '/live-vehicle-tracking';
  static const String splash = '/splash-screen';
  static const String login = '/login-screen';
  static const String fleetDashboard = '/fleet-dashboard';
  static const String maintenanceScheduler = '/maintenance-scheduler';
  static const String driverMobileDashboard = '/driver-mobile-dashboard';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    liveVehicleTracking: (context) => const LiveVehicleTracking(),
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    fleetDashboard: (context) => const FleetDashboard(),
    maintenanceScheduler: (context) => const MaintenanceScheduler(),
    driverMobileDashboard: (context) => const DriverMobileDashboard(),
    // TODO: Add your other routes here
  };
}
