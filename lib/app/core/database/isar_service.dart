import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/models/user_model.dart';
import '../../data/models/auth_token_model.dart';

class IsarService {
  static Isar? _isar;
  
  static Future<Isar> get instance async {
    if (_isar != null) return _isar!;
    
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [UserModelSchema, AuthTokenModelSchema],
      directory: dir.path,
      name: 'snappie_db',
    );
    
    return _isar!;
  }
  
  static Future<void> close() async {
    if (_isar != null) {
      await _isar!.close();
      _isar = null;
    }
  }
}
