import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/app_dependencies.dart';
import 'package:weather_app/assets/icons.dart';
import 'package:weather_app/assets/image_assets.dart';
import 'package:weather_app/assets/style.dart';
import 'package:weather_app/routes/app_router.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with WidgetsBindingObserver {
  Timer? timer;
  int _timeStamp = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timeStamp = DateTime.now().millisecondsSinceEpoch;
      timer = Timer.periodic(const Duration(milliseconds: 4000), (timer) {
        timer.cancel();
        getIt<AppRouter>().pushAndPopUntil(
          const HomeRoute(),
          predicate: (route) => route.settings.name == HomeRoute.name,
        );
      });
    });
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.resumed:
        if (DateTime.now().millisecondsSinceEpoch - _timeStamp >= 4000) {
          timer?.cancel();
          getIt<AppRouter>().pushAndPopUntil(
            const HomeRoute(),
            predicate: (route) => route.settings.name == HomeRoute.name,
          );
        }
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(PNGImage.imgBackground),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageAssets.pngAsset(
            PNGImage.imgLogo,
            fit: BoxFit.contain,
          ),
          Text(
            'Dự báo thời tiết',
            style: text24.bold,
          )
        ],
      ),
    );
  }
}
