import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/di_container.dart';
import 'core/router/app_router.dart';
import 'core/themes/app_theme.dart';
import 'features/app/bloc/theme_cubit.dart';
import 'features/app/bloc/app_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) => sl<ThemeCubit>(),
        ),
        BlocProvider<AppCubit>(
          create: (_) => sl<AppCubit>()..checkAuth(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            title: 'SATashkent',
            debugShowCheckedModeBanner: false,

            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.themeMode,

            routerConfig: sl<AppRouter>().router,

            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(
                    MediaQuery.of(context).textScaler.scale(1).clamp(0.85, 1.2),
                  ),
                ),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
