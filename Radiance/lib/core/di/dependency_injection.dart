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
import '../../features/api_keys/data/repositories/api_key_repository.dart';
import '../data/repositories/prediction_history_repository.dart';
import '../../features/export/data/services/pdf_export_service.dart';
import '../../features/export/data/services/csv_export_service.dart';
import '../../features/api/data/handlers/predictions_handler.dart';
import '../../features/api/data/handlers/company_handler.dart';
import '../../features/api/data/middleware/api_auth_middleware.dart';
import '../../features/api/data/middleware/rate_limiter.dart';
import '../../features/multi_tenant/data/repositories/company_repository.dart';
import '../../features/team_dashboard/data/repositories/team_stats_repository.dart';
import '../../features/team/data/repositories/invitation_repository.dart';

final getIt = GetIt.instance;

/// Configura todas as dependências da aplicação
Future<void> setupDependencyInjection() async {
  // ============ Core ============
  
  // Network
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(),
  );

  // API Client
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: 30000,
      receiveTimeout: 30000,
    ),
  );

  // Database
  getIt.registerLazySingleton<DatabaseHelper>(
    () => DatabaseHelper.instance,
  );

  // ============ Data Sources ============
  
  // Remote
  getIt.registerLazySingleton<PredictionRemoteDataSource>(
    () => PredictionRemoteDataSourceImpl(
      apiClient: getIt<ApiClient>(),
    ),
  );

  // Local
  getIt.registerLazySingleton<PredictionLocalDataSource>(
    () => PredictionLocalDataSourceImpl(
      databaseHelper: getIt<DatabaseHelper>(),
    ),
  );

  // ============ Repositories ============
  
  getIt.registerLazySingleton<PredictionRepository>(
    () => PredictionRepositoryImpl(
      remoteDataSource: getIt<PredictionRemoteDataSource>(),
      localDataSource: getIt<PredictionLocalDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  // ============ Use Cases ============
  
  getIt.registerLazySingleton<GetPredictionUseCase>(
    () => GetPredictionUseCase(getIt<PredictionRepository>()),
  );

  getIt.registerLazySingleton<SavePredictionUseCase>(
    () => SavePredictionUseCase(getIt<PredictionRepository>()),
  );

  getIt.registerLazySingleton<GetPredictionHistoryUseCase>(
    () => GetPredictionHistoryUseCase(getIt<PredictionRepository>()),
  );

  // ============ ViewModels ============
  
  getIt.registerFactory<DiamondPredictionViewModel>(
    () => DiamondPredictionViewModel(
      getPredictionUseCase: getIt<GetPredictionUseCase>(),
      savePredictionUseCase: getIt<SavePredictionUseCase>(),
      getPredictionHistoryUseCase: getIt<GetPredictionHistoryUseCase>(),
    ),
  );

  // ============ B2B Features ============
  
  // API Keys
  getIt.registerLazySingleton<ApiKeyRepository>(
    () => ApiKeyRepository(databaseHelper: getIt<DatabaseHelper>()),
  );

  // Export Services
  getIt.registerLazySingleton<PredictionHistoryRepository>(
    () => PredictionHistoryRepository(),
  );

  getIt.registerLazySingleton<PdfExportService>(
    () => PdfExportService(),
  );

  getIt.registerLazySingleton<CsvExportService>(
    () => CsvExportService(),
  );

  // API REST (handlers para documentação de referência)
  // Nota: Em produção, estes seriam implementados em um backend real
  getIt.registerLazySingleton(() => PredictionsHandler(
    historyRepository: getIt<PredictionHistoryRepository>(),
  ));

  getIt.registerLazySingleton(() => CompanyHandler(
    companyRepository: getIt<CompanyRepository>(),
  ));

  getIt.registerLazySingleton(() => ApiAuthMiddleware(
    apiKeyRepository: getIt<ApiKeyRepository>(),
  ));

  getIt.registerLazySingleton(() => RateLimiter());

  // Team Dashboard
  getIt.registerLazySingleton(() => TeamStatsRepository(
    predictionRepository: getIt<PredictionHistoryRepository>(),
    companyRepository: getIt<CompanyRepository>(),
  ));

  // Team Invitations
  getIt.registerLazySingleton(() => InvitationRepository(
    databaseHelper: getIt<DatabaseHelper>(),
  ));
}
