import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:news_app/Helper/Color.dart';
import 'package:news_app/Helper/Constant.dart';
import 'package:news_app/Helper/Session.dart';
import 'package:news_app/Helper/String.dart';
import 'package:news_app/Model/Events.dart';
import 'package:news_app/RequestOtp.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/dom.dart' as dom;

class EventDetail extends StatefulWidget {
  EventsModel model;
  EventDetail({Key? key, required this.model}) : super(key: key);

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  bool _isNetworkAvail = true;
  bool isLoading = false;
  bool isFirst = false;
  @override
  void initState() {
    api();
    super.initState();
  }

  Future<void> api() async {
    setState(() {
      isLoading = true;
    });
    await _setViews();
    setState(() {
      isLoading = false;
    });
  }

  _setLikesDisLikesForEvents(String status) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      var param = {
        ACCESS_KEY: access_key,
        USER_ID: CUR_USERID,
        'events_id': widget.model.id,
        STATUS: status,
      };

      Response response = await post(
              Uri.parse(baseUrl + 'set_like_dislike_for_events'),
              body: param,
              headers: headers)
          .timeout(Duration(seconds: timeOut));

      var getdata = json.decode(response.body);

      String error = getdata["error"];

      String msg = getdata["message"];

      if (error == "false") {
        if (status == "1") {
          widget.model.like = "1";
          widget.model.like_count =
              (int.parse(widget.model.like_count!) + 1).toString();
          setSnackbar('Voted Succesfully');
        } else if (status == "0") {
          widget.model.like = "0";
          widget.model.like_count =
              (int.parse(widget.model.like_count!) - 1).toString();
          setSnackbar(getTranslated(context, 'dislike_succ')!);
        }
        // setState(() {
        //   isFirst = false;
        // });
      }
    } else {
      setSnackbar(getTranslated(context, 'internetmsg')!);
    }
  }

  @override
  Widget build(BuildContext context) {
    String placeHolder = "assets/images/placeholder.png";
    int _fontValue = 15;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            children: [
              FadeInImage.assetNetwork(
                fadeInDuration: Duration(milliseconds: 150),
                image: widget.model.image!,
                fit: BoxFit.fill,
                height: MediaQuery.of(context).size.height * 0.42,
                width: double.infinity,
                placeholder: placeHolder,
                imageErrorBuilder: (context, error, stackTrace) {
                  return errorWidget(deviceHeight! * 0.42, double.infinity);
                },
              ),
              backBtn(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.model.views! + ' views',
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle1
                            ?.copyWith(
                              color: Colors.red,
                            ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          widget.model.like_count! + ' Votes',
                          style: TextStyle(color: Colors.black),
                        ),
                        RaisedButton(
                          onPressed: () async {
                            if (CUR_USERID != "") {
                              if (_isNetworkAvail) {
                                if (!isFirst) {
                                  setState(() {
                                    isFirst = true;
                                  });
                                  if (widget.model.like == "1") {
                                    await _setLikesDisLikesForEvents(
                                      "0",
                                    );
                                    setState(() {});
                                  } else {
                                    await _setLikesDisLikesForEvents(
                                      "1",
                                    );
                                    setState(() {});
                                  }
                                }
                              } else {
                                setSnackbar(
                                    getTranslated(context, 'internetmsg')!);
                              }
                            } else {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => Login()),
                              // );
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          RequestOtp()));
                            }
                          },
                          color: Colors.green,
                          child: Text(
                            'Vote now',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                titleView(),
                descView(),
              ],
            ),
          )
        ],
      ),
    );
  }

  backBtn() {
    return Positioned.directional(
        textDirection: Directionality.of(context),
        top: 30.0,
        start: 10.0,
        child: InkWell(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    height: 35,
                    width: 35,
                    padding: EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: Colors.transparent.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: SvgPicture.asset(
                      "assets/images/back_icon.svg",
                      semanticsLabel: 'back icon',
                    ),
                  ))),
          onTap: () {
            Navigator.pop(context, true);
          },
        ));
  }

  titleView() {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 6.0, start: 8),
      child: Text(
        widget.model.title!,
        style: Theme.of(this.context).textTheme.subtitle1?.copyWith(
            color: Theme.of(context).colorScheme.fontColor,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  descView() {
    return Padding(
        padding: EdgeInsets.only(top: 5.0),
        child: Html(
          data: widget.model.desc,
          shrinkWrap: true,
          style: {
            // tables will have the below background color
            "div": Style(
              color: Theme.of(context).colorScheme.fontColor.withOpacity(0.8),
              fontSize: FontSize((15 - 3).toDouble()),
            ),
            "p": Style(
                color: Theme.of(context).colorScheme.fontColor,
                fontSize: FontSize(15.toDouble())),
            "b ": Style(
                color: Theme.of(context).colorScheme.fontColor,
                fontSize: FontSize(15.toDouble())),
          },
          onLinkTap: (String? url, RenderContext context,
              Map<String, String> attributes, dom.Element? element) async {
            if (await canLaunch(url!)) {
              await launch(
                url,
                forceSafariVC: false,
                forceWebView: false,
              );
            } else {
              throw 'Could not launch $url';
            }
          },
        ));
  }

  Future<void> _setViews() async {
    int v = int.parse(widget.model.views.toString());
    v = v + 1;
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      var param = {
        ACCESS_KEY: access_key,
        'event_id': widget.model.id,
        'views': v.toString(),
      };
      Response response = await post(Uri.parse(baseUrl + 'update_event_count'),
              body: param, headers: headers)
          .timeout(Duration(seconds: timeOut));

      var getdata = json.decode(response.body);
      // ignore: avoid_print
      print(getdata);

      String error = getdata["error"];

      String msg = getdata["message"];
      if (error == "false") {
        // setSnackbar(getTranslated(context, 'report_success')!);
        // var reportC;
        // reportC.text = "";
        setState(() {});
      } else {
        setSnackbar(msg);
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
}
