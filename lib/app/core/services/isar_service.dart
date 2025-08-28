import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/models/place_isar_model.dart';

class IsarService {
  static Isar? _isar;
  
  static Future<Isar> get isar async {
    if (_isar != null) return _isar!;
    
    _isar = await _initIsar();
    return _isar!;
  }
  
  static Future<Isar> _initIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    
    return await Isar.open(
      [PlaceIsarModelSchema, CacheMetadataSchema],
      directory: dir.path,
    );
  }
  
  static Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }
}
