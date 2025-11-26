// lib/routes/app_routes.dart
import 'package:flutter/material.dart';

import '../screens/employer/find_dealer.dart';
// Auth screens (make sure these files exist at these paths)
import '../screens/auth/login_screen.dart';
import '../screens/auth/sign_up_screen.dart';
import '../screens/auth/forgot_password.dart';
import '../screens/auth/resetpassword.dart';
import '../screens/auth/splashscreen.dart';

// Employer screens
import '../screens/employer/employer_dashboard.dart';
import '../screens/employer/add_worker.dart';
import '../screens/employer/create_project.dart';
import '../screens/employer/project_list.dart';
import '../screens/employer/task_management.dart';
import '../screens/employer/inventory.dart';
import '../screens/employer/add_inventory.dart';
import '../screens/employer/attendance_view.dart';

import '../screens/employer/recent_activity.dart';

//Worker
import '../screens/worker/worker_dashboard.dart';
import '../screens/worker/my_tasks.dart';
import '../screens/worker/check_in_out.dart';
import '../screens/worker/salary_screen.dart';
import '../screens/shared/profile.dart';

class AppRoutes {
  // Auth
  static const String splashScreen = '/splash';
  static const String loginPage = '/login';
  static const String signUpPage = '/sign_up';
  static const String forgotPassword = '/forgot_password';
  static const String resetPassword = '/reset_password';

  // Employer
  static const String employerDashboard = '/employer_dashboard';
  static const String addWorker = '/add_worker';
  static const String createProject = '/create_project';
  static const String projectList = '/project_list';
  static const String taskManagement = '/task_management';
  static const String inventory = '/inventory';
  static const String addInventory = '/add_inventory';
  static const String attendanceView = '/attendance_view';
  static const String findDealer = '/find_dealer';
  static const String reports = '/reports';
  static const String recentActivity = '/recent_activity';

  //Worker
  static const String workerDashboard = '/worker_dashboard';
  static const String myTasks = '/my_tasks';
  static const String checkInOut = '/check_in_out';

  static const String profilePage = '/profile';
  static const String profileScreen = '/profile_screen';
  static const salaryScreen = '/salaryScreen';


  static final Map<String, WidgetBuilder> routes = {
    // Auth
    splashScreen: (context) => const SplashScreen(),
    loginPage: (context) => const LoginPage(),
    signUpPage: (context) => const SignUpPage(),
    forgotPassword: (context) => const ForgotPasswordPage(),
    resetPassword: (context) => const ResetPasswordPage(),

    // Employer
    employerDashboard: (context) => const EmployerDashboard(),
    addWorker: (context) => const AddWorkerScreen(),
    createProject: (context) => const CreateProjectScreen(),
    projectList: (context) => const ProjectListScreen(),
    taskManagement: (context) => const TaskManagementScreen(),
    inventory: (context) => const InventoryScreen(),
    addInventory: (context) => const AddInventoryScreen(),
    attendanceView: (context) => const AttendanceViewScreen(),
    findDealer: (context) => const FindDealerScreen(),

    recentActivity: (context) => const RecentActivityScreen(),

    //Worker
    workerDashboard: (context) => const WorkerDashboard(),
    myTasks: (context) => const MyTasks(),
    checkInOut: (context) => const CheckInOut(),
    salaryScreen: (context) => const SalaryScreen(),


    //Profile
    profilePage: (context) => const ProfileScreen(),
    profileScreen: (context) => const ProfileScreen(),
    
  };
}
