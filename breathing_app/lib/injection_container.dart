import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'presentation/blocs/theme/theme_cubit.dart';
import 'presentation/blocs/setup/setup_cubit.dart';
import 'presentation/blocs/breathing/breathing_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => ThemeCubit(prefs));
  sl.registerLazySingleton(() => SetupCubit());
  sl.registerFactory(() => BreathingBloc());
}
