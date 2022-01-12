import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart' as intl;
import 'package:news_app/Helper/Constant.dart';
import 'package:news_app/Helper/Session.dart';
import 'package:news_app/Helper/Color.dart';
import 'package:news_app/ListItemNotification.dart';
import 'package:news_app/Model/Notification.dart';
import 'package:shimmer/shimmer.dart';
import 'Helper/String.dart';
import 'Model/News.dart';
import 'NewsDetails.dart';

class NotificationList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StateNoti();
}

class StateNoti extends State<NotificationList> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController controller = new ScrollController();
  ScrollController controller1 = new ScrollController();

  List<NotificationModel> tempList = [];
  bool _isNetworkAvail = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey1 =
      new GlobalKey<RefreshIndicatorState>();
  TabController? _tc;
  List<NotificationModel> notiList = [];
  int offset = 0;
  int total = 0;
  int perOffset = 0;
  int perTotal = 0;
  bool isLoadingmore = true;
  bool _isLoading = true;
  bool isPerLoadingmore = true;
  bool _isPerLoading = true;
  List<NotificationModel> tempUserList = [];
  List<NotificationModel> userNoti = [];
  List<String> _tabs = [];
  List<String> selectedList = [];

  @override
  void initState() {
    getUserNotification();
    getNotification();
    controller.addListener(_scrollListener);
    controller1.addListener(_scrollListener1);
    new Future.delayed(Duration.zero, () {
      _tabs = [
        getTranslated(context, 'personal_lbl')!,
        getTranslated(context, 'news_lbl')!
      ];
    });
    _tc = TabController(length: 2, vsync: this, initialIndex: 0);
    _tc!.addListener(_handleTabControllerTick);

    super.initState();
  }

  void _handleTabControllerTick() {
    setState(() {
      selectedList.clear();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    controller1.dispose();
    super.dispose();
  }

  Widget tabShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.6),
      highlightColor: Colors.grey,
      child: Padding(
          padding: EdgeInsetsDirectional.only(start: 20.0, top: 20.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              width: 70,
              height: 15.0,
              color: Colors.grey,
            ),
            // Spacer(),
            Padding(
                padding: EdgeInsetsDirectional.only(start: 40.0),
                child: Container(
                  width: 70,
                  height: 15.0,
                  color: Colors.grey,
                )),
          ])),
    );
  }

  //refresh function used in refresh notification
  Future<void> _refresh() async {
    if (_tc!.index == 0) {
      setState(() {
        _isPerLoading = true;
      });
      perOffset = 0;
      perTotal = 0;
      userNoti.clear();
      getUserNotification();
    } else {
      setState(() {
        _isLoading = true;
      });
      offset = 0;
      total = 0;
      notiList.clear();
      getNotification();
    }
  }

  setAppBar() {
    return PreferredSize(
        preferredSize: Size(double.infinity, 72),
        child: Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: Column(children: [
              Text(
                getTranslated(context, 'notification_lbl')!,
                style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5),
              ),
              _tabs.length != 0
                  ? DefaultTabController(
                      length: 2,
                      child: Row(children: [
                        Container(
                            padding: EdgeInsetsDirectional.only(
                                start: 10.0, top: 15.0),
                            width: deviceWidth! / 1.8,
                            height: 35.0,
                            child: TabBar(
                              controller: _tc,
                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5),
                              labelPadding: EdgeInsets.zero,
                              labelColor: colors.primary,
                              unselectedLabelColor: Theme.of(context)
                                  .colorScheme
                                  .fontColor
                                  .withOpacity(0.7),
                              indicatorColor: colors.primary,
                              //indicatorSize: TabBarIndicatorSize.tab,
                              indicator: UnderlineTabIndicator(
                                  borderSide: BorderSide(
                                      width: 3.0, color: colors.primary),
                                  insets:
                                      EdgeInsets.symmetric(horizontal: 10.0)),
                              tabs: _tabs.map((e) => Tab(text: e)).toList(),
                            )),
                      ]))
                  : tabShimmer(),
              Padding(
                  padding: EdgeInsetsDirectional.only(
                      end: 15.0, start: 15.0, top: 1.0),
                  child: Divider(
                    thickness: 1.5,
                    height: 1.0,
                    color: Theme.of(context)
                        .colorScheme
                        .fontColor
                        .withOpacity(0.3),
                  ))
            ])));
  }

  deleteNoti(String id) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      var param = {ACCESS_KEY: access_key, ID: id};
      Response response = await post(Uri.parse(deleteUserNotiApi),
              body: param, headers: headers)
          .timeout(Duration(seconds: timeOut));

      var getdata = json.decode(response.body);
      String error = getdata["error"];

      String msg = getdata["message"];
      if (error == "false") {
        setState(() {
          for (int i = 0; i < selectedList.length; i++) {
            userNoti.removeWhere((item) => item.id == selectedList[i]);
          }
        });
        selectedList.clear();
        setSnackbar(getTranslated(context, 'delete_noti')!);
      } else {
        setSnackbar(msg);
      }
    } else {
      setSnackbar(getTranslated(context, 'internetmsg')!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: setAppBar(),
        body: TabBarView(controller: _tc, children: [
          _isPerLoading
              ? shimmer1(context)
              : userNoti.length == 0
                  ? Padding(
                      padding: const EdgeInsetsDirectional.only(
                          bottom: kToolbarHeight),
                      child: Center(
                          child:
                              Text(getTranslated(context, 'noti_nt_avail')!)))
                  : RefreshIndicator(
                      key: _refreshIndicatorKey1,
                      onRefresh: _refresh,
                      child: Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: 15.0, end: 15.0, bottom: 10.0),
                          child: Column(children: <Widget>[
                            selectedList.length > 0
                                ? Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        deleteNoti(selectedList.join(','));
                                      },
                                    ),
                                  )
                                : Container(),
                            Expanded(
                                child: ListView.builder(
                              controller: controller1,
                              itemCount: userNoti.length,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return (index == userNoti.length &&
                                        isPerLoadingmore)
                                    ? Center(child: CircularProgressIndicator())
                                    : ListItemNoti(
                                        userNoti: userNoti[index],
                                        isSelected: (bool value) {
                                          setState(() {
                                            if (value) {
                                              selectedList
                                                  .add(userNoti[index].id!);
                                            } else {
                                              selectedList
                                                  .remove(userNoti[index].id!);
                                            }
                                          });
                                        },
                                        key:
                                            Key(userNoti[index].id.toString()));
                              },
                            ))
                          ]))),
          _isLoading
              ? shimmer(context)
              : notiList.length == 0
                  ? Padding(
                      padding:
                          const EdgeInsetsDirectional.only(top: kToolbarHeight),
                      child: Center(
                          child:
                              Text(getTranslated(context, 'noti_nt_avail')!)))
                  : RefreshIndicator(
                      key: _refreshIndicatorKey,
                      onRefresh: _refresh,
                      child: Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: 15.0, end: 15.0, top: 10.0, bottom: 10.0),
                          child: ListView.builder(
                            controller: controller,
                            itemCount: notiList.length,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return (index == notiList.length && isLoadingmore)
                                  ? Center(child: CircularProgressIndicator())
                                  : listItem(index);
                            },
                          )))
        ]));
  }

  //shimmer effects
  Widget shimmer(BuildContext context) {
    var isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.only(
          start: 15.0, end: 15.0, top: 20.0, bottom: 10.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(0.6),
        highlightColor: Colors.grey,
        child: SingleChildScrollView(
          child: Column(
            children: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
                .map((_) => Padding(
                    padding: EdgeInsetsDirectional.only(
                      top: 5.0,
                      bottom: 10.0,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withOpacity(0.6),
                      ),
                      child: Row(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.grey,
                            ),
                            width: 80.0,
                            height: 80.0,
                          ),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsetsDirectional.only(
                                start: 13.0, end: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 13.0,
                                  color: Colors.grey,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 3.0),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 13.0,
                                  color: Colors.grey,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                ),
                                Container(
                                  width: 100,
                                  height: 10.0,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ))
                        ],
                      ),
                    )))
                .toList(),
          ),
        ),
      ),
    );
  }

  //shimmer effects
  Widget shimmer1(BuildContext context) {
    var isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.only(
          start: 15.0, end: 15.0, top: 20.0, bottom: 10.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(0.6),
        highlightColor: Colors.grey,
        child: SingleChildScrollView(
          child: Column(
            children: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
                .map((_) => Padding(
                    padding: EdgeInsetsDirectional.only(
                      top: 5.0,
                      bottom: 10.0,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withOpacity(0.6),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsetsDirectional.only(start: 5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.grey,
                                ),
                                width: 25.0,
                                height: 25.0,
                              )),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsetsDirectional.only(
                                start: 13.0, end: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 13.0,
                                  color: Colors.grey,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 3.0),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 13.0,
                                  color: Colors.grey,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                ),
                                Container(
                                  width: 100,
                                  height: 10.0,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ))
                        ],
                      ),
                    )))
                .toList(),
          ),
        ),
      ),
    );
  }

  //list of notification shown
  Widget listItem(int index) {
    NotificationModel model = notiList[index];

    DateTime time1 = DateTime.parse(model.date_sent!);

    return Hero(
        tag: model.id!,
        child: Padding(
            padding: EdgeInsetsDirectional.only(
              top: 5.0,
              bottom: 10.0,
            ),
            child: InkWell(
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.boxColor,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          blurRadius: 10.0,
                          offset: const Offset(5.0, 5.0),
                          color: Theme.of(context)
                              .colorScheme
                              .fontColor
                              .withOpacity(0.1),
                          spreadRadius: 1.0),
                    ],
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      model.image != null && model.image != ''
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: model.image! != ""
                                  ? FadeInImage.assetNetwork(
                                      fadeInDuration:
                                          Duration(milliseconds: 150),
                                      image: model.image!,
                                      height: 80.0,
                                      width: 80,
                                      fit: BoxFit.cover,
                                      placeholder: placeHolder,
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        return errorWidget(80, 80);
                                      },
                                    )
                                  : Image.asset(
                                      "assets/images/read.png",
                                      height: 80.0,
                                      fit: BoxFit.cover,
                                    ),
                            )
                          : Container(
                              height: 0,
                            ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsetsDirectional.only(
                            start: 13.0, end: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(model.title!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .fontColor
                                            .withOpacity(0.9),
                                        fontSize: 15.0,
                                        letterSpacing: 0.1)),
                            Padding(
                                padding:
                                    const EdgeInsetsDirectional.only(top: 8.0),
                                child: Text(convertToAgo(time1, 2)!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        ?.copyWith(
                                            fontWeight: FontWeight.normal,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .fontColor
                                                .withOpacity(0.7),
                                            fontSize: 11)))
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ),
              onTap: () {
                NotificationModel model = notiList[index];
                if (model.newsId != "") {
                  getNewsById(model.newsId!);
                }
              },
            )));
  }

  updateParent() {
    //setState(() {});
  }

  //when open dynamic link news index and id can used for fetch specific news
  Future<void> getNewsById(String id) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      var param = {
        NEWS_ID: id,
        ACCESS_KEY: access_key,
        USER_ID: CUR_USERID != null && CUR_USERID != "" ? CUR_USERID : "0"
      };
      Response response =
          await post(Uri.parse(getNewsByIdApi), body: param, headers: headers)
              .timeout(Duration(seconds: timeOut));
      var getdata = json.decode(response.body);

      String error = getdata["error"];

      if (error == "false") {
        var data = getdata["data"];
        List<News> news = [];
        news = (data as List).map((data) => new News.fromJson(data)).toList();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => NewsDetails(
                  model: news[0],
                  index: int.parse(id),
                  updateParent: updateParent,
                  id: news[0].id,
                  isFav: false,
                  isDetails: true,
                  news: [],
                )));
      }
    } else {
      setSnackbar(getTranslated(context, 'internetmsg')!);
    }
  }

  //get notification using api
  Future<void> getNotification() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        var parameter = {
          LIMIT: perPage.toString(),
          OFFSET: offset.toString(),
          ACCESS_KEY: access_key,
        };
        Response response = await post(Uri.parse(getNotificationApi),
                headers: headers, body: parameter)
            .timeout(Duration(seconds: timeOut));
        if (response.statusCode == 200) {
          var getData = json.decode(response.body);
          String error = getData["error"];
          if (error == "false") {
            total = int.parse(getData["total"]);
            if ((offset) < total) {
              tempList.clear();
              notiList.clear();
              var data = getData["data"];
              tempList = (data as List)
                  .map((data) => new NotificationModel.fromJson(data))
                  .toList();

              notiList.addAll(tempList);
              offset = offset + perPage;
            }
          } else {
            isLoadingmore = false;
          }
          if (mounted)
            setState(() {
              _isLoading = false;
            });
        }
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, 'somethingMSg')!);
        setState(() {
          _isLoading = false;
          isLoadingmore = false;
        });
      }
    } else {
      setSnackbar(getTranslated(context, 'internetmsg')!);
      setState(() {
        _isLoading = false;
        isLoadingmore = false;
      });
    }
  }

  //get notification using api
  Future<void> getUserNotification() async {
    if (CUR_USERID != null && CUR_USERID != "") {
      _isNetworkAvail = await isNetworkAvailable();
      if (_isNetworkAvail) {
        try {
          var parameter = {
            LIMIT: perPage.toString(),
            OFFSET: perOffset.toString(),
            ACCESS_KEY: access_key,
            USER_ID: CUR_USERID
          };

          Response response = await post(Uri.parse(getUserNotificationApi),
                  headers: headers, body: parameter)
              .timeout(Duration(seconds: timeOut));
          if (response.statusCode == 200) {
            var getData = json.decode(response.body);
            String error = getData["error"];
            if (error == "false") {
              perTotal = int.parse(getData["total"]);
              if ((perOffset) < perTotal) {
                tempUserList.clear();
                userNoti.clear();
                var data = getData["data"];
                tempUserList = (data as List)
                    .map((data) => new NotificationModel.fromJson(data))
                    .toList();

                userNoti.addAll(tempUserList);
                perOffset = perOffset + perPage;
              }
            } else {
              isPerLoadingmore = false;
            }
            if (mounted)
              setState(() {
                _isPerLoading = false;
              });
          }
        } on TimeoutException catch (_) {
          setSnackbar(getTranslated(context, 'somethingMSg')!);
          setState(() {
            _isPerLoading = false;
            isPerLoadingmore = false;
          });
        }
      } else {
        setSnackbar(getTranslated(context, 'internetmsg')!);
        setState(() {
          _isPerLoading = false;
          isPerLoadingmore = false;
        });
      }
    } else {
      setState(() {
        _isPerLoading = false;
      });
    }
  }

//set snackbar msg
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

  _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      if (this.mounted) {
        setState(() {
          isLoadingmore = true;

          if (offset < total) getNotification();
        });
      }
    }
  }

  _scrollListener1() {
    if (controller1.offset >= controller1.position.maxScrollExtent &&
        !controller1.position.outOfRange) {
      if (this.mounted) {
        setState(() {
          isPerLoadingmore = true;

          if (perOffset < perTotal) getUserNotification();
        });
      }
    }
  }
}
