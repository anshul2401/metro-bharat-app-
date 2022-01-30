// ignore_for_file: file_names

import 'package:news_app/Helper/String.dart';

//category model fetch category data from server side
class ShortsModel {
  String? id, contentType, contentValue, title, disc, likes, like;

  ShortsModel({
    this.id,
    this.contentType,
    this.contentValue,
    this.title,
    this.disc,
    this.likes,
    this.like,
  });

  factory ShortsModel.fromJson(Map<String, dynamic> json) {
    return ShortsModel(
      id: json['Id'],
      contentType: json[CONTENT_TYPE],
      contentValue: json[CONTENT_VALUE],
      title: json['title'],
      disc: json['description'],
      likes: json['total_like'],
      like: json['like'],
    );
  }
}
