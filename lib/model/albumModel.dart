import 'dart:convert';
import 'package:cypress/constants/Api.dart';
import 'package:http/http.dart' as http;

class AlbumData {
  final int userId;
  final int id;
  final String title;

  AlbumData({required this.userId, required this.id, required this.title});

  Map<String, dynamic> toJson() => {"userId": userId, "id": id, "title": title};
  Future<List<AlbumData>> albumDataApi() async {
    final getAlbumData = await http.get(
      Uri.parse(AppAPi.BaseUrl + "/albums"),
    );
    List<AlbumData> response = [];
    if (getAlbumData.statusCode == 200) {
      var data = jsonDecode(getAlbumData.body);
      for (Map i in data) {
        response.add(convertDealJsonToModel(i));
      }
    }
    return response;
  }

  AlbumData convertDealJsonToModel(Map i) {
    return AlbumData(userId: i["userId"], id: i["id"], title: i["title"]);
  }
}
