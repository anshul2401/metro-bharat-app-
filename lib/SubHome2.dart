// ignore_for_file: annotate_overrides, avoid_print, avoid_function_literals_in_foreach_calls, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, prefer_adjacent_string_concatenation, unnecessary_new, unnecessary_this, prefer_typing_uninitialized_variables, file_names

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:facebook_audience_network/ad/ad_native.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';

import 'package:news_app/Helper/FbAdHelper.dart';
import 'package:news_app/Helper/Color.dart';
import 'package:news_app/RequestOtp.dart';

import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';

import 'package:provider/provider.dart';

import 'Helper/Constant.dart';
import 'Helper/Session.dart';
import 'Helper/String.dart';

import 'Login.dart';
import 'Model/Category.dart';
import 'Model/News.dart';
import 'NewsDetails.dart';
import 'NewsTag.dart';

class SubHome2 extends StatefulWidget {
  SubHome2({
    this.scrollController,
    this.catList,
    this.curTabId,
    this.isSubCat,
    this.index,
    this.subCatId,
    this.channelName,
  });

  ScrollController? scrollController;

  List<Category>? catList;
  String? curTabId;
  bool? isSubCat;
  int? index;
  String? subCatId;
  String? channelName;

  SubHome2State createState() => new SubHome2State();
}

class SubHome2State extends State<SubHome2> {
  Key _key = new PageStorageKey({});
  bool _innerListIsScrolled = false;
  final GlobalKey<ScaffoldState> _scaffoldKey2 = GlobalKey<ScaffoldState>();
  bool _isNetworkAvail = true;
  bool enabled = true;

  List<News> tempList = [];
  List bookMarkValue = [];
  List<News> bookmarkList = [];
  List<News> newsList = [];
  double progress = 0;
  String fileSave = "";
  String otherImageSave = "";
  var isDarkTheme;
  List<News> tempNewsList = [];
  int offset = 0;
  int total = 0;
  int? from;
  String? curTabId;
  bool isFirst = false;
  bool _isLoading = true;
  bool _isLoadingMore = true;

  List<News> questionList = [];
  String? optId;
  int desiIndex = 3;
  int fbAdIndex = 5;
  List<News> queResultList = [];
  List<News> tempResult = [];
  bool isClickable = false;
  List<News> comList = [];
  bool isFrom = false;
  List<Map<String, String>> comments = [];

  void _updateScrollPosition() {
    if (!_innerListIsScrolled &&
        widget.scrollController!.position.extentAfter == 0.0) {
      setState(() {
        _innerListIsScrolled = true;
      });
    } else if (_innerListIsScrolled &&
        widget.scrollController!.position.extentAfter > 0.0) {
      setState(() {
        _innerListIsScrolled = false;
        // Reset scroll positions of the TabBarView pages
        _key = new PageStorageKey({});
      });
    }
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // Unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // Unique ID on Android
    }
  }

  @override
  void initState() {
    fbInit();
    getUserDetails();

    if (!widget.isSubCat!) {
      getNews();
    }

    callApi();
    super.initState();
  }

  callApi() async {
    await _getBookmark();
  }

  fbInit() async {
    String? deviceId = await _getId();

    FacebookAudienceNetwork.init(
        iOSAdvertiserTrackingEnabled: true, testingId: deviceId);
  }

  Future<void> getUserDetails() async {
    CUR_USERID = (await getPrefrence(ID)) ?? "";

    setState(() {});
  }

  @override
  void dispose() {
    widget.scrollController!.removeListener(_updateScrollPosition);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SubHome2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.subCatId != widget.subCatId) {
      updateData();
    }
  }

  updateData() async {
    _isLoading = true;
    newsList.clear();
    comList.clear();
    tempList.clear();
    _isLoadingMore = true;
    offset = 0;
    total = 0;
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey2,
      body: viewContent(),
    );
  }

  void loadMoreNews() {
    if (this.mounted) {
      setState(() {
        _isLoadingMore = true;
        if (offset < total) getNews();
      });
    }
  }

  viewContent() {
    return _isLoading
        ? contentShimmer(context)
        : newsList.length == 0
            ? Center(
                child: Text(getTranslated(context, 'no_news')!,
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .fontColor
                            .withOpacity(0.8))))
            : Padding(
                padding: EdgeInsetsDirectional.only(
                  top: 15.0,
                ),
                child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                        loadMoreNews();
                      }
                      return true;
                    },
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: (offset < total)
                          ? comList.length + 1
                          : comList.length,
                      itemBuilder: (context, index) {
                        return (index == comList.length && _isLoadingMore)
                            ? Center(child: CircularProgressIndicator())
                            : comList[index].type == "survey"
                                ? comList[index].from == 2
                                    ? showSurveyQueResult(index)
                                    : showSurveyQue(index)
                                : newsItem(index);
                      },
                    )));
  }

//set likes of news using api
  _setLikesDisLikes(String status, String id, int index) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      var param = {
        ACCESS_KEY: access_key,
        USER_ID: CUR_USERID,
        NEWS_ID: id,
        STATUS: status,
      };

      Response response = await post(Uri.parse(setLikesDislikesApi),
              body: param, headers: headers)
          .timeout(Duration(seconds: timeOut));

      var getdata = json.decode(response.body);

      String error = getdata["error"];

      String msg = getdata["message"];

      if (error == "false") {
        if (status == "1") {
          newsList[index].like = "1";
          newsList[index].totalLikes =
              (int.parse(newsList[index].totalLikes!) + 1).toString();
          setSnackbar(getTranslated(context, 'like_succ')!);
        } else if (status == "0") {
          newsList[index].like = "0";
          newsList[index].totalLikes =
              (int.parse(newsList[index].totalLikes!) - 1).toString();
          setSnackbar(getTranslated(context, 'dislike_succ')!);
        }
        setState(() {
          isFirst = false;
        });
      }
    } else {
      setSnackbar(getTranslated(context, 'internetmsg')!);
    }
  }

  updateHomePage() {
    setState(() {
      bookmarkList.clear();
      bookMarkValue.clear();
      _getBookmark();
    });
  }

//set bookmark of news using api
  _setBookmark(String status, String id) async {
    if (bookMarkValue.contains(id)) {
      setState(() {
        bookMarkValue = List.from(bookMarkValue)..remove(id);
      });
    } else {
      setState(() {
        bookMarkValue = List.from(bookMarkValue)..add(id);
      });
    }

    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      var param = {
        ACCESS_KEY: access_key,
        USER_ID: CUR_USERID,
        NEWS_ID: id,
        STATUS: status,
      };

      Response response =
          await post(Uri.parse(setBookmarkApi), body: param, headers: headers)
              .timeout(Duration(seconds: timeOut));

      var getdata = json.decode(response.body);

      String error = getdata["error"];

      String msg = getdata["message"];

      if (error == "false") {
        if (status == "0") {
          setSnackbar(msg);
        } else {
          setSnackbar(msg);
        }
      }
    } else {
      setSnackbar(getTranslated(context, 'internetmsg')!);
    }
  }

//show snackbar msg
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

//get bookmark news list id using api
  Future<void> _getBookmark() async {
    if (CUR_USERID != "") {
      _isNetworkAvail = await isNetworkAvailable();
      if (_isNetworkAvail) {
        try {
          var param = {
            ACCESS_KEY: access_key,
            USER_ID: CUR_USERID,
          };
          Response response = await post(Uri.parse(getBookmarkApi),
                  body: param, headers: headers)
              .timeout(Duration(seconds: timeOut));

          var getdata = json.decode(response.body);

          String error = getdata["error"];
          if (error == "false") {
            bookmarkList.clear();
            var data = getdata["data"];

            bookmarkList =
                (data as List).map((data) => new News.fromJson(data)).toList();
            bookMarkValue.clear();

            for (int i = 0; i < bookmarkList.length; i++) {
              bookMarkValue.add(bookmarkList[i].newsId);
            }
          }
        } on TimeoutException catch (_) {
          setSnackbar(getTranslated(context, 'somethingMSg')!);
        }
      } else {
        setSnackbar(getTranslated(context, 'internetmsg')!);
      }
    }
  }

  // Future<void> _getComment() async {
  //   if (widget.isDetails!) {
  //     if (comments_mode == "1") {
  //       _isNetworkAvail = await isNetworkAvailable();
  //       if (_isNetworkAvail) {
  //         try {
  //           var param = {
  //             ACCESS_KEY: access_key,
  //             NEWS_ID: widget.model!.id,
  //             LIMIT: perPage.toString(),
  //             OFFSET: offset.toString(),
  //             USER_ID: CUR_USERID != null && CUR_USERID != "" ? CUR_USERID : "0"
  //           };
  //           Response response = await post(Uri.parse(getCommnetByNewsApi),
  //                   body: param, headers: headers)
  //               .timeout(Duration(seconds: timeOut));

  //           var getdata = json.decode(response.body);

  //           comTotal = getdata["total"];

  //           String error = getdata["error"];
  //           if (error == "false") {
  //             total = int.parse(getdata["total"]);

  //             if ((offset) < total) {
  //               var data = getdata["data"];
  //               commentList = (data as List)
  //                   .map((data) => new Comment.fromJson(data))
  //                   .toList();

  //               offset = offset + perPage;
  //             }

  //             if (mounted)
  //               setState(() {
  //                 _isLoading = false;
  //               });
  //           }
  //         } on TimeoutException catch (_) {
  //           setSnackbar(getTranslated(context, 'somethingMSg')!);
  //           setState(() {
  //             _isLoading = false;
  //           });
  //         }
  //       } else {
  //         setSnackbar(getTranslated(context, 'internetmsg')!);
  //       }
  //     }
  //   }
  // }

//get latest news data list
  Future<void> getNews() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        var param = {
          ACCESS_KEY: access_key,
          LIMIT: perPage.toString(),
          OFFSET: offset.toString(),
          USER_ID: CUR_USERID != "" ? CUR_USERID : "0",
        };

        if (widget.catList![widget.index!].subData!.length != 0) {
          if (widget.subCatId == "0") {
            param[CATEGORY_ID] = widget.curTabId!;
          } else {
            param[SUBCAT_ID] = widget.subCatId!;
          }
        } else {
          param[CATEGORY_ID] = widget.curTabId!;
        }

        Response response = await post(Uri.parse(getNewsByCatApi),
                body: param, headers: headers)
            .timeout(Duration(seconds: timeOut));
        if (response.statusCode == 200) {
          var getData = json.decode(response.body);

          print(getData['data'][0]);
          print(getData['data'][0]['counter'].toString());

          String error = getData["error"];
          if (error == "false") {
            total = int.parse(getData["total"]);
            if ((offset) < total) {
              tempList.clear();
              var data = getData["data"];
              tempList = (data as List)
                  .map((data) => new News.fromJson(data))
                  .toList();

              tempList.forEach((element) {
                element.channel_name == widget.channelName
                    ? newsList.add(element)
                    : null;
              });
              // newsList.forEach((element) async {
              //   var param = {
              //     ACCESS_KEY: access_key,
              //     NEWS_ID: element.id,
              //     LIMIT: perPage.toString(),
              //     OFFSET: offset.toString(),
              //     USER_ID:
              //         CUR_USERID != null && CUR_USERID != "" ? CUR_USERID : "0"
              //   };
              //   Response response = await post(Uri.parse(getCommnetByNewsApi),
              //           body: param, headers: headers)
              //       .timeout(Duration(seconds: timeOut));

              //   var getdata = json.decode(response.body);

              //   var comTotal = getdata["total"];

              //   String error = getdata["error"];
              //   if (error == "false") {
              //     total = int.parse(getdata["total"]);

              //     if ((offset) < total) {
              //       var data = getdata["data"];
              //       comments.add({
              //         'id': element.id ?? '0',
              //         'total_com': (data as List).length.toString()
              //       });

              //       // offset = offset + perPage;
              //     }
              //   }
              // });
              // print('hell');
              // print(comments);
              offset = offset + perPage;

              await getQuestion();
            }
          } else {
            if (this.mounted)
              setState(() {
                _isLoadingMore = false;
                _isLoading = false;
              });
          }
        }
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, 'somethingMSg')!);
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    } else {
      setSnackbar(getTranslated(context, 'internetmsg')!);
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  //get all category using api
  Future<void> getQuestion() async {
    if (CUR_USERID != "") {
      _isNetworkAvail = await isNetworkAvailable();
      if (_isNetworkAvail) {
        try {
          var param = {ACCESS_KEY: access_key, USER_ID: CUR_USERID};

          Response response =
              await post(Uri.parse(getQueApi), body: param, headers: headers)
                  .timeout(Duration(seconds: timeOut));
          var getData = json.decode(response.body);

          String error = getData["error"];

          if (error == "false") {
            questionList.clear();
            var data = getData["data"];
            questionList = (data as List)
                .map((data) => new News.fromSurvey(data))
                .toList();
            combineList();

            if (this.mounted)
              setState(() {
                _isLoading = false;
              });
          } else {
            combineList();
            if (this.mounted)
              setState(() {
                _isLoading = false;
              });
          }
        } on TimeoutException catch (_) {
          setSnackbar(getTranslated(context, 'somethingMSg')!);
        }
      } else {
        setSnackbar(getTranslated(context, 'internetmsg')!);
      }
    } else {
      combineList();
      if (this.mounted)
        setState(() {
          _isLoading = false;
        });
    }
  }

  combineList() {
    comList.clear();
    int cur = 0;
    for (int i = 0; i < newsList.length; i++) {
      if (i != 0 && i % desiIndex == 0) {
        if (questionList.length != 0 && questionList.length > cur) {
          comList.add(questionList[cur]);

          cur++;
        }
      }

      comList.add(newsList[i]);
    }
  }

  _setQueResult(String queId, String optId, int index) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      var param = {
        ACCESS_KEY: access_key,
        USER_ID: CUR_USERID,
        QUESTION_ID: queId,
        OPTION_ID: optId
      };

      Response response =
          await post(Uri.parse(setQueResultApi), body: param, headers: headers)
              .timeout(Duration(seconds: timeOut));

      var getData = json.decode(response.body);

      String error = getData["error"];

      if (error == "false") {
        setSnackbar(getTranslated(context, 'survey_sub_succ')!);
        setState(() {
          questionList.removeWhere((item) => item.id == queId);
          _getQueResult(queId, index);
        });
      }
    } else {
      setSnackbar(getTranslated(context, 'internetmsg')!);
    }
  }

  //get Question result list using api
  Future<void> _getQueResult(String queId, int index) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        var param = {ACCESS_KEY: access_key, USER_ID: CUR_USERID};

        Response response = await post(Uri.parse(getQueResultApi),
                body: param, headers: headers)
            .timeout(Duration(seconds: timeOut));

        var getdata = json.decode(response.body);

        String error = getdata["error"];
        if (error == "false") {
          total = int.parse(getdata["total"]);
          tempResult.clear();
          //queResultList.clear();
          var data = getdata["data"];
          tempResult =
              (data as List).map((data) => new News.fromSurvey(data)).toList();
          // queResultList = tempResult.where((item) => item.id == queId).toList();
          queResultList.addAll(tempResult);

          News model = queResultList.where((item) => item.id == queId).first;
          model.from = 2;

          setState(() {
            comList[index] = model;
          });
        }
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, 'somethingMSg')!);
      }
    } else {
      setSnackbar(getTranslated(context, 'internetmsg')!);
    }
  }

  showSurveyQue(int i) {
    return Padding(
        padding: EdgeInsets.only(top: 15.0),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Theme.of(context).colorScheme.lightColor,
            ),
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(
                  comList[i].question!,
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Theme.of(context).colorScheme.darkColor,
                      height: 1.0),
                ),
                Padding(
                    padding: EdgeInsetsDirectional.only(
                        top: 15.0, start: 7.0, end: 7.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        //padding: EdgeInsets.only(bottom: 10.0),
                        itemCount: comList[i].optionDataList!.length,
                        itemBuilder: (context, j) {
                          return Padding(
                              padding: EdgeInsets.only(bottom: 10.0),
                              child: InkWell(
                                child: Container(
                                    height: 50,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: optId ==
                                                comList[i].optionDataList![j].id
                                            ? colors.primary.withOpacity(0.1)
                                            : isDark!
                                                ? colors.tempdarkColor
                                                : colors.bgColor),
                                    child: Text(
                                      comList[i].optionDataList![j].options!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          ?.copyWith(
                                              color: optId ==
                                                      comList[i]
                                                          .optionDataList![j]
                                                          .id
                                                  ? colors.primary
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .darkColor,
                                              height: 1.0),
                                      textAlign: TextAlign.center,
                                    )),
                                onTap: () {
                                  setState(() {
                                    optId = comList[i].optionDataList![j].id;
                                  });
                                },
                              ));
                        })),
                Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: InkWell(
                    child: Container(
                      height: 40.0,
                      width: deviceWidth! * 0.35,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: colors.tempboxColor,
                          borderRadius: BorderRadius.circular(7.0)),
                      child: Text(
                        getTranslated(context, 'submit_btn')!,
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle1
                            ?.copyWith(
                                color: colors.primary,
                                fontWeight: FontWeight.w600,
                                //fontSize: 21,
                                letterSpacing: 0.6),
                      ),
                    ),
                    onTap: () async {
                      if (optId != null && optId != "") {
                        _setQueResult(comList[i].id!, optId!, i);
                      } else {
                        setSnackbar(getTranslated(context, 'opt_sel')!);
                      }
                    },
                  ),
                )
              ],
            )));
  }

  showSurveyQueResult(int i) {
    return Padding(
        padding: EdgeInsets.only(top: 15.0),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Theme.of(context).colorScheme.lightColor,
            ),
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(
                  comList[i].question!,
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Theme.of(context).colorScheme.darkColor,
                      height: 1.0),
                ),
                Padding(
                    padding: EdgeInsetsDirectional.only(
                        top: 15.0, start: 7.0, end: 7.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        //padding: EdgeInsets.only(bottom: 10.0),
                        itemCount: comList[i].optionDataList!.length,
                        itemBuilder: (context, j) {
                          return Padding(
                            padding: EdgeInsetsDirectional.only(
                                bottom: 10.0, start: 15.0, end: 15.0),
                            child: LinearPercentIndicator(
                              animation: true,
                              animationDuration: 1000,
                              lineHeight: 40.0,
                              percent: double.parse(comList[i]
                                      .optionDataList![j]
                                      .percentage!) /
                                  100,
                              center: Text(
                                comList[i].optionDataList![j].percentage! + "%",
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                              linearStrokeCap: LinearStrokeCap.roundAll,
                              progressColor: colors.primary,
                              isRTL: false,
                              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            ),
                          );
                        })),
              ],
            )));
  }

  newsItem(int index) {
    List<String> tagList = [];
    DateTime time1 = DateTime.parse(comList[index].date!);
    if (comList[index].tagName! != "") {
      final tagName = comList[index].tagName!;
      tagList = tagName.split(',');
    }

    List<String> tagId = [];

    if (comList[index].tagId! != "") {
      tagId = comList[index].tagId!.split(",");
    }
    return Padding(
        padding: EdgeInsetsDirectional.only(top: index == 0 ? 0 : 15.0),
        child: Column(children: [
          fbNativeUnitId != "" &&
                  iosFbNativeUnitId != "" &&
                  index != 0 &&
                  index % fbAdIndex == 0
              ? _isNetworkAvail
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 15.0),
                      child: Container(
                          padding: EdgeInsets.all(7.0),
                          height: 320,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.boxColor,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: FacebookNativeAd(
                            backgroundColor:
                                Theme.of(context).colorScheme.boxColor,
                            placementId: FbAdHelper.nativeAdUnitId,
                            adType: Platform.isAndroid
                                ? NativeAdType.NATIVE_AD
                                : NativeAdType.NATIVE_AD_VERTICAL,
                            width: double.infinity,
                            height: 320,
                            keepAlive: true,
                            keepExpandedWhileLoading: false,
                            expandAnimationDuraion: 300,
                            listener: (result, value) {
                              print("Native Ad: $result --> $value");
                            },
                          )))
                  : Container()
              : Container(),
          AbsorbPointer(
            absorbing: !enabled,
            child: InkWell(
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: FadeInImage.assetNetwork(
                        image: comList[index].image!,
                        height: MediaQuery.of(context).size.width * (9 / 16),
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: placeHolder,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return errorWidget(320, double.infinity);
                        },
                      )),
                  comList[index].contentType == "video_upload" ||
                          comList[index].contentType == "video_youtube" ||
                          comList[index].contentType == "video_other"
                      ? Positioned.directional(
                          top: MediaQuery.of(context).size.height / 20,
                          end: MediaQuery.of(context).size.width / 2.3,
                          textDirection: Directionality.of(context),
                          child: InkWell(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white,
                                  ),
                                  child: Icon(
                                    Icons.play_arrow,
                                    color: Colors.grey,
                                    size: 35,
                                  ),
                                )),
                            onTap: () {},
                          ))
                      : Container(),
                  Positioned.directional(
                      textDirection: Directionality.of(context),
                      bottom: 0.0,
                      start: 0,
                      end: 0,
                      height: 100,
                      child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  color: colors.tempboxColor.withOpacity(0.85),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      convertToAgo(time1, 0)!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          ?.copyWith(
                                              color: colors.tempfontColor1,
                                              fontSize: 13.0),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(top: 6.0),
                                        child: Text(
                                          comList[index].title!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              ?.copyWith(
                                                  color: colors.darkColor1,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15,
                                                  height: 1.2),
                                          maxLines: 3,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(top: 6.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            comList[index].tagName! != ""
                                                ? SizedBox(
                                                    height: 23.0,
                                                    child: ListView.builder(
                                                        physics:
                                                            ClampingScrollPhysics(),
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            tagList.length >= 3
                                                                ? 3
                                                                : tagList
                                                                    .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Padding(
                                                              padding: EdgeInsetsDirectional
                                                                  .only(
                                                                      start: index ==
                                                                              0
                                                                          ? 0
                                                                          : 4),
                                                              child: InkWell(
                                                                child:
                                                                    Container(
                                                                        height:
                                                                            23.0,
                                                                        width:
                                                                            65,
                                                                        alignment:
                                                                            Alignment
                                                                                .center,
                                                                        padding: EdgeInsetsDirectional.only(
                                                                            start:
                                                                                3.0,
                                                                            end:
                                                                                3.0,
                                                                            top:
                                                                                2.5,
                                                                            bottom:
                                                                                2.5),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(3.0),
                                                                          color: colors
                                                                              .primary
                                                                              .withOpacity(0.08),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          tagList[
                                                                              index],
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .bodyText2
                                                                              ?.copyWith(
                                                                                color: colors.primary,
                                                                                fontSize: 12,
                                                                              ),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          softWrap:
                                                                              true,
                                                                        )),
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                NewsTag(
                                                                          tadId:
                                                                              tagId[index],
                                                                          tagName:
                                                                              tagList[index],
                                                                          updateParent:
                                                                              updateHomePage,
                                                                        ),
                                                                      ));
                                                                },
                                                              ));
                                                        }))
                                                : Container(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: Text(
                                                    '2 Min' + ' Read',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: Text(
                                                    comList[index].totalLikes ==
                                                            null
                                                        ? '0 Likes'
                                                        : comList[index]
                                                                .totalLikes! +
                                                            ' Likes',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: Text(
                                                    comList[index].counter ==
                                                            null
                                                        ? '0 views'
                                                        : comList[index]
                                                                .counter! +
                                                            ' Views',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Text(
                                                comList[index].total_comment ==
                                                        null
                                                    ? '0 comments'
                                                    : comList[index]
                                                            .total_comment! +
                                                        ' Comments',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            // Text(
                                            //   comList[index].question == null
                                            //       ? '0 Comments'
                                            //       : comList[index].question! +
                                            //           ' Comment',
                                            //   style: TextStyle(
                                            //       fontSize: 12,
                                            //       fontWeight: FontWeight.bold),
                                            // ),

                                            // Spacer(),
                                            // InkWell(
                                            //   child: SvgPicture.asset(
                                            //     bookMarkValue.contains(
                                            //             comList[index].id)
                                            //         ? "assets/images/bookmarkfilled_icon.svg"
                                            //         : "assets/images/bookmark_icon.svg",
                                            //     semanticsLabel: 'bookmark icon',
                                            //     height: 19,
                                            //     width: 19,
                                            //   ),
                                            //   onTap: () async {
                                            //     _isNetworkAvail =
                                            //         await isNetworkAvailable();
                                            //     if (CUR_USERID != "") {
                                            //       if (_isNetworkAvail) {
                                            //         setState(() {
                                            //           bookMarkValue.contains(
                                            //                   comList[index]
                                            //                       .id!)
                                            //               ? _setBookmark(
                                            //                   "0",
                                            //                   comList[index]
                                            //                       .id!)
                                            //               : _setBookmark(
                                            //                   "1",
                                            //                   comList[index]
                                            //                       .id!);
                                            //         });
                                            //       } else {
                                            //         setSnackbar(getTranslated(
                                            //             context,
                                            //             'internetmsg')!);
                                            //       }
                                            //     } else {
                                            //       Navigator.push(
                                            //           context,
                                            //           MaterialPageRoute(
                                            //             builder: (context) =>
                                            //                 Login(),
                                            //           ));
                                            //       // Navigator.push(
                                            //       //     context,
                                            //       //     MaterialPageRoute(
                                            //       //         builder: (BuildContext
                                            //       //                 context) =>
                                            //       //             RequestOtp()));
                                            //     }
                                            //   },
                                            // ),
                                            // Padding(
                                            //   padding:
                                            //       EdgeInsetsDirectional.only(
                                            //           start: 13.0),
                                            //   child: InkWell(
                                            //     child: SvgPicture.asset(
                                            //       "assets/images/share_icon.svg",
                                            //       semanticsLabel: 'share icon',
                                            //       height: 19,
                                            //       width: 19,
                                            //     ),
                                            //     onTap: () async {
                                            //       _isNetworkAvail =
                                            //           await isNetworkAvailable();
                                            //       if (_isNetworkAvail) {
                                            //         createDynamicLink(
                                            //             comList[index].id!,
                                            //             index,
                                            //             comList[index].title!);
                                            //       } else {
                                            //         setSnackbar(getTranslated(
                                            //             context,
                                            //             'internetmsg')!);
                                            //       }
                                            //     },
                                            //   ),
                                            // )
                                          ],
                                        ))
                                  ],
                                ),
                              )))),
                  Positioned.directional(
                    textDirection: Directionality.of(context),
                    bottom: (320 - 113) / 2.6,
                    start: deviceWidth! * 0.60,
                    child: Row(
                      children: [
                        InkWell(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(55.0),
                              child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    // padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: colors.tempboxColor
                                            .withOpacity(0.5),
                                        shape: BoxShape.circle),
                                    child: Image.asset(
                                      comList[index].like == "1"
                                          ? "assets/images/s_like_filled.png"
                                          : "assets/images/s_like_unfilled.png",
                                      // color: Colors.red,
                                      // semanticsLabel: 'like icon',
                                    ),
                                  ))),
                          onTap: () async {
                            _isNetworkAvail = await isNetworkAvailable();

                            if (CUR_USERID != "") {
                              if (_isNetworkAvail) {
                                if (!isFirst) {
                                  setState(() {
                                    isFirst = true;
                                  });
                                  if (comList[index].like == "1") {
                                    _setLikesDisLikes(
                                        "0", comList[index].id!, index);

                                    setState(() {});
                                  } else {
                                    _setLikesDisLikes(
                                        "1", comList[index].id!, index);

                                    setState(() {});
                                  }
                                }
                              } else {
                                setSnackbar(
                                    getTranslated(context, 'internetmsg')!);
                              }
                            } else {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => Login(),
                              //     ));
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          RequestOtp()));
                            }
                          },
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(start: 5.0),
                          child: InkWell(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(55.0),
                                child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                          color: colors.tempboxColor
                                              .withOpacity(0.5),
                                          shape: BoxShape.circle),
                                      child: Image.asset(
                                        bookMarkValue
                                                .contains(comList[index].id)
                                            ? "assets/images/s_save.png"
                                            : "assets/images/s_save_unfilled.png",
                                        height: 19,
                                        width: 19,
                                      ),
                                    ))),
                            onTap: () async {
                              _isNetworkAvail = await isNetworkAvailable();
                              if (CUR_USERID != "") {
                                if (_isNetworkAvail) {
                                  setState(() {
                                    bookMarkValue.contains(comList[index].id!)
                                        ? _setBookmark("0", comList[index].id!)
                                        : _setBookmark("1", comList[index].id!);
                                  });
                                } else {
                                  setSnackbar(
                                      getTranslated(context, 'internetmsg')!);
                                }
                              } else {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) => Login(),
                                //     ));
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            RequestOtp()));
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(start: 5.0),
                          child: InkWell(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(55.0),
                                child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      height: 35,
                                      width: 35,
                                      // padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: colors.tempboxColor
                                              .withOpacity(0.5),
                                          shape: BoxShape.circle),
                                      child: Image.asset(
                                        "assets/images/s_share.png",
                                        height: 19,
                                        width: 19,
                                      ),
                                    ))),
                            onTap: () async {
                              _isNetworkAvail = await isNetworkAvailable();
                              if (_isNetworkAvail) {
                                createDynamicLink(comList[index].id!, index,
                                    comList[index].title!);
                              } else {
                                setSnackbar(
                                    getTranslated(context, 'internetmsg')!);
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  enabled = false;
                });

                News model = comList[index];
                List<News> recList = [];
                recList.addAll(newsList);
                recList
                    .removeWhere((element) => element.id == comList[index].id);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => NewsDetails(
                          model: model,
                          index: index,
                          updateParent: updateHomePage,
                          id: model.id,
                          isFav: false,
                          isDetails: true,
                          news: recList,
                        )));
                setState(() {
                  enabled = true;
                });
              },
            ),
          )
        ]));
  }
}
