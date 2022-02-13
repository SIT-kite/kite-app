

class Activity {
  /// Activity id
  final int id;

  /// Activity category
  final int category;

  const Activity(this.id, this.category);

  @override
  String toString(){
    return 'Activity{id: $id, category: $category}';
  }

}
