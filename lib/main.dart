import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/module/home/bloc/home_bloc.dart';

import 'app_dependencies.dart';
import 'core/global_callback.dart';
import 'routes/app_router.dart';
import 'routes/router_observer.dart';
import 'widget/show_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initApp();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.light, // For Android (dark icons)
    statusBarBrightness: Brightness.dark,
  ));

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final _appRouter = getIt.get<AppRouter>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final transitionBuilder = Platform.isIOS
        ? const PageTransitionsTheme(
            builders: {
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            },
          )
        : const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            },
          );

    return BlocProvider(
      create: (context) => HomeBloc(),
      child: ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, child) {
            return _AutoHideKeyboard(
              child: MaterialApp.router(
                title: 'Weather',
                debugShowCheckedModeBanner: false,
                themeMode: ThemeMode.light,
                theme: ThemeData(
                  pageTransitionsTheme: transitionBuilder,
                  appBarTheme: const AppBarTheme(
                    color: Colors.transparent,
                    elevation: 0,
                    iconTheme: IconThemeData(size: 24),
                    actionsIconTheme: IconThemeData(size: 24),
                    systemOverlayStyle: SystemUiOverlayStyle.dark,
                  ),
                ),
                routeInformationParser: _appRouter.defaultRouteParser(),
                routerDelegate: _appRouter.delegate(
                  navigatorObservers: () => <NavigatorObserver>[
                    HeroController(),
                    RouterObserver(),
                  ],
                ),
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: child ?? const SizedBox.shrink(),
                  );
                },
              ),
            );
          }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      GlobalCallback.instance.onNetworkErrorPopup = (bool pop) async {
        if (_appRouter.current.path == RouteKey.rootPage) return;
        DialogApp.showFailure(
          _appRouter.navigatorKey.currentContext!,
          content: 'Mất kết nối mạng,\nbạn vui lòng kiểm tra lại!',
          barrierDismissible: false,
          largePadding: false,
        );
        if (pop == true) {
          Future.delayed(const Duration(seconds: 3)).then(
            (value) {
              _appRouter.pop();
            },
          );
        }
      };
    });
  }
}

class _AutoHideKeyboard extends StatelessWidget {
  final Widget child;

  const _AutoHideKeyboard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        if (FocusManager.instance.primaryFocus?.hasFocus ?? false) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: child,
    );
  }
}

Future<void> initApp() async {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  HttpOverrides.global = MyHttpOverrides();
  configureInjection();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
