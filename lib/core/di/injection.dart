// Dependency injection setup using Riverpod
import "package:riverpod_annotation/riverpod_annotation.dart";
import "../../config/app_config.dart";
import "../../network/api_client.dart";
import "../../utils/local_storage.dart";
import "../../errors/app_errors.dart";

part "injection.g.dart";

@riverpod
AppConfig appConfig(AppConfigRef ref) {
  // In production, read from environment or flavor
  const env = String.fromEnvironment("APP_ENV", defaultValue: "development");
  switch (env) {
    case "staging":
      return AppConfig.staging();
    case "production":
      return AppConfig.production();
    default:
      return AppConfig.development();
  }
}

@riverpod
ApiClient apiClient(ApiClientRef ref) {
  var config = ref.watch(appConfigProvider);
  return ApiClient(config);
}

@riverpod
LocalStorage localStorage(LocalStorageRef ref) {
  return LocalStorage();
}

// Feature-specific providers will be added here
// Example:
// @riverpod
// HomeRepository homeRepository(HomeRepositoryRef ref) {
//   return HomeRepositoryImpl(
//     remoteDataSource: ref.watch(homeRemoteDataSourceProvider),
//     localDataSource: ref.watch(homeLocalDataSourceProvider),
//   );
// }