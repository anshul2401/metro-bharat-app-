import 'package:news_app/Helper/String.dart';

//category model fetch category data from server side
class Channel {
  String? id, channelName, channelId, channel_image;

  Channel({this.id, this.channelName, this.channelId, this.channel_image});

  factory Channel.fromJson(Map<String, dynamic> json) {
    return new Channel(
        id: json[ID],
        channelName: json['channel_name'],
        channelId: json['id'],
        channel_image: json['channel_image']);
  }
}
