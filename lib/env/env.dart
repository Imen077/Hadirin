import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'CLOUDINARY_CLOUD_NAME', obfuscate: true)
  static final String cloudName = _Env.cloudName;

  @EnviedField(varName: 'CLOUDINARY_UPLOAD_PRESET', obfuscate: true)
  static final String uploadPreset = _Env.uploadPreset;
}
