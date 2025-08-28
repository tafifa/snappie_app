import 'package:get/get.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/layout/bindings/main_binding.dart';
import '../modules/layout/views/main_layout.dart';
import '../modules/explore/views/place_detail_view.dart';
import '../modules/explore/views/places_view.dart';
import '../modules/explore/views/reviews_view.dart';

class AppPages {
  AppPages._();

  static const INITIAL = '/login';
  static const HOME = '/main';
  static const PLACES = '/places';
  static const PLACE_DETAIL = '/place-detail';
  static const REVIEWS = '/reviews';
  static const PROFILE = '/profile';

  static final routes = [
    GetPage(
      name: '/login',
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: '/main',
      page: () => const MainLayout(),
      binding: MainBinding(),
    ),
    GetPage(
      name: '/place-detail',
      page: () => const PlaceDetailView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: '/places',
      page: () => const PlacesView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: '/reviews',
      page: () => const ReviewsView(),
      binding: MainBinding(),
    ),
  ];
}
