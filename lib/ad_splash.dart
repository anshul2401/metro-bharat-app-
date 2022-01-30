// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news_app/EventVideo.dart';
import 'package:news_app/Helper/Color.dart';
import 'package:news_app/Helper/Constant.dart';
import 'package:news_app/Helper/Session.dart';
import 'package:news_app/Helper/String.dart';
import 'package:news_app/Model/Shorts.dart';
import 'package:news_app/Model/ad_splash.dart';

import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;

import 'Helper/colors.dart';

class AdSplashPage extends StatefulWidget {
  const AdSplashPage({Key? key}) : super(key: key);

  @override
  _AdSplashPageState createState() => _AdSplashPageState();
}

class _AdSplashPageState extends State<AdSplashPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isNetworkAvail = true;
  List<AdSplash> adSplash = [];
  List<AdSplash> tempAdList = [];
  bool _isLoading = false;
  callApi() async {
    _isLoading = true;
    checkNet();
    await _getAdSplash();
    _isLoading = false;
  }

  Future<void> _getAdSplash() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      var param = {
        ACCESS_KEY: access_key,
        USER_ID: '0',
      };

      http.Response response = await http
          .post(Uri.parse(baseUrl + 'get_ad_splash'),
              body: param, headers: headers)
          .timeout(Duration(seconds: timeOut));

      var getdata = json.decode(response.body);

      String error = getdata["error"];
      print(getdata);
      if (error == "false") {
        var data = getdata["data"];

        tempAdList =
            (data as List).map((data) => AdSplash.fromJson(data)).toList();
        adSplash.addAll(tempAdList);

        setState(() {});

        // for (int i = 0; i < data.length; i++) {
        //   catId = data[i]["category_id"];
        // }
        // setState(() {
        //   selectedChoices = catId == "" ? catId!.split('') : catId!.split(',');
        // });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      setSnackbar(getTranslated(context, 'internetmsg')!);
    }
  }

  setSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).colorScheme.fontColor),
      ),
      backgroundColor: isDark! ? colors.tempdarkColor : colors.bgColor,
      elevation: 1.0,
    ));
  }

  @override
  void initState() {
    callApi();
    super.initState();
  }

  checkNet() async {
    _isNetworkAvail = await isNetworkAvailable();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //news video link set
  viewAd(AdSplash ad) {
    return Image.network(
      ad.imgUrl!,
      fit: BoxFit.fitHeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: 0);
    return Scaffold(
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Stack(alignment: Alignment.bottomRight, children: [
                PageView(
                    controller: controller,
                    scrollDirection: Axis.horizontal,
                    children: adSplash
                        .map((e) => Container(child: viewAd(e)))
                        .toList()),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, "/home");
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: StadiumBorder(),
                    color: Colors.red,
                  ),
                ),
              ]));
  }
}
