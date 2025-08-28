import 'package:isar/isar.dart';

part 'auth_token_model.g.dart';

@collection
class AuthTokenModel {
  Id id = Isar.autoIncrement;
  
  @Index(unique: true)
  late String key;
  
  late String token;
  
  AuthTokenModel();
  
  AuthTokenModel.create({
    required this.key,
    required this.token,
  });
}
