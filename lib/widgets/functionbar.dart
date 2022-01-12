import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/Bookmark.dart';
import 'package:news_app/Helper/size_config.dart';
import 'package:news_app/NotificationList.dart';

class Funtionbar extends StatefulWidget {
  const Funtionbar({Key? key}) : super(key: key);

  @override
  _FuntionbarState createState() => _FuntionbarState();
}

class _FuntionbarState extends State<Funtionbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 14 * AppSizeConfig.heightMultiplier!,
      width: 100 * AppSizeConfig.widthMultiplier!,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Column(
            //   children: [
            //     SizedBox(
            //       height: 1.4 * AppSizeConfig.heightMultiplier!,
            //     ),
            //     Container(
            //       height: 6.5 * AppSizeConfig.heightMultiplier!,
            //       width: 14 * AppSizeConfig.widthMultiplier!,
            //       decoration: BoxDecoration(
            //           color: Colors.transparent,
            //           border: Border.all(color: Colors.black54, width: 2.0),
            //           borderRadius: BorderRadius.circular(37)),
            //       child: Icon(
            //         Icons.download_outlined,
            //         color: Colors.red,
            //         size: 4 * AppSizeConfig.heightMultiplier!,
            //       ),
            //     ),
            //     SizedBox(
            //       height: 0.3 * AppSizeConfig.heightMultiplier!,
            //     ),
            //     Text(
            //       "Download",
            //       style: GoogleFonts.openSans(
            //           color: Colors.black54,
            //           fontSize: 1.7 * AppSizeConfig.textMultiplier!,
            //           fontWeight: FontWeight.bold),
            //     )
            //   ],
            // ),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => Bookmark()));
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 1.4 * AppSizeConfig.heightMultiplier!,
                  ),
                  Container(
                    height: 6.5 * AppSizeConfig.heightMultiplier!,
                    width: 14 * AppSizeConfig.widthMultiplier!,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.black54, width: 2.0),
                        borderRadius: BorderRadius.circular(37)),
                    child: Icon(
                      Icons.bookmark_border_outlined,
                      color: Colors.red,
                      size: 4 * AppSizeConfig.heightMultiplier!,
                    ),
                  ),
                  SizedBox(
                    height: 0.3 * AppSizeConfig.heightMultiplier!,
                  ),
                  Text(
                    "BookMark",
                    style: GoogleFonts.openSans(
                        color: Colors.black54,
                        fontSize: 1.7 * AppSizeConfig.textMultiplier!,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => NotificationList()));
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 1.4 * AppSizeConfig.heightMultiplier!,
                  ),
                  Container(
                    height: 6.5 * AppSizeConfig.heightMultiplier!,
                    width: 14 * AppSizeConfig.widthMultiplier!,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.black54, width: 2.0),
                        borderRadius: BorderRadius.circular(37)),
                    child: Icon(
                      Icons.notifications_none,
                      color: Colors.red,
                      size: 4 * AppSizeConfig.heightMultiplier!,
                    ),
                  ),
                  SizedBox(
                    height: 0.3 * AppSizeConfig.heightMultiplier!,
                  ),
                  Text(
                    "Notification",
                    style: GoogleFonts.openSans(
                        color: Colors.black54,
                        fontSize: 1.7 * AppSizeConfig.textMultiplier!,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
