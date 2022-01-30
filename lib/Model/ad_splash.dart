class AdSplash {
  String? id, imgUrl;
  AdSplash({required this.id, required this.imgUrl});
  factory AdSplash.fromJson(Map<String, dynamic> json) {
    return AdSplash(id: json['Id'], imgUrl: json['image']);
  }
}
