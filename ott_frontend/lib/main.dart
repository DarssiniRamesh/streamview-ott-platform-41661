import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'app_router.dart';
import 'app_theme.dart';
//// Entry point for the OTT frontend application.
//// Initializes Flutter bindings, loads environment variables gracefully (mock defaults if .env not found),
//// sets up dependency injection scaffolding, and renders the MaterialApp with routes and Ocean Professional theme.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Attempt to load .env but continue gracefully if absent.
  try {
    await dotenv.load(fileName: '.env', mergeWith: {});
  } catch (_) {
    // Swallow exceptions; Env() provides sensible defaults.
  }

  runApp(const OttApp());
}

/* */
/// Root widget configuring providers, theme and routing.
// PUBLIC_INTERFACE
class OttApp extends StatelessWidget {
  /// Root application widget configured with providers, theme, and navigation router.
  const OttApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder MultiProvider for later steps (repositories, view models, etc.)
    return MultiProvider(
      providers: const [
        // Add providers here in subsequent steps (e.g., ChangeNotifierProvider for app state)
      ],
      child: MaterialApp(
        title: 'StreamView',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme, // Minimalist Ocean Professional
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: '/',
      ),
    );
  }
}
