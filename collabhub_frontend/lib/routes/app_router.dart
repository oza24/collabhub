import 'package:collabhub/features/auth/screens/forgot_password_screen.dart';
import 'package:collabhub/features/auth/screens/login_screen.dart';
import 'package:collabhub/features/auth/screens/signup_screen.dart';
import 'package:collabhub/features/home/home_screen.dart';
import 'package:collabhub/features/workspace/workspace_detail_screen.dart';
import 'package:collabhub/features/workspace/workspace_screen.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/screens/otp_screen.dart';
import '../features/auth/screens/reset_password_screen.dart';
import '../features/auth/screens/splash_screen.dart';
import '../features/chat/direct_message_screen.dart';
import '../features/chat/message_screen.dart';
import '../features/notification/notification_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),

    GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
    ),

    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),

    GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
    ),

    GoRoute(path: '/workspacedetail',
      builder: (context, state) {
      final workspace = state.extra as Map<String, dynamic>;
      return WorkspaceDetailScreen(workspace: workspace);
      },
    ),
    
    GoRoute(path: '/workspaces',
      builder: (context, state) => const WorkspaceScreen(),
    ),

    GoRoute(path: '/messages',
      builder: (context, state) {
        final channel = state.extra as Map<String, dynamic>;
        return MessageScreen(channel: channel);
      },
    ),

    GoRoute(path: '/dm',
      builder: (context, state) {
        return DirectMessageScreen(
          user: state.extra as Map<String, dynamic>,
        );
      },
    ),

    GoRoute(
      path: "/workspace/:id",
      builder: (context, state) {
        final workspace =
        state.extra as Map<String,dynamic>;
        return WorkspaceDetailScreen(
          workspace: workspace,
        );
      },
    ),

    GoRoute(
      path: "/notifications",
      builder: (context,state){
        return const NotificationScreen();
        },
    ),

    GoRoute(path: '/forget-password',
      builder: (context,state) => const ForgotPasswordScreen(),
    ),

    GoRoute(
      path: '/verify-otp',
      builder: (context,state) {
        final email = state.extra as String;

        return OtpScreen(email: email);
      }
    ),
    
    GoRoute(path: '/reset-password',
      builder: (context,state){
      final data = state.extra as Map<String , dynamic>;

      return ResetPasswordScreen(
        email:data["email"],
        otp:data["otp"],
      );
      }
    ),
  ],
);