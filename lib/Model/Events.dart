import 'package:news_app/Helper/String.dart';

//category model fetch category data from server side
class EventsModel {
  String? id, image, title, desc, views, category_id, like, like_count;

  EventsModel({
    this.id,
    this.image,
    this.title,
    this.desc,
    this.views,
    this.category_id,
    this.like,
    this.like_count,
  });

  factory EventsModel.fromJson(Map<String, dynamic> json) {
    return new EventsModel(
        id: json['Id'],
        image: json['image'],
        title: json['title'],
        desc: json['description'],
        views: json['views'],
        category_id: json['categoryId'],
        like: json['like'],
        like_count: json['total_like']);
  }
}
