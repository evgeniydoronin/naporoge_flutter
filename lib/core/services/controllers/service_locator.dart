import 'package:dio/dio.dart';

import 'package:get_it/get_it.dart';

import '../http_client/dio_client.dart';
import '../../../features/auth/login/data/network/api/user_api.dart';
import '../../../features/planning/data/repositories/stream_repository.dart';
import '../../../features/planning/data/sources/remote/stream_api.dart';
import '../../../features/planning/presentation/stream_controller.dart';
import '../../../features/auth/login/data/repository/user_repository.dart';
import '../../../features/auth/login/presentation/auth_controller.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  getIt.registerSingleton(Dio());
  getIt.registerSingleton(DioClient(getIt<Dio>()));

  getIt.registerFactory(() => AuthController());
  getIt.registerSingleton(UserApi(dioClient: getIt<DioClient>()));
  getIt.registerSingleton(UserRepository(getIt.get<UserApi>()));

  getIt.registerFactory(() => StreamController());
  getIt.registerSingleton(StreamApi(dioClient: getIt<DioClient>()));
  getIt.registerSingleton(StreamRepository(getIt.get<StreamApi>()));
}
