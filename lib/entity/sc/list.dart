enum ActivityType { lecture, theme, creation, campus, practice, voluntary, unknown }

class Activity {
  /// Activity id
  final int id;

  /// Activity category
  final ActivityType category;

  /// Title
  final String title;

  /// Date
  final DateTime ts;

  const Activity(this.id, this.category, this.title, this.ts);

  @override
  String toString() {
    return 'Activity{id: $id, category: $category}';
  }
}
