// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:satashkent/core/di/register_module.dart' as _i436;
import 'package:satashkent/core/network/interceptors/auth_interceptor.dart'
    as _i73;
import 'package:satashkent/core/network/interceptors/refresh_token_interceptor.dart'
    as _i715;
import 'package:satashkent/core/router/app_router.dart' as _i134;
import 'package:satashkent/core/services/connectivity_service.dart' as _i1003;
import 'package:satashkent/core/services/storage_service.dart' as _i502;
import 'package:satashkent/features/app/bloc/app_cubit.dart' as _i168;
import 'package:satashkent/features/app/bloc/theme_cubit.dart' as _i401;
import 'package:satashkent/features/assessments/data/api/assessments_api.dart'
    as _i305;
import 'package:satashkent/features/assessments/data/repository/assessments_repository.dart'
    as _i151;
import 'package:satashkent/features/assessments/presentation/bloc/assessments_cubit.dart'
    as _i74;
import 'package:satashkent/features/auth/data/api/auth_api.dart' as _i1055;
import 'package:satashkent/features/auth/data/repository/auth_repository.dart'
    as _i226;
import 'package:satashkent/features/auth/presentation/bloc/auth_cubit.dart'
    as _i962;
import 'package:satashkent/features/competitions/data/api/competitions_api.dart'
    as _i171;
import 'package:satashkent/features/competitions/data/repository/competitions_repository.dart'
    as _i636;
import 'package:satashkent/features/competitions/presentation/bloc/competitions_cubit.dart'
    as _i843;
import 'package:satashkent/features/home/data/api/home_api.dart' as _i118;
import 'package:satashkent/features/home/data/repository/home_repository.dart'
    as _i423;
import 'package:satashkent/features/home/presentation/bloc/home_cubit.dart'
    as _i331;
import 'package:satashkent/features/profile/data/api/profile_api.dart' as _i773;
import 'package:satashkent/features/profile/data/repository/profile_repository.dart'
    as _i213;
import 'package:satashkent/features/profile/presentation/bloc/profile_cubit.dart'
    as _i919;
import 'package:satashkent/features/question_rush/presentation/bloc/question_rush_cubit.dart'
    as _i878;
import 'package:satashkent/features/questions/data/api/questions_api.dart'
    as _i917;
import 'package:satashkent/features/questions/data/repository/questions_repository.dart'
    as _i471;
import 'package:satashkent/features/questions/presentation/bloc/question_solve_cubit.dart'
    as _i150;
import 'package:satashkent/features/questions/presentation/bloc/questions_cubit.dart'
    as _i18;
import 'package:satashkent/features/roadmap/data/api/roadmap_api.dart' as _i759;
import 'package:satashkent/features/roadmap/data/repository/roadmap_repository.dart'
    as _i69;
import 'package:satashkent/features/roadmap/presentation/bloc/roadmap_cubit.dart'
    as _i950;
import 'package:satashkent/features/vocabulary/data/api/vocabulary_api.dart'
    as _i264;
import 'package:satashkent/features/vocabulary/data/repository/vocabulary_repository.dart'
    as _i734;
import 'package:satashkent/features/vocabulary/presentation/bloc/vocabulary_cubit.dart'
    as _i238;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.factory<_i878.QuestionRushCubit>(() => _i878.QuestionRushCubit());
    gh.factory<_i150.QuestionSolveCubit>(() => _i150.QuestionSolveCubit());
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i895.Connectivity>(() => registerModule.connectivity);
    gh.lazySingleton<_i502.StorageService>(
        () => _i502.StorageService(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i361.Dio>(
      () => registerModule.authDio(),
      instanceName: 'authDio',
    );
    gh.lazySingleton<_i73.AuthInterceptor>(
        () => _i73.AuthInterceptor(gh<_i502.StorageService>()));
    gh.singleton<_i134.AppRouter>(
        () => _i134.AppRouter(gh<_i502.StorageService>()));
    gh.singleton<_i401.ThemeCubit>(
        () => _i401.ThemeCubit(gh<_i502.StorageService>()));
    gh.singleton<_i168.AppCubit>(
        () => _i168.AppCubit(gh<_i502.StorageService>()));
    gh.lazySingleton<_i1003.ConnectivityService>(
        () => _i1003.ConnectivityService(gh<_i895.Connectivity>()));
    gh.lazySingleton<_i715.RefreshTokenInterceptor>(
        () => _i715.RefreshTokenInterceptor(
              gh<_i361.Dio>(instanceName: 'authDio'),
              gh<_i502.StorageService>(),
            ));
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio(
          gh<_i73.AuthInterceptor>(),
          gh<_i715.RefreshTokenInterceptor>(),
        ));
    gh.singleton<_i118.HomeApi>(() => _i118.HomeApi(gh<_i361.Dio>()));
    gh.singleton<_i305.AssessmentsApi>(
        () => _i305.AssessmentsApi(gh<_i361.Dio>()));
    gh.singleton<_i1055.AuthApi>(() => _i1055.AuthApi(gh<_i361.Dio>()));
    gh.singleton<_i759.RoadmapApi>(() => _i759.RoadmapApi(gh<_i361.Dio>()));
    gh.singleton<_i171.CompetitionsApi>(
        () => _i171.CompetitionsApi(gh<_i361.Dio>()));
    gh.singleton<_i773.ProfileApi>(() => _i773.ProfileApi(gh<_i361.Dio>()));
    gh.singleton<_i264.VocabularyApi>(
        () => _i264.VocabularyApi(gh<_i361.Dio>()));
    gh.singleton<_i917.QuestionsApi>(() => _i917.QuestionsApi(gh<_i361.Dio>()));
    gh.lazySingleton<_i151.AssessmentsRepository>(
        () => _i151.AssessmentsRepository(
              gh<_i305.AssessmentsApi>(),
              gh<_i1003.ConnectivityService>(),
            ));
    gh.lazySingleton<_i69.RoadmapRepository>(() => _i69.RoadmapRepository(
          gh<_i759.RoadmapApi>(),
          gh<_i1003.ConnectivityService>(),
        ));
    gh.lazySingleton<_i636.CompetitionsRepository>(
        () => _i636.CompetitionsRepository(
              gh<_i171.CompetitionsApi>(),
              gh<_i1003.ConnectivityService>(),
            ));
    gh.lazySingleton<_i471.QuestionsRepository>(() => _i471.QuestionsRepository(
          gh<_i917.QuestionsApi>(),
          gh<_i1003.ConnectivityService>(),
        ));
    gh.factory<_i74.AssessmentsCubit>(
        () => _i74.AssessmentsCubit(gh<_i151.AssessmentsRepository>()));
    gh.lazySingleton<_i734.VocabularyRepository>(
        () => _i734.VocabularyRepository(
              gh<_i264.VocabularyApi>(),
              gh<_i1003.ConnectivityService>(),
            ));
    gh.factory<_i950.RoadmapCubit>(
        () => _i950.RoadmapCubit(gh<_i69.RoadmapRepository>()));
    gh.lazySingleton<_i213.ProfileRepository>(() => _i213.ProfileRepository(
          gh<_i773.ProfileApi>(),
          gh<_i1003.ConnectivityService>(),
        ));
    gh.lazySingleton<_i226.AuthRepository>(() => _i226.AuthRepository(
          gh<_i1055.AuthApi>(),
          gh<_i502.StorageService>(),
          gh<_i1003.ConnectivityService>(),
        ));
    gh.lazySingleton<_i423.HomeRepository>(() => _i423.HomeRepository(
          gh<_i118.HomeApi>(),
          gh<_i1003.ConnectivityService>(),
        ));
    gh.factory<_i238.VocabularyCubit>(
        () => _i238.VocabularyCubit(gh<_i734.VocabularyRepository>()));
    gh.factory<_i331.HomeCubit>(
        () => _i331.HomeCubit(gh<_i423.HomeRepository>()));
    gh.factory<_i18.QuestionsCubit>(
        () => _i18.QuestionsCubit(gh<_i471.QuestionsRepository>()));
    gh.factory<_i843.CompetitionsCubit>(
        () => _i843.CompetitionsCubit(gh<_i636.CompetitionsRepository>()));
    gh.factory<_i919.ProfileCubit>(
        () => _i919.ProfileCubit(gh<_i213.ProfileRepository>()));
    gh.factory<_i962.AuthCubit>(
        () => _i962.AuthCubit(gh<_i226.AuthRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i436.RegisterModule {}
