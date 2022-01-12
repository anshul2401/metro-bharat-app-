// ignore_for_file: file_names

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:news_app/RequestOtp.dart';
import 'dart:math' as math;

import 'Helper/Color.dart';
import 'Helper/Session.dart';
import 'Helper/String.dart';
import 'Helper/colors.dart';
import 'Helper/size_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Login.dart';

//slide class
class Slide {
  final String? imageUrl;
  final String? title;
  final String? description;

  Slide({
    @required this.imageUrl,
    @required this.title,
    @required this.description,
  });
}

class IntroSliderScreen extends StatefulWidget {
  @override
  _GettingStartedScreenState createState() => _GettingStartedScreenState();
}

class _GettingStartedScreenState extends State<IntroSliderScreen>
    with TickerProviderStateMixin {
  late AnimationController buttonController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 400));
  late Animation<double> buttonSqueezeanimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: buttonController, curve: Curves.easeInOut));

  late AnimationController circleAnimationController =
      AnimationController(vsync: this, duration: Duration(seconds: 500))
        ..forward();
  late Animation<double> circleAnimation =
      Tween<double>().animate(CurvedAnimation(
    parent: circleAnimationController,
    curve: Curves.easeInCubic,
  ));

  late AnimationController imageSlideAnimationController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 500))
        ..repeat(reverse: true);
  late Animation<Offset> imageSlideAnimation =
      Tween<Offset>(begin: Offset.zero, end: Offset(0.0, -0.025)).animate(
          CurvedAnimation(
              parent: imageSlideAnimationController, curve: Curves.easeInOut));

  late AnimationController pageIndicatorAnimationController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  late Tween<Alignment> pageIndicator =
      AlignmentTween(begin: Alignment.centerLeft, end: Alignment.centerLeft);
  late Animation<Alignment> pageIndicatorAnimation = pageIndicator.animate(
      CurvedAnimation(
          parent: pageIndicatorAnimationController, curve: Curves.easeInOut));
  late AnimationController animationController;
  late Animation animation;

  late AnimationController animationController1;
  late Animation animation1;

  late AnimationController animationController2;
  late Animation animation2;
  late List<Slide> slideList = [
    Slide(
      imageUrl: 'assets/images/img_5.png',
      title: getTranslated(context, 'wel_title1')!,
      description: getTranslated(context, 'wel_des1')!,
    ),
    Slide(
      imageUrl: 'assets/images/img_8.png',
      title: getTranslated(context, 'wel_title2')!,
      description: getTranslated(context, 'wel_des2')!,
    ),
  ];

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      duration: Duration(
        seconds: 2,
      ),
      vsync: this,
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInCubic,
    );
    animationController.addStatusListener(animationStatusListener);
    animationController.forward();

    animationController1 = AnimationController(
      duration: Duration(
        seconds: 2,
      ),
      vsync: this,
    );
    animation1 = CurvedAnimation(
      parent: animationController1,
      curve: Curves.easeInCubic,
    );
    animationController1.addStatusListener(animationStatusListener1);
    animationController1.forward();

    animationController2 = AnimationController(
      duration: Duration(
        seconds: 2,
      ),
      vsync: this,
    );
    animation2 = CurvedAnimation(
      parent: animationController2,
      curve: Curves.easeInCubic,
    );
    animationController2.addStatusListener(animationStatusListener2);
    animationController2.forward();
  }

  @override
  void dispose() {
    buttonController.dispose();
    imageSlideAnimationController.dispose();
    pageIndicatorAnimationController.dispose();
    circleAnimationController.dispose();
    animationController1.dispose();
    animationController.dispose();
    animationController2.dispose();
    super.dispose();
  }

  void animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      animationController.reverse();
    } else if (status == AnimationStatus.dismissed) {
      animationController.forward();
    }
  }

  void animationStatusListener1(AnimationStatus stat) {
    if (stat == AnimationStatus.completed) {
      animationController1.reverse();
    } else if (stat == AnimationStatus.dismissed) {
      animationController1.forward();
    }
  }

  void animationStatusListener2(AnimationStatus stat) {
    if (stat == AnimationStatus.completed) {
      animationController2.reverse();
    } else if (stat == AnimationStatus.dismissed) {
      animationController2.forward();
    }
  }

  void onPageChanged(int index) {
    if (index == 0) {
      buttonController.reverse();
      pageIndicator.begin = pageIndicator.end;
      pageIndicator.end = Alignment.centerLeft;
    } else if (index == 1) {
      buttonController.reverse();
      pageIndicator.begin = pageIndicator.end;
      pageIndicator.end = Alignment.center;
    } else {
      pageIndicator.begin = pageIndicator.end;
      pageIndicator.end = Alignment.centerRight;
      buttonController.forward();
    }
    Future.delayed(Duration.zero, () {
      pageIndicatorAnimationController.forward(from: 0.0);
    });
  }

  Widget _buildPageIndicator() {
    final double widthAndHeight = 10.0;
    final double borderRadius = 7.5;
    return Align(
      alignment: AlignmentDirectional.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * (0.1),
        width: MediaQuery.of(context).size.width * (0.125),
        padding: EdgeInsets.only(
            top: 15, bottom: MediaQuery.of(context).size.height * (0.025)),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: widthAndHeight,
                width: widthAndHeight,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(borderRadius)),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Container(
                height: widthAndHeight,
                width: widthAndHeight,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(borderRadius)),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Container(
                height: widthAndHeight,
                width: widthAndHeight,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(borderRadius)),
              ),
            ),
            AnimatedBuilder(
              animation: pageIndicatorAnimationController,
              builder: (context, child) {
                return Align(
                  alignment: pageIndicatorAnimation.value,
                  child: child,
                );
              },
              child: Container(
                height: widthAndHeight,
                width: widthAndHeight,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(borderRadius)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFilledCircle(double radius, Color color) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: color,
    );
  }

  Widget _buildBorderedCircle(
      double radius, double borderWidth, Color color, double padding) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: borderWidth),
      ),
      padding: EdgeInsets.all(padding),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: radius,
      ),
    );
  }

  Widget _buildIntroSlider() {
    return PageView.builder(
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) {
        return Container(
            padding: EdgeInsetsDirectional.only(
                start: 30.0, top: 30.0, bottom: 60.0, end: 30.0),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .boxColor
                                .withOpacity(0.6)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * (0.14),
                            ),
                            Text(
                              slideList[index].title!,
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.fontColor,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            SlideTransition(
                              position: imageSlideAnimation,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * (0.45),
                                alignment: Alignment.center,
                                child: Image.asset(
                                  slideList[index].imageUrl!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                slideList[index].description!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.fontColor,
                                    fontSize: 19.0),
                              ),
                            ),
                          ],
                        )))));
      },
      itemCount: slideList.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: 100 * AppSizeConfig.heightMultiplier!,
                child: Image.asset('assets/images/img_5.png',
                    fit: BoxFit.fitHeight,
                    height: 100 * AppSizeConfig.heightMultiplier!),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: 8 * AppSizeConfig.heightMultiplier!),
                child: Container(
                  height: 30 * AppSizeConfig.heightMultiplier!,
                  width: 100 * AppSizeConfig.widthMultiplier!,
                  child: Image.asset('assets/images/img_8.png',
                      fit: BoxFit.fitHeight,
                      height: 30 * AppSizeConfig.heightMultiplier!),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 65 * AppSizeConfig.heightMultiplier!,
                    left: 5 * AppSizeConfig.widthMultiplier!),
                child: Text(
                  "All your personalized News in one Destination,",
                  style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 2.5 * AppSizeConfig.textMultiplier!,
                      color: Colors.black),
                ),
              ),
              InkWell(
                onTap: () {
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => Login()),
                  // );
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => RequestOtp()));
                },
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 75 * AppSizeConfig.heightMultiplier!,
                      left: 20 * AppSizeConfig.widthMultiplier!),
                  child: Container(
                    height: 8 * AppSizeConfig.heightMultiplier!,
                    width: 58 * AppSizeConfig.widthMultiplier!,
                    decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(22.0)),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 5 * AppSizeConfig.widthMultiplier!,
                        ),
                        Text(
                          "   Lets get Started,",
                          style: GoogleFonts.openSans(
                              fontWeight: FontWeight.w800,
                              fontSize: 2.1 * AppSizeConfig.textMultiplier!,
                              color: Colors.white),
                        ),
                        SizedBox(
                          width: 4 * AppSizeConfig.widthMultiplier!,
                        ),
                        Icon(
                          Icons.arrow_forward_outlined,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
