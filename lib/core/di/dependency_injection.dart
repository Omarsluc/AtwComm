// import 'package:dio/dio.dart';
// import 'package:get_it/get_it.dart';
//
//
// import 'package:shared_preferences/shared_preferences.dart';
//
// final getIt = GetIt.instance;
//
// Future<void> setUp() async {
//   Dio dio = DioFactory.getDio();
//
//   SharedPreferences pref = await SharedPreferences.getInstance();
//   getIt.registerSingleton<SharedPreferences>(pref);
//
//   // // login di
//
//   getIt.registerLazySingleton<SearchApi>(() => SearchApi(dio));
//   getIt.registerLazySingleton<SearchRepo>(() => SearchRepo(getIt()));
//   getIt.registerFactory<SearchCubit>(() => SearchCubit(getIt()));
//
//   // // login di
//   getIt.registerLazySingleton<VideoRepo>(() => VideoRepo());
//   getIt.registerFactory<VidoCubit>(() => VidoCubit(getIt()));
// }
