import 'package:flutter/material.dart';

/// Defines and generates named routes for the application, keeping navigation centralized.
///
/// Routes:
/// - '/':       Home placeholder (to be replaced with bottom nav and IndexedStack)
/// - '/search': Search screen placeholder
/// - '/profile': Profile screen placeholder
/// - '/player': Video player placeholder with simple arguments support
class AppRouter {
  AppRouter._();

  // PUBLIC_INTERFACE
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _build(const _HomePage(), settings);
      case '/search':
        return _build(const _SearchPage(), settings);
      case '/profile':
        return _build(const _ProfilePage(), settings);
      case '/player':
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final title = args['title'] as String? ?? 'Now Playing';
        return _build(_PlayerPage(title: title), settings);
      default:
        return _build(const _NotFoundPage(), settings);
    }
  }

  static MaterialPageRoute _build(Widget child, RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => child, settings: settings);
  }
}

/// Minimalist placeholders to be replaced in later steps.

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StreamView')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Home',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text('Minimalist Ocean Professional theme applied.'),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/search'),
                    icon: const Icon(Icons.search),
                    label: const Text('Search'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/profile'),
                    icon: const Icon(Icons.person),
                    label: const Text('Profile'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      '/player',
                      arguments: {'title': 'Sample Video'},
                    ),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Player'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchPage extends StatelessWidget {
  const _SearchPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: const Center(
        child: Text('Search screen placeholder'),
      ),
    );
  }
}

class _ProfilePage extends StatelessWidget {
  const _ProfilePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(
        child: Text('Profile screen placeholder'),
      ),
    );
  }
}

class _PlayerPage extends StatelessWidget {
  final String title;
  const _PlayerPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(
        child: Icon(Icons.ondemand_video, size: 72),
      ),
    );
  }
}

class _NotFoundPage extends StatelessWidget {
  const _NotFoundPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Not Found')),
      body: const Center(
        child: Text('Route not found'),
      ),
    );
  }
}
