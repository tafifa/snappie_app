import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../../data/datasources/user_local_datasource.dart';
import '../../data/datasources/user_remote_datasource.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/user/get_current_user_usecase.dart';
import '../../domain/usecases/user/get_users_usecase.dart';
import '../../domain/usecases/user/login_usecase.dart';

class DependencyInjection {
  static Future<void> init() async {
    // Core dependencies
    Get.lazyPut<Connectivity>(() => Connectivity());
    Get.lazyPut<NetworkInfo>(() => NetworkInfoImpl(Get.find()));
    Get.lazyPut<DioClient>(() => DioClient());
    
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
    
    // Repositories
    Get.lazyPut<UserRepository>(
      () => UserRepositoryImpl(
        remoteDataSource: Get.find<UserRemoteDataSource>(),
        localDataSource: Get.find<UserLocalDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
    );
  }
  
  static Future<void> _initDomainLayer() async {
    // Use cases
    Get.lazyPut<GetCurrentUserUseCase>(
      () => GetCurrentUserUseCase(Get.find<UserRepository>()),
    );
    Get.lazyPut<GetUsersUseCase>(
      () => GetUsersUseCase(Get.find<UserRepository>()),
    );
    Get.lazyPut<LoginUseCase>(
      () => LoginUseCase(Get.find<UserRepository>()),
    );
  }
  
  static Future<void> _initPresentationLayer() async {
    // Controllers are typically initialized in their respective bindings
    // This method can be used for global presentation layer dependencies
  }
}