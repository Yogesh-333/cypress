import 'dart:convert';
import 'package:cypress/constants/Api.dart';
import 'package:http/http.dart' as http;

class PhotoData {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  PhotoData({required this.url, required this.thumbnailUrl, required this.albumId, required this.id, required this.title});

  Map<String, dynamic> toJson() => {"albumId": albumId, "id": id, "title": title,"url":url,"thumbnailUrl":thumbnailUrl};
  Future<List<PhotoData>> photoDataApi(int albumId) async {
    final getPhotoData = await http.get(
      Uri.parse(AppAPi.BaseUrl + "/photos?albumId=" + albumId.toString()),
    );
    List<PhotoData> response = [];
    if (getPhotoData.statusCode == 200) {
      var data = jsonDecode(getPhotoData.body);
      for (Map i in data) {
        response.add(convertDealJsonToModel(i));
      }
    }
    return response;
  }

  PhotoData convertDealJsonToModel(Map i) {
    return PhotoData(
        albumId: i["albumId"],
        id: i["id"],
        title: i["title"],
        url: i["url"],
        thumbnailUrl: i["thumbnailUrl"]);
  }
}
