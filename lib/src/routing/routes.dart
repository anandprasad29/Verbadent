/// Route path constants for the application.
/// Use these instead of hardcoded string literals.
class Routes {
  static const String home = '/';
  static const String library = '/library';
  static const String beforeVisit = '/before-visit';
  static const String duringVisit = '/during-visit';
  static const String buildOwn = '/build-own';
  static const String settings = '/settings';

  /// Dynamic route for custom templates
  static const String customTemplate = '/template/:id';

  /// Helper to generate custom template path with ID
  static String customTemplatePath(String id) => '/template/$id';

  // Private constructor to prevent instantiation
  Routes._();
}
