import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Utility accessor for environment configuration.
/// Falls back to sensible defaults when .env is not provided or variables are absent.
///
/// Defaults:
/// - API_MODE: 'mock'
/// - BASE_URL: 'https://example.mock.api'
class Env {
  Env._();

  /// Returns the API mode for data layer logic.
  /// Expected values: 'mock' or 'live'
  // PUBLIC_INTERFACE
  static String get apiMode {
    final value = dotenv.maybeGet('API_MODE') ?? 'mock';
    final normalized = value.trim().toLowerCase();
    if (normalized != 'live' && normalized != 'mock') {
      return 'mock';
    }
    return normalized;
  }

  /// Base URL for backend API when API_MODE is 'live'.
  // PUBLIC_INTERFACE
  static String get baseUrl {
    final value = dotenv.maybeGet('BASE_URL')?.trim();
    if (value == null || value.isEmpty) {
      // Safe default; not used in mock mode.
      return 'https://example.mock.api';
    }
    return value;
  }
}
