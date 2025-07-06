import 'package:get/get.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/user/get_current_user_usecase.dart';
import '../../../domain/usecases/user/get_users_usecase.dart';
import '../../../domain/usecases/base_usecase.dart';

class HomeController extends GetxController {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final GetUsersUseCase getUsersUseCase;
  
  HomeController({
    required this.getCurrentUserUseCase,
    required this.getUsersUseCase,
  });
  
  // Reactive variables
  final _isLoading = false.obs;
  final _currentUser = Rxn<UserEntity>();
  final _users = <UserEntity>[].obs;
  final _errorMessage = ''.obs;
  
  // Getters
  bool get isLoading => _isLoading.value;
  UserEntity? get currentUser => _currentUser.value;
  List<UserEntity> get users => _users;
  String get errorMessage => _errorMessage.value;
  
  @override
  void onInit() {
    super.onInit();
    loadCurrentUser();
    loadUsers();
  }
  
  @override
  void onReady() {
    super.onReady();
  }
  
  @override
  void onClose() {
    super.onClose();
  }
  
  Future<void> loadCurrentUser() async {
    _setLoading(true);
    _clearError();
    
    final result = await getCurrentUserUseCase(const NoParams());
    
    result.fold(
      (failure) => _setError(failure.message),
      (user) => _currentUser.value = user,
    );
    
    _setLoading(false);
  }
  
  Future<void> loadUsers({int page = 1, String? search}) async {
    _setLoading(true);
    _clearError();
    
    final result = await getUsersUseCase(
      PaginationParams(page: page, search: search),
    );
    
    result.fold(
      (failure) => _setError(failure.message),
      (usersList) {
        if (page == 1) {
          _users.assignAll(usersList);
        } else {
          _users.addAll(usersList);
        }
      },
    );
    
    _setLoading(false);
  }
  
  Future<void> refreshData() async {
    await Future.wait([
      loadCurrentUser(),
      loadUsers(),
    ]);
  }
  
  void _setLoading(bool loading) {
    _isLoading.value = loading;
  }
  
  void _setError(String error) {
    _errorMessage.value = error;
  }
  
  void _clearError() {
    _errorMessage.value = '';
  }
}
