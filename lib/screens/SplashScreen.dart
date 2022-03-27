import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cypress/model/albumModel.dart';
import 'package:cypress/model/photoModel.dart';
import 'package:cypress/utils/SpKeys.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    checkConnectivity();
    super.initState();
  }

  AlbumData albumDataObj = AlbumData(title: '', id: 0, userId: 0);
  PhotoData photoDataObj =
      PhotoData(thumbnailUrl: '', url: '', id: 0, albumId: 0, title: '');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.network(
            'https://assets3.lottiefiles.com/packages/lf20_l9bcfk19.json'),
      ),
    );
  }

  checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: new Text("No Internet"),
                content: new Text("Please check your connection"),
                actions: <Widget>[
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text("Retry"),
                    onPressed: () async {
                      checkConnectivity();
                      Get.back();
                    },
                  ),
                ],
              ));
    } else if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      final prefs = await SharedPreferences.getInstance();
      var albumListJson = prefs.getString(SpKeys().albumList);
      var photoListJson = prefs.getString(SpKeys().photoList);
      List<AlbumData> albumList = [];
      List<List<PhotoData>> photoList = [];
      if(albumListJson!=""&&albumListJson!=null&&photoListJson!=""&&photoListJson!=null){
        var albumListJsonDecode= jsonDecode(albumListJson);
        var photoListJsonDecode = jsonDecode(photoListJson);
        for (Map i in albumListJsonDecode) {
          albumList.add(albumDataObj.convertDealJsonToModel(i));
        }
        for(var value in photoListJsonDecode){
          List<PhotoData>temp=[];
          for(Map value1 in value){
            temp.add(photoDataObj.convertDealJsonToModel(value1));
          }
          photoList.add(temp);
        }
      }
      if (photoList.isEmpty || albumList.isEmpty) {
        getData();
      }
      else{
        Get.off(() => HomeScreen(
          photoListData: photoList,
          albumListData: albumList,
        ));
      }
    }
  }

  getData() async {
    List<List<PhotoData>> finalValue = [];
    List<AlbumData> albumValue = await albumDataObj.albumDataApi();
    for (int i = 0; i < albumValue.length; i++) {
      List<PhotoData> photoValue =
          await photoDataObj.photoDataApi(albumValue[i].id);
      finalValue.add(photoValue);
    }
    if (finalValue.isNotEmpty) {
      var finalJson = jsonEncode(finalValue);
      var albumJson = jsonEncode(albumValue);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(SpKeys().albumList, albumJson);
      await prefs.setString(SpKeys().photoList, finalJson);
      Get.off(() => HomeScreen(
            photoListData: finalValue,
            albumListData: albumValue,
          ));
    }
  }
}
