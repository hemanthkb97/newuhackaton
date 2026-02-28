import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<bool> {
  static const _key = 'isDarkMode';
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs) : super(_prefs.getBool(_key) ?? false);

  bool get isDark => state;

  void toggle() {
    final newValue = !state;
    _prefs.setBool(_key, newValue);
    emit(newValue);
  }
}
