import 'core_dependencies.dart';
import 'data_dependencies.dart';

class DependencyInjection {
  static Future<void> init() async {
    // Initialize core dependencies (network, auth services, etc)
    await CoreDependencies.init();
    
    // Initialize data layer (datasources & repositories)
    await DataDependencies.init();
    
    // Controllers akan di-load via module bindings di routes
    // Tidak perlu init di sini lagi
  }
}
