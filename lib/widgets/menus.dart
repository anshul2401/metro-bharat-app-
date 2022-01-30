import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news_app/Helper/Color.dart';
import 'package:news_app/Helper/Constant.dart';
import 'package:news_app/Helper/Session.dart';
import 'package:news_app/Helper/String.dart';
import 'package:news_app/Helper/size_config.dart';
import 'package:news_app/Home.dart';
import 'package:news_app/Login.dart';
import 'package:news_app/Privacy.dart';
import 'package:news_app/RequestOtp.dart';
import 'package:news_app/search_page.dart';
import 'package:share/share.dart';

import '../Setting.dart';

class menus1 extends StatefulWidget {
  const menus1({Key? key}) : super(key: key);

  @override
  _menus1State createState() => _menus1State();
}

class _menus1State extends State<menus1> {
  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          menus(Icons.home_outlined, "Home", () {
            Navigator.of(context).pushNamedAndRemoveUntil(
                "/home", (Route<dynamic> route) => false);
          }),
          SizedBox(
            height: 2 * AppSizeConfig.heightMultiplier!,
          ),
          menus(Icons.search, "Search News", () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FilterNetworkListPage(),
                ));
          }),

          // SizedBox(
          //   height: 2 * AppSizeConfig.heightMultiplier!,
          // ),
          // menus(Icons.video_collection_outlined, "Video", () {}),
          SizedBox(
            height: 2 * AppSizeConfig.heightMultiplier!,
          ),
          menus(Icons.tv, "Live Tv", () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => HomePage(
                      isLiveTvPage: true,
                      isEventPage: false,
                      isShortPage: false,
                    )));
          }),
          SizedBox(
            height: 2 * AppSizeConfig.heightMultiplier!,
          ),
          // menus(Icons.info_outline, "About Us", () {
          //   Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (BuildContext context) => PrivacyPolicy(
          //                 title: getTranslated(context, 'about_us')!,
          //                 from: "home",
          //               )));
          // }),

          // SizedBox(
          //   height: 2 * AppSizeConfig.heightMultiplier!,
          // ),
          // menus(Icons.contact_support, "Contact us", () {
          //   Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (BuildContext context) => PrivacyPolicy(
          //                 title: getTranslated(context, 'contact_us')!,
          //                 from: "home",
          //               )));
          // }),
          // SizedBox(
          //   height: 2 * AppSizeConfig.heightMultiplier!,
          // ),
          menus(Icons.switch_left, "Change Channel", () {
            selectedChannelName = '';
            selectedChannelImg = '';
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => HomePage(
                          isLiveTvPage: false,
                          isEventPage: false,
                          isShortPage: false,
                        )));
          }),
          SizedBox(
            height: 2 * AppSizeConfig.heightMultiplier!,
          ),
          menus(Icons.settings_accessibility_outlined, "Setting", () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => Setting()));
          }),
          SizedBox(
            height: 2 * AppSizeConfig.heightMultiplier!,
          ),
          menus(Icons.photo_camera_back, "Share App", () {
            var str =
                "$appName\n\n$APPFIND$androidLink$packageName\n\n $IOSLBL\n$iosLink\t$iosPackage";
            Share.share(str);
          }),
          SizedBox(
            height: 2 * AppSizeConfig.heightMultiplier!,
          ),
          // menus(Icons.dynamic_form_outlined, "Home", () {}),
          // SizedBox(
          //   height: 2 * AppSizeConfig.heightMultiplier!,
          // ),
          // SizedBox(
          //   height: 2 * AppSizeConfig.heightMultiplier!,
          // ),

          CUR_USERID != ""
              ? menus(Icons.outbond_outlined, "Logout", () {
                  logOutDailog();
                })
              : menus(Icons.outbond_outlined, "Login", () {
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => Login()),
                  // );
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => RequestOtp()));
                }),
          SizedBox(
            height: 2 * AppSizeConfig.heightMultiplier!,
          ),
        ],
      ),
    );
  }

  menus(IconData icon, String text, onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        children: [
          SizedBox(
            width: 3 * AppSizeConfig.widthMultiplier!,
          ),
          Icon(
            icon,
            color: Colors.blueAccent,
            size: 30,
          ),
          SizedBox(
            width: 3 * AppSizeConfig.widthMultiplier!,
          ),
          Text(
            text,
            style: GoogleFonts.openSans(
                color: Colors.black87,
                fontSize: 1.8 * AppSizeConfig.textMultiplier!,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Future<void> getUserDetails() async {
    CUR_USERID = (await getPrefrence(ID)) ?? "";

    setState(() {});
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Signed Out");
  }

  //set logout dialogue
  logOutDailog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStater) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              content: Text(
                getTranslated(context, 'LOGOUTTXT')!,
                style: Theme.of(this.context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(color: Theme.of(context).colorScheme.fontColor),
              ),
              actions: <Widget>[
                new TextButton(
                    child: Text(
                      getTranslated(context, 'NO')!,
                      style: Theme.of(this.context)
                          .textTheme
                          .subtitle2
                          ?.copyWith(
                              color: Theme.of(context).colorScheme.fontColor,
                              fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    }),
                new TextButton(
                    child: Text(
                      getTranslated(context, 'YES')!,
                      style: Theme.of(this.context)
                          .textTheme
                          .subtitle2
                          ?.copyWith(
                              color: Theme.of(context).colorScheme.fontColor,
                              fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      await googleSignIn.signOut();
                      //await facebookSignIn.logOut();
                      await _auth.signOut();
                      clearUserSession();
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => Login()),
                      // );
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => RequestOtp()));
                    })
              ],
            );
          });
        });
  }
}
