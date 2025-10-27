import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:snappie_app/app/data/models/comment_model.dart';
import 'package:snappie_app/app/data/models/like_model.dart';
import 'package:snappie_app/app/data/models/post_model.dart';
import '../../data/models/user_model.dart';
import '../../data/models/place_model.dart';
import '../../data/models/articles_model.dart';
import '../../data/models/checkin_model.dart';
import '../../data/models/review_model.dart';
import '../../data/models/auth_token_model.dart';

class IsarService {
  static Isar? _isar;
  
  static Future<Isar> get instance async {
    if (_isar != null) return _isar!;

    _isar = await _initIsar();
    
    return _isar!;
  }

  static Future<Isar> _initIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    
    return await Isar.open(
      [
        AuthTokenModelSchema,
        UserModelSchema,
        PlaceModelSchema,
        CheckinModelSchema,
        ReviewModelSchema,
        ArticlesModelSchema,
        PostModelSchema,
        CommentModelSchema,
        LikeModelSchema,
      ],
      directory: dir.path,
      name: 'snappie_db',
    );
  }
  
  static Future<void> close() async {
    if (_isar != null) {
      await _isar!.close();
      _isar = null;
    }
  }
}
