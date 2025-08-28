import 'package:get/get.dart';
import '../../doma../../domain/errors/failures.dart';

abstract class BaseController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool hasError = false.obs;

  void setLoading(bool loading) {
    isLoading.value = loading;
    if (loading) {
      clearError();
    }
  }

  void setError(String message) {
    errorMessage.value = message;
    hasError.value = true;
    isLoading.value = false;
  }

  void setFailure(Failure failure) {
    setError(failure.message);
  }

  void clearError() {
    errorMessage.value = '';
    hasError.value = false;
  }

  void resetState() {
    isLoading.value = false;
    clearError();
  }

  Future<void> handleAsyncOperation<T>(
    Future<T> Function() operation, {
    String? loadingMessage,
    String? errorMessage,
  }) async {
    try {
      setLoading(true);
      await operation();
    } catch (e) {
      setError(errorMessage ?? e.toString());
    } finally {
      setLoading(false);
    }
  }
}
