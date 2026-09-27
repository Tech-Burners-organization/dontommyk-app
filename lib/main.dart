import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:tommy/app/app.dart';
import 'package:tommy/core/bloc/app_bloc_observer.dart';
import 'package:tommy/core/di/app_dependencies.dart';
import 'package:tommy/core/utils/prefs_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefsHelper.init();
  Bloc.observer = const AppBlocObserver();

  final dependencies = AppDependencies.create();
  runApp(TommyApp(dependencies: dependencies));
}
