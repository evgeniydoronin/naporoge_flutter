import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../features/todo/data/sources/local/todo_local_storage.dart';
import '../../../features/todo/domain/repositories/todo_local_repository.dart';
import '../../../features/todo/data/repositories/todo_remote_repository.dart';
import '../../../features/todo/data/sources/remote/todo_api.dart';
import '../../../features/todo/presentation/todo_controller.dart';
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

  /// auth
  getIt.registerFactory(() => AuthController());
  getIt.registerSingleton(UserApi(dioClient: getIt<DioClient>()));
  getIt.registerSingleton(UserRepository(getIt.get<UserApi>()));

  /// streams
  getIt.registerFactory(() => StreamController());
  getIt.registerSingleton(StreamApi(dioClient: getIt<DioClient>()));
  getIt.registerSingleton(StreamRepository(getIt.get<StreamApi>()));

  /// todos
  getIt.registerFactory(() => TodoController());
  getIt.registerSingleton(TodoApi(dioClient: getIt<DioClient>()));
  getIt.registerSingleton(TodoRemoteRepository(getIt.get<TodoApi>()));
  getIt.registerSingleton(TodoLocal());
  getIt.registerSingleton(TodoLocalRepository(getIt.get<TodoLocal>()));
}
