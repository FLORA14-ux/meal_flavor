class ApiConstants {
  // Android emulator: http://10.0.2.2:3000
  // iOS simulator / web: http://localhost:3000
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000', // Default for web/local development
  );
}
