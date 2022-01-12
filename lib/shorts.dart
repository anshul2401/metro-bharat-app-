import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news_app/EventVideo.dart';
import 'package:news_app/Helper/Color.dart';
import 'package:news_app/Helper/Session.dart';
import 'package:news_app/Model/Shorts.dart';

import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'Helper/colors.dart';

class ShortsPage extends StatefulWidget {
  const ShortsPage({Key? key}) : super(key: key);

  @override
  _ShortsPageState createState() => _ShortsPageState();
}

class _ShortsPageState extends State<ShortsPage> {
  List<ShortsModel> shorts = [
    ShortsModel(
      id: '0',
      contentType: 'video_upload',
      contentValue:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4',
    ),
    ShortsModel(
      id: '1',
      contentType: 'video_upload',
      contentValue:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    ),
    ShortsModel(
      id: '2',
      contentType: 'video_upload',
      contentValue:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
    ),
    ShortsModel(
      id: '3',
      contentType: 'video_upload',
      contentValue:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    ),
    // ShortsModel(
    //   id: '2',
    //   contentType: 'video_youtube',
    //   contentValue: 'https://www.youtube.com/watch?v=uz4xRnE-UIw',
    // ),
    // ShortsModel(
    //   id: '3',
    //   contentType: 'video_youtube',
    //   contentValue: 'https://www.youtube.com/watch?v=Y3_V7Tcdvyo',
    // ),
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<FlickManager> flickManager = [];
  FlickManager? flickManager1;
  YoutubePlayerController? _yc;
  bool _isNetworkAvail = true;

  @override
  void initState() {
    super.initState();
    checkNet();
    shorts.forEach((element) {
      if (element != "" || element != null) {
        if (element.contentType == "video_upload") {
          flickManager.add(FlickManager(
              videoPlayerController:
                  VideoPlayerController.network(element.contentValue!),
              autoPlay: false));
        } else if (shorts[0].contentType == "video_youtube") {
          _yc = YoutubePlayerController(
            initialVideoId:
                YoutubePlayer.convertUrlToId(shorts[0].contentValue!)!,
            flags: const YoutubePlayerFlags(
              autoPlay: false,
            ),
          );
        } else if (shorts[0].contentType == "video_other") {
          flickManager1 = FlickManager(
              videoPlayerController:
                  VideoPlayerController.network(shorts[0].contentValue!),
              autoPlay: false);
        }
      }
    });
  }

  checkNet() async {
    _isNetworkAvail = await isNetworkAvailable();
  }

  // getS(ShortsModel shorts) {
  //   if (shorts.contentValue != "" || shorts.contentValue != null) {
  //     if (shorts.contentType == "video_upload") {
  //       flickManager = FlickManager(
  //           videoPlayerController:
  //               VideoPlayerController.network(shorts.contentValue!),
  //           autoPlay: false);
  //     } else if (shorts.contentType == "video_youtube") {
  //       _yc = YoutubePlayerController(
  //         initialVideoId: YoutubePlayer.convertUrlToId(shorts.contentValue!)!,
  //         flags: const YoutubePlayerFlags(
  //           autoPlay: false,
  //         ),
  //       );
  //     } else if (shorts.contentType == "video_other") {
  //       flickManager1 = FlickManager(
  //           videoPlayerController:
  //               VideoPlayerController.network(shorts.contentValue!),
  //           autoPlay: false);
  //     }
  //   }
  // }

  // dispost(ShortsModel shortsModel) {
  //   if (shortsModel.contentType == "video_upload") {
  //     flickManager!.dispose();
  //   } else if (shortsModel.contentType == "video_youtube") {
  //     _yc!.dispose();
  //   } else if (shortsModel.contentType == "video_other") {
  //     flickManager1!.dispose();
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
    int index = 0;
    for (var element in shorts) {
      if (element.contentType == "video_upload") {
        flickManager[index].dispose();
      } else if (element.contentType == "video_youtube") {
        _yc!.dispose();
      } else if (element.contentType == "video_other") {
        flickManager1!.dispose();
      }
      index++;
    }
  }

  //news video link set
  viewVideo(ShortsModel shorts, String index) {
    return shorts.contentType == "video_upload"
        ? Container(
            alignment: Alignment.center,
            child:
                FlickVideoPlayer(flickManager: flickManager[int.parse(index)]))
        : shorts.contentType == "video_youtube"
            ? YoutubePlayerBuilder(
                player: YoutubePlayer(
                  controller: _yc!,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.red,
                ),
                builder: (context, player) {
                  return Center(child: player);
                })
            : shorts.contentType == "video_other"
                ? Container(
                    alignment: Alignment.center,
                    child: FlickVideoPlayer(flickManager: flickManager1!))
                : Container();
  }

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: 0);
    return Scaffold(
        body: PageView(
            controller: controller,
            scrollDirection: Axis.vertical,
            children: shorts
                .map((e) => Container(child: viewVideo(e, e.id!)))
                .toList()));
  }
}

// TikTokStyleFullPageScroller(
//         contentSize: shorts.length,
//         swipePositionThreshold: 0.2,
//         // ^ the fraction of the screen needed to scroll
//         swipeVelocityThreshold: 2000,
//         // ^ the velocity threshold for smaller scrolls
//         animationDuration: const Duration(milliseconds: 300),
//         // ^ how long the animation will take
//         onScrollEvent: _handleCallbackEvent,
//         // ^ registering our own function to listen to page changes
//         builder: (BuildContext context, int index) {
//           // getS(shorts[index]);
//           print(index);
//           return Container(
//               color: Colors.white,
//               child: Stack(children: <Widget>[
//                 Padding(
//                   padding: EdgeInsetsDirectional.only(start: 0, end: 0),
//                   child: _isNetworkAvail
//                       ? Container(
//                           alignment: Alignment.center,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10.0)),
//                           child: viewVideo(shorts[index], index))
//                       : Center(
//                           child: Text(getTranslated(context, 'internetmsg')!)),
//                 ),
//                 // Padding(
//                 //     padding: const EdgeInsetsDirectional.only(
//                 //         top: 30.0, start: 10.0),
//                 //     child: Container(
//                 //         height: 30,
//                 //         width: 30,
//                 //         padding: EdgeInsets.all(8.0),
//                 //         decoration: BoxDecoration(
//                 //             color: Theme.of(context).colorScheme.boxColor,
//                 //             boxShadow: [
//                 //               BoxShadow(
//                 //                   blurRadius: 10.0,
//                 //                   offset: const Offset(5.0, 5.0),
//                 //                   color: Theme.of(context)
//                 //                       .colorScheme
//                 //                       .fontColor
//                 //                       .withOpacity(0.1),
//                 //                   spreadRadius: 1.0),
//                 //             ],
//                 //             borderRadius: BorderRadius.circular(6.0)),
//                 //         child: InkWell(
//                 //           onTap: () {
//                 //             Navigator.of(context).pop();
//                 //           },
//                 //           child: SvgPicture.asset(
//                 //             "assets/images/back_icon.svg",
//                 //             semanticsLabel: 'back icon',
//                 //             color: Theme.of(context).colorScheme.fontColor,
//                 //           ),
//                 //         ))),
//               ]));
//         },
//       ),
//     );
//   }

//   void _handleCallbackEvent(ScrollEventType type, {int? currentIndex}) {
//     // _yc!.reset();
//     // setState(() {
//     //   _yc = YoutubePlayerController(
//     //     initialVideoId: YoutubePlayer.convertUrlToId(
//     //         shorts[currentIndex ?? 0].contentValue!)!,
//     //     flags: const YoutubePlayerFlags(
//     //       autoPlay: false,
//     //     ),
//     //   );
//     // });

//     print(
//         "Scroll callback received with data: {type: $type, and index: ${currentIndex ?? 'not given'}}");
//   }