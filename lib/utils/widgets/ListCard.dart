import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
class ListCard extends StatelessWidget {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;
  ListCard(this.id,this.albumId,this.thumbnailUrl,this.title,this.url);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:()=> _openCustomDialog(context),
      child: Padding(
        padding:  EdgeInsets.all(10.sp),
        child: Container(
          height: 25.h,
          width: 30.w,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(thumbnailUrl))),
          child: SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsets.all(10.sp),
              child: SizedBox(height:15.h,child: Text(title,style: TextStyle(fontSize: 12.sp),)),
            ),
          ),
        ),
      ),
    );
  }
  void _openCustomDialog(BuildContext context) {
    showGeneralDialog(barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Image.network(
                  url,
                  fit: BoxFit.fill,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
                content: Text(title,style: TextStyle(fontSize: 15.sp),),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context, pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) { return const AlertDialog(title: Text('Alert!'));
      },
       );
  }
}
