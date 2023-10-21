import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    resolver.next();
  }
}
