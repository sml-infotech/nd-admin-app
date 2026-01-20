import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  String token = "";
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  String _displayedText = "";
  final String _fullText = "Daiva DashBoard";
  late Timer _timer;
  int _charIndex = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    getResellerData();

    _startTypingAnimation();

    Timer(Duration(seconds: 3), () {
      var routeToNavigate = StringsRoute.login;
      if (token.isNotEmpty) {
        routeToNavigate = StringsRoute.dashboard;
      }
      Navigator.pushNamedAndRemoveUntil(
        context,
        routeToNavigate,
        (route) => false,
      );
    });
  }

  Future<void> getResellerData() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('authToken') ?? "";
  }

  void _startTypingAnimation() {
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (_charIndex < _fullText.length) {
        setState(() {
          _displayedText += _fullText[_charIndex];
          _charIndex++;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(ImageStrings.loginImage, width: 120),
              SizedBox(height: 16),
              Text(
                _displayedText,
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: font,
                  fontWeight: FontWeight.bold,
                  color: ColorConstant.buttonColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
