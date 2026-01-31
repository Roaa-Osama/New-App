import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/theme.dart';
import 'features/auth/login_screen.dart';
import 'features/images/presentation/images_screen.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';

final ValueNotifier<Locale> appLocale = ValueNotifier(const Locale('en'));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
  } catch (_) {}

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: appLocale,
      builder: (context, locale, _) {
        return MaterialApp(
          title: 'User App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),

          locale: locale,
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          home: Builder(
            builder: (context) {
              final user = FirebaseAuth.instance.currentUser;

              if (user != null) {
                if (!user.emailVerified) {
                  FirebaseAuth.instance.signOut();
                  return const LoginScreen();
                }
                return const ImagesScreen();
              }
              return const LoginScreen();
            },
          ),
        );
      },
    );
  }
}