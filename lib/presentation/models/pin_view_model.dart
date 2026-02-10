class PinViewModel {
  final int id;
  final String imageUrl;
  final String title;
  final String photographer;
  final bool liked;
  final DateTime savedAt;
  final int width;
  final int height;

  const PinViewModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.photographer,
    required this.liked,
    required this.savedAt,
    required this.width,
    required this.height,
  });
}
