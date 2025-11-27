import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'app_router.dart';
import 'app_theme.dart';
import 'features/video/video_player_provider.dart';
import 'features/video/video_player_screen.dart';

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
    return ChangeNotifierProvider(
      create: (_) => VideoPlayerProvider(),
      child: MaterialApp(
        title: 'StreamView',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme, // Minimalist Ocean Professional
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: '/',
        builder: (context, child) {
          // Listen to expansion and navigate to full player when needed.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final vm = context.read<VideoPlayerProvider>();
            if (vm.isExpanded && vm.current != null) {
              // Ensure we are on top-level navigator and not pushing duplicates.
              final navigator = Navigator.of(context);
              // If already on player route, skip.
              bool onPlayer = false;
              navigator.popUntil((route) {
                if (route.settings.name == '/player') {
                  onPlayer = true;
                }
                return true;
              });
              if (!onPlayer) {
                navigator.push(VideoPlayerScreen.route(vm.current!));
              }
            }
          });
          return child ?? const SizedBox.shrink();
        },
      ),
    );
  }
}
