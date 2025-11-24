import '../../../common/domain/dental_item.dart';

/// Data for the "Before the Visit" page content.
/// Contains both the story sequence items and the tools/actions items.
/// IDs match those in ContentTranslations for localization support.
class BeforeVisitData {
  /// Story sequence items showing the dental visit flow.
  /// These are displayed in a horizontal row with arrows connecting them.
  static const List<DentalItem> storyItems = [
    DentalItem(
      id: 'dentist-chair',
      imagePath: 'assets/images/before_visit/dentist_chair.png',
      caption: "This is the dentist's chair",
    ),
    DentalItem(
      id: 'dentist-mask',
      imagePath: 'assets/images/before_visit/dentist_mask.png',
      caption: 'The dentist wears a mask',
    ),
    DentalItem(
      id: 'dentist-gloves',
      imagePath: 'assets/images/before_visit/dentist_gloves.png',
      caption: 'The dentist wears a glove',
    ),
    DentalItem(
      id: 'bright-light',
      imagePath: 'assets/images/before_visit/bright_light.png',
      caption: 'The dentist has a bright light',
    ),
    DentalItem(
      id: 'count-teeth',
      imagePath: 'assets/images/before_visit/count_teeth.png',
      caption: 'The dentist will count your teeth',
    ),
  ];

  /// Tools and actions items shown in a grid layout.
  /// These are standalone items without sequential connection.
  static const List<DentalItem> toolsItems = [
    DentalItem(
      id: 'dental-mirror',
      imagePath: 'assets/images/before_visit/dental_mirror.png',
      caption: 'This is a mirror',
    ),
    DentalItem(
      id: 'dental-drill',
      imagePath: 'assets/images/before_visit/dental_drill.png',
      caption: "This is the dentist's drill",
    ),
    DentalItem(
      id: 'suction',
      imagePath: 'assets/images/before_visit/suction.png',
      caption: 'This is a suction',
    ),
    DentalItem(
      id: 'open-mouth',
      imagePath: 'assets/images/before_visit/open_mouth.png',
      caption: 'Open your mouth',
    ),
    DentalItem(
      id: 'stop',
      imagePath: 'assets/images/before_visit/stop.png',
      caption: 'Stop',
    ),
  ];

  // Private constructor to prevent instantiation
  BeforeVisitData._();
}
