import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/Helper/colors.dart';
import 'package:news_app/Helper/size_config.dart';

class Appbar extends StatefulWidget {
  const Appbar({Key? key}) : super(key: key);

  @override
  _AppbarState createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 17 * AppSizeConfig.heightMultiplier!,
      width: 100 * AppSizeConfig.widthMultiplier!,
      color: primary,
      child: Row(
        children: [
          SizedBox(
            width: 5 * AppSizeConfig.widthMultiplier!,
          ),
          Column(
            children: [
              SizedBox(
                height: 6 * AppSizeConfig.heightMultiplier!,
              ),
              CircleAvatar(
                radius: 5 * AppSizeConfig.heightMultiplier!,
                backgroundColor: Colors.black12,
                child: Icon(
                  Icons.account_circle_outlined,
                  color: Colors.white70,
                  size: 6 * AppSizeConfig.heightMultiplier!,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 3 * AppSizeConfig.widthMultiplier!,
          ),
          Column(
            children: [
              SizedBox(
                height: 7 * AppSizeConfig.heightMultiplier!,
              ),
              Text(
                "Namaskar!",
                style: GoogleFonts.openSans(
                    color: Colors.white,
                    fontSize: 1.5 * AppSizeConfig.textMultiplier!,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 1.1 * AppSizeConfig.heightMultiplier!,
              ),
              Container(
                height: 3 * AppSizeConfig.heightMultiplier!,
                width: 40 * AppSizeConfig.widthMultiplier!,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    // border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(3.5)),
                child: Center(
                    child: Text(
                  "Bharat Metro",
                  style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 2 * AppSizeConfig.textMultiplier!,
                      fontWeight: FontWeight.w800),
                )),
              )
            ],
          ),
          // SizedBox(
          //   width: 2 * AppSizeConfig.widthMultiplier!,
          // ),
          // Column(
          //   children: [
          //     SizedBox(
          //       height: 7 * AppSizeConfig.heightMultiplier!,
          //     ),
          //     const Icon(
          //       Icons.close,
          //       color: Colors.white70,
          //       size: 30,
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }
}
