import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news_app/Helper/Color.dart';
import 'package:news_app/Helper/Constant.dart';
import 'package:news_app/Helper/Session.dart';
import 'package:news_app/Helper/String.dart';
import 'package:news_app/Home.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/Live.dart';
import 'package:news_app/Search.dart';

class LiveTvPage extends StatefulWidget {
  const LiveTvPage({Key? key}) : super(key: key);

  @override
  _LiveTvPageState createState() => _LiveTvPageState();
}

class _LiveTvPageState extends State<LiveTvPage> {
  @override
  void initState() {
    sett();
    super.initState();
  }

  Future<void> sett() async {
    await getLiveNews();
  }

  var isliveNews;
  bool _folded = true;
  final TextEditingController textController = TextEditingController();
  bool _isNetworkAvail = true;
  Future<void> getLiveNews() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      var parameter = {ACCESS_KEY: access_key};

      http.Response response = await http
          .post(Uri.parse(getLiveStreamingApi),
              body: parameter, headers: headers)
          .timeout(Duration(seconds: timeOut));
      var getdata = json.decode(response.body);
      String error = getdata["error"];

      if (error == "false") {
        isliveNews = getdata["data"];
      } else {
        isliveNews = "";
      }
    } else {
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

  HomePageState h = HomePageState();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: liveWithSearchView(),
    );
  }

  Widget liveWithSearchView() {
    print(isliveNews);
    return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Row(
          children: [
            liveStreaming_mode == "1" && isliveNews != "" && isliveNews != null
                ? Expanded(
                    flex: _folded ? 9 : 3,
                    child: InkWell(
                      child: Padding(
                          padding: EdgeInsetsDirectional.only(
                              end: _folded ? 0.0 : 10.0),
                          child: Container(
                              height: 60,
                              // width: _folded ? deviceWidth! - 120 : 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Theme.of(context).colorScheme.lightColor,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 10.0,
                                      offset: const Offset(12.0, 15.0),
                                      color: colors.tempfontColor1
                                          .withOpacity(0.2),
                                      spreadRadius: -7),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/live_news.svg",
                                    semanticsLabel: 'live news',
                                    height: 21.0,
                                    width: 21.0,
                                    color:
                                        Theme.of(context).colorScheme.fontColor,
                                  ),
                                  _folded
                                      ? Padding(
                                          padding: EdgeInsetsDirectional.only(
                                              start: 8.0),
                                          child: Text(
                                            getTranslated(context, 'liveNews')!,
                                            style: Theme.of(this.context)
                                                .textTheme
                                                .subtitle1
                                                ?.copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .fontColor,
                                                    fontWeight:
                                                        FontWeight.w600),
                                          ))
                                      : Container()
                                ],
                              ))),
                      onTap: () {
                        if (_isNetworkAvail) {
                          if (isliveNews != "" && isliveNews != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Live(
                                    liveNews: isliveNews,
                                  ),
                                ));
                          }
                        } else {
                          setSnackbar(getTranslated(context, 'internetmsg')!);
                        }
                      },
                    ))
                : Container(),
            liveStreaming_mode == "1" && isliveNews != "" && isliveNews != null
                ? Expanded(
                    flex: _folded ? 3 : 9,
                    child: Padding(
                        padding: EdgeInsetsDirectional.only(
                            start: _folded ? 10.0 : 0.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: InkWell(
                              child: AnimatedContainer(
                                  alignment: Alignment.center,
                                  duration: Duration(milliseconds: 400),
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .lightColor,
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 10.0,
                                          offset: const Offset(12.0, 15.0),
                                          color: colors.tempfontColor1
                                              .withOpacity(0.2),
                                          spreadRadius: -7),
                                    ],
                                  ),
                                  child: Padding(
                                      padding: EdgeInsetsDirectional.only(
                                          start: !_folded ? 20.0 : 0.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/images/search_icon.svg",
                                              height: 18,
                                              width: 18,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .fontColor,
                                            ),
                                            !_folded
                                                ? Expanded(
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .only(
                                                                    start:
                                                                        10.0),
                                                        child: TextField(
                                                          controller:
                                                              textController,
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyText2
                                                              ?.copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .fontColor
                                                                      .withOpacity(
                                                                          0.7)),
                                                          autofocus: true,
                                                          onChanged: (value) {},
                                                          decoration: InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              focusedBorder:
                                                                  InputBorder
                                                                      .none,
                                                              enabledBorder:
                                                                  InputBorder
                                                                      .none,
                                                              errorBorder:
                                                                  InputBorder
                                                                      .none,
                                                              disabledBorder:
                                                                  InputBorder
                                                                      .none),
                                                        )))
                                                : Container(),
                                          ]))),
                              onTap: () {
                                // setState(() {
                                // _folded = !_folded;
                                //});
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        Search()));
                              },
                            ))))
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: InkWell(
                      child: AnimatedContainer(
                          alignment: Alignment.center,
                          duration: Duration(milliseconds: 400),
                          height: 60,
                          width: deviceWidth! - 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Theme.of(context).colorScheme.lightColor,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 10.0,
                                  offset: const Offset(12.0, 15.0),
                                  color: colors.tempfontColor1.withOpacity(0.2),
                                  spreadRadius: -7),
                            ],
                          ),
                          child: Padding(
                              padding: EdgeInsetsDirectional.only(
                                  start: !_folded ? 20.0 : 0.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/search_icon.svg",
                                      height: 18,
                                      width: 18,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .fontColor,
                                    ),
                                    !_folded
                                        ? Expanded(
                                            child: Padding(
                                                padding:
                                                    EdgeInsetsDirectional.only(
                                                        start: 10.0),
                                                child: TextField(
                                                  controller: textController,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2
                                                      ?.copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .fontColor
                                                                  .withOpacity(
                                                                      0.7)),
                                                  autofocus: true,
                                                  onChanged: (value) {},
                                                  decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      errorBorder:
                                                          InputBorder.none,
                                                      disabledBorder:
                                                          InputBorder.none),
                                                )))
                                        : Container(),
                                  ]))),
                      onTap: () {
                        setState(() {
                          _folded = !_folded;
                        });
                      },
                    ))
          ],
        ));
  }
}
