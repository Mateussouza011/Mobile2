import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../network/network_info.dart';
import '../../data/datasources/local/database_helper.dart';
import '../../data/datasources/local/prediction_local_datasource.dart';
import '../../data/datasources/remote/api_endpoints.dart';
import '../../data/datasources/remote/prediction_remote_datasource.dart';
import '../../data/repositories/prediction_repository_impl.dart';
import '../../domain/repositories/prediction_repository.dart';
import '../../domain/usecases/get_prediction.dart';
import '../../domain/usecases/get_prediction_history.dart';
import '../../domain/usecases/save_prediction.dart';
import '../../presentation/viewmodels/diamond_prediction_viewmodel.dart';

final getIt = GetIt.instance;
Future<void> setupDependencyInjection() async {
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(),
  );
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: 30000,
      receiveTimeout: 30000,
    ),
  );
  getIt.registerLazySingleton<DatabaseHelper>(
    () => DatabaseHelper.instance,
  );
  getIt.registerLazySingleton<PredictionRemoteDataSource>(
    () => PredictionRemoteDataSourceImpl(
      apiClient: getIt<ApiClient>(),
    ),
  );
  getIt.registerLazySingleton<PredictionLocalDataSource>(
    () => PredictionLocalDataSourceImpl(
      databaseHelper: getIt<DatabaseHelper>(),
    ),
  );
  
  getIt.registerLazySingleton<PredictionRepository>(
    () => PredictionRepositoryImpl(
      remoteDataSource: getIt<PredictionRemoteDataSource>(),
      localDataSource: getIt<PredictionLocalDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );
  
  getIt.registerLazySingleton<GetPredictionUseCase>(
    () => GetPredictionUseCase(getIt<PredictionRepository>()),
  );

  getIt.registerLazySingleton<SavePredictionUseCase>(
    () => SavePredictionUseCase(getIt<PredictionRepository>()),
  );

  getIt.registerLazySingleton<GetPredictionHistoryUseCase>(
    () => GetPredictionHistoryUseCase(getIt<PredictionRepository>()),
  );
  
  getIt.registerFactory<DiamondPredictionViewModel>(
    () => DiamondPredictionViewModel(
      getPredictionUseCase: getIt<GetPredictionUseCase>(),
      savePredictionUseCase: getIt<SavePredictionUseCase>(),
      getPredictionHistoryUseCase: getIt<GetPredictionHistoryUseCase>(),
    ),
  );
}
