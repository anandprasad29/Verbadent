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

  @override
  String get searchPlaceholder => 'Search by caption...';

  @override
  String get searchNoResults => 'No results found';

  @override
  String searchResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: 'No items',
    );
    return '$_temp0';
  }

  @override
  String get templateNamePlaceholder => 'Template Name';

  @override
  String selectedCount(int count) {
    return '$count selected';
  }

  @override
  String get createTemplate => 'Create Template';

  @override
  String get editTemplate => 'Edit';

  @override
  String get deleteTemplate => 'Delete Template';

  @override
  String get deleteConfirmation =>
      'Are you sure you want to delete this template?';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get addImages => 'Add Images';

  @override
  String get currentImages => 'Current Images';

  @override
  String get tapToRemove => 'Tap to remove';

  @override
  String get noImagesSelected => 'No images selected yet';

  @override
  String get selectAtLeastOne => 'Select at least one image';

  @override
  String get enterTemplateName => 'Please enter a template name';

  @override
  String get unsavedChangesTitle => 'Unsaved Changes';

  @override
  String get unsavedChangesMessage =>
      'You have unsaved changes. Are you sure you want to discard them?';

  @override
  String get discard => 'Discard';

  @override
  String get templateLimitReached => 'Template limit reached';

  @override
  String templateLimitMessage(int count) {
    return 'You can create up to $count templates. Please delete an existing template to create a new one.';
  }

  @override
  String get loadingTemplates => 'Loading templates...';

  @override
  String get dragToReorder => 'Drag to reorder';

  @override
  String get emptyTemplatePrompt =>
      'Tap images below to add them to your template';

  @override
  String get duplicateNameError => 'A template with this name already exists';
}
