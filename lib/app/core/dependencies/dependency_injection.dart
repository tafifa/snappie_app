import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../services/auth_service.dart';
import '../../data/datasources/user_local_datasource.dart';
import '../../data/datasources/user_remote_datasource.dart';
import '../../data/datasources/place_remote_datasource.dart';
import '../../data/datasources/place_local_datasource.dart';
import '../../data/datasources/checkin_remote_datasource.dart';
import '../../data/datasources/review_remote_datasource.dart';
import '../../data/datasources/articles_remote_datasource.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/repositories/place_repository_impl.dart';
import '../../data/repositories/checkin_repository_impl.dart';
import '../../data/repositories/review_repository_impl.dart';
import '../../data/repositories/articles_repository_impl.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/place_repository.dart';
import '../../domain/repositories/checkin_repository.dart';
import '../../domain/repositories/review_repository.dart';
import '../../domain/repositories/articles_repository.dart';
import '../../domain/usecases/user/get_current_user_usecase.dart';
import '../../domain/usecases/user/get_users_usecase.dart';
import '../../domain/usecases/user/login_usecase.dart';
import '../../domain/usecases/place/get_categories_usecase.dart';
import '../../domain/usecases/place/get_nearby_places_usecase.dart';
import '../../domain/usecases/place/get_place_by_id_usecase.dart';
import '../../domain/usecases/place/get_places_usecase.dart';
import '../../domain/usecases/checkin/create_checkin_usecase.dart';
import '../../domain/usecases/checkin/get_checkin_history_usecase.dart';
import '../../domain/usecases/review/create_review_usecase.dart';
import '../../domain/usecases/review/get_reviews_usecase.dart';

class DependencyInjection {
  static Future<void> init() async {
    // Core dependencies
    Get.lazyPut<Connectivity>(() => Connectivity());
    Get.lazyPut<NetworkInfo>(() => NetworkInfoImpl(Get.find()));
    Get.lazyPut<DioClient>(() => DioClient());
    Get.put<AuthService>(AuthService(), permanent: true);
    
    // Data layer dependencies
    await _initDataLayer();
    
    // Domain layer dependencies
    await _initDomainLayer();
    
    // Presentation layer dependencies
    await _initPresentationLayer();
  }
  
  static Future<void> _initDataLayer() async {
    // Data sources
    Get.lazyPut<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(Get.find<DioClient>()),
    );
    Get.lazyPut<UserLocalDataSource>(
      () => UserLocalDataSourceImpl(),
    );
    Get.lazyPut<PlaceRemoteDataSource>(
      () => PlaceRemoteDataSourceImpl(Get.find<DioClient>()),
    );
    Get.lazyPut<PlaceLocalDataSource>(
      () => PlaceLocalDataSourceImpl(),
    );
    Get.lazyPut<CheckinRemoteDataSource>(
      () => CheckinRemoteDataSourceImpl(Get.find<DioClient>()),
    );
    Get.lazyPut<ReviewRemoteDataSource>(
      () => ReviewRemoteDataSourceImpl(Get.find<DioClient>()),
    );
    Get.lazyPut<ArticlesRemoteDataSource>(
      () => ArticlesRemoteDataSourceImpl(Get.find<DioClient>()),
    );
    
    // Repositories
    Get.lazyPut<UserRepository>(
      () => UserRepositoryImpl(
        remoteDataSource: Get.find<UserRemoteDataSource>(),
        localDataSource: Get.find<UserLocalDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
    );
    Get.lazyPut<PlaceRepository>(
      () => PlaceRepositoryImpl(
        remoteDataSource: Get.find<PlaceRemoteDataSource>(),
        localDataSource: Get.find<PlaceLocalDataSource>(),
      ),
    );
    Get.lazyPut<CheckinRepository>(
      () => CheckinRepositoryImpl(
        remoteDataSource: Get.find<CheckinRemoteDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
    );
    Get.lazyPut<ReviewRepository>(
      () => ReviewRepositoryImpl(
        remoteDataSource: Get.find<ReviewRemoteDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
    );
    Get.lazyPut<ArticlesRepository>(
      () => ArticlesRepositoryImpl(
        remoteDataSource: Get.find<ArticlesRemoteDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
    );
  }
  
  static Future<void> _initDomainLayer() async {
    // User use cases
    Get.lazyPut<GetCurrentUserUseCase>(
      () => GetCurrentUserUseCase(Get.find<UserRepository>()),
    );
    Get.lazyPut<GetUsersUseCase>(
      () => GetUsersUseCase(Get.find<UserRepository>()),
    );
    Get.lazyPut<LoginUseCase>(
      () => LoginUseCase(Get.find<UserRepository>()),
    );
    
    // Place use cases
    Get.lazyPut<GetCategoriesUseCase>(
      () => GetCategoriesUseCase(Get.find<PlaceRepository>()),
    );
    Get.lazyPut<GetNearbyPlacesUseCase>(
      () => GetNearbyPlacesUseCase(Get.find<PlaceRepository>()),
    );
    Get.lazyPut<GetPlaceByIdUseCase>(
      () => GetPlaceByIdUseCase(Get.find<PlaceRepository>()),
    );
    Get.lazyPut<GetPlacesUseCase>(
      () => GetPlacesUseCase(Get.find<PlaceRepository>()),
    );
    
    // Checkin use cases
    Get.lazyPut<CreateCheckinUseCase>(
      () => CreateCheckinUseCase(Get.find<CheckinRepository>()),
    );
    Get.lazyPut<GetCheckinHistoryUseCase>(
      () => GetCheckinHistoryUseCase(Get.find<CheckinRepository>()),
    );
    
    // Review use cases
    Get.lazyPut<CreateReviewUseCase>(
      () => CreateReviewUseCase(Get.find<ReviewRepository>()),
    );
    Get.lazyPut<GetReviewsUseCase>(
      () => GetReviewsUseCase(Get.find<ReviewRepository>()),
    );
  }
  
  static Future<void> _initPresentationLayer() async {
    // Controllers are typically initialized in their respective bindings
    // This method can be used for global presentation layer dependencies
  }
}
