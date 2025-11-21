import 'package:get/get.dart';
import 'package:snappie_app/app/modules/explore/views/place_view.dart';
import 'package:snappie_app/app/modules/profile/views/profile_view.dart';
import 'package:snappie_app/app/modules/profile/views/user_profile_view.dart';
import 'package:snappie_app/app/modules/shared/components/tnc_view.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/shared/layout/views/main_layout.dart';
import '../modules/shared/layout/bindings/main_binding.dart';
import '../modules/explore/views/place_detail_view.dart';
import '../modules/explore/views/reviews_view.dart';
import '../modules/explore/bindings/explore_binding.dart';
import '../modules/shared/components/splash_view.dart';

class AppPages {
  AppPages._();

  static const INITIAL = '/login';

  // Splash and Auth
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const SPLASH = '/splash';
  static const TNC = '/tnc';

  // Home
  static const MAIN = '/main';
  static const POST = '/post';

  // Explore
  static const EXPLORE = '/explore';
  static const PLACES = '/places';
  static const PLACE_DETAIL = '/place-detail';
  static const REVIEWS = '/reviews';

  // Articles
  static const ARTICLES = '/articles';
  static const ARTICLES_DETAIL = '/articles-detail';

  // Profile
  static const PROFILE = '/profile';
  static const USER_PROFILE = '/user-profile'; // Read-only profile untuk navigasi dari widget lain
  static const SETTINGS = '/settings';
  static const EDIT_PROFILE = '/edit-profile';

  static final routes = <GetPage>[
    // Splash (no binding needed)
    GetPage(
      name: SPLASH,
      page: () => const SplashView(),
    ),
    
    // Auth module - dengan AuthBinding
    GetPage(
      name: LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: REGISTER,
      page: () => const RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: TNC,
      page: () => const TncView(),
    ),

    // Home module - MainBinding inject semua tab controllers (Home, Explore, Articles, Profile)
    GetPage(
      name: MAIN,
      page: () => const MainLayout(),
      binding: MainBinding(),
    ),
    GetPage(
      name: POST,
      page: () => const MainLayout(),
      binding: MainBinding(),
    ),

    // Explore detail pages - full screen navigation dari tab explore
    GetPage(
      name: PLACE_DETAIL,
      page: () => const PlaceView(),
      binding: ExploreBinding(),
    ),
    GetPage(
      name: REVIEWS,
      page: () => const ReviewsView(),
      binding: ExploreBinding(),
    ),

    // Profile pages - full screen navigation dari tab profile
    // ProfileController sudah di-inject di MainBinding, jadi tidak perlu binding lagi
    GetPage(
      name: PROFILE,
      page: () => const ProfileView(),
      // Tidak perlu binding karena sudah di MainBinding
    ),
    // UserProfile - read-only profile untuk navigasi dari widget lain (avatar tap, dll)
    // Menggunakan StatefulWidget biasa tanpa controller/binding
    GetPage(
      name: USER_PROFILE,
      page: () => const UserProfileView(),
    ),
    GetPage(
      name: SETTINGS,
      page: () => const ProfileView(), // TODO: Buat SettingsView terpisah
      // Tidak perlu binding karena sudah di MainBinding
    ),
    GetPage(
      name: EDIT_PROFILE,
      page: () => const ProfileView(), // TODO: Buat EditProfileView terpisah
      // Tidak perlu binding karena sudah di MainBinding
    ),
  ];
}