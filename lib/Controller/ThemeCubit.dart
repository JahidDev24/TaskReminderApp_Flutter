import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  void toggleTheme(ThemeMode mode) {
    emit(mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }
}