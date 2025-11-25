// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Verbadent CareQuest';

  @override
  String get navLibrary => 'Library';

  @override
  String get navBeforeVisit => 'Before the visit';

  @override
  String get navDuringVisit => 'During the visit';

  @override
  String get navBuildOwn => 'Build your own';

  @override
  String get pageHeaderLibrary => 'Library';

  @override
  String get pageHeaderBeforeVisit => 'Before the visit';

  @override
  String get pageHeaderDuringVisit => 'During the visit';

  @override
  String get pageHeaderBuildOwn => 'Build your own';

  @override
  String get languageSelectorLabel => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Spanish';

  @override
  String get loadingContent => 'Loading...';

  @override
  String get speakingIndicator => 'Speaking';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get lightMode => 'Light mode';

  @override
  String get themeSystem => 'System';
}
