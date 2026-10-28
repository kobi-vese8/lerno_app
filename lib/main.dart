import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/lerno_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/onboarding_studies_screen.dart';
import 'screens/add_courses_screen.dart';
import 'screens/setup_complete_screen.dart';
import 'screens/home_screen.dart';
import 'screens/lecture_detail_screen.dart';
import 'screens/flashcards_screen.dart';
import 'screens/study_session_screen.dart';
import 'screens/reminders_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/feedback_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const LernoApp());
}

class LernoApp extends StatelessWidget {
  const LernoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lerno',
      debugShowCheckedModeBanner: false,
      theme: LernoTheme.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/welcome': (_) => const WelcomeScreen(),
        '/onboarding/studies': (_) => const OnboardingStudiesScreen(),
        '/onboarding/courses': (_) => const AddCoursesScreen(),
        '/onboarding/complete': (_) => const SetupCompleteScreen(),
        '/home': (_) => const HomeScreen(),
        '/lecture-detail': (_) => const LectureDetailScreen(),
        '/flashcards': (_) => const FlashcardsScreen(),
        '/study-session': (_) => const StudySessionScreen(),
        '/reminders': (_) => const RemindersScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/feedback': (_) => const FeedbackScreen(),
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignupScreen(),
      },
    );
  }
}