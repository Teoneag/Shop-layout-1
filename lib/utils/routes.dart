import 'package:flutter/material.dart';
import '/screens/forgot_password_screen.dart';
import '/screens/verify_email_screen.dart';
import '/screens/loading_screen.dart';
import '/main.dart';
import '/screens/login_screen.dart';
import '/screens/register_screen.dart';

class Routes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String loading = '/loading';
  static const String verifyEmail = '/verifyEmail';
  static const String forgotPassowrd = '/forgotPassowrd';
  // static const String help = '/help';
  // static const String notifications = '/notifications';
  // static const String profile = '/profile';
  // static const String settings = '/settings';
  // static const String aboutUs = '/about_us';
  // static const String coin = '/coin';
}

final Map<String, WidgetBuilder> routes = {
  Routes.login: (context) => const LoginScreen(),
  Routes.register: (context) => const RegisterScreen(),
  Routes.home: (context) => const MyHomeScreen(),
  Routes.loading: (context) => const LoadingScreen(),
  Routes.verifyEmail: (context) => const VerifyEmailScreen(),
  Routes.forgotPassowrd: (context) => const ForgotPasswordScreen(),
  // Routes.help: (context) => const HelpScreen(),
  // Routes.notifications: (context) => const NotificationScreen(),
  // Routes.profile: (context) => const ProfileScreen(),
  // Routes.settings: (context) => const SettingsScreen(),
  // Routes.aboutUs: (context) => const AboutUsScreen(),
  // // Routes.coin: (context) => CoinScreen(coin: coin,),
};

Route<dynamic> generateLocalRoutes(RouteSettings settings) {
  switch (settings.name) {
    case Routes.login:
      return MaterialPageRoute(
          builder: (context) =>
              LoginScreen(initialEmail: settings.arguments as String?));
    case Routes.register:
      return MaterialPageRoute(
          builder: (context) =>
              RegisterScreen(initialEmail: settings.arguments as String?));
    case Routes.forgotPassowrd:
      return MaterialPageRoute(
          builder: (context) => ForgotPasswordScreen(
              initialEmail: settings.arguments as String?));
    case Routes.verifyEmail:
      return MaterialPageRoute(
          builder: (context) =>
              VerifyEmailScreen(initialEmail: settings.arguments as String?));
    default:
      return MaterialPageRoute(builder: routes[settings.name]!);
  }
}
