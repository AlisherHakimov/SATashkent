import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'di_container.config.dart';

final sl = GetIt.instance;

@InjectableInit()
Future<void> initDi() async {
  await sl.init();
  return sl.allReady();
}

Future<void> disposeDi() {
  return sl.reset();
}
