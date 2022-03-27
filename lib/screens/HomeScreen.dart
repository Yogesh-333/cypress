import 'package:cypress/model/albumModel.dart';
import 'package:cypress/model/photoModel.dart';
import 'package:cypress/utils/widgets/ListCard.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  final List<List<PhotoData>> photoListData;
  final List<AlbumData> albumListData;
  const HomeScreen({required this.photoListData, required this.albumListData});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        body: ListView.builder(
            shrinkWrap: true,
            //itemCount: widget.albumListData.length,
            itemBuilder: (BuildContext context, int index1) {
              final val1 =
                  index1 % widget.photoListData.length; //<----to the right

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 2.h,bottom: 2.h,left: 2.w),
                    child: SizedBox(

                      child: Text(
                        widget.albumListData[val1].title,
                        style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600),
                       // overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100.w,
                    height: 25.h,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        //itemCount: widget.albumListData[index1].length,

                        itemBuilder: (BuildContext context, int index) {
                          final i = index %
                              widget.photoListData[val1]
                                  .length; //<----to the right
                          final item = widget.photoListData[val1][i];
                          return ListCard(item.id, item.albumId,
                              item.thumbnailUrl, item.title, item.url);
                        }),
                  ),
                  Divider(thickness: 2.sp,)
                ],
              );
            }),
      ),
    );
  }
}
