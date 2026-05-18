# Flutter Analyze Fix Plan - 19 Issues

## Priority 1: Compile Errors (my_trips_screen.dart)
- [x] Fix missing State.build implementation (added full build with TabBar)
- [x] Remove unused import 'create_trip_screen.dart'
- [x] Fix sync File.existsSync() in build() for images (use errorBuilder + _buildSafeImage)

## Priority 2: use_build_context_synchronously (11 instances)
- [ ] screens/auth/profile_screen.dart:23
- [ ] screens/auth/sign_in_screen.dart:23
- [ ] screens/detail/edit_trip_screen.dart:42
- [ ] screens/onboarding/onboarding_screen.dart:37
- [ ] screens/profile/profile_screen.dart:53,67
- [ ] screens/trips/create_trip_screen.dart:121,122
Add `if (!mounted) return;` before Navigator.pop/push after async.

## Priority 3: Deprecated APIs
- [x] screens/auth/sign_up_screen.dart:181 withOpacity -> withValues(alpha: 0.05) (still has Radio issue)
- [x] screens/detail/tour_detail_screen.dart:27 withOpacity
- [ ] screens/auth/sign_up_screen.dart:191-193 Radio groupValue/onChanged

## Priority 4: Others
- [x] screens/auth/chat_screen.dart:44 camel_case_types 'chatBubble' -> ChatBubble
- [ ] services/auth_service.dart: print -> debugPrint

## Follow-up
- [ ] flutter analyze to check remaining
- [ ] Fix next priorities
- [ ] flutter pub get && flutter run

