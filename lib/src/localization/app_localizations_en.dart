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
  String get navBeforeVisit => 'Before Visit';

  @override
  String get navDuringVisit => 'During Visit';

  @override
  String get navBuildOwn => 'Build Your Own';

  @override
  String get pageHeaderLibrary => 'Library';

  @override
  String get pageHeaderBeforeVisit => 'Before Visit';

  @override
  String get pageHeaderDuringVisit => 'During Visit';

  @override
  String get pageHeaderBuildOwn => 'Build Your Own';

  @override
  String get languageSelectorLabel => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Spanish';
}
