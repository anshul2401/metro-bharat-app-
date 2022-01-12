class EventCategory {
  late String id, event_category_name, status;
  EventCategory({
    required this.id,
    required this.event_category_name,
    required this.status,
  });
  factory EventCategory.fromJson(Map<String, dynamic> json) {
    return new EventCategory(
      id: json['Id'],
      event_category_name: json['event_category_name'],
      status: json['status'],
    );
  }
}
