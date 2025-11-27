import 'package:flutter/material.dart';
import 'package:ott_frontend/features/video/mini_player.dart';
import 'package:ott_frontend/features/video/video_detail_screen.dart';
import 'package:ott_frontend/features/video/video_models.dart';

/// Defines and generates named routes for the application, keeping navigation centralized.
///
/// Routes:
/// - '/':       MainShell with bottom nav and IndexedStack
/// - '/detail': Video details screen expecting VideoItem as args
class AppRouter {
  AppRouter._();

  // PUBLIC_INTERFACE
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _build(const _MainShell(), settings);
      case '/detail':
        final item = settings.arguments as VideoItem;
        return _build(VideoDetailScreen(item: item), settings);
      default:
        return _build(const _NotFoundPage(), settings);
    }
  }

  static MaterialPageRoute _build(Widget child, RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => child, settings: settings);
  }
}

class _MainShell extends StatefulWidget {
  const _MainShell();

  @override
  State<_MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<_MainShell> {
  int _index = 0;

  final _pages = const [
    _HomePage(),
    _SearchPage(),
    _ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // IndexedStack preserves state while navigating
          IndexedStack(
            index: _index,
            children: _pages,
          ),
          // Mini player docked at bottom
          const Align(
            alignment: Alignment.bottomCenter,
            child: MiniPlayer(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    final items = DemoVideos.all;
    return Scaffold(
      appBar: AppBar(title: const Text('StreamView')),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88), // leave space for mini player
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final v = items[i];
          return ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            leading: SizedBox(
              width: 72,
              height: 48,
              child: v.posterAsset != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(v.posterAsset!, fit: BoxFit.cover),
                    )
                  : const Icon(Icons.movie_creation_outlined),
            ),
            title: Text(v.title),
            subtitle: Text(v.isNetwork ? 'Network stream' : 'Local asset'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/detail', arguments: v),
          );
        },
      ),
    );
  }
}

class _SearchPage extends StatelessWidget {
  const _SearchPage();

  @override
  Widget build(BuildContext context) {
    final items = DemoVideos.all;
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 16 / 10,
        ),
        itemCount: items.length,
        itemBuilder: (context, i) {
          final v = items[i];
          return InkWell(
            onTap: () => Navigator.pushNamed(context, '/detail', arguments: v),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  if (v.posterAsset != null)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(v.posterAsset!, fit: BoxFit.cover),
                      ),
                    ),
                  Positioned(
                    left: 8, right: 8, bottom: 8,
                    child: Text(
                      v.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProfilePage extends StatelessWidget {
  const _ProfilePage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child: Text('Profile screen placeholder'),
      ),
    );
  }
}

class _NotFoundPage extends StatelessWidget {
  const _NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Route not found')),
    );
  }
}
