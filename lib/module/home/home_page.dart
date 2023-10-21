import 'dart:developer';
import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weather_app/app_dependencies.dart';
import 'package:weather_app/assets/icons.dart';
import 'package:weather_app/assets/image_assets.dart';
import 'package:weather_app/assets/style.dart';
import 'package:weather_app/domain/entities/weather_model.dart';
import 'package:weather_app/routes/app_router.dart';
import 'package:weather_app/utils/extension/string.dart';
import 'package:weather_app/utils/utils.dart';
import 'package:weather_app/widget/bottom_sheet.dart';

import 'bloc/home_bloc.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  HomeBloc get _homeBloc => context.read<HomeBloc>();
  final TextEditingController _searchController = TextEditingController();
  final onSearching = PublishSubject<String?>();

  @override
  void initState() {
    _homeBloc.add(GetWeatherInfo());
    _searchController.addListener(() {
      if (_searchController.text.isNotEmpty) {
        onSearching.add(_searchController.text);
      }
    });

    onSearching
        .distinct()
        .debounceTime(const Duration(milliseconds: 500))
        .listen(_onSearch);
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  void dispose() {
    _homeBloc.close();
    _searchController.dispose();
    onSearching.close();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _homeBloc.add(GetWeatherInfo());
      _homeBloc.didGoToSettings = false;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _homeBloc,
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state.status == HomeStatus.locationPermissionDenied) {
            _showLocationPermissionBottomSheet(
              title: 'Cấp quyền truy cập vị trí',
              description:
                  'Bạn vui lòng cấp quyền truy cập vị trí trên thiết bị để cập nhật thời tiết theo vị trí của bạn',
              icon: SVGIcons.icLocationGreen,
              onGoToSettings: () {
                openAppSettings();
              },
            );
          }
          if (state.status == HomeStatus.locationServiceDisabled) {
            _showLocationPermissionBottomSheet(
              title: 'Cấp quyền truy cập vị trí',
              description:
                  'Bạn vui lòng cấp quyền truy cập vị trí trên thiết bị để cập nhật thời tiết theo vị trí của bạn',
              icon: SVGIcons.icDeviceSettings,
              onGoToSettings: () async {
                if (Platform.isAndroid) {
                  const AndroidIntent intent = AndroidIntent(
                    action: 'android.settings.LOCATION_SOURCE_SETTINGS',
                  );
                  intent.launch();
                } else {
                  await Geolocator.openLocationSettings();
                }
              },
            );
          }
        },
        builder: (context, state) {
          final data = state.data;
          return Stack(
            children: [
              ImageAssets.pngAsset(
                PNGImage.imgBackground,
                fit: BoxFit.contain,
              ),
              Scaffold(
                backgroundColor: Colors.transparent,
                resizeToAvoidBottomInset: false,
                appBar: _BaseAppBar(
                  childAction: AnimSearchBar(
                    width: context.sWidth - 50.w,
                    textController: _searchController,
                    onSuffixTap: () {
                      log('onSuffixTap =>>>>');
                      onSearching.add(null);
                    },
                    onSubmitted: (value) {
                      onSearching.add(value);
                    },
                  ),
                ),
                body: SafeArea(
                  child: Container(
                    width: context.sWidth,
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    margin: EdgeInsets.only(top: context.sHeight * 0.15),
                    child: state.locationDenied
                        ? Lottie.asset(JsonsImage.jsonLocation)
                        : _body(state, data),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Column _body(HomeState state, WeatherModel? data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        _WeatherDetail(
          temp: state.temp ?? '',
          icon: state.icon ?? '',
        ),
        _CurrentLocationName(data: data),
        if (state.description.isNotNullOrEmpty)
          Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: Text(
              '${state.description}',
              style: text14.medium.whiteColor,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        SizedBox(
          height: 40.h,
        ),
        _DetailToDay(
          humidity: state.humidity,
          wind: state.windSped,
          feelsLike: state.feelsLike,
        ),
      ],
    );
  }

  void _onSearch(String? event) {
    log('_onSearch =>>>> $event');
    _homeBloc.add(GetCoordinatesByLocationName(locationName: event));
  }

  _showLocationPermissionBottomSheet({
    required String title,
    required String description,
    required String icon,
    required VoidCallback onGoToSettings,
  }) async {
    await BottomSheetApp.show(
      context,
      iconBottomSheet: icon,
      isDismissible: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              title,
              style: text16.bold,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              description,
              style: text14,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 34.h, top: 30.h),
            child: _Button(
              onPressed: () {
                getIt.get<AppRouter>().pop();
                onGoToSettings.call();
              },
              backgroundColor: Colors.black,
              textColor: Colors.white,
              showBorder: false,
              child: const Text(
                'Đến cài đặt',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrentLocationName extends StatelessWidget {
  const _CurrentLocationName({
    required this.data,
  });

  final WeatherModel? data;

  @override
  Widget build(BuildContext context) {
    return data?.name.isNotNullOrEmpty == true
        ? Padding(
            padding: EdgeInsets.only(top: 40.h),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ImageAssets.pngAsset(
                  PNGImage.imgLocation,
                  width: 24.sp,
                  height: 24.sp,
                  fit: BoxFit.fill,
                  alignment: Alignment.bottomCenter,
                ),
                SizedBox(
                  width: 4.5.w,
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 5.sp),
                    child: Text(
                      data?.name ?? '',
                      style: text12.whiteColor.medium,
                    ),
                  ),
                )
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}

class _WeatherDetail extends StatelessWidget {
  final String temp;
  final String icon;
  const _WeatherDetail({
    required this.temp,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon.isNotNullOrEmpty)
          Expanded(
            child: ImageAssets.pngAsset(
              icon,
              fit: BoxFit.contain,
            ),
          ),
        Expanded(
          child: Column(
            children: [
              Text(
                'June 07',
                style: text20.bold.whiteColor,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 12.h,
              ),
              if (temp.isNotNullOrEmpty)
                Text(
                  '$tempºC',
                  style: text52.medium.whiteColor,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget childAction;
  const _BaseAppBar({
    required this.childAction,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: childAction,
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _DetailToDay extends StatelessWidget {
  final num humidity;
  final num wind;
  final num feelsLike;

  const _DetailToDay({
    this.humidity = 0,
    this.wind = 0,
    this.feelsLike = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _itemWidget(
          icon: SVGIcons.icHumidity,
          title: 'Độ ẩm',
          value: '${humidity.format()}%',
        ),
        const Spacer(),
        _itemWidget(
          icon: SVGIcons.icWind,
          title: 'Gió',
          value: '${wind.format()}km/h',
        ),
        const Spacer(),
        _itemWidget(
          icon: SVGIcons.icFeelsLike,
          title: 'Cảm nhận',
          value: '${feelsLike.format()}°',
        )
      ],
    );
  }

  _itemWidget({
    required String value,
    required String icon,
    required String title,
  }) {
    return Expanded(
      flex: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageAssets.svgAssets(
            icon,
            width: 30.sp,
            height: 30.sp,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: Text(
              title,
              style: text14.medium.whiteColor,
            ),
          ),
          Text(
            value,
            style: text14.medium.whiteColor,
          ),
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final Function() onPressed;
  final Widget child;
  final Color? backgroundColor;
  final bool showBorder;
  final Color? textColor;
  const _Button({
    required this.onPressed,
    required this.child,
    this.backgroundColor,
    this.showBorder = true,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: Container(
        height: 34.h,
        width: context.sWidth,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          border: showBorder
              ? Border.all(
                  color: Colors.black,
                  width: 1.5.sp,
                )
              : null,
          borderRadius: BorderRadius.circular(8.sp),
        ),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: InkWell(
            onTap: onPressed,
            child: DefaultTextStyle(
              style: text16.bold.copyWith(color: textColor),
              child: Align(widthFactor: 1.0, child: child),
            ),
          ),
        ),
      ),
    );
  }
}
