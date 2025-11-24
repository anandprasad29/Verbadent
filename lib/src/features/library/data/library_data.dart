import '../../../common/domain/dental_item.dart';

/// Sample dental-related library items based on Figma design.
/// These will be replaced with actual content when image assets are provided.
class LibraryData {
  /// Sample library items matching the Figma "Before Your Visit" design
  static const List<DentalItem> sampleItems = [
    // Row 1 - Dental visit scenarios
    DentalItem(
      id: 'dentist-chair',
      imagePath: 'assets/images/library/dentist_chair.png',
      caption: "This is the dentist's chair",
    ),
    DentalItem(
      id: 'dentist-mask',
      imagePath: 'assets/images/library/dentist_mask.png',
      caption: 'The dentist wears a mask',
    ),
    DentalItem(
      id: 'dentist-gloves',
      imagePath: 'assets/images/library/dentist_gloves.png',
      caption: 'The dentist wears a glove',
    ),
    DentalItem(
      id: 'bright-light',
      imagePath: 'assets/images/library/bright_light.png',
      caption: 'The dentist has a bright light',
    ),
    DentalItem(
      id: 'count-teeth',
      imagePath: 'assets/images/library/count_teeth.png',
      caption: 'The dentist will count your teeth',
    ),
    // Row 2 - Dental tools and actions
    DentalItem(
      id: 'dental-mirror',
      imagePath: 'assets/images/library/dental_mirror.png',
      caption: 'This is a mirror',
    ),
    DentalItem(
      id: 'dental-drill',
      imagePath: 'assets/images/library/dental_drill.png',
      caption: "This is the dentist's drill",
    ),
    DentalItem(
      id: 'suction',
      imagePath: 'assets/images/library/suction.png',
      caption: 'This is a suction',
    ),
    DentalItem(
      id: 'open-mouth',
      imagePath: 'assets/images/library/open_mouth.png',
      caption: 'Open your mouth',
    ),
    DentalItem(
      id: 'stop',
      imagePath: 'assets/images/library/stop.png',
      caption: 'Stop',
    ),
  ];

  // Private constructor to prevent instantiation
  LibraryData._();
}
