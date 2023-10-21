import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'package:weather_app/module/home/home_page.dart';
import 'package:weather_app/module/splash/splash_page.dart';

import 'auth_guard.dart';

part 'app_router.gr.dart';

const _kDuration = 300;

class RouteKey {
  static const rootPage = '/root';
  static const homePage = '/homePage';
}

@lazySingleton
@AutoRouterConfig(generateForDir: ['lib'])
class AppRouter extends _$AppRouter implements AutoRouteGuard {
  AppRouter({required AuthGuard authGuard});

  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          initial: true,
          path: RouteKey.rootPage,
          page: SplashRoute.page,
        ),
        AutoRoute(
          path: RouteKey.homePage,
          page: HomeRoute.page,
        ),
        RedirectRoute(path: '*', redirectTo: RouteKey.rootPage),
      ];

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    resolver.next();
  }
}
