import 'package:flutter_tdd_reso_coder/core/network/network_info.dart';
import 'package:flutter_tdd_reso_coder/core/presentation/util/input_converter.dart';
import 'package:flutter_tdd_reso_coder/trivia/data/data_sources/local_data_source.dart';
import 'package:flutter_tdd_reso_coder/trivia/data/data_sources/remote_data_source.dart';
import 'package:flutter_tdd_reso_coder/trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_tdd_reso_coder/trivia/domain/use_cases/get_concrete_number_trivia_use_case.dart';
import 'package:flutter_tdd_reso_coder/trivia/domain/use_cases/get_random_number_trivia_use_case.dart';
import 'package:flutter_tdd_reso_coder/trivia/presentation/bloc/number_trivia/number_trivia_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //bloc
  sl.registerFactory(
    () => NumberTriviaBloc(
        getConcreteNumberTriviaUseCase: sl<GetConcreteNumberTriviaUseCase>(),
        getRandomNumberTriviaUseCase: sl<GetRandomNumberTriviaUseCase>(),
        inputConverter: sl<InputConverter>()),
  );

  //use cases
  sl.registerLazySingleton(() => GetConcreteNumberTriviaUseCase(sl<NumberTriviaRepositoryImpl>()));
  sl.registerLazySingleton(() => GetRandomNumberTriviaUseCase(sl<NumberTriviaRepositoryImpl>()));

  //repository
  sl.registerLazySingleton(
    () => NumberTriviaRepositoryImpl(
        networkInfo: sl<NetworkInfoImpl>(),
        localDataSource: sl<LocalDataSourceImpl>(),
        remoteDataSource: sl<RemoteDataSourceImpl>()),
  );

  //datasources
  sl.registerLazySingleton(() => LocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()));
  sl.registerLazySingleton(() => RemoteDataSourceImpl(client: sl<Client>()));

  //network info
  sl.registerLazySingleton(
      () => NetworkInfoImpl(connectionChecker: sl<InternetConnectionChecker>()));

  //core - util classes - 3rd party lib
  final sharedPreference = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreference);
  sl.registerLazySingleton<InputConverter>(() => InputConverter());
  sl.registerLazySingleton<Client>(() => Client());
  sl.registerLazySingleton<InternetConnectionChecker>(() => InternetConnectionChecker());
}
