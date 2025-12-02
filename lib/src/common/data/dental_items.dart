import '../domain/dental_item.dart';

/// Central repository of all dental items used across the app.
/// This is the single source of truth for dental content.
/// All features (Library, Before Visit, Build Your Own, etc.) reference these items.
class DentalItems {
  /// All dental items available in the app.
  /// Images are stored in `assets/images/library/`.
  static const List<DentalItem> all = [
    // Dental visit scenarios
    DentalItem(
      id: 'dentist-chair',
      imagePath: 'assets/images/library/dentist_chair.webp',
      caption: "This is the dentist's chair",
    ),
    DentalItem(
      id: 'dentist-mask',
      imagePath: 'assets/images/library/dentist_mask.webp',
      caption: 'The dentist wears a mask',
    ),
    DentalItem(
      id: 'dentist-gloves',
      imagePath: 'assets/images/library/dentist_gloves.webp',
      caption: 'The dentist wears a glove',
    ),
    DentalItem(
      id: 'bright-light',
      imagePath: 'assets/images/library/bright_light.webp',
      caption: 'The dentist has a bright light',
    ),
    DentalItem(
      id: 'count-teeth',
      imagePath: 'assets/images/library/count_teeth.webp',
      caption: 'The dentist will count your teeth',
    ),
    // Dental tools and actions
    DentalItem(
      id: 'dental-mirror',
      imagePath: 'assets/images/library/dental_mirror.webp',
      caption: 'This is a mirror',
    ),
    DentalItem(
      id: 'dental-drill',
      imagePath: 'assets/images/library/dental_drill.webp',
      caption: "This is the dentist's drill",
    ),
    DentalItem(
      id: 'suction',
      imagePath: 'assets/images/library/suction.webp',
      caption: 'This is a suction',
    ),
    DentalItem(
      id: 'open-mouth',
      imagePath: 'assets/images/library/open_mouth.webp',
      caption: 'Open your mouth',
    ),
    DentalItem(
      id: 'stop',
      imagePath: 'assets/images/library/stop.webp',
      caption: 'Stop',
    ),
  ];

  /// IDs for the "Before Visit" story sequence.
  /// These items are shown in a horizontal flow with arrows.
  static const List<String> beforeVisitStoryIds = [
    'dentist-chair',
    'dentist-mask',
    'dentist-gloves',
    'bright-light',
    'count-teeth',
  ];

  /// IDs for the "Before Visit" tools grid.
  /// These items are shown in a grid layout.
  static const List<String> beforeVisitToolsIds = [
    'dental-mirror',
    'dental-drill',
    'suction',
    'open-mouth',
    'stop',
  ];

  /// Lookup map for fast ID-based access.
  static final Map<String, DentalItem> _itemMap = {
    for (var item in all) item.id: item,
  };

  /// Get items by their IDs (preserves order).
  /// Returns only items that exist in the catalog.
  static List<DentalItem> getByIds(List<String> ids) {
    return ids
        .where((id) => _itemMap.containsKey(id))
        .map((id) => _itemMap[id]!)
        .toList();
  }

  /// Get a single item by ID.
  /// Returns null if not found.
  static DentalItem? getById(String id) => _itemMap[id];

  /// Get items for the Before Visit story sequence.
  static List<DentalItem> get beforeVisitStoryItems =>
      getByIds(beforeVisitStoryIds);

  /// Get items for the Before Visit tools grid.
  static List<DentalItem> get beforeVisitToolsItems =>
      getByIds(beforeVisitToolsIds);

  // Private constructor to prevent instantiation
  DentalItems._();
}

