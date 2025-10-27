import 'package:get/get.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../../data/datasources/local/user_local_datasource.dart';
import '../../data/datasources/remote/user_remote_datasource.dart';
import '../../data/datasources/remote/place_remote_datasource.dart';
import '../../data/datasources/remote/checkin_remote_datasource.dart';
import '../../data/datasources/remote/review_remote_datasource.dart';
import '../../data/datasources/remote/articles_remote_datasource.dart';
import '../../data/datasources/remote/post_remote_datasource.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/repositories/place_repository_impl.dart';
import '../../data/repositories/checkin_repository_impl.dart';
import '../../data/repositories/review_repository_impl.dart';
import '../../data/repositories/articles_repository_impl.dart';
import '../../data/repositories/post_repository_impl.dart';

/// Data layer dependencies: DataSources & Repositories
/// Shared across modules, permanent untuk menghindari disposal
class DataDependencies {
  static Future<void> init() async {
    // Data sources - lazyPut OK karena dibuat saat dibutuhkan
    Get.lazyPut<UserLocalDataSource>(
      () => UserLocalDataSourceImpl(),
    );
    Get.lazyPut<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(Get.find<DioClient>()),
    );
    Get.lazyPut<PlaceRemoteDataSource>(
      () => PlaceRemoteDataSourceImpl(Get.find<DioClient>()),
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
    Get.lazyPut<PostRemoteDataSource>(
      () => PostRemoteDataSourceImpl(Get.find<DioClient>()),
    );
    
    // Repositories - PERMANENT untuk menghindari disposal
    // Repositories adalah shared services yang harus tetap hidup
    Get.put<UserRepository>(
      UserRepository(
        remoteDataSource: Get.find<UserRemoteDataSource>(),
        localDataSource: Get.find<UserLocalDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
      permanent: true,
    );
    Get.put<PlaceRepository>(
      PlaceRepository(
        remoteDataSource: Get.find<PlaceRemoteDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
      permanent: true,
    );
    Get.put<CheckinRepository>(
      CheckinRepository(
        remoteDataSource: Get.find<CheckinRemoteDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
      permanent: true,
    );
    Get.put<ReviewRepository>(
      ReviewRepository(
        remoteDataSource: Get.find<ReviewRemoteDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
      permanent: true,
    );
    Get.put<ArticlesRepository>(
      ArticlesRepository(
        remoteDataSource: Get.find<ArticlesRemoteDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
      permanent: true,
    );
    Get.put<PostRepository>(
      PostRepository(
        remoteDataSource: Get.find<PostRemoteDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
      permanent: true,
    );
  }
}
