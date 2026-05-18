import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:provider/provider.dart';
import 'providers/tour_provider.dart';
import 'providers/cart_provider.dart';

//Profile
// import 'screens/profile/search_screen.dart';
import 'screens/profile/settings_screen.dart';
import 'screens/profile/edit_profile_screen.dart';
import 'screens/profile/change_password_screen.dart';
import 'screens/profile/my_photos_screen.dart';
import 'screens/profile/add_photos_screen.dart';
import 'screens/profile/my_journeys_screen.dart';
import 'screens/profile/add_journey_screen.dart';
 
//blogs
import 'blogs/blogs_screen.dart';

//
import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/sign_in_screen.dart';
import 'screens/main/main_screen.dart';

//detail
import 'screens/detail/edit_trip_screen.dart';
import 'screens/detail/trip_detail_screen.dart';


//auth
import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/sign_up_screen.dart';
import 'screens/chat/chat_screen.dart';
import 'screens/auth/see_more_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final seen = prefs.getBool('seenOnboarding') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TourProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MyApp(seen),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool seen;

  const MyApp(this.seen, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(seen: seen),
        '/onboarding': (context) => const OnboardingScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/signin': (context) => const SignInScreen(),
        '/main': (context) => const MainScreen(),
        '/forgotpassword': (context) => const ForgotPasswordScreen(),
        '/tripEdit': (context) => const EditTripScreen(),
        '/chat': (context) => const ChatScreen(),
        '/see-more': (context) => const SeeMoreScreen(),
      
      //blogs
        '/blogs': (context) => const BlogDetailScreen(),

      //Profile
        // '/search': (context) => const SearchScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/edit': (context) => const EditProfileScreen(),
        '/change-password': (context) => const ChangePasswordScreen(),
        '/photos': (context) => const MyPhotosScreen(),
        '/add-photos': (context) => const AddPhotosScreen(),
        '/journeys': (context) => const MyJourneysScreen(),
        '/add-journey': (context) => const AddJourneyScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final args = settings.arguments;
          final Map tripDetail = (args is Map)
              ? args
              : {
                  'city': 'Sample',
                  'date': '2024-01-01',
                  'image': '',
                  'attractions': [],
                  'fee': '100',
                  'from': '',
                  'to': '',
                  'travelers': 1,
                };

          return MaterialPageRoute(
            builder: (context) => TripDetailScreen(
              trip: tripDetail,
              onDelete: () async {
                final prefs = await SharedPreferences.getInstance();
                final data = prefs.getString('trips');

                if (data != null) {
                  final trips = jsonDecode(data);
                  trips.remove(tripDetail);
                  await prefs.setString('trips', jsonEncode(trips));
                }
              },
            ),
          );
        }
        return null;
      },
    );
  }
}

