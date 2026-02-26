class StylistOption {
  final String id;
  final String name;
  final String? title;
  final double? rating;
  final String? availability;
  final bool isNoPreference;

  StylistOption({
    required this.id,
    required this.name,
    this.title,
    this.rating,
    this.availability,
    required this.isNoPreference,
  });
}
