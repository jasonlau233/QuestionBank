import 'core/manager.dart';
import 'core/bootstrap.dart';

void main() {
  /// 测试环境需要自己配置dev
  Manager.shared.config = Manager.shared.config.copyWith(env: HttpEnv.Test);
  bootApplication();
}
