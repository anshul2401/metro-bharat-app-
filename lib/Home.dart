// ignore_for_file: file_names, avoid_print, unnecessary_new, prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flick_video_player/flick_video_player.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:intl/intl.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';
import 'package:marquee/marquee.dart';
import 'package:news_app/Bookmark.dart';
import 'package:news_app/Helper/Color.dart';
import 'package:news_app/Helper/Constant.dart';
import 'package:news_app/Helper/Session.dart';
import 'package:news_app/Helper/String.dart';
import 'package:news_app/Model/BreakingNews.dart';
import 'package:news_app/Model/Channel.dart';
import 'package:news_app/Model/Events.dart';
import 'package:news_app/Model/News.dart';
import 'package:news_app/Model/Shorts.dart';
import 'package:news_app/Model/event_category.dart';
import 'package:news_app/NewsTag.dart';
import 'package:news_app/NotificationList.dart';
import 'package:news_app/RequestOtp.dart';
import 'package:news_app/Search.dart';
import 'package:news_app/Setting.dart';
import 'package:news_app/SubHome2.dart';
import 'package:news_app/drawer_mainpage.dart';
import 'package:news_app/event_details.dart';
import 'package:news_app/live_tv.dart';
import 'package:news_app/search_page.dart';
import 'package:news_app/shorts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:video_player/video_player.dart';
import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'Helper/PushNotificationService.dart';
import 'Live.dart';
import 'Login.dart';
import 'Model/Category.dart';
import 'Model/WeatherData.dart';
import 'NewsDetails.dart';
import 'SubHome.dart';
import 'main.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

int _selectedIndex = 0;

class HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Widget>? fragments;
  DateTime? currentBackPressTime;
  bool _isNetworkAvail = true;
  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];
  GlobalKey keyButton = GlobalKey();
  GlobalKey keyButton1 = GlobalKey();
  GlobalKey keyBottomNavigation1 = GlobalKey();
  GlobalKey keyBottomNavigation2 = GlobalKey();
  GlobalKey keyBottomNavigation3 = GlobalKey();
  GlobalKey keyBottomNavigation4 = GlobalKey();

  @override
  void initState() {
    super.initState();
    // selectedChannelName == ''
    //     ? null
    //     : Future.delayed(Duration.zero, showTutorial);
    getUserDetails();
    initDynamicLinks();
    fragments = [
      HomePage(
        isLiveTvPage: false,
        isEventPage: false,
        isShortPage: false,
      ),
      HomePage(
        isLiveTvPage: true,
        isEventPage: false,
        isShortPage: false,
      ),
      HomePage(
        isLiveTvPage: false,
        isEventPage: false,
        isShortPage: true,
      ),
      HomePage(
        isLiveTvPage: false,
        isEventPage: true,
        isShortPage: false,
      ),
    ];
    firNotificationInitialize();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getUserDetails() async {
    CUR_USERID = (await getPrefrence(ID)) ?? "";
    CATID = (await getPrefrence(cur_catId)) ?? "";

    setState(() {});
  }

  void initTargets() {
    targets.clear();
    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation1",
        keyTarget: keyBottomNavigation1,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Click here for home page",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation2",
        keyTarget: keyBottomNavigation2,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Click here to view live tv",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation3",
        keyTarget: keyBottomNavigation3,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Click here to view shorts",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation4",
        keyTarget: keyBottomNavigation4,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Click here for events",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void showTutorial() {
    initTargets();
    tutorialCoachMark = TutorialCoachMark(
      context,
      targets: targets,
      colorShadow: Colors.red,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () {
        print("skip");
      },
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp)=> ShowCasw)
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: colors.bgColor,
      // appBar: AppBar(
      //   title: Padding(
      //     padding: const EdgeInsets.only(right: 0, left: 0),
      //     child: Image.asset('assets/images/img_6.png'),
      //   ),
      //   actions: [
      //     Container(
      //       padding: EdgeInsets.only(left: 0, right: 60),
      //       // decoration: BoxDecoration(
      //       //   borderRadius: BorderRadius.circular(15),
      //       //   color: Colors.red,
      //       // ),
      //       alignment: Alignment.center,
      //       child: Text(
      //         'Change Channel',
      //         style: TextStyle(
      //           color: Colors.red,
      //         ),
      //       ),
      //     ),
      //     GestureDetector(
      //       onTap: () {
      //         Navigator.push(context,
      //             MaterialPageRoute(builder: (context) => const LiveTvPage()));
      //         // Navigator.push(
      //         //     context,
      //         //     MaterialPageRoute(
      //         //       builder: (context) => Live(
      //         //         liveNews: isliveNews,
      //         //       ),
      //         //     ));
      //       },
      //       child: Container(
      //         padding: EdgeInsets.only(right: 16),
      //         // decoration: BoxDecoration(
      //         //   borderRadius: BorderRadius.circular(15),
      //         //   color: Colors.red,
      //         // ),
      //         alignment: Alignment.center,
      //         child: Text(
      //           'Live T.V.',
      //           style: TextStyle(
      //             color: Colors.blue,
      //           ),
      //         ),
      //       ),
      //     ),
      //   ],
      //   backgroundColor: colors.bgColor,
      //   elevation: 0,
      // ),
      //extendBodyBehindAppBar: true,
      extendBody: true,
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.add),
      //   onPressed: () {
      //     // Overlay.of(context).insert(entry);
      //   },
      // ),
      // drawer: Container(
      //   width: MediaQuery.of(context).size.width * 0.9,
      //   child: Drawer(
      //     child: Drawermain(),
      //   ),
      // ),
      // bottomNavigationBar: BottomAppBar(
      //   shape: CircularNotchedRectangle(),
      //   notchMargin: 4.0,
      //   child: Row(
      //     mainAxisSize: MainAxisSize.max,
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: <Widget>[
      //       // TextButton(
      //       //   child: Text("Breaking News", style: TextStyle(fontSize: 16)),
      //       //   onPressed: () {},
      //       // ),
      //       // TextButton(
      //       //   child: Text("Live T.V.", style: TextStyle(fontSize: 16)),
      //       //   onPressed: () {},
      //       // ),

      //     ],
      //   ),
      // ),
      bottomNavigationBar: Stack(
        children: [
          Container(
            height: 50,
            child: Row(
              children: [
                Expanded(
                    child: Center(
                  child: SizedBox(
                    key: keyBottomNavigation1,
                    height: 40,
                    width: 40,
                  ),
                )),
                Expanded(
                    child: Center(
                  child: SizedBox(
                    key: keyBottomNavigation2,
                    height: 40,
                    width: 40,
                  ),
                )),
                Expanded(
                  child: Center(
                    child: SizedBox(
                      key: keyBottomNavigation3,
                      height: 40,
                      width: 40,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SizedBox(
                      key: keyBottomNavigation4,
                      height: 40,
                      width: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: Colors.grey,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                title: Text(
                  'Home',
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.tv,
                ),
                title: Text(
                  'Live T.V.',
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                title: Text('Shorts'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.event),
                title: Text('Events'),
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.black,
            iconSize: 20,
            onTap: _onItemTapped,
            elevation: 5,
          ),
        ],
      ),
      body: fragments?[_selectedIndex],
    );
  }

  void firNotificationInitialize() {
    //for firebase push notification
    FlutterLocalNotificationsPlugin();
// initialise the plugin. ic_launcher needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true);
    final MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);

    PushNotificationService.flutterLocalNotificationsPlugin.initialize(
        initializationSettings, onSelectNotification: (String? payload) async {
      if (payload != null && payload != "") {
        debugPrint('notification payload: $payload');
        getNewsById(payload);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
        );
      }
    });
  }

  //when home page in back click press
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (_selectedIndex != 0) {
      _selectedIndex = 0;

      return Future.value(false);
    } else if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      setSnackbar(getTranslated(context, 'EXIT_WR')!);

      return Future.value(false);
    }
    return Future.value(true);
  }

  _onItemTapped(index) async {
    setState(() {
      _selectedIndex = index;
    });
  }

  //when dynamic link share that's open in app used this function
  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      final Uri? deepLink = dynamicLink?.link;

      if (deepLink != null) {
        if (deepLink.queryParameters.length > 0) {
          String id = deepLink.queryParameters['id']!;
          getNewsById(id);
        }
      }
    }, onError: (OnLinkErrorException e) async {
      print(e.message);
    });
  }

  updateParent() {
    setState(() {});
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

  //when open dynamic link news index and id can used for fetch specific news
  Future<void> getNewsById(String id) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      var param = {
        NEWS_ID: id,
        ACCESS_KEY: access_key,
        USER_ID: CUR_USERID != null && CUR_USERID != "" ? CUR_USERID : "0"
      };
      http.Response response = await http
          .post(Uri.parse(getNewsByIdApi), body: param, headers: headers)
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
                  // updateHome: updateParent,
                )));
      }
    } else {
      setSnackbar(getTranslated(context, 'internetmsg')!);
    }
  }

  bottomBar() {
    return Padding(
        padding: EdgeInsetsDirectional.only(
            start: 15.0, end: 15.0, bottom: 15.0, top: 10.0),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                    blurRadius: 10.0,
                    offset: const Offset(5.0, 5.0),
                    color: Theme.of(context)
                        .colorScheme
                        .fontColor
                        .withOpacity(0.1),
                    spreadRadius: 1.0),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: BottomNavigationBar(
                showSelectedLabels: false,
                showUnselectedLabels: false,
                currentIndex: _selectedIndex,
                onTap: (int index) {
                  _onItemTapped(index);
                },
                backgroundColor: Theme.of(context).colorScheme.boxColor,
                type: BottomNavigationBarType.fixed,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: SvgPicture.asset("assets/images/home_icon.svg",
                          semanticsLabel: 'livetv',
                          height: 20.0,
                          width: 20.0,
                          color: _selectedIndex == 0
                              ? colors.primary
                              : Theme.of(context).colorScheme.fontColor),
                      label: "Live T.V."),
                  BottomNavigationBarItem(
                      icon: SvgPicture.asset("assets/images/saved_icon.svg",
                          semanticsLabel: 'saved',
                          height: 20.0,
                          width: 20.0,
                          color: _selectedIndex == 1
                              ? colors.primary
                              : Theme.of(context).colorScheme.fontColor),
                      label: "Saved Bookmark"),
                  BottomNavigationBarItem(
                      icon: SvgPicture.asset("assets/images/home_icon.svg",
                          semanticsLabel: 'home',
                          height: 20.0,
                          width: 20.0,
                          color: _selectedIndex == 2
                              ? colors.primary
                              : Theme.of(context).colorScheme.fontColor),
                      label: "Home"),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.notifications,
                        color: _selectedIndex == 3
                            ? colors.primary
                            : Theme.of(context).colorScheme.fontColor,
                      ),
                      label: "Notification"),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.settings,
                        color: _selectedIndex == 4
                            ? colors.primary
                            : Theme.of(context).colorScheme.fontColor,
                      ),
                      label: "Setting"),
                ],
              ),
            )));
  }
}

class HomePage extends StatefulWidget {
  final bool isLiveTvPage;
  final bool isEventPage;
  final bool isShortPage;
  HomePage(
      {required this.isLiveTvPage,
      required this.isEventPage,
      required this.isShortPage});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<News> tempList = [];
  List<Category> tempCatList = [];
  List<Channel> tempChannelList = [];
  List<BreakingNewsModel> tempBreakList = [];
  List<BreakingNewsModel> breakingNewsList = [];
  List<EventsModel> tempEventList = [];
  List<EventsModel> eventsList = [];
  List<String> tempAdList = [];
  List<String> adList = [];
  WeatherData? weatherData;
  loc.Location _location = new loc.Location();
  String? error;
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  bool _folded = true;
  final TextEditingController textController = TextEditingController();
  TabController? _tc;
  int offsetRecent = 0;
  int totalRecent = 0;
  int offsetUser = 0;
  int totalUser = 0;
  String? catId = "";
  List<Map<String, dynamic>> _tabs = [];
  List<News> recentNewsList = [];
  List<News> tempUserNews = [];
  List<News> userNewsList = [];
  bool _isBreakLoading = true;
  bool _isUserLoading = true;
  bool _isUserLoadMore = true;
  bool _isRecentLoading = true;
  bool _isRecentLoadMore = true;
  bool isEventLoading = true;
  bool _isLoading = true;
  bool _isLoadingMore = true;
  bool _isNetworkAvail = true;
  bool weatherLoad = true;
  List<Category> catList = [];
  List<Channel> channelList = [];
  int tcIndex = 0;

  var scrollController = ScrollController();
  List bookMarkValue = [];
  List<News> bookmarkList = [];
  List<String> allImage = [];
  List<EventCategory> eventCatList = [];
  List<EventCategory> tempEventCatList = [];
  final _pageController = PageController();
  int _curSlider = 0;
  int? selectSubCat = 0;
  var newHome;

  bool isFirst = false;
  // ignore: prefer_typing_uninitialized_variables
  var isliveNews;

  List<News> newsList = [];
  List<News> tempNewsList = [];
  int offset = 0;
  int total = 0;
  bool enabled = true;
  ScrollController controller = new ScrollController();
  ScrollController controller1 = new ScrollController();
  bool isTab = true;
  SubHome2 subHome = SubHome2();
  SubHome2 subHome2 = SubHome2();
  YoutubePlayerController? _yc;
  FlickManager? flickManager;
  bool showLiveTv = true;
  List<String> selectedChoices = [];
  bool showBreakingNews = true;
  String? sortBy;
  List<FlickManager> flickManager11 = [];
  List<ShortsModel> shorts = [];
  List<ShortsModel> tempShortList = [];

  @override
  void initState() {
    loadWeather();

    controller.addListener(_scrollListener);
    controller1.addListener(_scrollListener1);

    callApi();

    super.initState();
  }

  Future<void> callApi() async {
    getSetting();
    await getAd();
    await getLiveNews();
    await getBreakingNews();
    await getNews();
    await getUserByCatNews();
    await getUserByCat();
    await getCat();
    await getChannel();
    await _getBookmark();
    await getEvents();
    await getEventCat();
    await getShorts();
  }

  Future<void> getShorts() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      var param = {
        ACCESS_KEY: access_key,
        USER_ID: '0',
      };

      http.Response response = await http
          .post(Uri.parse(baseUrl + 'get_video'), body: param, headers: headers)
          .timeout(Duration(seconds: timeOut));

      var getdata = json.decode(response.body);

      String error = getdata["error"];
      print('this is shorts');
      print(getdata);
      if (error == "false") {
        var data = getdata["data"];

        tempShortList =
            (data as List).map((data) => ShortsModel.fromJson(data)).toList();
        shorts.addAll(tempShortList);
        setState(() {});
        // shorts.forEach((element) {
        //   print(element.contentValue);
        //   if (element != "" || element != null) {
        //     flickManager11.add(FlickManager(
        //       videoPlayerController:
        //           VideoPlayerController.network(element.contentValue!),
        //       autoPlay: false,
        //     ));
        //   }
        // });

        // for (int i = 0; i < data.length; i++) {
        //   catId = data[i]["category_id"];
        // }
        // setState(() {
        //   selectedChoices = catId == "" ? catId!.split('') : catId!.split(',');
        // });
      }
    } else {
      // setState(() {
      //   _isLoading = false;
      // });
      setSnackbar(getTranslated(context, 'internetmsg')!);
    }
  }

  Future<void> getUserByCat() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      var param = {
        ACCESS_KEY: access_key,
        USER_ID: CUR_USERID,
      };

      http.Response response = await http
          .post(Uri.parse(getUserByCatIdApi), body: param, headers: headers)
          .timeout(Duration(seconds: timeOut));

      var getdata = json.decode(response.body);

      print("get data cat id************$getdata");

      String error = getdata["error"];
      if (error == "false") {
        var data = getdata["data"];

        for (int i = 0; i < data.length; i++) {
          catId = data[i]["category_id"];
        }
        setState(() {
          selectedChoices = catId == "" ? catId!.split('') : catId!.split(',');
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      setSnackbar(getTranslated(context, 'internetmsg')!);
    }
  }

  Future<void> getAd() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      var param = {
        ACCESS_KEY: access_key,
      };

      http.Response response = await http
          .post(Uri.parse(baseUrl + 'get_ads'), body: param, headers: headers)
          .timeout(Duration(seconds: timeOut));

      var getdata = json.decode(response.body);

      String error = getdata["error"];
      if (error == "false") {
        var data = getdata["data"];
        data.forEach((element) {
          tempAdList.add(element['image']);
        });

        adList.addAll(tempAdList);

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

  //get user selected category newslist
  Future<void> getUserByCatNews() async {
    if (CUR_USERID != "") {
      _isNetworkAvail = await isNetworkAvailable();
      if (_isNetworkAvail) {
        try {
          var param = {
            ACCESS_KEY: access_key,
            CATEGORY_ID: CATID,
            USER_ID: CUR_USERID,
            LIMIT: perPage.toString(),
            OFFSET: offsetUser.toString(),
          };
          http.Response response = await http
              .post(Uri.parse(getNewsByUserCatApi),
                  body: param, headers: headers)
              .timeout(Duration(seconds: timeOut));
          if (response.statusCode == 200) {
            var getData = json.decode(response.body);
            String error = getData["error"];
            if (error == "false") {
              totalUser = int.parse(getData["total"]);
              if ((offsetUser) < totalUser) {
                tempUserNews.clear();
                var data = getData["data"];
                tempUserNews = (data as List)
                    .map((data) => new News.fromJson(data))
                    .toList();
                userNewsList.addAll(tempUserNews);
                offsetUser = offsetUser + perPage;
              }
            } else {
              _isUserLoadMore = false;
            }
            if (mounted)
              setState(() {
                _isUserLoading = false;
              });
          }
        } on TimeoutException catch (_) {
          setSnackbar(getTranslated(context, 'somethingMSg')!);
          setState(() {
            _isUserLoading = false;
            _isUserLoadMore = false;
          });
        }
      } else {
        setSnackbar(getTranslated(context, 'internetmsg')!);
        setState(() {
          _isUserLoading = false;
          _isUserLoadMore = false;
        });
      }
    }
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

      http.Response response = await http
          .post(Uri.parse(setBookmarkApi), body: param, headers: headers)
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

  //add tab bar category title
  _addInitailTab() async {
    setState(() {
      for (int i = 0; i < catList.length; i++) {
        _tabs.add({
          'text': catList[i].categoryName,
        });
        catId = catList[i].id;
      }

      _tc = TabController(
        vsync: this,
        length: _tabs.length,
      )..addListener(() {
          setState(() {
            isTab = true;

            tcIndex = _tc!.index;
            selectSubCat = 0;
          });
        });
    });
  }

  catShimmer() {
    return Container(
        child: Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.4),
            highlightColor: Colors.grey.withOpacity(0.4),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: [0, 1, 2, 3, 4, 5, 6]
                      .map((i) => Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: i == 0 ? 0 : 15),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Colors.grey),
                            height: 32.0,
                            width: 110.0,
                          )))
                      .toList()),
            )));
  }

  // tabBarData() {
  //   return Container(
  //     height: 45,
  //     child: ListView.builder(
  //         padding: EdgeInsets.all(5),
  //         // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //         //   childAspectRatio: (2.2 / 1),
  //         //   crossAxisCount: 4,
  //         //   mainAxisSpacing: 0,
  //         // ),
  //         scrollDirection: Axis.horizontal,
  //         itemCount: _tabs.length,
  //         itemBuilder: (BuildContext ctx, index) {
  //           return GestureDetector(
  //             onTap: () {
  //               setState(() {
  //                 tcIndex = index;
  //                 _tc!.index = index;

  //                 // catList[index].subData == [] ? isTab = true : isTab = false;
  //               });
  //             },
  //             child: ConstrainedBox(
  //               constraints: BoxConstraints(
  //                   maxHeight: 45, minHeight: 45, maxWidth: 100, minWidth: 50),
  //               child: Padding(
  //                 padding: const EdgeInsets.all(3.0),
  //                 child: Container(
  //                   padding: EdgeInsets.zero,
  //                   decoration: BoxDecoration(
  //                     color: tcIndex == index
  //                         ? colors.primary.withOpacity(0.07)
  //                         : Theme.of(context)
  //                             .colorScheme
  //                             .fontColor
  //                             .withOpacity(0.13),
  //                     borderRadius: BorderRadius.circular(5),
  //                   ),
  //                   alignment: Alignment.center,
  //                   child: Text(
  //                     _tabs[index]["text"],
  //                     style: Theme.of(context).textTheme.subtitle2?.copyWith(
  //                         color:
  //                             tcIndex == index ? colors.primary : Colors.black,
  //                         fontSize: 12,
  //                         fontWeight: selectSubCat == index
  //                             ? FontWeight.w600
  //                             : FontWeight.w600),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           );
  //         }),
  //   );
  // }
  tabBarData() {
    return TabBar(
      //indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: Theme.of(context).textTheme.subtitle1?.copyWith(
            fontWeight: FontWeight.w600,
          ),
      unselectedLabelColor: isDark! ? Colors.white : Colors.black,
      isScrollable: true,

      indicator: BoxDecoration(
          color: colors.primary, borderRadius: BorderRadius.circular(5)),
      // indicator: UnderlineTabIndicator(
      //     borderSide: BorderSide(width: 2.0, color: colors.primary),
      //     insets: EdgeInsets.symmetric(horizontal: 0.0)),

      tabs: _tabs
          .map((tab) => Container(
                // decoration: BoxDecoration(color: Colors.red.withOpacity(0.07)),
                height: 27,
                padding: EdgeInsetsDirectional.all(0),
                child: Tab(
                  text: tab['text'],
                ),
              ))
          .toList(),
      labelColor: Colors.white,

      controller: _tc,

      unselectedLabelStyle: Theme.of(context).textTheme.subtitle1?.copyWith(),
    );
  }

  subTabData() {
    return catList.length != 0
        ? catList[_tc!.index].subData!.length != 0
            ? Padding(
                padding: EdgeInsetsDirectional.only(top: 10.0, start: 0),
                child: Container(
                    color: Colors.white,
                    height: 27,
                    alignment: Alignment.centerLeft,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: catList[_tc!.index].subData!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: EdgeInsetsDirectional.only(
                                  start: index == 0 ? 0 : 10),
                              child: InkWell(
                                child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsetsDirectional.only(
                                        start: 7.0,
                                        end: 7.0,
                                        top: 2.5,
                                        bottom: 2.5),
                                    // decoration: BoxDecoration(
                                    //   borderRadius: BorderRadius.circular(5.0),
                                    //   color: selectSubCat == index
                                    //       ? colors.primary.withOpacity(0.07)
                                    //       : Theme.of(context)
                                    //           .colorScheme
                                    //           .fontColor
                                    // .withOpacity(0.13),

                                    // ),
                                    decoration: BoxDecoration(
                                        // border: selectSubCat == index
                                        //     ? Border(
                                        //         bottom: BorderSide(
                                        //             width: 2.0,
                                        //             color: Colors.red),
                                        //       )
                                        //     : Border(
                                        //         bottom: BorderSide(
                                        //             width: 0.0,
                                        //             color: Colors.white),
                                        // ),
                                        color: selectSubCat == index
                                            ? Colors.red
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Text(
                                      catList[_tc!.index]
                                          .subData![index]
                                          .subCatName!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          ?.copyWith(
                                              color: selectSubCat == index
                                                  ? Colors.white
                                                  : isDark!
                                                      ? Colors.white
                                                      : Colors.grey,
                                              fontSize: 12,
                                              fontWeight: selectSubCat == index
                                                  ? FontWeight.w600
                                                  : FontWeight.normal),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                    )),
                                onTap: () async {
                                  setState(() {
                                    isTab = false;
                                    selectSubCat = index;

                                    if (index == 0) {
                                      subHome = SubHome2(
                                        subCatId: "0",
                                        curTabId: catList[tcIndex].id!,
                                        index: tcIndex,
                                        isSubCat: true,
                                        catList: catList,
                                        scrollController: scrollController,
                                        channelName: selectedChannelName,
                                        sortOption: sortBy,
                                      );
                                    } else {
                                      subHome = SubHome2(
                                        subCatId: catList[tcIndex]
                                            .subData![index]
                                            .id!,
                                        curTabId: "0",
                                        index: tcIndex,
                                        isSubCat: true,
                                        catList: catList,
                                        scrollController: scrollController,
                                        channelName: selectedChannelName,
                                        sortOption: sortBy,
                                      );
                                    }
                                  });
                                },
                              ));
                        })))
            : Container()
        : Container();
  }

  List<String> channelName = [
    'Metro Mumbai',
    'Metro Delhi',
    'Metro Gujrat',
    'Metro Bihar',
    'Metro Uttar Pradesh',
    'Metro Banglore',
    'Metro Patna',
  ];

  void showMe(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext contex) {
        return StatefulBuilder(
          builder: (context, StateSetter setState1) {
            return Container(
              height: 500,
              padding: MediaQuery.of(context).viewInsets,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Choose Channel',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Icon(
                                Icons.cancel,
                                color: Colors.grey,
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: channelList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState1(() {
                                      selectedChannelName =
                                          channelList[index].channelId!;
                                      selectedChannelImg =
                                          channelList[index].channel_image!;
                                      Navigator.of(context).pop();
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil("/home",
                                              (Route<dynamic> route) => false);
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      // borderRadius: BorderRadius.circular(15),
                                      color: selectedChannelName ==
                                              channelList[index].channelId
                                          ? Colors.red.withOpacity(0.1)
                                          : Colors.grey.withOpacity(0.5),
                                    ),
                                    child: Text(
                                      channelList[index].channelName!,
                                      style: TextStyle(
                                        color: selectedChannelName ==
                                                channelList[index].channelId
                                            ? Colors.red
                                            : Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                      const SizedBox(
                        height: 15,
                      )
                    ]),
              ),
            );
          },
        );
      },
    );
  }

  String breakingNews() {
    String bn = '';
    breakingNewsList.forEach((element) {
      bn = bn + element.title.toString() + ' | ';
    });
    return bn;
  }

  PageController shortcontroller = PageController(initialPage: 0);
  viewVideo(ShortsModel shorts, String index) {
    return Stack(children: [
      Container(
          alignment: Alignment.center,
          child: FlickVideoPlayer(
              flickManager: FlickManager(
            videoPlayerController:
                VideoPlayerController.network(shorts.contentValue!),
            autoPlay: false,
          ))),
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Text(
                shorts.title!,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 100, left: 20),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    shorts.disc!,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 100, right: 20),
                child: Column(
                  children: [
                    InkWell(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(55.0),
                          child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                height: 35,
                                width: 35,
                                // padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: colors.tempboxColor.withOpacity(0.5),
                                    shape: BoxShape.circle),
                                child: Image.asset(
                                  shorts.like == "1"
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
                              if (shorts.like == "1") {
                                _setLikesDisLikesForShort(
                                    "0", shorts.id!, int.parse(index));

                                setState(() {});
                              } else {
                                _setLikesDisLikesForShort(
                                    "1", shorts.id!, int.parse(index));

                                setState(() {});
                              }
                            }
                          } else {
                            setSnackbar(getTranslated(context, 'internetmsg')!);
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
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      shorts.likes! + ' Like',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: 9.0),
                      child: InkWell(
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/images/s_share.png",
                              height: 30.0,
                              width: 30.0,
                            ),
                            Padding(
                                padding: EdgeInsetsDirectional.only(top: 4.0),
                                child: Text(
                                  getTranslated(context, 'share_lbl')!,
                                  style: Theme.of(this.context)
                                      .textTheme
                                      .caption
                                      ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .fontColor
                                              .withOpacity(0.8),
                                          fontSize: 9.0),
                                ))
                          ],
                        ),
                        onTap: () async {
                          _isNetworkAvail = await isNetworkAvailable();
                          if (_isNetworkAvail) {
                            createDynamicLink(
                              shorts.id!,
                              int.parse(shorts.id!),
                              shorts.title!,
                            );
                          } else {
                            setSnackbar(getTranslated(context, 'internetmsg')!);
                          }
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    ]);
  }

  _setLikesDisLikesForShort(String status, String id, int index) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      var param = {
        ACCESS_KEY: access_key,
        USER_ID: CUR_USERID,
        'shorts_id': id,
        STATUS: status,
      };

      Response response = await post(
              Uri.parse(baseUrl + 'set_like_dislike_for_shorts'),
              body: param,
              headers: headers)
          .timeout(Duration(seconds: timeOut));

      var getdata = json.decode(response.body);

      String error = getdata["error"];

      String msg = getdata["message"];

      if (error == "false") {
        if (status == "1") {
          shorts[index].like = "1";
          shorts[index].likes =
              (int.parse(shorts[index].likes!) + 1).toString();
          setSnackbar(getTranslated(context, 'like_succ')!);
        } else if (status == "0") {
          shorts[index].like = "0";
          shorts[index].likes =
              (int.parse(shorts[index].likes!) - 1).toString();
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

  _setLikesDisLikesForEvents(String status, String id, int index) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      var param = {
        ACCESS_KEY: access_key,
        USER_ID: CUR_USERID,
        'events_id': id,
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
          shorts[index].like = "1";
          shorts[index].likes =
              (int.parse(shorts[index].likes!) + 1).toString();
          setSnackbar(getTranslated(context, 'like_succ')!);
        } else if (status == "0") {
          shorts[index].like = "0";
          shorts[index].likes =
              (int.parse(shorts[index].likes!) - 1).toString();
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

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;

    return selectedChannelName == ''
        ? Scaffold(
            body: channelList.isEmpty
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Choose Channel',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),

                          channelListContent(),
                          // Container(
                          //   child: GridView.builder(
                          //       gridDelegate:
                          //           const SliverGridDelegateWithFixedCrossAxisCount(
                          //         mainAxisSpacing: 15,
                          //         crossAxisCount: 3,
                          //         childAspectRatio: 3 / 3.7,
                          //       ),
                          //       shrinkWrap: true,
                          //       itemCount: channelList.length,
                          //       itemBuilder: (context, index) {
                          //         return Padding(
                          //           padding: const EdgeInsets.all(3.0),
                          //           child: GestureDetector(
                          //             onTap: () {
                          //               setState(() {
                          //                 selectedChannelName =
                          //                     channelList[index].channelId!;
                          //                 selectedChannelImg =
                          //                     channelList[index].channel_image!;
                          //                 Navigator.of(context).pop();
                          //                 Navigator.of(context)
                          //                     .pushNamedAndRemoveUntil(
                          //                         "/home",
                          //                         (Route<dynamic> route) =>
                          //                             false);
                          //               });
                          //             },
                          //             child: Column(
                          //               children: [
                          //                 Image.network(channelList[index]
                          //                             .channel_image ==
                          //                         null
                          //                     ? ''
                          //                     : channelList[index]
                          //                         .channel_image!),
                          //                 Container(
                          //                   alignment: Alignment.center,
                          //                   padding: EdgeInsets.all(8),
                          //                   decoration: BoxDecoration(
                          //                     border: Border.all(),
                          //                     // borderRadius: BorderRadius.circular(15),
                          //                     color: selectedChannelName ==
                          //                             channelList[index]
                          //                                 .channelId
                          //                         ? Colors.red.withOpacity(0.1)
                          //                         : Colors.grey
                          //                             .withOpacity(0.5),
                          //                   ),
                          //                   child: Text(
                          //                     channelList[index].channelName!,
                          //                     style: TextStyle(
                          //                       color: selectedChannelName ==
                          //                               channelList[index]
                          //                                   .channelId
                          //                           ? Colors.red
                          //                           : Colors.black,
                          //                       fontSize: 12,
                          //                       fontWeight: FontWeight.bold,
                          //                     ),
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //         );
                          //       }),
                          // ),
                          const SizedBox(
                            height: 15,
                          )
                        ]),
                  ),
          )
        : widget.isShortPage
            ? Scaffold(
                body: PageView(
                    controller: shortcontroller,
                    scrollDirection: Axis.vertical,
                    children: shorts
                        .map((e) => Container(child: viewVideo(e, e.id!)))
                        .toList()))
            : widget.isEventPage
                ? Scaffold(
                    appBar: AppBar(
                      title: GestureDetector(
                        onTap: () {
                          showMe(context);
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 70,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 0, left: 10),
                                child: Image.network(selectedChannelImg),
                              ),
                            ),
                            Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                      actions: [
                        // TODO: add here the search bar
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FilterNetworkListPage(),
                                ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            FilterNetworkListPage(),
                                      ));
                                },
                                icon: Icon(
                                  Icons.search_rounded,
                                  size: 35,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ],
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      elevation: 0,
                    ),
                    drawer: Container(
                      width: MediaQuery.of(context).size.width * 1,
                      child: Drawer(
                        child: Drawermain(),
                      ),
                    ),
                    body: Container(
                        child: SingleChildScrollView(child: viewEvents())),
                  )
                : widget.isLiveTvPage
                    ? Scaffold(
                        appBar: AppBar(
                          title: GestureDetector(
                            onTap: () {
                              showMe(context);
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 70,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 0, left: 10),
                                    child: Image.network(selectedChannelImg),
                                  ),
                                ),
                                Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                          actions: [
                            // TODO: add here the search bar
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FilterNetworkListPage(),
                                    ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FilterNetworkListPage(),
                                          ));
                                    },
                                    icon: Icon(
                                      Icons.search_rounded,
                                      size: 35,
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Live(
                                        liveNews: isliveNews,
                                      ),
                                    ));
                              },
                              child: Container(
                                padding: EdgeInsets.only(right: 20),
                                // decoration: BoxDecoration(
                                //   borderRadius: BorderRadius.circular(15),
                                //   color: Colors.red,
                                // ),
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [],
                                ),
                              ),
                            ),
                          ],
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          elevation: 0,
                        ),
                        drawer: Container(
                          width: MediaQuery.of(context).size.width * 1,
                          child: Drawer(
                            child: Drawermain(),
                          ),
                        ),
                        body: Center(
                          child: getLiveTv(),
                        ),
                      )
                    : Scaffold(
                        appBar: AppBar(
                          title: GestureDetector(
                            onTap: () {
                              showMe(context);
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 70,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 0, left: 10),
                                    child: Image.network(selectedChannelImg),
                                  ),
                                ),
                                Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                          actions: [
                            // TODO: add here the search bar
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FilterNetworkListPage(),
                                    ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FilterNetworkListPage(),
                                          ));
                                    },
                                    icon: Icon(
                                      Icons.search_rounded,
                                      size: 35,
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) => Live(
                                //         liveNews: isliveNews,
                                //       ),
                                //     ));
                                setState(() {
                                  showLiveTv = true;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.only(right: 20),
                                // decoration: BoxDecoration(
                                //   borderRadius: BorderRadius.circular(15),
                                //   color: Colors.red,
                                // ),
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/live_news.svg",
                                      semanticsLabel: 'live news',
                                      height: 21.0,
                                      width: 21.0,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Live T.V.',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          elevation: 0,
                        ),
                        drawer: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Drawer(
                            child: Drawermain(),
                          ),
                        ),
                        key: _scaffoldKey,
                        body: SafeArea(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(
                              start: 15.0,
                              end: 15.0,
                              bottom: 10.0,
                            ),
                            child: NestedScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              controller: scrollController,
                              clipBehavior: Clip.none,
                              headerSliverBuilder: (BuildContext context,
                                  bool innerBoxIsScrolled) {
                                return <Widget>[
                                  new SliverList(
                                    delegate: new SliverChildListDelegate([
                                      // weatherDataView(),
                                      // liveWithSearchView(),
                                      // viewBreakingNews(),
                                      // viewRecentContent(),
                                      // CUR_USERID != "" && CATID != ""
                                      //     ? viewUserNewsContent()
                                      //     : Container(),
                                      // catText(),
                                      // tabBarData(),
                                      // subTabData(),
                                      // const SizedBox(
                                      //   height: 20,
                                      // ),
                                      // weatherDataView(),
                                      (isliveNews == "" && isliveNews == null)
                                          ? Container()
                                          : showLiveTv
                                              ? getLiveTv()
                                              : Container(
                                                  height: 10,
                                                ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              backgroundBlendMode:
                                                  BlendMode.srcIn,
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                              gradient: LinearGradient(colors: [
                                                Colors.red,
                                                Colors.orange
                                              ]),
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            height: 25,
                                            child: Text(
                                              'Breaking',
                                              style: TextStyle(
                                                color: Colors.yellow,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  Color.fromRGBO(0, 0, 139, 1),
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.72,
                                            height: 25,
                                            child: Marquee(
                                              fadingEdgeStartFraction: 0.05,
                                              text: breakingNews(),
                                              scrollAxis: Axis.horizontal,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontStyle: FontStyle.italic,
                                              ),
                                              blankSpace: 300,
                                            ),
                                          ),
                                        ],
                                      ),

                                      // catShimmer()
                                    ]),
                                  ),
                                  SliverAppBar(
                                    toolbarHeight: 0,
                                    titleSpacing: 0,
                                    pinned: true,
                                    bottom: catList.length != 0
                                        ? PreferredSize(
                                            preferredSize: Size.fromHeight(
                                              catList[_tc!.index]
                                                          .subData!
                                                          .length !=
                                                      0
                                                  ? 90
                                                  : 53,
                                            ),
                                            child: Column(children: [
                                              tabBarData(),
                                              subTabData(),

                                              SizedBox(
                                                height: 5,
                                              ),

                                              // weatherDataView(),
                                              // getLiveTv(),
                                            ]))
                                        : PreferredSize(
                                            preferredSize: Size.fromHeight(34),
                                            child: catShimmer()),
                                    backgroundColor: isDark!
                                        ? colors.tempdarkColor
                                        : colors.bgColor,
                                    elevation: 0,
                                    floating: true,
                                  ),
                                  new SliverList(
                                    delegate: new SliverChildListDelegate([
                                      // weatherDataView(),
                                      // liveWithSearchView(),
                                      // viewBreakingNews(),
                                      // viewRecentContent(),
                                      // CUR_USERID != "" && CATID != ""
                                      //     ? viewUserNewsContent()
                                      //     : Container(),
                                      // catText(),
                                      // tabBarData(),
                                      // subTabData(),
                                      // const SizedBox(
                                      //   height: 20,
                                      // ),
                                      // weatherDataView(),
                                      adList.isEmpty
                                          ? Container()
                                          : Container(
                                              height: 150,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Image(
                                                fit: BoxFit.fitWidth,
                                                image: NetworkImage(adList[0]),
                                              )),

                                      _tc!.index == 0
                                          ? viewBreakingNews()
                                          : Container(),
                                      // SizedBox(
                                      //   height: 20,
                                      // ),
                                      // weatherDataView(),
                                      // catShimmer()
                                      // viewRecentContent(),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      // weatherDataView(),
                                      // SizedBox(
                                      //   height: 20,
                                      // ),

                                      Padding(
                                        padding: EdgeInsetsDirectional.only(
                                            start: 0.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          padding:
                                              EdgeInsets.only(left: 8, top: 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                catList[_tc!.index]
                                                    .categoryName!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1
                                                    ?.copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .lightColor,
                                                        fontWeight:
                                                            FontWeight.w600),
                                              ),
                                              PopupMenuButton<String>(
                                                icon: Icon(
                                                  Icons.sort,
                                                  color: Colors.white,
                                                ),
                                                onSelected: (val) {
                                                  SubHome2 s = SubHome2();
                                                  s = subHome;

                                                  setState(() {
                                                    sortBy = val;
                                                    subHome = SubHome2(
                                                        subCatId: s.subCatId,
                                                        curTabId: s.curTabId,
                                                        index: s.index,
                                                        isSubCat: s.isSubCat,
                                                        catList: s.catList,
                                                        scrollController:
                                                            s.scrollController,
                                                        channelName:
                                                            s.channelName,
                                                        sortOption: val);
                                                    // sortBy = val!;
                                                  });
                                                  print(subHome.sortOption);
                                                },
                                                itemBuilder:
                                                    (BuildContext context) {
                                                  return {
                                                    'Date(Newest)',
                                                    'Most Liked',
                                                    'Most Viewd',
                                                    'Date(Oldest)'
                                                  }.map((String choice) {
                                                    return PopupMenuItem<
                                                        String>(
                                                      value: choice,
                                                      child: Text(choice),
                                                    );
                                                  }).toList();
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ];
                              },

                              body: catList.length != 0
                                  ? TabBarView(
                                      controller: _tc,

                                      //key: _key,
                                      children: new List<Widget>.generate(
                                          _tc!.length, (int index) {
                                        // return viewRecentContent();
                                        return isTab
                                            ? SubHome2(
                                                curTabId: catList[index].id,
                                                isSubCat: false,
                                                scrollController:
                                                    scrollController,
                                                catList: catList,
                                                subCatId: "0",
                                                index: index,
                                                channelName:
                                                    selectedChannelName,
                                                sortOption: sortBy,
                                              )
                                            : subHome;
                                        // : Padding(
                                        //     padding: const EdgeInsets.only(
                                        //         top: 8.0, left: 7),
                                        //     child: ListView.builder(
                                        //         shrinkWrap: true,
                                        //         itemCount: catList[index]
                                        //             .subData!
                                        //             .length,
                                        //         itemBuilder: (context, indexx) {
                                        //           print(catList[index]
                                        //               .subData![indexx]
                                        //               .id);
                                        //           return Column(
                                        //             mainAxisSize:
                                        //                 MainAxisSize.min,
                                        //             crossAxisAlignment:
                                        //                 CrossAxisAlignment
                                        //                     .start,
                                        //             mainAxisAlignment:
                                        //                 MainAxisAlignment.start,
                                        //             children: [
                                        //               Container(
                                        //                 decoration:
                                        //                     BoxDecoration(
                                        //                   color: Colors.black,
                                        //                   borderRadius:
                                        //                       BorderRadius
                                        //                           .circular(5),
                                        //                 ),
                                        //                 child: Padding(
                                        //                   padding:
                                        //                       const EdgeInsets
                                        //                           .all(8.0),
                                        //                   child: Text(
                                        //                     catList[index]
                                        //                         .subData![
                                        //                             indexx]
                                        //                         .subCatName!,
                                        //                     style: TextStyle(
                                        //                         color: Colors
                                        //                             .white),
                                        //                   ),
                                        //                 ),
                                        //               ),
                                        //               Container(
                                        //                 height: 300,
                                        //                 child: SubHome(
                                        //                   curTabId:
                                        //                       catList[index].id,
                                        //                   isSubCat: false,
                                        //                   scrollController:
                                        //                       scrollController,
                                        //                   catList: catList,
                                        //                   subCatId: catList[
                                        //                           index]
                                        //                       .subData![indexx]
                                        //                       .id,
                                        //                   index: index,
                                        //                   channelName:
                                        //                       selectedChannelName,
                                        //                 ),
                                        //               ),
                                        //             ],
                                        //           );
                                        //         }),
                                        //   );
                                      }),
                                    )
                                  : contentShimmer(context),
                              // subHome = SubHome(
                              //               subCatId: "0",
                              //               curTabId: catList[tcIndex].id!,
                              //               index: tcIndex,
                              //               isSubCat: true,
                              //               catList: catList,
                              //               scrollController: scrollController,
                              //               channelName: selectedChannelName,
                              //             );
                              // body: catList.length != 0
                              //     ? SingleChildScrollView(
                              //         // physics: ClampingScrollPhysics(),

                              //         child: Container(
                              //           height: 900,
                              //           width: MediaQuery.of(context).size.width,
                              //           child: Column(
                              //             mainAxisAlignment: MainAxisAlignment.end,
                              //             children: [
                              //               viewBreakingNews(),
                              //               Container(
                              //                 height: 900,
                              //                 width: MediaQuery.of(context).size.width,
                              //                 child: ListView.builder(
                              //                     itemCount: _tc!.length,
                              //                     shrinkWrap: true,
                              //                     itemBuilder: (context, index) {
                              //                       return isTab
                              //                           ? SubHome(
                              //                               curTabId: catList[index].id,
                              //                               isSubCat: false,
                              //                               scrollController:
                              //                                   scrollController,
                              //                               catList: catList,
                              //                               subCatId: "0",
                              //                               index: index,
                              //                             )
                              //                           : subHome;
                              //                     }),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       )
                              //     : contentShimmer(context),
                            ),
                          ),
                        ),
                      );
  }

  channelListContent() {
    return !_isLoading
        ? Padding(
            padding: EdgeInsetsDirectional.only(top: 25.0),
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 3 / 3.8,
                ),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: channelList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedChannelName = channelList[index].channelId!;
                        selectedChannelImg = channelList[index].channel_image!;
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            "/home", (Route<dynamic> route) => false);
                      });
                    },
                    child: Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Container(
                              padding: EdgeInsets.only(top: 8),
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8)),
                              child: Column(
                                children: [
                                  Container(
                                      height: 70,
                                      width: MediaQuery.of(context).size.width /
                                          3.5,
                                      child: Image(
                                        fit: BoxFit.fitWidth,
                                        image: NetworkImage(
                                            channelList[index].channel_image ==
                                                    null
                                                ? ''
                                                : channelList[index]
                                                    .channel_image!),
                                      )),
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .boxColor,
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 10.0,
                                              offset: const Offset(5.0, 5.0),
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .fontColor
                                                  .withOpacity(0.1),
                                              spreadRadius: 1.0),
                                        ],
                                      ),
                                      child: Material(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .boxColor,
                                        child: InkWell(
                                          highlightColor: Theme.of(context)
                                              .colorScheme
                                              .boxColor,
                                          splashColor: colors.primary,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: Container(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .boxColor,
                                            height: 45,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.5,
                                            // padding: EdgeInsetsDirectional.only(
                                            //     start: 20.0,
                                            //     end: 15.0,
                                            //     top: 10.0,
                                            //     bottom: 10.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3.5,
                                                  child: Text(
                                                      channelList[index]
                                                          .channelName!,
                                                      softWrap: true,
                                                      textAlign: TextAlign
                                                          .center,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle1
                                                          ?.copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .fontColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              letterSpacing:
                                                                  0.5,
                                                              fontSize: 12)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              selectedChannelName =
                                                  channelList[index].channelId!;
                                              selectedChannelImg =
                                                  channelList[index]
                                                      .channel_image!;
                                              Navigator.of(context).pop();
                                              Navigator.of(context)
                                                  .pushNamedAndRemoveUntil(
                                                      "/home",
                                                      (Route<dynamic> route) =>
                                                          false);
                                            });
                                          },
                                        ),
                                      )),
                                ],
                              ),
                            )),
                      ],
                    ),
                  );
                }))
        : Padding(
            padding: EdgeInsets.only(top: kToolbarHeight),
            child: CircularProgressIndicator());
  }

  Widget weatherDataView() {
    DateTime now = DateTime.now();
    String day = DateFormat('EEEE').format(now);
    return !weatherLoad
        ? Container(
            padding: EdgeInsets.all(15.0),
            height: 110,
            //width: deviceWidth,
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
            child: Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      getTranslated(context, 'weather_lbl')!,
                      style:
                          Theme.of(this.context).textTheme.subtitle2?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .fontColor
                                    .withOpacity(0.8),
                              ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                    weatherData != null
                        ? Row(
                            children: <Widget>[
                              Image.network(
                                "https:${weatherData!.icon!}",
                                width: 40.0,
                                height: 40.0,
                              ),
                              Padding(
                                  padding:
                                      EdgeInsetsDirectional.only(start: 7.0),
                                  child: Text(
                                    "${weatherData!.tempC!.toString()}\u2103",
                                    style: Theme.of(this.context)
                                        .textTheme
                                        .headline6
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .fontColor
                                              .withOpacity(0.8),
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    maxLines: 1,
                                  ))
                            ],
                          )
                        : Container()
                  ],
                ),
                Spacer(),
                weatherData != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            "${weatherData!.name!},${weatherData!.region!},${weatherData!.country!}",
                            style: Theme.of(this.context)
                                .textTheme
                                .subtitle2
                                ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.fontColor,
                                    fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 1,
                          ),
                          Padding(
                              padding: EdgeInsetsDirectional.only(top: 3.0),
                              child: Text(
                                day,
                                style: Theme.of(this.context)
                                    .textTheme
                                    .caption
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .fontColor
                                          .withOpacity(0.8),
                                    ),
                              )),
                          Padding(
                              padding: EdgeInsetsDirectional.only(top: 3.0),
                              child: Text(
                                weatherData!.text!,
                                style: Theme.of(this.context)
                                    .textTheme
                                    .caption
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .fontColor
                                          .withOpacity(0.8),
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              )),
                          Padding(
                              padding: EdgeInsetsDirectional.only(top: 3.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.arrow_upward_outlined,
                                      size: 13.0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .fontColor),
                                  Text(
                                    "H:${weatherData!.maxTempC!.toString()}\u2103",
                                    style: Theme.of(this.context)
                                        .textTheme
                                        .caption
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .fontColor
                                              .withOpacity(0.8),
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                  ),
                                  Padding(
                                      padding: EdgeInsetsDirectional.only(
                                          start: 8.0),
                                      child: Icon(Icons.arrow_downward_outlined,
                                          size: 13.0,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .fontColor)),
                                  Text(
                                    "L:${weatherData!.minTempC!.toString()}\u2103",
                                    style: Theme.of(this.context)
                                        .textTheme
                                        .caption
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .fontColor
                                              .withOpacity(0.8),
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                  ),
                                ],
                              ))
                        ],
                      )
                    : Container()
              ],
            ))
        : weatherShimmer();
  }

  weatherShimmer() {
    return Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(0.4),
        highlightColor: Colors.grey.withOpacity(0.4),
        child: Container(
          height: 98,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Theme.of(context).colorScheme.lightColor,
          ),
        ));
  }

  //get live news video
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
    } else
      setSnackbar(getTranslated(context, 'internetmsg')!);
  }

  getLiveTv() {
    String width = (MediaQuery.of(context).size.width * 2.7).toString();
    if (isliveNews[0][TYPE] == "url_youtube") {
      _yc = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(isliveNews[0]["url"])!,
        flags: YoutubePlayerFlags(
          autoPlay: false,
          isLive: true,
        ),
      );
    } else {
      flickManager = FlickManager(
          videoPlayerController:
              VideoPlayerController.network(isliveNews[0]["url"]),
          autoPlay: false);
    }
    print(isliveNews[0]["url"]);
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Container(
        // padding: EdgeInsets.all(8),
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(10),
        //   color: Colors.grey.withOpacity(0.1),
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  showLiveTv = false;
                });
              },
              child: Container(
                child: Icon(
                  Icons.cancel,
                  color: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(
                  start: 0.0, end: 0.0, top: 5.0, bottom: 10.0),
              child: _isNetworkAvail
                  ? isliveNews[0][TYPE] == "url_youtube"
                      ? YoutubePlayerBuilder(
                          player: YoutubePlayer(
                            controller: _yc!,
                          ),
                          builder: (context, player) {
                            return Center(child: player);
                          })
                      : Container(
                          color: Colors.transparent,
                          height: 205,
                          child: WebView(
                            onProgress: (progress) {},
                            initialUrl: Uri.dataFromString(
                                    '<html><body><iframe height="600" width="$width" src="${isliveNews[0]["url"]}" allow="autoplay"></iframe></body></html>',
                                    mimeType: 'text/html')
                                .toString(),
                            javascriptMode: JavascriptMode.unrestricted,
                          ))
                  : Center(child: Text(getTranslated(context, 'internetmsg')!)),
            ),
          ],
        ),
      ),
    );
  }
  // getLiveTv() {
  //   // flickManager = FlickManager(
  //   //     videoPlayerController:
  //   //         VideoPlayerController.network('https://vimeo.com/event/1756042'),
  //   // autoPlay: false);
  //   // return Padding(
  //   //   padding: const EdgeInsets.only(top: 0),
  //   //   child: Container(
  //   //     // padding: EdgeInsets.all(8),
  //   //     // decoration: BoxDecoration(
  //   //     //   borderRadius: BorderRadius.circular(10),
  //   //     //   color: Colors.grey.withOpacity(0.1),
  //   //     // ),
  //   //     child: Column(
  //   //       crossAxisAlignment: CrossAxisAlignment.end,
  //   //       children: [
  //   //         GestureDetector(
  //   //           onTap: () {
  //   //             setState(() {
  //   //               showLiveTv = false;
  //   //             });
  //   //           },
  //   //           child: Container(
  //   //             child: Icon(
  //   //               Icons.cancel,
  //   //               color: Colors.grey,
  //   //             ),
  //   //           ),
  //   //         ),
  //   //         Padding(
  //   //           padding: EdgeInsetsDirectional.only(
  //   //               start: 3.0, end: 3.0, top: 5.0, bottom: 10.0),
  //   //           child: _isNetworkAvail
  //   //               ? FlickVideoPlayer(flickManager: flickManager!)
  //   //               : Center(child: Text(getTranslated(context, 'internetmsg')!)),
  //   //         ),
  //   //       ],
  //   //     ),
  //   //   ),
  //   // );
  //   String width = (MediaQuery.of(context).size.width * 2.7).toString();
  //   return Container(
  //       color: Colors.transparent,
  //       height: 232,
  //       child: WebView(
  //         initialUrl: Uri.dataFromString(
  //                 '<html><body><iframe height="600" width="${width}" src="https://metrotvnetwork.livebox.co.in/livebox/player/?chnl=metromumbai" allow="autoplay"></iframe></body></html>',
  //                 mimeType: 'text/html')
  //             .toString(),
  //         javascriptMode: JavascriptMode.unrestricted,
  //       ));
  // }

  Widget liveWithSearchView() {
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

  updateHome() {
    setState(() {});
  }

  loadWeather() async {
    loc.LocationData locationData;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled!) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    locationData = await _location.getLocation();

    error = null;

    final lat = locationData.latitude;
    final lon = locationData.longitude;
    final weatherResponse = await http.get(Uri.parse(
        'https://api.weatherapi.com/v1/forecast.json?key=d0f2f4dbecc043e78d6123135212408&q=${lat.toString()},${lon.toString()}&days=1&aqi=no&alerts=no'));

    if (weatherResponse.statusCode == 200) {
      if (this.mounted)
        return setState(() {
          weatherData =
              new WeatherData.fromJson(jsonDecode(weatherResponse.body));
          weatherLoad = false;
        });
    }

    setState(() {
      weatherLoad = false;
    });
  }

  Widget viewBreakingNews() {
    return Padding(
        padding: EdgeInsetsDirectional.only(
          top: 15.0,
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsetsDirectional.only(start: 0.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Text(
                      getTranslated(context, 'breakingNews_lbl')!,
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: Theme.of(context).colorScheme.lightColor,
                          fontWeight: FontWeight.w600),
                    ),
                  )),
              _isBreakLoading
                  ? newsShimmer()
                  : breakingNewsList.length == 0
                      ? Center(
                          child: Text(
                              getTranslated(context, 'breaking_not_avail')!,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .fontColor
                                          .withOpacity(0.8))))
                      : SizedBox(
                          height: 250.0 * (9 / 16) + 75,
                          child: ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: breakingNewsList.length,
                            itemBuilder: (context, index) {
                              return breakingNewsItem(index);
                            },
                          ))
            ]));
  }

  Widget viewEvents() {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        top: 15.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //     padding: EdgeInsetsDirectional.only(start: 8.0),
          //     child: Container(
          //       decoration: BoxDecoration(
          //         color: Colors.red,
          //         borderRadius: BorderRadius.circular(5),
          //       ),
          //       padding: EdgeInsets.all(8),
          //       child: Text(
          //         getTranslated(context, 'breakingNews_lbl')!,
          //         style: Theme.of(context).textTheme.subtitle1?.copyWith(
          //             color: Theme.of(context).colorScheme.lightColor,
          //             fontWeight: FontWeight.w600),
          //       ),
          //     )),
          isEventLoading
              ? contentShimmer(context)
              : eventsList.length == 0
                  ? Center(
                      child: Text('No Events',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .fontColor
                                      .withOpacity(0.8))))
                  : ListView.builder(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: eventCatList.length,
                      itemBuilder: (context, index) {
                        List<EventsModel> tEvents = [];
                        eventsList.forEach((e) {
                          e.category_id == eventCatList[index].id
                              ? tEvents.add(e)
                              : null;
                        });
                        return Container(
                          height: 275,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, bottom: 0),
                                child: Text(
                                  eventCatList[index].event_category_name,
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 250.0,
                                child: ListView.builder(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: tEvents.length,
                                  itemBuilder: (context, index) {
                                    return eventsItem(tEvents[index]);
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        );
                      }),
        ],
      ),
    );
  }

  Widget viewRecentContent() {
    return Padding(
        padding: EdgeInsetsDirectional.only(
          top: 15.0,
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(start: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Text(
                    getTranslated(context, 'recentNews_lbl')!,
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: Theme.of(context).colorScheme.lightColor,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              _isRecentLoading
                  ? newsShimmer()
                  : recentNewsList.length == 0
                      ? Center(
                          child: Text(getTranslated(context, 'recent_no_news')!,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .fontColor
                                          .withOpacity(0.8))))
                      : SizedBox(
                          height: 250.0,
                          child: ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            controller: controller,
                            itemCount: (offsetRecent < totalRecent)
                                ? recentNewsList.length + 1
                                : recentNewsList.length,
                            itemBuilder: (context, index) {
                              return (index == recentNewsList.length &&
                                      _isRecentLoadMore)
                                  ? Center(child: CircularProgressIndicator())
                                  : recentNewsItem(index);
                            },
                          ))
            ]));
  }

  Widget viewUserNewsContent() {
    return Padding(
        padding: EdgeInsetsDirectional.only(
          top: 15.0,
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsetsDirectional.only(start: 8.0),
                  child: Text(
                    getTranslated(context, 'forYou_lbl')!,
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .fontColor
                            .withOpacity(0.9),
                        fontWeight: FontWeight.w600),
                  )),
              _isUserLoading
                  ? newsShimmer()
                  : userNewsList.length == 0
                      ? Center(
                          child: Text(userNews_not_avail,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .fontColor
                                          .withOpacity(0.8))))
                      : SizedBox(
                          height: 250.0,
                          child: ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            controller: controller1,
                            itemCount: (offsetUser < totalUser)
                                ? userNewsList.length + 1
                                : userNewsList.length,
                            itemBuilder: (context, index) {
                              return (index == userNewsList.length &&
                                      _isUserLoadMore)
                                  ? Center(child: CircularProgressIndicator())
                                  : userNewsItem(index);
                            },
                          ))
            ]));
  }

  Widget catText() {
    return Padding(
        padding: EdgeInsetsDirectional.only(top: 20.0, bottom: 20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                flex: 2,
                child: Divider(
                  color:
                      Theme.of(context).colorScheme.fontColor.withOpacity(0.7),
                  endIndent: 20,
                  thickness: 1.0,
                )),
            Text(
              getTranslated(context, 'category_lbl')!,
              style: Theme.of(context).textTheme.subtitle1?.merge(TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .fontColor
                        .withOpacity(0.7),
                  )),
            ),
            Expanded(
                flex: 7,
                child: Divider(
                  color:
                      Theme.of(context).colorScheme.fontColor.withOpacity(0.7),
                  indent: 20,
                  thickness: 1.0,
                )),
          ],
        ));
  }

  newsShimmer() {
    return Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(0.6),
        highlightColor: Colors.grey,
        child: SingleChildScrollView(
          //padding: EdgeInsetsDirectional.only(start: 5.0, top: 20.0),
          scrollDirection: Axis.horizontal,
          child: Row(
              children: [0, 1, 2, 3, 4, 5, 6]
                  .map((i) => Padding(
                      padding: EdgeInsetsDirectional.only(
                          top: 15.0, start: i == 0 ? 0 : 6.0),
                      child: Stack(children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.grey.withOpacity(0.6)),
                          height: 240.0,
                          width: 195.0,
                        ),
                        Positioned.directional(
                            textDirection: Directionality.of(context),
                            bottom: 7.0,
                            start: 7,
                            end: 7,
                            height: 99,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.grey,
                              ),
                            )),
                      ])))
                  .toList()),
        ));
  }

  recentNewsItem(int index) {
    List<String> tagList = [];
    DateTime time1 = DateTime.parse(recentNewsList[index].date!);
    if (recentNewsList[index].tagName! != "") {
      final tagName = recentNewsList[index].tagName!;
      tagList = tagName.split(',');
    }

    List<String> tagId = [];

    if (recentNewsList[index].tagId! != "") {
      tagId = recentNewsList[index].tagId!.split(",");
    }

    allImage.clear();

    allImage.add(recentNewsList[index].image!);
    if (recentNewsList[index].imageDataList!.length != 0) {
      for (int i = 0; i < recentNewsList[index].imageDataList!.length; i++) {
        allImage.add(recentNewsList[index].imageDataList![i].otherImage!);
      }
    }

    return Padding(
      padding:
          EdgeInsetsDirectional.only(top: 15.0, start: index == 0 ? 0 : 6.0),
      child: InkWell(
        child: Stack(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: FadeInImage.assetNetwork(
                  image: recentNewsList[index].image!,
                  height: 250.0,
                  width: 193.0,
                  fit: BoxFit.cover,
                  placeholder: placeHolder,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return errorWidget(250, 193);
                  },
                )),
            Positioned.directional(
                textDirection: Directionality.of(context),
                bottom: 7.0,
                start: 7,
                end: 7,
                height: 99,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
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
                                        fontSize: 10.0),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    recentNewsList[index].title!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        ?.copyWith(
                                            color: colors.tempfontColor1
                                                .withOpacity(0.9),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12.5,
                                            height: 1.0),
                                    maxLines: 3,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(top: 4.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      recentNewsList[index].tagName! != ""
                                          ? SizedBox(
                                              height: 16.0,
                                              child: ListView.builder(
                                                  physics:
                                                      AlwaysScrollableScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  shrinkWrap: true,
                                                  itemCount: tagList.length >= 2
                                                      ? 2
                                                      : tagList.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .only(
                                                                    start: index ==
                                                                            0
                                                                        ? 0
                                                                        : 1.5),
                                                        child: InkWell(
                                                          child: Container(
                                                              height: 16.0,
                                                              width: 45,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              padding: EdgeInsetsDirectional
                                                                  .only(
                                                                      start:
                                                                          3.0,
                                                                      end: 3.0,
                                                                      top: 2.5,
                                                                      bottom:
                                                                          2.5),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            3.0),
                                                                color: colors
                                                                    .primary
                                                                    .withOpacity(
                                                                        0.08),
                                                              ),
                                                              child: Text(
                                                                tagList[index],
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyText2
                                                                    ?.copyWith(
                                                                      color: colors
                                                                          .primary,
                                                                      fontSize:
                                                                          9.5,
                                                                    ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                softWrap: true,
                                                              )),
                                                          onTap: () async {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          NewsTag(
                                                                    tadId: tagId[
                                                                        index],
                                                                    tagName:
                                                                        tagList[
                                                                            index],
                                                                    updateParent:
                                                                        updateHomePage,
                                                                  ),
                                                                ));
                                                          },
                                                        ));
                                                  }))
                                          : Container(),
                                      Spacer(),
                                      InkWell(
                                        child: SvgPicture.asset(
                                          bookMarkValue.contains(
                                                  recentNewsList[index].id)
                                              ? "assets/images/bookmarkfilled_icon.svg"
                                              : "assets/images/bookmark_icon.svg",
                                          semanticsLabel: 'bookmark icon',
                                          height: 14,
                                          width: 14,
                                        ),
                                        onTap: () async {
                                          _isNetworkAvail =
                                              await isNetworkAvailable();
                                          if (CUR_USERID != "") {
                                            if (_isNetworkAvail) {
                                              setState(() {
                                                bookMarkValue.contains(
                                                        recentNewsList[index]
                                                            .id!)
                                                    ? _setBookmark(
                                                        "0",
                                                        recentNewsList[index]
                                                            .id!)
                                                    : _setBookmark(
                                                        "1",
                                                        recentNewsList[index]
                                                            .id!);
                                              });
                                            } else {
                                              setSnackbar(getTranslated(
                                                  context, 'internetmsg')!);
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
                                                    builder: (BuildContext
                                                            context) =>
                                                        RequestOtp()));
                                          }
                                        },
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.only(
                                            start: 8.0),
                                        child: InkWell(
                                          child: SvgPicture.asset(
                                            "assets/images/share_icon.svg",
                                            semanticsLabel: 'share icon',
                                            height: 13,
                                            width: 13,
                                          ),
                                          onTap: () async {
                                            _isNetworkAvail =
                                                await isNetworkAvailable();
                                            if (_isNetworkAvail) {
                                              createDynamicLink(
                                                  recentNewsList[index].id!,
                                                  index,
                                                  recentNewsList[index].title!);
                                            } else {
                                              setSnackbar(getTranslated(
                                                  context, 'internetmsg')!);
                                            }
                                          },
                                        ),
                                      )
                                    ],
                                  ))
                            ],
                          ),
                        )))),
            Positioned.directional(
                textDirection: Directionality.of(context),
                bottom: (250 - 80) / 2,
                start: 190 - 65,
                child: InkWell(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(40.0),
                      child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            height: 40,
                            width: 40,
                            padding: EdgeInsets.all(10.5),
                            decoration: BoxDecoration(
                                color: colors.tempboxColor.withOpacity(0.7),
                                shape: BoxShape.circle),
                            child: SvgPicture.asset(
                              recentNewsList[index].like == "1"
                                  ? "assets/images/likefilled_button.svg"
                                  : "assets/images/Like_icon.svg",
                              semanticsLabel: 'like icon',
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
                          if (recentNewsList[index].like == "1") {
                            _setLikesDisLikes(
                                "0", recentNewsList[index].id!, index, 1);

                            setState(() {});
                          } else {
                            _setLikesDisLikes(
                                "1", recentNewsList[index].id!, index, 1);
                            setState(() {});
                          }
                        } else {
                          setSnackbar(getTranslated(context, 'internetmsg')!);
                        }
                      } else {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => Login(),
                        // ));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    RequestOtp()));
                      }
                    }
                  },
                ))
          ],
        ),
        onTap: () {
          News model = recentNewsList[index];
          List<News> recList = [];
          recList.addAll(recentNewsList);
          recList.removeAt(index);
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
        },
      ),
    );
  }

  userNewsItem(int index) {
    List<String> tagList = [];
    DateTime time1 = DateTime.parse(userNewsList[index].date!);
    if (userNewsList[index].tagName! != "") {
      final tagName = userNewsList[index].tagName!;
      tagList = tagName.split(',');
    }

    List<String> tagId = [];

    if (userNewsList[index].tagId! != "") {
      tagId = userNewsList[index].tagId!.split(",");
    }

    allImage.clear();

    allImage.add(userNewsList[index].image!);
    if (userNewsList[index].imageDataList!.length != 0) {
      for (int i = 0; i < userNewsList[index].imageDataList!.length; i++) {
        allImage.add(userNewsList[index].imageDataList![i].otherImage!);
      }
    }

    return Padding(
      padding:
          EdgeInsetsDirectional.only(top: 15.0, start: index == 0 ? 0 : 6.0),
      child: InkWell(
        child: Stack(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: FadeInImage.assetNetwork(
                  image: userNewsList[index].image!,
                  height: 250.0,
                  width: 193.0,
                  fit: BoxFit.cover,
                  placeholder: placeHolder,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return errorWidget(250, 193);
                  },
                )),
            Positioned.directional(
                textDirection: Directionality.of(context),
                bottom: 7.0,
                start: 7,
                end: 7,
                height: 99,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
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
                                        fontSize: 10.0),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    userNewsList[index].title!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        ?.copyWith(
                                            color: colors.tempfontColor1
                                                .withOpacity(0.9),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12.5,
                                            height: 1.0),
                                    maxLines: 3,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(top: 4.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      userNewsList[index].tagName! != ""
                                          ? SizedBox(
                                              height: 16.0,
                                              child: ListView.builder(
                                                  physics:
                                                      AlwaysScrollableScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  shrinkWrap: true,
                                                  itemCount: tagList.length >= 2
                                                      ? 2
                                                      : tagList.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .only(
                                                                    start: index ==
                                                                            0
                                                                        ? 0
                                                                        : 1.5),
                                                        child: InkWell(
                                                          child: Container(
                                                              height: 16.0,
                                                              width: 45,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              padding: EdgeInsetsDirectional
                                                                  .only(
                                                                      start:
                                                                          3.0,
                                                                      end: 3.0,
                                                                      top: 2.5,
                                                                      bottom:
                                                                          2.5),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            3.0),
                                                                color: colors
                                                                    .primary
                                                                    .withOpacity(
                                                                        0.08),
                                                              ),
                                                              child: Text(
                                                                tagList[index],
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyText2
                                                                    ?.copyWith(
                                                                      color: colors
                                                                          .primary,
                                                                      fontSize:
                                                                          9.5,
                                                                    ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                softWrap: true,
                                                              )),
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          NewsTag(
                                                                    tadId: tagId[
                                                                        index],
                                                                    tagName:
                                                                        tagList[
                                                                            index],
                                                                    updateParent:
                                                                        updateHomePage,
                                                                  ),
                                                                ));
                                                          },
                                                        ));
                                                  }))
                                          : Container(),
                                      Spacer(),
                                      InkWell(
                                        child: SvgPicture.asset(
                                          bookMarkValue.contains(
                                                  userNewsList[index].id)
                                              ? "assets/images/bookmarkfilled_icon.svg"
                                              : "assets/images/bookmark_icon.svg",
                                          semanticsLabel: 'bookmark icon',
                                          height: 14,
                                          width: 14,
                                        ),
                                        onTap: () async {
                                          _isNetworkAvail =
                                              await isNetworkAvailable();
                                          if (CUR_USERID != "") {
                                            if (_isNetworkAvail) {
                                              setState(() {
                                                bookMarkValue.contains(
                                                        userNewsList[index].id!)
                                                    ? _setBookmark("0",
                                                        userNewsList[index].id!)
                                                    : _setBookmark(
                                                        "1",
                                                        userNewsList[index]
                                                            .id!);
                                              });
                                            } else {
                                              setSnackbar(getTranslated(
                                                  context, 'internetmsg')!);
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
                                                    builder: (BuildContext
                                                            context) =>
                                                        RequestOtp()));
                                          }
                                        },
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.only(
                                            start: 8.0),
                                        child: InkWell(
                                          child: SvgPicture.asset(
                                            "assets/images/share_icon.svg",
                                            semanticsLabel: 'share icon',
                                            height: 13,
                                            width: 13,
                                          ),
                                          onTap: () async {
                                            _isNetworkAvail =
                                                await isNetworkAvailable();
                                            if (_isNetworkAvail) {
                                              createDynamicLink(
                                                  userNewsList[index].id!,
                                                  index,
                                                  userNewsList[index].title!);
                                            } else {
                                              setSnackbar(getTranslated(
                                                  context, 'internetmsg')!);
                                            }
                                          },
                                        ),
                                      )
                                    ],
                                  ))
                            ],
                          ),
                        )))),
            Positioned.directional(
                textDirection: Directionality.of(context),
                bottom: (250 - 80) / 2,
                start: 190 - 65,
                child: InkWell(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(40.0),
                      child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            height: 40,
                            width: 40,
                            padding: EdgeInsets.all(10.5),
                            decoration: BoxDecoration(
                                color: colors.tempboxColor.withOpacity(0.7),
                                shape: BoxShape.circle),
                            child: SvgPicture.asset(
                              userNewsList[index].like == "1"
                                  ? "assets/images/likefilled_button.svg"
                                  : "assets/images/Like_icon.svg",
                              semanticsLabel: 'like icon',
                            ),
                          ))),
                  onTap: () async {
                    _isNetworkAvail = await isNetworkAvailable();

                    if (CUR_USERID != "") {
                      if (_isNetworkAvail) {
                        if (userNewsList[index].like == "1") {
                          _setLikesDisLikes(
                              "0", userNewsList[index].id!, index, 2);
                          setState(() {});
                        } else {
                          _setLikesDisLikes(
                              "1", userNewsList[index].id!, index, 2);
                          setState(() {});
                        }
                      } else {
                        setSnackbar(getTranslated(context, 'internetmsg')!);
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
                              builder: (BuildContext context) => RequestOtp()));
                    }
                  },
                ))
          ],
        ),
        onTap: () {
          News model = userNewsList[index];
          List<News> usList = [];
          usList.addAll(userNewsList);
          usList.removeAt(index);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => NewsDetails(
                    model: model,
                    index: index,
                    updateParent: updateHomePage,
                    id: model.id,
                    isFav: false,
                    isDetails: true,
                    news: usList,
                  )));
        },
      ),
    );
  }

  breakingNewsItem(int index) {
    return Padding(
      padding:
          EdgeInsetsDirectional.only(top: 15.0, start: index == 0 ? 0 : 6.0),
      child: InkWell(
        child: Stack(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: FadeInImage.assetNetwork(
                  image: breakingNewsList[index].image!,
                  height: 250.0 * (9 / 16),
                  width: 250.0,
                  fit: BoxFit.cover,
                  placeholder: placeHolder,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return errorWidget(250, 193);
                  },
                )),
            Positioned.directional(
                textDirection: Directionality.of(context),
                bottom: 0.0,
                start: 0,
                end: 0,
                height: 62,
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                breakingNewsList[index].title!,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    ?.copyWith(
                                        color: colors.tempfontColor1
                                            .withOpacity(0.9),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.5,
                                        height: 1.0),
                                maxLines: 3,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        )))),
          ],
        ),
        onTap: () {
          BreakingNewsModel model = breakingNewsList[index];
          List<BreakingNewsModel> tempBreak = [];
          tempBreak.addAll(breakingNewsList);
          tempBreak.removeAt(index);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => NewsDetails(
                    model1: model,
                    index: index,
                    updateParent: updateHomePage,
                    id: model.id,
                    isFav: false,
                    isDetails: false,
                    news1: tempBreak,

                    // updateHome: updateHome,
                  )));
        },
      ),
    );
  }

  eventsItem(EventsModel eventsModel) {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 10.0, start: 15, end: 15),
      child: InkWell(
        child: Stack(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: FadeInImage.assetNetwork(
                  image: eventsModel.image!,
                  height: 250.0,
                  width: 193.0,
                  fit: BoxFit.cover,
                  placeholder: placeHolder,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return errorWidget(250, 193);
                  },
                )),
            Positioned.directional(
                textDirection: Directionality.of(context),
                bottom: 0.0,
                start: 0,
                end: 0,
                height: 62,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: colors.tempboxColor.withOpacity(0.85),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                eventsModel.title!,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    ?.copyWith(
                                        color: colors.tempfontColor1
                                            .withOpacity(0.9),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.5,
                                        height: 1.0),
                                maxLines: 3,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        )))),
          ],
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  EventDetail(model: eventsModel)));
        },
      ),
    );
  }

//set likes of news using api
  _setLikesDisLikes(String status, String id, int index, int from) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      var param = {
        ACCESS_KEY: access_key,
        USER_ID: CUR_USERID,
        NEWS_ID: id,
        STATUS: status,
      };

      http.Response response = await http
          .post(Uri.parse(setLikesDislikesApi), body: param, headers: headers)
          .timeout(Duration(seconds: timeOut));

      var getdata = json.decode(response.body);

      String error = getdata["error"];

      String msg = getdata["message"];

      if (error == "false") {
        if (status == "1") {
          if (from == 1) {
            recentNewsList[index].like = "1";
            recentNewsList[index].totalLikes =
                (int.parse(recentNewsList[index].totalLikes!) + 1).toString();
          } else {
            userNewsList[index].like = "1";
            userNewsList[index].totalLikes =
                (int.parse(userNewsList[index].totalLikes!) + 1).toString();
          }
          setSnackbar(getTranslated(context, 'like_succ')!);
        } else if (status == "0") {
          if (from == 1) {
            recentNewsList[index].like = "0";
            recentNewsList[index].totalLikes =
                (int.parse(recentNewsList[index].totalLikes!) - 1).toString();
          } else {
            userNewsList[index].like = "0";
            userNewsList[index].totalLikes =
                (int.parse(userNewsList[index].totalLikes!) - 1).toString();
          }
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

//get settings api
  Future<void> getSetting() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        var param = {
          ACCESS_KEY: access_key,
        };
        http.Response response = await http
            .post(Uri.parse(getSettingApi), body: param, headers: headers)
            .timeout(Duration(seconds: timeOut));
        if (response.statusCode == 200) {
          var getData = json.decode(response.body);
          String error = getData["error"];
          if (error == "false") {
            var data = getData["data"];

            category_mode = data[CATEGORY_MODE];
            comments_mode = data[COMM_MODE];
            breakingNews_mode = data[BREAK_NEWS_MODE];
            liveStreaming_mode = data[LIVE_STREAM_MODE];
            subCategory_mode = data[SUBCAT_MODE];
            if (data.toString().contains(FB_REWARDED_ID)) {
              fbRewardedVideoId = data[FB_REWARDED_ID];
            }
            if (data.toString().contains(FB_INTER_ID)) {
              fbInterstitialId = data[FB_INTER_ID];
            }
            if (data.toString().contains(FB_BANNER_ID)) {
              fbBannerId = data[FB_BANNER_ID];
            }
            if (data.toString().contains(FB_NATIVE_ID)) {
              fbNativeUnitId = data[FB_NATIVE_ID];
            }
            if (data.toString().contains(IOS_FB_REWARDED_ID)) {
              iosFbRewardedVideoId = data[IOS_FB_REWARDED_ID];
            }
            if (data.toString().contains(IOS_FB_INTER_ID)) {
              iosFbInterstitialId = data[IOS_FB_INTER_ID];
            }
            if (data.toString().contains(IOS_FB_BANNER_ID)) {
              iosFbBannerId = data[IOS_FB_BANNER_ID];
            }
            if (data.toString().contains(IOS_FB_NATIVE_ID)) {
              iosFbNativeUnitId = data[IOS_FB_NATIVE_ID];
            }
          }
        }
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, 'somethingMSg')!);
      }
    } else {
      setSnackbar(getTranslated(context, 'internetmsg')!);
    }
  }

  //get breaking news data list
  Future<void> getBreakingNews() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        var param = {
          ACCESS_KEY: access_key,
        };
        http.Response response = await http
            .post(Uri.parse(getBreakingNewsApi), body: param, headers: headers)
            .timeout(Duration(seconds: timeOut));
        if (response.statusCode == 200) {
          var getData = json.decode(response.body);
          String error = getData["error"];
          if (error == "false") {
            tempBreakList.clear();
            var data = getData["data"];
            tempBreakList = (data as List)
                .map((data) => new BreakingNewsModel.fromJson(data))
                .toList();

            breakingNewsList.addAll(tempBreakList);

            setState(() {
              _isBreakLoading = false;
            });
          }
        }
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, 'somethingMSg')!);
        setState(() {
          _isBreakLoading = false;
        });
      }
    } else {
      setSnackbar(getTranslated(context, 'internetmsg')!);
      setState(() {
        _isBreakLoading = false;
      });
    }
  }

  _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      if (this.mounted) {
        setState(() {
          _isRecentLoadMore = true;

          if (offsetRecent < totalRecent) getNews();
        });
      }
    }
  }

  _scrollListener1() {
    if (controller1.offset >= controller1.position.maxScrollExtent &&
        !controller1.position.outOfRange) {
      if (this.mounted) {
        setState(() {
          _isUserLoadMore = true;

          if (offsetUser < totalUser) getUserByCatNews();
        });
      }
    }
  }

//get latest news data list
  Future<void> getNews() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        var param = {
          ACCESS_KEY: access_key,
          LIMIT: perPage.toString(),
          OFFSET: offsetRecent.toString(),
          USER_ID: CUR_USERID != "" ? CUR_USERID : "0"
        };

        http.Response response = await http
            .post(Uri.parse(getNewsApi), body: param, headers: headers)
            .timeout(Duration(seconds: timeOut));

        if (response.statusCode == 200) {
          var getData = json.decode(response.body);
          String error = getData["error"];
          if (error == "false") {
            totalUser = int.parse(getData["total"]);
            if ((offsetUser) < totalUser) {
              tempUserNews.clear();
              var data = getData["data"];

              tempUserNews = (data as List)
                  .map((data) => new News.fromJson(data))
                  .toList();

              userNewsList.addAll(tempUserNews);
              offsetUser = offsetUser + perPage;
            }
          } else {
            _isUserLoadMore = false;
          }
          if (mounted)
            setState(() {
              _isUserLoading = false;
            });
        }

        if (response.statusCode == 200) {
          var getData = json.decode(response.body);

          String error = getData["error"];
          if (error == "false") {
            totalRecent = int.parse(getData["total"]);

            if ((offsetRecent) < totalRecent) {
              tempList.clear();
              var data = getData["data"];
              tempList = (data as List)
                  .map((data) => new News.fromJson(data))
                  .toList();
              tempList.forEach((element) {
                element.channel_name == selectedChannelName
                    ? recentNewsList.add(element)
                    : null;
              });
              // recentNewsList.addAll(tempList);

              offsetRecent = offsetRecent + perPage;
            }
          } else {
            _isRecentLoadMore = false;
          }
          if (mounted)
            setState(() {
              _isRecentLoading = false;
            });
        }
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, 'somethingMSg')!);
        setState(() {
          _isRecentLoading = false;
          _isRecentLoadMore = false;
        });
      }
    } else {
      setSnackbar(getTranslated(context, 'internetmsg')!);
      setState(() {
        _isRecentLoading = false;
        _isRecentLoadMore = false;
      });
    }
  }

// get all category using api
  Future<void> getCat() async {
    if (category_mode == "1") {
      _isNetworkAvail = await isNetworkAvailable();
      if (_isNetworkAvail) {
        try {
          var param = {
            ACCESS_KEY: access_key,
          };

          http.Response response = await http
              .post(Uri.parse(getCatApi), body: param, headers: headers)
              .timeout(Duration(seconds: timeOut));
          var getData = json.decode(response.body);

          String error = getData["error"];
          if (error == "false") {
            tempCatList.clear();
            var data = getData["data"];

            tempCatList = (data as List)
                .map((data) => new Category.fromJson(data))
                .toList();
            tempCatList = new List.from(tempCatList.reversed);
            print(selectedChoices);
            selectedChoices.isNotEmpty ? catList.add(tempCatList[0]) : null;

            selectedChoices.isNotEmpty
                ? tempCatList.forEach((element) {
                    print(element);
                    selectedChoices.contains(element.id)
                        ? catList.add(element)
                        : null;
                  })
                : catList.addAll(tempCatList);

            // catList.reversed;
            // print(selectedChoices);

            // catList.addAll(tempCatList);
            for (int i = 0; i < catList.length; i++) {
              if (catList[i].subData!.length != 0) {
                catList[i].subData!.insert(
                    0,
                    SubCategory(
                        id: "0",
                        subCatName:
                            "${getTranslated(context, 'all_lbl')! + "\t" + catList[i].categoryName!}"));
              }
            }

            _tabs.clear();
            this._addInitailTab();
          }
          if (mounted)
            setState(() {
              _isLoading = false;
            });
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
    } else {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

// get all category using api
  Future<void> getEventCat() async {
    if (category_mode == "1") {
      _isNetworkAvail = await isNetworkAvailable();
      if (_isNetworkAvail) {
        try {
          var param = {
            ACCESS_KEY: access_key,
          };

          http.Response response = await http
              .post(Uri.parse(baseUrl + 'get_event_category'),
                  body: param, headers: headers)
              .timeout(Duration(seconds: timeOut));
          var getData = json.decode(response.body);
          print('hhhhhhhhhhh');
          print(getData);

          String error = getData["error"];
          if (error == "false") {
            tempEventCatList.clear();
            var data = getData["data"];

            tempEventCatList = (data as List)
                .map((data) => new EventCategory.fromJson(data))
                .toList();

            eventCatList.addAll(tempEventCatList);

            // catList.reversed;
            // print(selectedChoices);

            // catList.addAll(tempCatList);

          }
          if (mounted)
            setState(() {
              _isLoading = false;
            });
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
    } else {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  Future<void> getChannel() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        var param = {
          ACCESS_KEY: access_key,
          USER_ID: CUR_USERID,
        };

        http.Response response = await http
            .post(Uri.parse(getChanApi), body: param, headers: headers)
            .timeout(Duration(seconds: timeOut));
        var getData = json.decode(response.body);

        String error = getData["error"];
        print(response.body);
        if (error == "false") {
          tempChannelList.clear();
          var data = getData["data"];

          tempChannelList =
              (data as List).map((data) => new Channel.fromJson(data)).toList();
          channelList.addAll(tempChannelList);
          // _tabs.clear();
          // this._addInitailTab();
        }
        if (mounted)
          setState(() {
            _isLoading = false;
          });
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
          http.Response response = await http
              .post(Uri.parse(getBookmarkApi), body: param, headers: headers)
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
              setState(() {
                bookMarkValue.add(bookmarkList[i].newsId);
              });
            }
            if (mounted)
              setState(() {
                _isLoading = false;
              });
          } else {
            setState(() {
              _isLoadingMore = false;
              _isLoading = false;
            });
          }
        } on TimeoutException catch (_) {
          setSnackbar(getTranslated(context, 'somethingMSg')!);
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        setSnackbar(getTranslated(context, 'internetmsg')!);
      }
    }
  }

  Future<void> getEvents() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        var param = {
          ACCESS_KEY: access_key,
        };
        http.Response response = await http
            .post(Uri.parse(getEventsApi), body: param, headers: headers)
            .timeout(Duration(seconds: timeOut));
        if (response.statusCode == 200) {
          var getData = json.decode(response.body);

          String error = getData["error"];
          if (error == "false") {
            tempEventList.clear();
            var data = getData["data"];
            tempEventList = (data as List)
                .map((data) => new EventsModel.fromJson(data))
                .toList();

            eventsList.addAll(tempEventList);

            setState(() {
              isEventLoading = false;
            });
          }
        }
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, 'somethingMSg')!);
        setState(() {
          isEventLoading = false;
        });
      }
    } else {
      setSnackbar(getTranslated(context, 'internetmsg')!);
      setState(() {
        isEventLoading = false;
      });
    }
  }
}
