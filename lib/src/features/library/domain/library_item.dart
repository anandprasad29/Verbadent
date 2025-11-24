/// Data model for a library item with image and caption
class LibraryItem {
  final String id;
  final String imagePath;
  final String caption;

  const LibraryItem({
    required this.id,
    required this.imagePath,
    required this.caption,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LibraryItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          imagePath == other.imagePath &&
          caption == other.caption;

  @override
  int get hashCode => id.hashCode ^ imagePath.hashCode ^ caption.hashCode;
}

