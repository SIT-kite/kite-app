class ActivityDetail {
  /// Activity id
  final int id;

  /// Category id
  final int category;

  /// Activity title
  final String title;

  /// Activity start time
  final DateTime startTime;

  /// Sign start time
  final DateTime signStartTime;

  /// Sign end time
  final DateTime signEndTime;

  /// Place
  final String place;

  /// Duration
  final String duration;

  /// Activity manager
  final String manager;

  /// Manager contact(phone)
  final String contact;

  /// Activity organizer
  final String organizer;

  /// Activity undertaker
  final String undertaker;

  /// Description in text[]
  final String description;

  /// Image attachment
  final List<ScImages> images;

  const ActivityDetail(
      this.id,
      this.category,
      this.title,
      this.startTime,
      this.signStartTime,
      this.signEndTime,
      this.place,
      this.duration,
      this.manager,
      this.contact,
      this.organizer,
      this.undertaker,
      this.description,
      this.images);

  @override
  String toString() {
    return 'ActivityDetail{id: $id, category: $category, title: $title, '
        'startTime: $startTime, signStartTime: $signStartTime, '
        'signEndTime: $signEndTime, place: $place, duration: $duration,'
        'manager: $manager, contact: $contact, organizer: $organizer,'
        ' undertaker: $undertaker, description: $description, images: $images}';
  }
}

class ScImages {
  /// New image name
  final String newName;

  /// Old image name
  final String oldName;

  /// Image content
  final List<int> content;

  const ScImages(this.newName, this.oldName, this.content);

  @override
  String toString() {
    return 'ScImages{newName: $newName, oldName: $oldName, content: $content}';
  }
}
