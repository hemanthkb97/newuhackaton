import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/datasources/breathing_log_local_datasource.dart';
import 'data/repositories/breathing_log_repository_impl.dart';
import 'domain/repositories/breathing_log_repository.dart';
import 'presentation/blocs/logs/breathing_logs_cubit.dart';
import 'presentation/blocs/theme/theme_cubit.dart';
import 'presentation/blocs/setup/setup_cubit.dart';
import 'presentation/blocs/breathing/breathing_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => ThemeCubit(prefs));
  sl.registerLazySingleton(() => SetupCubit());
  sl.registerFactory(() => BreathingBloc());

  sl.registerLazySingleton(() => BreathingLogLocalDatasource(prefs));
  sl.registerLazySingleton<BreathingLogRepository>(
      () => BreathingLogRepositoryImpl(sl()));
  sl.registerLazySingleton(() => BreathingLogsCubit(sl()));
}
