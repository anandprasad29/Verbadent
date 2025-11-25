// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Verbadent CareQuest';

  @override
  String get navLibrary => 'Biblioteca';

  @override
  String get navBeforeVisit => 'Antes de la visita';

  @override
  String get navDuringVisit => 'Durante la visita';

  @override
  String get navBuildOwn => 'Crea el tuyo';

  @override
  String get pageHeaderLibrary => 'Biblioteca';

  @override
  String get pageHeaderBeforeVisit => 'Antes de la visita';

  @override
  String get pageHeaderDuringVisit => 'Durante la visita';

  @override
  String get pageHeaderBuildOwn => 'Crea el tuyo';

  @override
  String get languageSelectorLabel => 'Idioma';

  @override
  String get languageEnglish => 'Inglés';

  @override
  String get languageSpanish => 'Español';

  @override
  String get loadingContent => 'Cargando...';

  @override
  String get speakingIndicator => 'Hablando';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get lightMode => 'Modo claro';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get searchPlaceholder => 'Buscar por texto...';

  @override
  String get searchNoResults => 'No se encontraron resultados';

  @override
  String searchResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementos',
      one: '1 elemento',
      zero: 'Sin elementos',
    );
    return '$_temp0';
  }
}
